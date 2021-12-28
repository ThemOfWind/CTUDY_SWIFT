//
//  Errors.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation

enum Errors : String, Error {
    case duplicatedUserName = "이미 사용된 아이디(이메일)입니다."
    case noSignUp = "회원가입에 실패하였습니다."
    case noSignIn = "아이디 및 비밀번호가 일치하지 않습니다."
    case noLogout = "로그아웃에 실패하였습니다. (token 인증처리 실패)"
}
