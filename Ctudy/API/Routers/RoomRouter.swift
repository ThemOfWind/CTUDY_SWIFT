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
    case registerroom(name: String, member_list: Array<Int>)
    
    var baseURL: URL {
        return URL(string:API.BASE_URL + "study/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchroom:
            return .get
        case .registerroom:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .searchroom:
            return "room/"
        case .registerroom:
            return "room/"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .searchroom:
            break
        case .registerroom(let name, let member_list):
            let parameters = RegisterRoomRequest(name: name, member_list: member_list)
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        return request
    }
}
