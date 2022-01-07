//
//  IDCheckResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/13.
//

import Foundation

struct UserNameCheckResponse: Codable {
    var result: Bool // 결과(true, false)
    var username: String // 아이디(이메일)
}
