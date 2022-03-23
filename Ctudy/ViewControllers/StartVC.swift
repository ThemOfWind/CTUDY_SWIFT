//
//  StartVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation
import UIKit

class StartVC : UIViewController {
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        self.navigationController?.isNavigationBarHidden = true
        self.signUpBtn.layer.cornerRadius = 5
        self.loginBtn.layer.cornerRadius = 5
    }
}
