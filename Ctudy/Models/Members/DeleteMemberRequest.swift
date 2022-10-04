//
//  DeleteMemberRequest.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/18.
//

import Foundation

struct DeleteMemberRequest: Codable {
    var member_list: Array<Int> // 멤버 pk 리스트
}
