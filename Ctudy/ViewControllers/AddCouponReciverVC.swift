//
//  AddCouponReciverVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/30.
//

import Foundation
import UIKit
import SwiftyJSON
import Kingfisher

class AddCouponReciverVC: BasicVC, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 변수
    @IBOutlet weak var memberTableView: UITableView!
    var members: Array<SearchStudyMemberResponse>? // 전달받은 스터디룸 멤버 리스트
    weak var delegate: CouponSendDelegate?
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddCouponReciverVC - viewDidLoad() called")
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // custon 셀 설정
        let memberCell = UINib(nibName: String(describing: StudyMemberTableViewCell.self), bundle: nil)
        self.memberTableView.register(memberCell, forCellReuseIdentifier: "StudyMemberTableViewCell")
        self.memberTableView.rowHeight = 90
        self.memberTableView.allowsSelection = true
        self.memberTableView.showsVerticalScrollIndicator = false
        
        // delegate 연결
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memberList = members {
            return members!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "StudyMemberTableViewCell", for: indexPath) as! StudyMemberTableViewCell
        if let memberList = members {
            cell.member.text = memberList[indexPath.row].name
            cell.memberName.text = "@\(memberList[indexPath.row].username)"
            cell.couponCnt.text = ""
            if memberList[indexPath.row].image != "" {
                cell.memberImg.kf.setImage(with: URL(string: API.IMAGE_URL + memberList[indexPath.row].image)!)
            } else {
                cell.memberImg.image = UIImage(named: "user_default.png")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.onMemberViewClicked(receiver: CouponReciverRequest(id: members![indexPath.row].id, name: members![indexPath.row].name, username: members![indexPath.row].username, image: members![indexPath.row].image))
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}