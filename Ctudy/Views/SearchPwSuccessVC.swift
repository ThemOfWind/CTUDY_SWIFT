//
//  SearchPwSuccessVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/27.
//

import Foundation
import UIKit

class SearchPwSuccessVC: BasicVC {
    // MARK: - 변수
    @IBOutlet weak var homeBtn: UIButton!
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchPwSuccessVC - viewDidLoad() called")
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.titleGeneral(title: "비밀번호 변경", isLargeTitles: true)
        
        // ui
        self.homeBtn.tintColor = .white
        self.homeBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.homeBtn.layer.cornerRadius = 10
        
        // button event 연결
        self.homeBtn.addTarget(self, action: #selector(onGoToHomeBtnClicked(_:)), for: .touchUpInside)
    }
    
    // MARK: - override func
    @objc fileprivate func onGoToHomeBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindStartVC", sender: self)
    }
}
