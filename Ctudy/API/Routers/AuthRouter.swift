//
//  APIRouter.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
    // logout(get), signin(post), signup(get, post)
    
    case signin(username: String, password: String) // 로그인
    case usernamecheck(username: String) // 아이디 중복체크
    case signup(name: String, username: String, password: String) // 회원가입
    case logout // 로그아웃
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "account/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .signin:
            return .post
        case .usernamecheck:
            return .get
        case .signup:
            return .post
        case .logout:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .signin:
            return "signin/"
        case .usernamecheck:
            return "signup/"
        case .signup:
            return "signup/"
        case .logout:
            return "logout/"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case let .signin(username, password):
            return ["username" : username, "password" : password]
        case let .usernamecheck(username):
            return ["username" : username]
        case let .signup(name, username, password):
            return ["name" : name, "username" : username, "password" : password]
        case .logout:
            return ["" : ""]
            
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        print("AuthRouter - asURLRequest() called / url: \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
//        switch self {
//        case .signup:
//            request = try JSONParameterEncoder().encode(parameters, into: request)
//        case .idCheck:
//            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
//        case .signin:
//            request = try JSONParameterEncoder().encode(parameters, into: request)
//        }
        
        return request
    }
}

