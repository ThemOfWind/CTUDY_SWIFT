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
    
    // MARK: - view load func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    fileprivate func config() {
        // navigationbar
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.none
        self.rightItem = RightItem.none
        
        // logo ui
        signatureImg.image = UIImage(named: "ctudy_icon.png")
        signatureImg.tintColor = COLOR.SIGNATURE_COLOR
        
        // btn ui
        self.signUpBtn.tintColor = .white
        self.signUpBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.signUpBtn.layer.cornerRadius = 10
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
        self.loginBtn.tintColor = COLOR.SIGNATURE_COLOR
        self.loginBtn.backgroundColor = .white
        self.loginBtn.layer.cornerRadius = 10
    }
    
    // MARK: - pop func
    @IBAction func unwindStartVC(_ segue: UIStoryboardSegue) {}
}
