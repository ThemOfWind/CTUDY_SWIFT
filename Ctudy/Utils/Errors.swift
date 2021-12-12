//
//  Errors.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation

enum Errors : String, Error {
    case duplicatedUserName = "중복된 아이디입니다."
    case noSignUp = "회원가입에 실패하였습니다."
}
