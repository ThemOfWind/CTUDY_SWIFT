//
//  CreateCouponResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/31.
//

import Foundation

struct RegisterCouponRequest: Codable {
    var name: String // 쿠폰이름
    var room_id: Int // 스터디룸 pk
    var receiver_id: Int // 쿠폰 수신자 pk
    var start_date: String // 유효 시작일자
    var end_date: String // 유효 마지막일자
}
