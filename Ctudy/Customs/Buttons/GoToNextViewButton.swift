//
//  GoToNextViewButton.swift
//  Ctudy
//
//  Created by 김지은 on 2022/07/21.
//

protocol GoToViewButtonDelegate: AnyObject {
    func goToViewBtnClicked(sender: UIButton)
}

import Foundation
import UIKit

class GoToNextViewButton: UIButton {
    // MARK: 변수
    //delegate(위임자) 생성
    var nextBtnDelegate: GoToViewButtonDelegate?
    
    // MARK: - view load func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // button ui
//        let chevron = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .small))
        let chevron = UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .small))
        self.setImage(chevron, for: .normal)
        self.tintColor = COLOR.SUBTITLE_COLOR
        
        // button event 연결
        self.addTarget(self, action: #selector(goToViewBtnClicked(sender:)), for: .touchUpInside)
    }
    
    @objc func goToViewBtnClicked(sender: GoToNextViewButton) {
        if sender.tag == self.tag {
            self.nextBtnDelegate?.goToViewBtnClicked(sender: sender)
        }
    }
}
