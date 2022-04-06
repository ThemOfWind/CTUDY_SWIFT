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
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "study/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchmember:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchmember:
            return "member/"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case let .searchmember(page):
            return ["page" : page]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)

        return request
    }
}
