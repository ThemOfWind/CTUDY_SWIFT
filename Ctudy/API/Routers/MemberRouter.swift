//
//  MemberRouter.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import Alamofire

enum MemberRouter: URLRequestConvertible {
    case searchmember(page: String) // 전체 멤버 조회
    case deletemember(id: String, memberlist: Array<Int>)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "study/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchmember:
            return .get
        case .deletemember:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .searchmember:
            return "room/member/"
        case .deletemember(id: let id, memberlist: let memberlist):
            return "room/member/\(id)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        print("MemeberRouter - asURLRequest() called / url: \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .searchmember(page: let page):
            let parameters = ["page" : page, "max_page" : "10"] as Dictionary
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        case .deletemember(id: let id, memberlist: let memberlist):
            let parameters: Dictionary = ["member_list" : memberlist] as Dictionary
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return request
    }
}
