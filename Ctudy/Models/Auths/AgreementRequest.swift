//
//  AgreementRequest.swift
//  Ctudy
//
//  Created by 김지은 on 2022/07/21.
//

import Foundation

struct AgreementRequest: Codable {
    var id: String // 이동할 view 구분 id값
    var text: String // 표기할 text
    var page: String // 이동할 view name
    var isChecked: Bool // check 상태
}
