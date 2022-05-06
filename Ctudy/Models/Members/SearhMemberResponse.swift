//
//  SearhMemberResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation

struct SearchMemberResponse: Codable {
    var id: Int // 사용자 pk id
    var name: String // 사용자 이름
    var userName: String // 사용자 아이디
    var ischecked: Bool // 사용여부
}
