//
//  SignUpSuccessVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import UIKit

class SignUpSuccessVC : BasicVC {
    // MARK: - 변수
    @IBOutlet weak var enterName: UILabel!
    @IBOutlet weak var goToLoginBtn: UIButton!
    var memberName : String?
    var memberUserName : String?
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpSuccessVC - viewDidLoad() calld")
        
        // navigationBar
//        self.navigationController?.isNavigationBarHidden = true
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.none
        self.rightItem = RightItem.none
        
        // btn ui
        self.goToLoginBtn.layer.cornerRadius = 30
        self.goToLoginBtn.layer.borderWidth = 1
        self.goToLoginBtn.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
        
        // label ui
        self.enterName.text = memberName
    }

    // MARK: - action func
    // start 화면으로 이동
    @IBAction func onGoToLoginBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindLoginVC", sender: self)
    }
}
