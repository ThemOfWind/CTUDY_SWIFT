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
    case usernamecheck(username: String?, email: String?) // 아이디 중복체크
//    case signup(name: String, username: String, password: String) // 회원가입
    case logout // 로그아웃
    case profile // 접속 회원정보
    case searchid(email: String) // 아이디 찾기
    case searchpw(email: String, username: String) // 비밀번호 찾기 (아이디&이메일 확인)
    case certificate(email: String, username: String, code: String) // 비밀번호 찾기 (인증번호)
    case resetpw(email: String, username: String, key: String, newpassword: String) // 비밀번호 찾기 (비밀번호 변경)
    case updateprofile(name: String) // 프로필 설정 변경
    case updatepassword(password: String, newpassword: String) // 비밀번호 변경
    case withdraw // 회원탈퇴
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "account/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .signin:
            return .post
        case .usernamecheck:
            return .get
//        case .signup:
//            return .post
        case .logout:
            return .get
        case .profile:
            return .get
        case .searchid:
            return .post
        case .searchpw:
            return .post
        case .certificate:
            return .post
        case .resetpw:
            return .post
        case .updateprofile:
            return .put
        case .updatepassword:
            return .put
        case .withdraw:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .signin:
            return "signin/"
        case .usernamecheck:
            return "signup/"
//        case .signup:
//            return "signup/"
        case .logout:
            return "logout/"
        case .profile:
            return "profile/"
        case .searchid:
            return "findid/"
        case .searchpw:
            return "findpw/"
        case .certificate:
            return "findpw/certificate/"
        case .resetpw:
            return "findpw/reset/"
        case .updateprofile:
            return "profile/"
        case .updatepassword:
            return "password/"
        case .withdraw:
            return "withdraw/"
        }
    }
    
//    var parameters: [String : String] {
//        switch self {
//        case let .signin(username, password):
//            return ["username" : username, "password" : password]
//        case let .usernamecheck(username):
//            return ["username" : username]
//        case let .signup(name, username, password):
//            return ["name" : name, "username" : username, "password" : password]
//        case .logout:
//            return ["" : ""]
//
//        }
//    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        print("AuthRouter - asURLRequest() called / url: \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .signin(let username, let password):
            let parameters = ["username" : username, "password" : password] as Dictionary
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .usernamecheck(username: let username, email: let email):
            if let usernameParam = username, email == nil {
                let parameters = ["username" : usernameParam] as Dictionary
                request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
            } else if let emailParam = email, username == nil {
                let parameters = ["email" : emailParam] as Dictionary
                request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
            }
//        case .signup(let name, let username, let password):
//            let parameters = ["name" : name, "username" : username, "password" : password] as Dictionary
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .logout:
            break
        case .profile:
            break
        case .searchid(email: let email):
            let parameters = ["email" : email] as Dictionary
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .searchpw(email: let email, username: let username):
            let parameters = ["email" : email, "username" : username] as Dictionary
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .certificate(email: let email, username: let username, code: let code):
            let parameters = ["email" : email, "username" : username, "code" : code] as Dictionary
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .resetpw(email: let email, username: let username, key: let key, newpassword: let newpassword):
            let parameters = ["email" : email, "username" : username, "key" : key, "new_password" : newpassword] as Dictionary
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .updateprofile(name: let name):
            let parameters = ["name" : name] as Dictionary
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .updatepassword(password: let password, newpassword: let newpassword):
            let parameters = ["password" : password, "new_password" : newpassword]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        case .withdraw:
            break
        }
        
        return request
    }
}

