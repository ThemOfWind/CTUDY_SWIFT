//
//  Response.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import SwiftyJSON

struct Response : Codable {
    var result : Bool
    var username : String
    var name : String
}
