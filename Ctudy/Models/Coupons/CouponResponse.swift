//
//  File.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/20.
//

import Foundation

struct CouponResponse: Codable {
    var id: Int // 쿠폰 pk
    var name: String // 쿠폰 이름
    var image: String // 쿠폰 이미지
    var startdate: String // 쿠폰 사용 시작일
    var enddate: String // 쿠폰 사용 마지막일
    
    var sid: Int // sender pk
    var sname: String // sender 이름
    var susername: String // sender 아이디
    var simage: String // sender 이미지
    
    var rid: Int // receiver pk
    var rname: String // receiver 이름
    var rusername: String // receiver 아이디
    var rimage: String // receiver 이미지
}
