//
//  AlamofireManager.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

final class AlamofireManager {
    // 싱글턴 적용
    static let shared = AlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    
    // 로거 설정
    let monitors = [
        MyStatusLogger()
    ] as [EventMonitor]
    
    // 세션 설정
    var session : Session
    
    
    private init() {
        session = Session(
            interceptor: interceptors
            , eventMonitors: monitors
        )
    }
    
    // MARK: - 아이디 중복체크
    func getUserNameCheck(username username: String, completion: @escaping (Result<UserNameCheckResponse, AuthErrors>) -> Void) {
        print("AlamofireManger - getUserNameCheck() called / parameters = [username: \(username)]")
        
        self.session
            .request(AuthRouter.usernamecheck(username: username))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                guard let result = responseJson["result"].bool else { return }
                
                // 사용가능한 아이디일때
                if result {
                    guard let username = responseJson["response"]["username"].string else { return }
                    let jsonData = UserNameCheckResponse(username: username)
                    completion(.success(jsonData))
                }
                // 중복 아이디일때
                else {
                    completion(.failure(.duplicatedUserName))
                }
            })
    }
    
    // MARK: - 회원가입
    func postSignUp(name name: String, username username: String, password password: String, completion: @escaping (Result<SignUpResponse, AuthErrors>) -> Void) {
        print("AlamofireManager - postSignUp() called / parameters = [name: \(name), username: \(username), password: \(password)]")
        
        self.session
            .request(AuthRouter.signup(name: name, username: username, password: password))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                guard let result = responseJson["result"].bool,
                      let name = responseJson["response"]["name"].string,
                      let username = responseJson["response"]["username"].string else { return }
                let jsonData = SignUpResponse(name: name, username: username)
                
                if result {
                    completion(.success(jsonData))
                } else {
                    completion(.failure(.noSignUp))
                }
            })
    }
    
    // MARK: - 로그인
    func postSignIn(username: String, password: String, completion: @escaping(Result<SignInResponse, AuthErrors>) -> Void) {
        print("AlamofireManager - postSignIn() called / parameters = [username: \(username), password: \(password)]")
        
        self.session
            .request(AuthRouter.signin(username: username, password: password))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                guard let result = responseJson["result"].bool else { return }
                var accessToken : String = ""
                
                if result {
                    if let jtoken = responseJson["response"]["access_token"].string {
                        accessToken = jtoken
                    }
                }
                
                let jsonData = SignInResponse(token: accessToken)
                
                if result {
                    // 토큰 정보 저장
                    if TokenManager().tokenSave(API.SERVICEID, account: "accessToken", value: accessToken) {
                        completion(.success(jsonData))
                    } else {
                        completion(.failure(.noSaveToken))
                    }
                } else {
                    completion(.failure(.noSignIn))
                }
                
            })
    }
    
    // MARK: - 로그아웃
    func getLogout(completion: @escaping(Result<Bool, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.logout)
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                guard let result = responseJson["result"].bool else { return }
                
                if result {
                    // 토큰 정보 삭제
                    if TokenManager().tokenDelete(API.SERVICEID, account: "accessToken") {
                        completion(.success(result))
                    } else {
                        completion(.failure(.noDelToken))
                    }
                } else {
                    completion(.failure(.noLogout))
                }
            })
    }
    
    // MARK: - 전체 스터디 룸 조회
    func getSearchRoom(completion: @escaping(Result<[SearchRoomResponse], RoomErrors>) -> Void) {
        self.session
            .request(RoomRouter.searchroom)
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                guard let result = responseJson["result"].bool else { return }
                let response = responseJson["response"]
                var rooms = [SearchRoomResponse]()
                
                for (index, subJson) : (String, JSON) in response {
                    guard let name = subJson["name"].string
                            , let membercount = subJson["member_count"].int
                            , let mastername = subJson["master_name"].string else { return }
                    
                    let roomItem = SearchRoomResponse(name: name, membercount: membercount, mastername: mastername)
                    rooms.append(roomItem)
                }
                
                if result {
                    if rooms.count > 0 {
                        completion(.success(rooms))
                    } else {
                        completion(.failure(.noSearchRoom))
                    }
                } else {
                    completion(.failure(.noSearchRoom))
                }
            })
    }
    
    // MARK: - 전체 멤버 조회
    func getSearchMember(page: String, competion: @escaping(Result<JSON, MemberErrors>) -> Void) {
        self.session
            .request(MemberRouter.searchmember(page: page))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                guard let result = responseJson["result"].bool else { return }
                let response = responseJson["response"]
                //let list = response["list"]
//                let nextPage = response["next"]
                
                //var members = [SearchMemberResponse]()
                
                if result {
//                    for (index, subJson) : (String, JSON) in list {
//                        guard let id = subJson["id"].int
//                             ,let username = subJson["username"].string
//                        else { return }
//
//                        let memberItem = SearchMemberResponse(id: id, userName: username)
//                        members.append(memberItem)
//                    }
                    
                    if response.exists() {
                        competion(.success(response))
                    }
                    else {
                        competion(.failure(.noSearchMember))
                    }
                }
                else {
                    competion(.failure(.noSearchMember))
                }
            })
    }
}
