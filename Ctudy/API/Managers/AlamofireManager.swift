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
    let baseInterceptors = Interceptor(interceptors: [BaseInterceptor()])
    
    // 로거 설정
    let monitors = [
        MyStatusLogger()
    ] as [EventMonitor]
    
    // 세션 설정
    var session: Session
    
    private init() {
        session = Session(
            interceptor: baseInterceptors
            , eventMonitors: monitors
        )
    }
    
    // MARK: - 아이디&이메일 중복체크
    func getExistCheck(errorType errorType: String, username username: String? = nil, email email: String? = nil, completion: @escaping (Result<Bool, AuthErrors>) -> Void) {
        print("AlamofireManger - getExistCheck() called / parameters = [username: \(username)]")
        
        self.session
            .request(AuthRouter.usernamecheck(username: username, email: email))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                print("AlamofireManager - getExistCheck()")
                
                var error: AuthErrors!
                switch errorType {
                case "username":
                    error = .existedUserName
                case "email":
                    error = .existedEmail
                default:
                    error = .existed
                }
                
                switch statusCode {
                case 200:
                    guard let result = responseJson["response"]["success"].bool else { return }
                    if result {
                        completion(.success(result))
                    } else {
                        completion(.failure(error))
                    }
                default:
                    print("getExistCheck() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(error))
                }
            })
    }
    
    // MARK: - 회원가입
    func postSignUp(name name: String, email: String, username username: String, password password: String, image: Data? = nil, completion: @escaping (Result<SignUpResponse, AuthErrors>) -> Void) {
        let url = URL(string: API.BASE_URL + "account/signup/")!
        let header: HTTPHeaders = [ "Content-Type" : "multipart/form-data" ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(name.utf8), withName: "name")
            multipartFormData.append(Data(email.utf8), withName: "email")
            multipartFormData.append(Data(username.utf8), withName: "username")
            multipartFormData.append(Data(password.utf8), withName: "password")
            if image != nil {
                multipartFormData.append(image!, withName: "file", fileName: "default.png", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header).response(completionHandler: { response in
            guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
            let responseJson = JSON(responseValue)
            
            switch statusCode {
            case 200:
                let name = responseJson["response"]["name"].string ?? ""
                let username = responseJson["response"]["username"].string ?? ""
                let jsonData = SignUpResponse(name: name, username: username)
                completion(.success(jsonData))
            default:
                print("postSignUp() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                completion(.failure(.noSignUp))
            }
        })
    }
    
    // MARK: - 아이디 찾기
    func postSearchId(email: String, completion: @escaping(Result<String, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.searchid(email: email))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    if let username = responseJson["response"]["username"].string {
                        completion(.success(username))
                    } else {
                        completion(.failure(.noSearchid))
                    }
                default:
                    print("postSearchId() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noSearchid))
                }
            })
    }
    
    // MARK: - 비밀번호 찾기 (아이디&이메일 확인)
    func postSearchPw(email: String, username: String, completion: @escaping(Result<Bool, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.searchpw(email: email, username: username))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else {
                    return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("postSearchPw() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noSearchPw))
                }
            })
    }
    
    // MARK: - 비밀번호 찾기 (이메일로 인증번호 받기)
    func postCertificate(email: String, username: String, code: String, completion: @escaping(Result<CertificateResponseRequest, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.certificate(email: email, username: username, code: code))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else {
                    return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    guard let key = responseJson["response"]["key"].string else { return }
                    let data = CertificateResponseRequest(email: email, username: username, key: key)
                    completion(.success(data))
                default:
                    print("postSearchPw() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noCertificate))
                }
            })
    }
    
    // MARK: - 비밀번호 찾기 (신규 비밀번호)
    func postResetPw(email: String, username: String, key: String, newpassword: String, completion: @escaping(Result<Bool, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.resetpw(email: email, username: username, key: key, newpassword: newpassword))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else {
                    return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("postResetPw() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noUpdatePassword))
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
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                var accessToken : String = ""
                
                switch statusCode {
                case 200:
                    if let jtoken = responseJson["response"]["access_token"].string {
                        accessToken = jtoken
                    }
                    
                    // 토큰 정보 저장
                    if KeyChainManager().tokenSave(API.SERVICEID, account: "accessToken", value: accessToken) {
                        let jsonData = SignInResponse(token: accessToken)
                        
                        completion(.success(jsonData))
                    } else {
                        completion(.failure(.noSaveToken))
                    }
                default:
                    print("postSignIn() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
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
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    // 토큰 정보 삭제
                    if KeyChainManager().tokenDelete(API.SERVICEID, account: "accessToken") {
                        completion(.success(true))
                    } else {
                        completion(.failure(.noDelToken))
                    }
                default:
                    print("getLogout() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noLogout))
                }
            })
    }
    
    // MARK: - 접속 회원정보 조회
    func getProfile(completion: @escaping(Result<ProfileResponse, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.profile)
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                guard let id = responseJson["response"]["id"].int
                        , let userName = responseJson["response"]["username"].string
                        , let name = responseJson["response"]["name"].string else { return }
                let image = responseJson["response"]["image"].string ?? ""
                
                switch statusCode {
                case 200:
                    if KeyChainManager().tokenSave(API.SERVICEID, account: "id", value: String(id))
                        , KeyChainManager().tokenSave(API.SERVICEID, account: "username", value: userName)
                        , KeyChainManager().tokenSave(API.SERVICEID, account: "name", value: name)
                        , KeyChainManager().tokenSave(API.SERVICEID, account: "image", value: image) {
                        let jsonData = ProfileResponse(id: id, username: userName, name: name, image: image)
                        
                        completion(.success(jsonData))
                    } else {
                        completion(.failure(.noProfile))
                    }
                default:
                    print("getProfile() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noProfile))
                }
            })
    }
    
    // MARK: - 비밀번호 변경
    func putPassword(password: String, newpassword: String, completion: @escaping(Result<Bool, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.updatepassword(password: password, newpassword: newpassword))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.failure(.noUpdatePassword))
                default:
                    print("putPassword() - netsork fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noUpdatePassword))
                }
            })
    }
    
    // MARK: - 회원탈퇴
    func deleteWithdraw(completion: @escaping(Result<Bool, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.withdraw)
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("deleteWithdraw() - netsork fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noWithdraw))
                }
            })
    }
    
    // MARK: - 전체 스터디 룸 조회
    func getSearchRoom(completion: @escaping(Result<[SearchRoomResponse], RoomErrors>) -> Void) {
        self.session
            .request(RoomRouter.searchroom)
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    let response = responseJson["response"]
                    var rooms = [SearchRoomResponse]()
                    
                    for (index, subJson) : (String, JSON) in response {
                        guard let id = subJson["id"].int
                                , let name = subJson["name"].string
                                , let membercount = subJson["member_count"].int
                                , let mastername = subJson["master_name"].string else { return }
                        let banner = subJson["banner"].string ?? ""
                        
                        let roomItem = SearchRoomResponse(id: id, name: name, membercount: membercount, mastername: mastername, banner: banner)
                        rooms.append(roomItem)
                    }
                    
                    completion(.success(rooms))
                default:
                    print("getSearchRoom() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noSearchRoom))
                }
            })
    }
    
    // MARK: - 스터디룸 상세 멤버 조회
    func getSearchStudyMember(id: String, completion: @escaping(Result<JSON, RoomErrors>) -> Void) {
        self.session
            .request(RoomRouter.searchstudymember(id: id))
            .validate(statusCode: 200..<501)
            .response(completionHandler: { response in
                
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    let response = responseJson["response"]
                    completion(.success(response))
                default:
                    print("getSearchStudyMember() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noSearchMemeber))
                }
            })
    }
    
    // MARK: - 스터디룸 멤버 강제 탈퇴
    func deleteStudyMember(id: String, memberlist: Array<Int>, completion: @escaping(Result<Bool, MemberErrors>) -> Void) {
        self.session
            .request(MemberRouter.deletemember(id: id, memberlist: memberlist))
            .validate(statusCode: 200..<501)
            .response(completionHandler: { response in
                guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("deleteStudyMember() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noDeleteMember))
                }
            })
    }
    
    
    // MARK: - 전체 멤버 조회
    func getSearchMember(search: String, roomId: String? = nil, page: String, completion: @escaping(Result<JSON, MemberErrors>) -> Void) {
        self.session
            .request(MemberRouter.searchmember(search: search, roomid: roomId, page: page))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    let response = responseJson["response"]
                    //                    if response.exists() {
                    completion(.success(response))
                default:
                    print("getSearchMember() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noSearchMember))
                }
            })
    }
    
    // MARK: - 스터디룸 등록
    func postRegisterRoom(name: String, member_list: Array<Int>, image: Data? = nil, completion: @escaping(Result<Bool, RoomErrors>) -> Void) {
        let url = URL(string: API.BASE_URL + "study/room/")!
        let token = KeyChainManager().tokenLoad(API.SERVICEID, account: "accessToken")
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
            , "Authorization" : "Bearer " + String(token!)
        ]
        
        //        print("postRegisterRoom() - token: \(token), url: \(url)")
        //        print("postRegisterRoom() - header: Content-Type(\(header["Content-Type"])), Authorization(\(header["Authorization"])")
        
        AF.upload(multipartFormData: { multipartFormData in
            let mpfData = RegisterRoomRequest(name: name, member_list: member_list)
            multipartFormData.append(try! JSONEncoder().encode(mpfData), withName: "payload")
            if image != nil {
                multipartFormData.append(image!, withName: "file", fileName: "default.png", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header).response(completionHandler: { response in
            guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
            let responseJson = JSON(responseValue)
            
            switch statusCode {
            case 200:
                completion(.success(true))
            default:
                print("postRegisterRoom() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                completion(.failure(.noRegisterRoom))
                
            }
        })
    }
    
    // MARK: - 쿠폰등록
    func postRegisterCoupon(name: String, roomId: Int, receiverId: Int, startDate: String, endData: String, image: Data? = nil, completion: @escaping(Result<Bool, CouponErrors>) -> Void) {
        let url = URL(string: API.BASE_URL + "coupon/")!
        let token = KeyChainManager().tokenLoad(API.SERVICEID, account: "accessToken")
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
            , "Authorization" : "Bearer " + String(token!)
        ]
        
        //        print("postRegisterRoom() - token: \(token), url: \(url)")
        //        print("postRegisterRoom() - header: Content-Type(\(header["Content-Type"])), Authorization(\(header["Authorization"])")
        
        AF.upload(multipartFormData: { multipartFormData in
            let mpfData = RegisterCouponRequest(name: name, room_id: roomId, receiver_id: receiverId, start_date: startDate, end_date: endData)
            multipartFormData.append(try! JSONEncoder().encode(mpfData), withName: "payload")
            if image != nil {
                multipartFormData.append(image!, withName: "file", fileName: "default.png", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header).response(completionHandler: { response in
            guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
            let responseJson = JSON(responseValue)
            
            switch statusCode {
            case 200:
                completion(.success(true))
            default:
                print("postRegisterCoupon() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                completion(.failure(.noCreateCoupon))
                
            }
        })
    }
    
    // MARK: - 스터디룸 나가기
    func deleteOutRoom(id: String, memberId: String, completion: @escaping(Result<Bool, RoomErrors>) -> Void) {
        self.session
            .request(RoomRouter.outroom(id: id, memberId: memberId))
            .validate(statusCode: 200..<501)
            .response(completionHandler: { response in
                guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("deleteOutRoom() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noOutRoom))
                }
            })
    }
    
    // MARK: - 스터디룸 설정 (스터디룸 이미지)
    func postUpdateRoom_image(id: Int, image: Data? = nil, completion: @escaping(Result<Bool, RoomErrors>) -> Void) {
        let url = URL(string: API.BASE_URL + "study/room/banner/\(id)")!
        let token = KeyChainManager().tokenLoad(API.SERVICEID, account: "accessToken")
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
            , "Authorization" : "Bearer " + String(token!)
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            if image != nil {
                multipartFormData.append(image!, withName: "file", fileName: "default.png", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header).response(completionHandler: { response in
            guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
            let responseJson = JSON(responseValue)
            
            switch statusCode {
            case 200:
                completion(.success(true))
            default:
                print("postUpdateRoom_image() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                completion(.failure(.noUpdateRoomImage))
                
            }
        })
    }
    
    // MARK: - 스터디룸 설정 (스터디룸 이름, 방장 정보)
    func putUpdateRoom(id: Int, name: String, master: Int, completion: @escaping(Result<Bool, RoomErrors>) -> Void) {
        self.session
            .request(RoomRouter.updatestudyroom(id: String(id), name: name, master: master))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                print("putUpdateRoom() - id: \(id), name: \(name), master: \(master)")
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("putUpdateRoom() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noUpdateRoom))
                }
            })
    }
    
    // MARK: - 프로필 관리 (이미지)
    func postUpdateProfile_image(image: Data? = nil, completion: @escaping(Result<Bool, AuthErrors>) -> Void) {
        let url = URL(string: API.BASE_URL + "account/profile/")!
        let token = KeyChainManager().tokenLoad(API.SERVICEID, account: "accessToken")
        let header: HTTPHeaders = [
            "Content-Type" : "multipart/form-data"
          , "Authorization" : "Bearer " + String(token!)
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            if image != nil {
                multipartFormData.append(image!, withName: "file", fileName: "default.png", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header).response(completionHandler: { response in
            guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
            let responseJson = JSON(responseValue)
            
            switch statusCode {
            case 200:
                completion(.success(true))
            default:
                print("postUpdateProfile_image() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                completion(.failure(.noUpdateProfileImage))
                
            }
        })
    }
    
    // MARK: - 프로필 관리 (닉네임)
    func putUpdateProfile(name: String, completion: @escaping(Result<Bool, AuthErrors>) -> Void) {
        self.session
            .request(AuthRouter.updateprofile(name: name))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                print("putUpdateProfile() - name: \(name)")
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("putUpdateProfile() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noUpdateProfileName))
                }
            })
    }
    
    // MARK: - 스터디룸 멤버 초대
    func postInviteMember(id: String, memberList: Array<Int>, completion: @escaping(Result<Bool, MemberErrors>) -> Void) {
        self.session
            .request(MemberRouter.invitemember(id: id, memberlist: memberList))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("postInviteMember() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noInviteMember))
                }
            })
    }
    
    // MARK: - 쿠폰 조회
    /*
     mode
      a : 전체
      r : 받은 쿠폰
      rd : 만료된 받은 쿠폰 (사용x)
     */
    func getSearchCoupon(id: String, mode: String? = nil, completion: @escaping(Result<[CouponResponse], CouponErrors>) -> Void) {
        self.session
            .request(CouponRouter.searchcoupon(id: id, mode: mode))
            .validate(statusCode: 200..<501)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value
                        , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    let response = responseJson["response"]
                    var coupons = [CouponResponse]()
                    
                    for (index, subJson) : (String, JSON) in response {
                        guard let id = subJson["id"].int
                                , let name = subJson["name"].string
                                , let startdate = subJson["start_date"].string
                                , let enddate = subJson["end_date"].string
                                , let sid = subJson["sender"]["id"].int
                                , let sname = subJson["sender"]["name"].string
                                , let susername = subJson["sender"]["username"].string
                                , let rid = subJson["receiver"]["id"].int
                                , let rname = subJson["receiver"]["name"].string
                                , let rusername = subJson["receiver"]["username"].string else { return }
                        let image = subJson["image"].string ?? ""
                        let simage = subJson["sender"]["image"].string ?? ""
                        let rimage = subJson["receiver"]["image"].string ?? ""
                        
                        let couponItem = CouponResponse(id: id, name: name, image: image, startdate: startdate, enddate: enddate, sid: sid, sname: sname, susername: susername, simage: simage, rid: rid, rname: rname, rusername: rusername, rimage: rimage)
                        coupons.append(couponItem)
                    }
                    completion(.success(coupons))
                default:
                    print("getSearchCoupon() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noSearchCoupon))
                }
            })
    }
    
    // MARK: - 쿠폰 사용
    func deleteUseCoupon(id: String, completion: @escaping(Result<Bool, CouponErrors>) -> Void) {
        self.session
            .request(CouponRouter.usecoupon(id: id))
            .validate(statusCode: 200..<501)
            .response(completionHandler: { response in
                guard let responseValue = response.value
                    , let statusCode = response.response?.statusCode else { return }
                let responseJson = JSON(responseValue)
                
                switch statusCode {
                case 200:
                    completion(.success(true))
                default:
                    print("deleteUseCoupon() - network fail / error: \(statusCode), \(responseJson["error"]["message"].rawValue)")
                    completion(.failure(.noUseCoupon))
                }
            })
    }
}
