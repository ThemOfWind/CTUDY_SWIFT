//
//  MainDetailVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/21.
//

import Foundation
import UIKit

class MainDetailVC : BasicVC {
    var userName: String? // 사용자 id
    var roomName: Int? // 스터디룸 id
    var roomNameString: String? // 스터디룸 name
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        
        print("MainDetailVC - viewDidLoad() called / userName: \(self.userName), roomName: \(self.roomName), roomNameString: \(self.roomNameString)")
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "스터디멤버 상세정보")
        self.rightItem = RightItem.none
    }
}
