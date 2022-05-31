//
//  CreateCouponResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/31.
//

import Foundation

struct CreateCouponResponse: Codable {
    var name: String // 쿠폰이름
    var roomId: Int // 스터디룸 pk
    var receiverId: Int // 쿠폰 수신자 pk
    var startDate: String // 유효 시작일자
    var endDate: String // 유효 마지막일자
}
