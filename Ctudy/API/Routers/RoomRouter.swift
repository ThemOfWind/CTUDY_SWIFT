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
    case searchstudymember(id: String) // 스터디 멤버 조회
    
    var baseURL: URL {
        return URL(string:API.BASE_URL + "study/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchroom:
            return .get
        case .registerroom:
            return .post
        case .searchstudymember:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchroom:
            return "room/"
        case .registerroom:
            return "room/"
        case .searchstudymember(id: let id):
            return "room/\(id)/"
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
        case .searchstudymember(let id):
            break
        }
        
        return request
    }
}
