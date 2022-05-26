//
//  MainDetailVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/21.
//

import Foundation
import UIKit
import SwiftyJSON
import Kingfisher

class MainDetailVC : BasicVC, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 변수
//    @IBOutlet weak var studyRoom: UILabel!
    @IBOutlet weak var profileUserImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUserName: UILabel!
    @IBOutlet weak var couponBtn: UIButton!
    @IBOutlet weak var myCouponBtn: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var memberTableView: UITableView!
    var members: Array<SearchStudyMemberResponse> = [] // 멤버 리스트
    var profileId: Int? // 접속 회원 id
    var roomName: Int? // 스터디룸 id
    var roomNameString: String? // 스터디룸 name
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        
        print("MainDetailVC - viewDidLoad() called / roomName: \(String(describing: self.roomName)), roomNameString: \(String(describing: self.roomNameString))")
    }
     
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: roomNameString, isLargeTitles: true)
        self.rightItem = RightItem.anyCustoms(items: [.setting], title: nil, rightSpaceCloseToDefault: false)
        
        // label
//        self.studyRoom.text = roomNameString
        
        // profile
        self.profileUserImg.layer.cornerRadius = self.profileUserImg.bounds.height / 2
        self.profileUserImg.layer.borderWidth = 1
        self.profileUserImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        self.profileUserImg.backgroundColor = COLOR.DISABLE_COLOR
        self.profileUserImg.tintColor = COLOR.SUBTITLE_COLOR
        if let userImg = KeyChainManager().tokenLoad(API.SERVICEID, account: "image"), userImg != "" {
            self.profileUserImg.kf.setImage(with: URL(string: API.IMAGE_URL + userImg)!)
        } else {
            self.profileUserImg.image = UIImage(named: "user_default.png")
//            self.profileUserImg.image = UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large))
        }
        self.profileUserImg.contentMode = .scaleAspectFill
        
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
        
        // 셀 리소스 파일 가져오기
        let memberCell = UINib(nibName: String(describing: StudyMemberTableViewCell.self), bundle: nil)
        
        // 셀 리소스 등록하기
        self.memberTableView.register(memberCell, forCellReuseIdentifier: "StudyMemberTableViewCell")
        
        // 셀 설정
        self.memberTableView.rowHeight = 90
        self.memberTableView.allowsSelection = false
        self.memberTableView.showsVerticalScrollIndicator = false // scroll 제거
        
        // delegete
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
        
        // 스터디룸 멤버 조회
        if let id = roomName {
            getSearchStudyMemeber(id: String(id))
        }
    }
    
    // 스터디룸 멤버 조회
    fileprivate func getSearchStudyMemeber(id: String) {
        AlamofireManager.shared.getSearchStudyMember(id: id, completion: {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                // 마스터 정보
                let masterList = response["master"]
                guard let id = masterList["id"].int
                    , let username = masterList["username"].string
                    , let name = masterList["name"].string else { return }
                let image = masterList["image"].string ?? ""
                
                let masterItem = SearchStudyMemberResponse(id: id, name: name + "⭐️", userName: username, image: image)
                self.members.append(masterItem)
                
                // 멤버 정보
                let memberList = response["members"]
                for (_, subJson) : (String, JSON) in memberList {
                    guard let id = subJson["id"].int
                        , let username = subJson["username"].string
                        , let name = subJson["name"].string else { return }
                    let image = subJson["image"].string ?? ""
                    
                    let memberItem = SearchStudyMemberResponse(id: id, name: name, userName: username, image: image)
                    self.members.append(memberItem)
                }
                
                // view reload
                self.memberTableView.reloadData()
            case .failure(let error):
                print("MainDetailVC - getSearchStudyMember.failure / error: \(error.rawValue)")
            }
        })
    }
    
    // MARK: - btn action func
    override func AnyItemAction(sender: UIBarButtonItem) {
        // setting btn
        print("setting btn click!!")
    }
    
    // MARK: - delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "StudyMemberTableViewCell", for: indexPath) as! StudyMemberTableViewCell
        cell.member.text = members[indexPath.row].name
        cell.memberName.text = "@\(members[indexPath.row].userName)"
        cell.couponCnt.text = cell.couponCnt.text!
        if members[indexPath.row].image != "" {
            cell.memberImg.kf.setImage(with: URL(string: API.IMAGE_URL + members[indexPath.row].image)!)
        } else {
            cell.memberImg.image = UIImage(named: "user_default.png")
        }
        return cell
    }
}
