//
//  RegisterRoomResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/04/06.
//

import Foundation

struct RegisterRoomRequest: Codable {
    var name: String    // 스터디룸 이름
    var member_list: Array<Int> // 멤버 pk 리스트
//    var image: [Data]?
}
