//
//  CouponReciverRequest.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/30.
//

import Foundation

struct CouponReciverRequest: Codable {
    var id: Int // 쿠폰 수신자 pk
    var name: String // 쿠폰 수신자 이름
    var username: String // 쿠폰 수신자 아이디
    var image: String // 쿠폰 수신자 이미지
}
