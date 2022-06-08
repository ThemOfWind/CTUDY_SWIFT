//
//  SettingStudyRoomRequest.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/05.
//

import Foundation

struct SettingStudyRoomResponse: Codable {
    var id: Int // 스터디룸 pk
    var name: String // 스터디룸 이름
    var masterid: Int // 스터디룸 방장 pk
    var mastername: String // 스터디룸 방장 이름
    var banner: String // 스터디룸 image
}
