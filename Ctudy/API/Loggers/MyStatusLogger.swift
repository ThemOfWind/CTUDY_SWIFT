//
//  MyStatusCodeLogger.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/23.
//

import Foundation
import Alamofire

final class MyStatusLogger : EventMonitor {
    let queue = DispatchQueue(label: "APILog")
    
    // status log
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let statusCode =  request.response?.statusCode else { return }
        
        print("MyStatusLogger - request<Value>() called / statusCode :\(statusCode)")
    }
}
