//
//  SettingStudyRoomRequest.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/05.
//

import Foundation

struct SettingStudyRoomRequest: Codable {
    var id: Int // 스터디룸 pk id
    var name: String // 스터디룸 이름
    var membercount: Int // 스터디룸 인원수
    var mastername: String // 스터디룸 방장이름
    var banner: String // 스터디룸 image
}
