//
//  SignUpFirstVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/30.
//

import Foundation
import UIKit

class SignUpFirstVC: BasicVC {
    // MARK: - 변수
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var goToStartBtn: UIButton!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var serviceView: UIView!
    
    // MARK: - view load func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpFirstVC - viewDidLoad() called")
        self.config()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        // 화면 swipe 기능 막기
//        leftItem = LeftItem.none
//    }
    
    fileprivate func config() {
        // navigationbar item
        self.navigationController?.navigationBar.sizeToFit()
        leftItem = LeftItem.none
        titleItem = TitleItem.titleGeneral(title: "회원가입", isLargeTitles: true)
        
        // view ui
        privacyView.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        privacyView.layer.borderWidth = 1
        privacyView.layer.cornerRadius = 10
        serviceView.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        serviceView.layer.borderWidth = 1
        serviceView.layer.cornerRadius = 10
        
        // button ui
        nextBtn.tintColor = .white
        nextBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        nextBtn.layer.cornerRadius = 10
        
        // button event 연결
        self.goToStartBtn.addTarget(self, action: #selector(onGoToStartBtnClicked), for: .touchUpInside)
    }
    
    // MARK: - go to startview func
    @objc fileprivate func onGoToStartBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
}
