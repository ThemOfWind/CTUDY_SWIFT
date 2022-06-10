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
//    case registerroom(name: String, member_list: Array<Int>)
    case searchstudymember(id: String) // 스터디 멤버 조회
    case updatestudyroom(id: String, name: String, master: Int) // 스터디룸 설정 변경
    
    var baseURL: URL {
        return URL(string:API.BASE_URL + "study/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchroom:
            return .get
        case .searchstudymember:
            return .get
        case .updatestudyroom:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .searchroom:
            return "room/"
        case .searchstudymember(id: let id):
            return "room/\(id)"
        case .updatestudyroom(id: let id, name: let name, master: let master):
            return "room/\(id)"
        }
    }
    
//    var header: String {
//        switch self {
//        case .searchroom:
//            return "multipart/form-data; charset=UTF-8"
//        }
//    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        print("RoomRouter - asURLRequest() called / url: \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .searchroom:
            break
//        case .registerroom(let name, let member_list):
////            let parameters = RegisterRoomRequest(name: name, member_list: member_list)
////            request.httpBody = try? JSONEncoder().encode(parameters)
//
//            AF.upload(multipartFormData: { multipartFormData in
//                let parameters = RegisterRoomRequest(name: name, member_list: member_list)
//                multipartFormData.append("\(parameters.name)".data(using: .utf8)!, withName: "name")
//                multipartFormData.append("\(parameters.member_list)".data(using: .utf8)!, withName: "member_list")
//
////                if let image = parameters.image {
////
////                }
//            }, to: url, usingThreshold: UInt64.init(), method: method)
        case .searchstudymember(let id):
            break
        case .updatestudyroom(id: let id, name: let name, master: let master):
            print("RoomRouter - id: \(id), name: \(name), master: \(master)")
            let parameters = ["name" : name, "master" : master] as Dictionary
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return request
    }
}
