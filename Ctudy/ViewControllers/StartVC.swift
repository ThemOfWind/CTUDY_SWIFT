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
        self.signUpBtn.layer.cornerRadius = 30
        self.signUpBtn.layer.borderWidth = 1
        self.signUpBtn.layer.borderColor = UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1).cgColor
        self.loginBtn.layer.cornerRadius = 30
        self.loginBtn.layer.borderColor = UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1).cgColor
        self.loginBtn.layer.borderWidth = 1
    }
    
    @IBAction func unwindLoginVC(_ segue: UIStoryboardSegue) {}
}
