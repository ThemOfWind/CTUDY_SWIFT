//
//  MultiPartFormInterceptor.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/09.
//

import Foundation
import Alamofire

class MultiPartFormInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("MultiPartFormInterceptor - adapt() called")

        var request = urlRequest
        
        // 헤더 추가
        request.addValue("mutipart/form-data; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("mutipart/form-data; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        // tocken 추가
        if let accessToken = KeyChainManager().tokenLoad(API.SERVICEID, account: "accessToken") {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else { print("accesToken is nil") }
        
        print("Authorization value: \(request.headers.value(for: "Authorization"))")
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("MultiPartFormInterceptor - retry() called")
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        let data = ["statusCode" : statusCode ]
        
        //노티피케이션을 이용하여 fail정보 넘기기
        completion(.doNotRetry)
    }
}
