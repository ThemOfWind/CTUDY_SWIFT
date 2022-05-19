//
//  BaseInterceptor.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    // 정상작동 시 응답 methods
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        print("BaseInterceptor - adapt() called")

        var request = urlRequest
        
        // 헤더 추가
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        // tocken 추가
        if let accessToken = KeyChainManager().tokenLoad(API.SERVICEID, account: "accessToken") {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else { print("accesToken is nil") }
        
//        print("Authorization value: \(request.headers.value(for: "Authorization"))")
        completion(.success(request))
    }
    
    // 비정상작동 시 응답 methods
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        print("BaseInterceptor - retry() called")
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        let data = ["statusCode" : statusCode ]
        
        //노티피케이션을 이용하여 fail정보 넘기기
        completion(.doNotRetry)
    }
}
