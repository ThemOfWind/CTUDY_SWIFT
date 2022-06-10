//
//  SearchIdSecondVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/26.
//

import Foundation
import UIKit

class SearchIdSuccessVC: BasicVC {
    // MARK: - 변수
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var uesrName: UILabel!
    var searchId: String? // 넘겨받은 찾은 id
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchIdSuccessVC - viewDidLoad() called")
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.titleGeneral(title: "아이디 찾기", isLargeTitles: true)
        
        // button ui
        self.homeBtn.tintColor = .white
        self.homeBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.homeBtn.layer.cornerRadius = 10
        
        // button event 연결
        self.homeBtn.addTarget(self, action: #selector(onGoToHomeBtnClicked(_:)), for: .touchUpInside)
    }
    
    // MARK: - @objc func
    @objc func onGoToHomeBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindStartVC", sender: self)
    }
}
