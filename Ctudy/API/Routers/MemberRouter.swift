//
//  MemberRouter.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import Alamofire

enum MemberRouter: URLRequestConvertible {
    case searchmember
    
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
    
    var paramters: [String : String] {
        switch self {
        case .searchmember:
            return ["" : ""]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(paramters, into: request)

        return request
    }
}
