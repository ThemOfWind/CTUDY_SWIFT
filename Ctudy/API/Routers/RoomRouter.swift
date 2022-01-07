//
//  RoomRouter.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import Alamofire

enum RoomRouter: URLRequestConvertible {
case searchroom
    
    var baseURL: URL {
        return URL(string:API.BASE_URL + "study/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchroom:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchroom:
            return "room/"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .searchroom:
            return ["" : ""]
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
