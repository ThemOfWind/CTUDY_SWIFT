//
//  agreementCheckButton.swift
//  Ctudy
//
//  Created by 김지은 on 2022/07/18.
//
// 범용성을 위해 class가 아닌 Anyobject로 선언
protocol AgreementCheckButtonDelegate: AnyObject {
    func agreementCheckBtnClicked(sender: UIButton, ischecked: Bool)
}

import Foundation
import UIKit

class AgreementCheckButton: UIButton {
    // bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                // btn check on 설정
                self.tintColor = COLOR.SIGNATURE_COLOR
                self.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
            } else {
                // btn check off 설정
                self.tintColor = COLOR.DISABLE_COLOR
                self.setImage(UIImage(systemName: "checkmark.circle")!, for: .normal)
            }
        }
    }
    //delegate(위임자) 생성
    var checkBtnDelegate: AgreementCheckButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .none
        self.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
        self.isChecked = false
    }
    
    // checkbtn click event
    @objc func btnClicked(sender: AgreementCheckButton) {
        if sender.tag == self.tag {
            isChecked = !isChecked
            self.checkBtnDelegate?.agreementCheckBtnClicked(sender: sender, ischecked: isChecked)
            print("AgreementCheckButton - btnClicked() called / sender.tag = \(sender.tag), isChecked: \(sender.isChecked)")
        }
    }
}
