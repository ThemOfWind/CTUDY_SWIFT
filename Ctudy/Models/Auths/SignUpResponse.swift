//
//  Response.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation

struct SignUpResponse: Codable {
    var name: String // 이름
    var username: String // 아이디(이메일)
}
