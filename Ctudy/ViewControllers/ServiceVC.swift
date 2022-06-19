//
//  ServiceVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/17.
//

import Foundation
import UIKit

class ServiceVC: BasicVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    fileprivate func config() {
        // navigationbar
        self.navigationController?.navigationBar.sizeToFit() // UIKit에 포함된 특정 View를 자체 내부 요구의 사이즈로 resize 해주는 함수
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "이용약관", isLargeTitles: false)
    }
}
