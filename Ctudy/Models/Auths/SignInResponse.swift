//
//  LogInResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/13.
//

import Foundation

struct SignInResponse: Codable {
    var result: Bool // 결과(true, false)
    var token: String // 인증토큰
}
