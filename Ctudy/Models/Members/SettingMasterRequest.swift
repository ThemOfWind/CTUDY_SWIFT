//
//  SettingMasterRequest.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/05.
//

import Foundation

struct SettingMasterRequest: Codable {
    var id: Int //  사용자 pk id
    var name: String // 사용자 이름
    var username: String // 사용자 아이디
    var image: String // 사용자 이미지
}
