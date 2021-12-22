//
//  Response.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation

struct SignUpResponse : Codable {
    var result : Bool
    var name : String
    var username : String
}
