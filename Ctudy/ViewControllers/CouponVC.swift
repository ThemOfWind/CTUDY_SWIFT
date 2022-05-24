//
//  CouponVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/25.
//

import Foundation
import UIKit

class CouponVC: BasicVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func AnyItemAction(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "CouponHistoryVC", sender: nil)
    }
    
    fileprivate func config() {
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "내 쿠폰", isLargeTitles: true)
        self.rightItem = RightItem.anyCustoms(items: [.setting], title: nil, rightSpaceCloseToDefault: false)
    }
}
