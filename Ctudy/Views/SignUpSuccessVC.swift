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
    @IBOutlet weak var goToStartBtn: UIButton!
    var memberName: String?
    var memberUserName: String?
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigationBar setting
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.none
        
        // btn ui
        self.goToStartBtn.tintColor = .white
        self.goToStartBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.goToStartBtn.layer.cornerRadius = 10
        
        // label ui
        self.enterName.text = memberName
    }
    
    // MARK: - action func
    // start 화면으로 이동
    @IBAction func onGoToStartBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindStartVC", sender: self)
    }
}
