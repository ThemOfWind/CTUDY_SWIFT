//
//  SearchStudyMemeberResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/04/16.
//

import Foundation

struct SearchStudyMemberResponse: Codable {
    var id: Int //  사용자 pk id
    var name: String // 사용자 이름
    var username: String // 사용자 아이디
    var image: String // 사용자 이미지
    var coupon: Int // 쿠폰 개수
}
