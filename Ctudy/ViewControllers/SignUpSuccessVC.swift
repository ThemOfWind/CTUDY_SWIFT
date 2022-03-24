//
//  SignUpSuccessVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/12.
//

import Foundation
import UIKit

class SignUpSuccessVC : UIViewController {
    
    @IBOutlet weak var enterName: UILabel!
    @IBOutlet weak var goToLoginBtn: UIButton!
    
    var memberName : String?
    var memberUserName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpSuccessVC - viewDidLoad() calld")
        
        // UI
        self.navigationController?.isNavigationBarHidden = true
        self.goToLoginBtn.layer.cornerRadius = 30
        self.goToLoginBtn.layer.borderWidth = 1
        self.goToLoginBtn.layer.borderColor = UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1).cgColor
        self.enterName.text = memberName
    }

    @IBAction func onGoToLoginBtnClicked(_ sender: Any) {
        print("click!!!!")
        performSegue(withIdentifier: "unwindLoginVC", sender: self)
    }
}
