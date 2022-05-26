//
//  SearchPasswordVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/26.
//

import Foundation
import UIKit

class SearchPwFirstVC: BasicVC {
    // MARK: - 변수
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "비밀번호 찾기", isLargeTitles: true)
    }
    
    
}
