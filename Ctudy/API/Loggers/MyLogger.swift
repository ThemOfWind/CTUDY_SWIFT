//
//  MyLogger.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/23.
//

import Foundation
import Alamofire

final class MyLogger : EventMonitor {
    let queue = DispatchQueue(label: "APILog")
    
    // header log
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume() called")
        debugPrint(request)
    }
    
    // body log
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request<Value>() called")
        debugPrint(response)
    }
}
