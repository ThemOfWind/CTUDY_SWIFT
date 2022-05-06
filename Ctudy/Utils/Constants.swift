//
//  Constatns.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/09.
//

import Foundation
import UIKit

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

enum COLOR {
    static let SIGNATURE_COLOR: UIColor = UIColor(red: 128/255, green: 192/255, blue: 0/255, alpha: 1)
    static let SIGNATURE_COLOR_TRANSPARENCY_10: UIColor = UIColor(red: 128/255, green: 192/255, blue: 0/255, alpha: 0.1)
    static let DISABLE_COLOR: UIColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
    static let SUBTITLE_COLOR: UIColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)
    static let INDICATOR_BACKGROUND_COLOR: UIColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 50)
}
