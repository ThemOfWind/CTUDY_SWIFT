//
//  SignUpRequest.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/19.
//

import Foundation

struct SignUpRequest: Codable {
    var name: String    // 이름
    var email: String   // 이메일(email)
    var username: String    // 아이디
    var password: String    // 비밀번호
}
