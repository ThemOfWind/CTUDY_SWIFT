//
//  UpdateRoomResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/06.
//

import Foundation

struct UpdateRoomRequest: Codable {
    var id: Int // 스터디룸 pk
    var name: String // 스터디룸 이름
    var master: Int // master pk
}
