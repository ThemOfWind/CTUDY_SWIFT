//
//  SettingBarButtonItem.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/10.
//

import Foundation
import UIKit

class SettingBarButtonItem : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = COLOR.SIGNATURE_COLOR
    }
}
