//
//  Constatns.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/09.
//

import Foundation
import UIKit

enum API {
    static let BASE_URL: String = "https://api.ctudy.com/api/v2/"
//    static let BASE_URL: String = "http://192.168.219.115:8000/api/v2/"
//    static let BASE_URL: String = "http://192.168.0.20:8000/api/v2/"
//    static let IMAGE_DEFAULT: String = "https://api.ctudy.com/media/public/room/864b172ba4d74a5ea6946f58c0233c29.png" // studyroom default image
    static let IMAGE_URL: String = "https://api.ctudy.com"
    static let SERVICEID: String = "com.jinny.Ctudy"
}

enum REGEX {
    static let NAME_REGEX: String = "[^ ]{2,}"
    static let CTUDYNAME_REGEX: String = "[^ ]+"
    static let EMAIL_REGEX: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let USERNAME_REGEX: String = "[A-Z0-9a-z]{8,15}"
    static let PASSWORD_REGEX: String = "^(?=.*[A-Za-z])(?=.*[!@#$%^])(?=.*[0-9]).{8,20}"
    static let DATE_REGEX: String = "(19|20)[0-9]{2}-(0[1-9]|1[0-2])-(0[1-9]|1[0-9]|2[0-9]|3[0-1])"
}

enum COLOR {
    static let SIGNATURE_COLOR: UIColor = UIColor(red: 128/255, green: 192/255, blue: 0/255, alpha: 1)
    static let SIGNATURE_COLOR_TRANSPARENCY_10: UIColor = UIColor(red: 128/255, green: 192/255, blue: 0/255, alpha: 0.1)
    static let BORDER_COLOR: UIColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 0.5)
    static let DISABLE_COLOR: UIColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
    static let SUBTITLE_COLOR: UIColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)
    static let BASIC_BACKGROUD_COLOR: UIColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)
    static let BASIC_TINT_COLOR: UIColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
    static let INDICATOR_BACKGROUND_COLOR: UIColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 50)
}
