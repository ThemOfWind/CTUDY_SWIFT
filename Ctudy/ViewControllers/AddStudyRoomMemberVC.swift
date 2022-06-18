//
//  AddStudyRoomMemberVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/18.
//

import Foundation
import UIKit

class AddStudyRoomMemberVC: BasicVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    fileprivate func config() {
        // navigationbar item 설정
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "멤버 초대", isLargeTitles: true)
    }
}
