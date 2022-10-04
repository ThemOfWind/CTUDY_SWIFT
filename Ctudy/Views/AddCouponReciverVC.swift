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
        let emptyCell = EmptyTableViewCell.nib()
        
        memberTableView.register(memberCell, forCellReuseIdentifier: "StudyMemberTableViewCell")
        memberTableView.register(emptyCell, forCellReuseIdentifier: "EmptyTableViewCell")
        
        memberTableView.rowHeight = 90
        //        self.memberTableView.allowsSelection = true
        memberTableView.showsVerticalScrollIndicator = false
        
        // delegate 연결
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (members?.count ?? 0) == 0 {
            return 1
        } else {
            return (members?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if members?.isEmpty == true {
            let cell = memberTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "아직 스터디룸 멤버가 없습니다.🥲"
            cell.subtitleLabel.text = "초대는 방장만 가능합니다.\n방장은 '설정>멤버초대'를 통해서\n멤버를 초대할 수 있습니다."
            memberTableView.rowHeight = self.memberTableView.bounds.height
            return cell
        } else {
            let cell = memberTableView.dequeueReusableCell(withIdentifier: "StudyMemberTableViewCell", for: indexPath) as! StudyMemberTableViewCell
            cell.selectionStyle = .none // 선택 block 없애기
            cell.member.text = members![indexPath.row].name
            cell.memberName.text = "@\(members![indexPath.row].username)"
            cell.couponCnt.text = ""
            if members![indexPath.row].image != "" {
                cell.memberImg.kf.indicatorType = .activity
                cell.memberImg.kf.setImage(with: URL(string: API.IMAGE_URL + members![indexPath.row].image)!)
            } else {
                cell.memberImg.image = UIImage(named: "user_default.png")
            }
            memberTableView.rowHeight = 90
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if members?.isEmpty == true {
            return
        } else {
            self.delegate?.onMemberViewClicked(receiver: CouponReciverRequest(id: members![indexPath.row].id, name: members![indexPath.row].name, username: members![indexPath.row].username, image: members![indexPath.row].image))
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
