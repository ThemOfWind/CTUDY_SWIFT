//
//  CertificateResponse.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/16.
//

import Foundation

struct CertificateResponseRequest: Codable {
    var email: String // 이메일
    var username: String // 아이디
    var key: String // 인증성공 key (신규 비밀번호 등록 시 필요)
}
