//
//  CouponRouter.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/20.
//

import Foundation
import Alamofire

enum CouponRouter: URLRequestConvertible {
    case searchcoupon(id: String, mode: String?) // 쿠폰 조회
    case usecoupon(id: String) // 쿠폰 사용
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "coupon/")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchcoupon:
            return .get
        case .usecoupon:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .searchcoupon:
            return ""
        case .usecoupon(id: let id):
            return "\(id)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        print("CouponRouter - asURLRequest() called / url: \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .searchcoupon(id: let id, mode: let mode):
            if let m = mode {
                let parameters = ["room_id" : id, "mode" : mode] as Dictionary
                request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
            } else {
                let parameters = ["room_id" : id] as Dictionary
                request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
            }
        case .usecoupon(id: let id):
            break
        }
        
        return request
    }
}
