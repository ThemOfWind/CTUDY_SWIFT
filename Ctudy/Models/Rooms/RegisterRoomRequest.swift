//
//  RegisterRoomResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/04/06.
//

import Foundation

struct RegisterRoomRequest: Codable {
    var name: String
    var member_list: Array<Int>
}
