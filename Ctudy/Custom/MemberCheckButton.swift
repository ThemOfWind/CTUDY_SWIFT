//
//  CheckButton.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/28.
//

import Foundation
import UIKit

class CheckButton: UIButton {
    // bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                // btn check on 설정
                self.setTitle("", for: .normal)
                self.setTitleColor(.white, for: .normal)
                self.setImage(UIImage(named: "checkmark"), for: .normal)
                self.setBackgroundColor(UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1), for: .normal)
            } else {
                // btn check off 설정
                self.setTitle("초대", for: .normal)
                self.setTitleColor(UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1), for: .normal)
                self.setImage(nil, for: .normal)
                self.setBackgroundColor(.white, for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc func btnClicked(sender: UIButton) {
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
