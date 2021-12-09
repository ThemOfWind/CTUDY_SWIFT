//
//  ViewController.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/07.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var goToSignUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.config()
    }
    
    fileprivate func config() {
        // UI
        loginBtn.layer.cornerRadius = 20
        
        // add Btn methods
        loginBtn.addTarget(self, action: #selector(onLoginBtnClicked), for: .touchUpInside)
    }


    // MARK: - objc methods
    @objc func onLoginBtnClicked() {
        print("LoginVC - onLoginBtnClicked() called")
        
    }
}

