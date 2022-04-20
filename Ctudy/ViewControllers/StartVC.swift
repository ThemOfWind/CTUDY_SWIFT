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
    @IBOutlet weak var signatureImg: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    fileprivate func config() {
//        // navigationbar
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.none
        self.rightItem = RightItem.none
        
        // logo ui
        signatureImg.tintColor = COLOR.SIGNATURE_COLOR
        
        // btn ui
        self.signUpBtn.tintColor = .white
        self.signUpBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.signUpBtn.layer.cornerRadius = 30
        self.loginBtn.tintColor = .white
        self.loginBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.loginBtn.layer.cornerRadius = 30
    }
    
    // MARK: - pop func
    @IBAction func unwindLoginVC(_ segue: UIStoryboardSegue) {}
}
