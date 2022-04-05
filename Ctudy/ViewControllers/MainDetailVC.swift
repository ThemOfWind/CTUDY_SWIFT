//
//  MainDetailVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/21.
//

import Foundation
import UIKit

class MainDetailVC : BasicVC {
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: "", action: nil), animated: true)
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "스터디멤버 상세정보")
        self.rightItem = RightItem.none
    }
}
