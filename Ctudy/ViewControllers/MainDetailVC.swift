//
//  MainDetailVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/21.
//

import Foundation
import UIKit

class MainDetailVC : BasicVC {
    
    @IBOutlet weak var studyRoom: UILabel!
    @IBOutlet weak var profileUserImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var couponBtn: UIButton!
    @IBOutlet weak var myCouponBtn: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var memberTableView: UITableView!
    var profileId: Int? // 접속 회원 id
    var roomName: Int? // 스터디룸 id
    var roomNameString: String? // 스터디룸 name
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        
        print("MainDetailVC - viewDidLoad() called / roomName: \(self.roomName), roomNameString: \(self.roomNameString)")
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.none
        self.rightItem = RightItem.anyCustoms(items: [.setting], title: nil, rightSpaceCloseToDefault: false)
    
        // label
        self.studyRoom.text = roomNameString
        
        // profile
        self.profileUserImg.layer.cornerRadius = self.profileUserImg.bounds.height / 2
        self.profileUserImg = nil
        self.profileId = Int(KeyChainManager().tokenLoad(API.SERVICEID, account: "id")!)
        self.profileName.text = KeyChainManager().tokenLoad(API.SERVICEID, account: "name")
        self.profileUserName.text = KeyChainManager().tokenLoad(API.SERVICEID, account: "userName")
        self.profileUserName.textColor = COLOR.SUBTITLE_COLOR
        
        // btn
        self.btnStackView.layer.cornerRadius = self.btnStackView.bounds.height / 2
        self.btnStackView.backgroundColor = COLOR.SIGNATURE_COLOR_TRANSPARENCY_10
        
        self.couponBtn.tintColor = COLOR.SIGNATURE_COLOR
        self.couponBtn.backgroundColor = .white
        self.couponBtn.layer.cornerRadius = self.couponBtn.bounds.height / 2
        
        self.myCouponBtn.tintColor = .white
        self.myCouponBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        self.myCouponBtn.layer.cornerRadius = self.couponBtn.bounds.height / 2
    }
    
    // MARK: - btn action func
    func rightItemAction(items: [UIBarButtonItem]) {
        print("오잉")
    }
}
