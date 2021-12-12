//
//  AlamofireManager.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import Alamofire
import SwiftyJSON

final class AlamofireManager {
    // 싱글턴 적용
    static let shared = AlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    
    // 로거 설정
    
    
    // 세션 설정
    var session : Session
    
    
    private init() {
        session = Session(interceptor: interceptors)
    }
    
    // 회원가입
    func postSignUp(name name: String, username username: String, password password: String, completion: @escaping (Result<Response, Errors>) -> Void) {
        
        print("AlamofireManager - postSignUp() called / parameters = [name : \(name), username : \(username), password : \(password)]")
        
        self.session
            .request(AuthRouter.signup(name: name, username: username, password: password))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
//                let jsonArray = responseJson["result", "response"]
                
//                print("jsonArray.count : \(jsonArray.count)")
                print("responseJson.count : \(responseJson.count)")
                
                guard let result = responseJson["result"].bool,
                      let name = responseJson["response"]["name"].string,
                      let username = responseJson["response"]["username"].string else { return }
                
                let jsonData = Response(result: result, username: username, name: name)
                
                if jsonData.result {
                    completion(.success(jsonData))
                } else {
                    completion(.failure(.noSignUp))
                }
                
            })
    }
    
    // 로그인
    
    
}
