//
//  BasicButton.swift
//  Ctudy
//
//  Created by 김지은 on 2022/04/01.
//

import Foundation
import UIKit

class BasicButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            print("어잉?")
            if isEnabled {
                self.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
                self.tintColor = COLOR.SIGNATURE_COLOR
            } else {
                self.layer.borderColor = UIColor(named: "LightGray")?.cgColor
                self.tintColor = UIColor(named: "LightGray")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 1
        self.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
        self.isEnabled = true
    }
}
