//
//  UserDefaults.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/29.
//

import Foundation

class UserInfos {
    func localLogout() {
        // 기본 저장소의 값을 삭제
        let ud = UserDefaults.standard
        //ud.removeObject(forKey: UserInfoKey.loginId)
        //ud.removeObject(forKey: UserInfoKey.account)
        //ud.removeObject(forKey: UserInfoKey.name)
        ud.synchronize()
    }
}
