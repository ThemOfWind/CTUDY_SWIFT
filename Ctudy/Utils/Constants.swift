//
//  Constatns.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/09.
//

import Foundation

enum API {
    static let BASE_URL: String = "https://api.ctudy.com/api/v1/"
//    static let BASE_URL : String = "http://172.30.1.52:8000/api/v1/"
    static let SERVICEID: String = "com.jinny.Ctudy"
}

enum REGEX {
    static let NAME_REGEX: String = "[가-힣]{2,}"
    static let USERNAME_REGEX: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let PASSWORD_REGEX: String = "^(?=.*[A-Za-z])(?=.*[!@#$%^])(?=.*[0-9]).{8,20}"
}
