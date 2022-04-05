//
//  StartVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation
import UIKit

class StartVC : BasicVC {
    
    // MARK: - 변수
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    fileprivate func config() {
        // btn ui
        self.signUpBtn.layer.cornerRadius = 30
        self.signUpBtn.layer.borderWidth = 1
        self.signUpBtn.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
        self.loginBtn.layer.cornerRadius = 30
        self.loginBtn.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
        self.loginBtn.layer.borderWidth = 1
    }
    
    // MARK: - pop func
    @IBAction func unwindLoginVC(_ segue: UIStoryboardSegue) {}
}
