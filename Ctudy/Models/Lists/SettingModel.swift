//
//  SettingModel.swift
//  Ctudy
//
//  Created by 김지은 on 2022/07/22.
//

import Foundation

struct SettingModel: Codable {
    var id: String // cell의 id
    var text: String // label text
    var color: String // label 색상
    var page: String // 이동할 view 이름
}
