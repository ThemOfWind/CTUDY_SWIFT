//
//  SignUpSuccessVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import UIKit

class SignUpSuccessVC: BasicVC {
    // MARK: - 변수
    @IBOutlet weak var enterName: UILabel!
    @IBOutlet weak var goToLoginBtn: UIButton!
    var memberName: String?
    var memberUserName: String?
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpSuccessVC - viewDidLoad() calld")
        
        // navigationBar setting
        self.leftItem = LeftItem.none
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        // navigationBar left item
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.hidesBackButton = true
        
        // btn ui
        self.goToLoginBtn.tintColor = .white
        self.goToLoginBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.goToLoginBtn.layer.cornerRadius = 10
        
        // label ui
        self.enterName.text = memberName
    }
    
    // MARK: - action func
    // start 화면으로 이동
    @IBAction func onGoToLoginBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindLoginVC", sender: self)
    }
}
