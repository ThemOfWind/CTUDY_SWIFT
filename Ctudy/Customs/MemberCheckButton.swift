//
//  CheckButton.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/28.
//

import Foundation
import UIKit

class MemberCheckButton: UIButton {
    // bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                // btn check on 설정
                self.setTitle("", for: .normal)
                self.tintColor = .white
                self.setImage(UIImage(systemName: "checkmark")!, for: .normal)
                self.backgroundColor = COLOR.SIGNATURE_COLOR
            } else {
                // btn check off 설정
                self.setTitle("초대", for: .normal)
                self.tintColor = COLOR.SIGNATURE_COLOR
                self.setBackgroundImage(nil, for: .normal)
                self.backgroundColor = .white
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
        self.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    // checkbtn click event
    @objc func btnClicked(sender: UIButton) {
        print("MemberCheckButton - btnClicked() called / sender.tag = \(sender.tag)")
        if sender == self {
            isChecked = !isChecked
        }
    }
}

// btn background color 지정
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
