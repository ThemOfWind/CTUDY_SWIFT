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
        
        self.goToLoginBtn.layer.cornerRadius = 5
        self.enterName.text = memberName
    }
//
//    @IBAction func onGoToLoginBtnClicked(_ sender: Any) {
//        performSegue(withIdentifier: "unwindLoginVC", sender: self)
//    }
}
