//
//  ProfileResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/04/08.
//

import Foundation

struct ProfileResponse: Codable {
    var id: Int // 사용자 pk
    var username: String // 사용자 계정
    var name: String // 사용자 이름
}
