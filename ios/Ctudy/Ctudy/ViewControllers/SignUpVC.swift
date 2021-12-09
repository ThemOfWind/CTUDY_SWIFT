//
//  SingUpVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/08.
//

import Foundation
import UIKit

class SignUpVC : UIViewController {
    
    @IBOutlet weak var registerUserName: UITextField!
    @IBOutlet weak var registerUserId: UITextField!
    @IBOutlet weak var registerUserPw: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var goToLoginBtn: UIButton!
    @IBOutlet weak var checkIdBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SignUpVC - viewDidLoad() called")
        
        self.config()
    }
    
    fileprivate func config() {
        // UI
        self.navigationController?.isNavigationBarHidden = true
        checkIdBtn.layer.cornerRadius = 13
        signUpBtn.layer.cornerRadius = 20
        
        // add Btn methods
        checkIdBtn.addTarget(self, action: #selector(onCheckIdBtnClicked), for: .touchUpInside)
        goToLoginBtn.addTarget(self, action: #selector(onGoToLoginBtnClicked), for: .touchUpInside)
    }
    
    // MARK: - objc methods
    @objc func onCheckIdBtnClicked() {
        print("SignUpVC - onCheckIdBtnClicked() called")
        
        
    }
    
    @objc func onGoToLoginBtnClicked() {
        print("SignUpVC - onGoToLoginBtnClicked() called / naviggationController poped")
        
        self.navigationController?.popViewController(animated: true)
    }
}
