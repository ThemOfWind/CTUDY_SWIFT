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
import NVActivityIndicatorView
import SwiftUI

class MainDetailVC : BasicVC, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 변수
    //    @IBOutlet weak var studyRoom: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var couponBtn: UIButton!
    @IBOutlet weak var myCouponBtn: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var memberTableView: UITableView!
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        indicatorView.backgroundColor = UIColor.white
        indicatorView.isOpaque = false
        return indicatorView
    }()
    lazy var indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                type: .pacman,
                                                color: COLOR.SIGNATURE_COLOR,
                                                padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    lazy var loading: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "loading..."
        label.textColor = COLOR.SIGNATURE_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var roomId: Int! // 전달받은 스터디룸 id
    var members: Array<SearchStudyMemberResponse> = [] // 전달할 멤버 리스트
    var settingRoom: SettingStudyRoomResponse! // 전달할 room 정보
    var isMaster: Bool = false // 사용자가 master인지 체크, 전달할 master bool값
    let profileId = Int(KeyChainManager().tokenLoad(API.SERVICEID, account: "id")!) // 사용자 id
    
    // MARK: - view load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSearchStudyMemeber(id: String(roomId))
        config()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // 다음 화면 이동 시 입력받은 이름정보 넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "RegisterCouponFirstVC" {
            if let controller = segue.destination as? RegisterCouponFirstVC {
                var memberList = [SearchStudyMemberResponse]()
                
                for index in 0..<members.count {
                    if profileId != members[index].id {
                        let member = SearchStudyMemberResponse(id: members[index].id, name: members[index].name, username: members[index].username, image: members[index].image, coupon: members[index].coupon)
                        memberList.append(member)
                    }
                }
                
                controller.members = memberList
                controller.roomId = roomId
            }
        } else if let id = segue.identifier, id == "StudyRoomSettingVC" {
            if let controller = segue.destination as? StudyRoomSettingVC {
                var memberList = [SearchStudyMemberResponse]()
                
                for index in 0..<members.count {
                    if profileId != members[index].id {
                        let member = SearchStudyMemberResponse(id: members[index].id, name: members[index].name, username: members[index].username, image: members[index].image, coupon: members[index].coupon)
                        memberList.append(member)
                    }
                }
                
                controller.members = memberList
                controller.settingRoom = settingRoom
                controller.isMaster = isMaster
            }
        } else if let id = segue.identifier, id == "CouponVC" {
            if let controller = segue.destination as? CouponVC {
                controller.roomId = roomId
            }
        }
    }
    
    fileprivate func config() {
        // navigationbar item 설정
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "", isLargeTitles: true)
        rightItem = RightItem.anyCustoms(items: [.setting], title: nil, rightSpaceCloseToDefault: false)
        
        // profile
        profileImg.layer.cornerRadius = self.profileImg.bounds.height / 2
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        profileImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        profileImg.tintColor = COLOR.BASIC_TINT_COLOR
        if let userImg = KeyChainManager().tokenLoad(API.SERVICEID, account: "image"), userImg != "" {
            profileImg.kf.setImage(with: URL(string: API.IMAGE_URL + userImg)!)
        } else {
            profileImg.image = UIImage(named: "user_default.png")
        }
        profileImg.contentMode = .scaleAspectFill
        profileImg.translatesAutoresizingMaskIntoConstraints = false
        
        profileName.text = KeyChainManager().tokenLoad(API.SERVICEID, account: "name")
        profileUsername.text = "@\(KeyChainManager().tokenLoad(API.SERVICEID, account: "username")!)"
        profileUsername.textColor = COLOR.SUBTITLE_COLOR
        
        // btn
        btnStackView.layer.cornerRadius = btnStackView.bounds.height / 2
        btnStackView.backgroundColor = COLOR.SIGNATURE_COLOR_TRANSPARENCY_10
        
        couponBtn.tintColor = COLOR.SIGNATURE_COLOR
        couponBtn.backgroundColor = .white
        couponBtn.layer.cornerRadius = couponBtn.bounds.height / 2
        
        myCouponBtn.tintColor = .white
        myCouponBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        myCouponBtn.layer.cornerRadius = couponBtn.bounds.height / 2
        
        // 셀 리소스 파일 가져오기
        let memberCell = UINib(nibName: String(describing: StudyMemberTableViewCell.self), bundle: nil)
        let emptyCell = EmptyTableViewCell.nib()
        
        // 셀 리소스 등록하기
        memberTableView.register(memberCell, forCellReuseIdentifier: "StudyMemberTableViewCell")
        memberTableView.register(emptyCell, forCellReuseIdentifier: "EmptyTableViewCell")
        
        // 셀 설정
        memberTableView.rowHeight = 100
//        memberTableView.allowsSelection = false
        memberTableView.showsVerticalScrollIndicator = false // scroll 제거
        
        // delegete
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
    
    // MARK: - indicator in api calling
    fileprivate func onStartActivityIndicator() {
        DispatchQueue.main.async {
            // 불투명 뷰 추가
            self.view.addSubview(self.indicatorView)
            // activity indicator 추가
            self.indicatorView.addSubview(self.indicator)
            self.indicatorView.addSubview(self.loading)
            
            NSLayoutConstraint.activate([
                self.indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.loading.centerYAnchor.constraint(equalTo: self.indicator.bottomAnchor, constant: 5)
            ])
            
            // 애니메이션 시작
            self.indicator.startAnimating()
        }
    }
    
    fileprivate func onStopActivityIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // 애니메이션 정지.
            // 서버 통신 완료 후 다음의 메서드를 실행해서 통신의 끝나는 느낌을 줄 수 있다.
            self.indicator.stopAnimating()
            self.indicatorView.removeFromSuperview()
        }
    }
    
    // MARK: - search room member api
    fileprivate func getSearchStudyMemeber(id: String) {
        self.members.removeAll()
        
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
                let coupon = masterList["coupon"].int ?? 0
                
                let masterItem = SearchStudyMemberResponse(id: id, name: name + "⭐️", username: username, image: image, coupon: coupon)
                self.members.append(masterItem)
                
                // 멤버 정보
                let memberList = response["members"]
                for (_, subJson) : (String, JSON) in memberList {
                    guard let id = subJson["id"].int
                            , let username = subJson["username"].string
                            , let name = subJson["name"].string else { return }
                    let image = subJson["image"].string ?? ""
                    let coupon = subJson["coupon"].int ?? 0
                    
                    let memberItem = SearchStudyMemberResponse(id: id, name: name, username: username, image: image, coupon: coupon)
                    self.members.append(memberItem)
                }
                
                self.settingRoom = SettingStudyRoomResponse(id: response["id"].int!, name: response["name"].string!, masterid: id, mastername: name, banner: response["banner"].string ?? "")
                
                // 현재 사용자가 master인지 체크
                self.titleItem = TitleItem.titleGeneral(title: self.settingRoom.name, isLargeTitles: true)
                if self.settingRoom.masterid == self.profileId {
                    self.isMaster = true
                } else {
                    self.isMaster = false
                }
                
                // view reload
                self.memberTableView.reloadData()
            case .failure(let error):
                print("MainDetailVC - getSearchStudyMember.failure / error: \(error.rawValue)")
            }
        })
    }
    
    // MARK: - delete memeber api
    fileprivate func onDeleteBtnClicked(id: String, index: Int) {
        // logout alert 띄우기
        let alert = UIAlertController(title: nil, message: "멤버를 강퇴하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            
            self.onStartActivityIndicator()
            
            AlamofireManager.shared.deleteStudyMember(id: id, memberlist: [self.members[index].id], completion: {
                [weak self] result in
                guard let self = self else { return }
                
                self.onStopActivityIndicator()
                
                switch result {
                case .success(_):
                    self.getSearchStudyMemeber(id: String(self.roomId))
                case .failure(let error):
                    print("MainDetailVC - deleteStudyMember().failure / error: \(error)")
                    self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                }
            })
            
            if self.indicator.isAnimating {
                self.onStopActivityIndicator()
            }
        }))
        
        self.present(alert, animated: false)
    }
    
    // MARK: - return view func
    @IBAction func unwindMainDetailVC(_ segue: UIStoryboardSegue) {}
    
    // MARK: - navigation right button func
    override func anyItemAction(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "StudyRoomSettingVC", sender: nil)
    }
    
    // MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if members.count == 0 {
            return 1
        } else {
            return members.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if members.isEmpty == true {
            let cell = memberTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "아직 초대한 멤버가 없습니다."
            cell.subtitleLabel.text = "초대는 방장만 가능합니다.\n방장은 '설정>멤버초대'를 통해서\n멤버를 초대할 수 있습니다."
            memberTableView.rowHeight = self.memberTableView.bounds.height
            return cell
        } else {
            let cell = memberTableView.dequeueReusableCell(withIdentifier: "StudyMemberTableViewCell", for: indexPath) as! StudyMemberTableViewCell
            cell.selectionStyle = .none // 선택 block 없애기
            cell.member.text = members[indexPath.row].name
            cell.memberName.text = "@\(members[indexPath.row].username)"
            //        let coupon = String("0\(members[indexPath.row].coupon)")
            cell.couponCnt.text = "쿠폰 \(String(format: "%02d", members[indexPath.row].coupon))"
            if members[indexPath.row].image != "" {
                cell.memberImg.kf.setImage(with: URL(string: API.IMAGE_URL + members[indexPath.row].image)!)
            } else {
                cell.memberImg.image = UIImage(named: "user_default.png")
            }
            memberTableView.rowHeight = 100
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if members.isEmpty == true {
            return nil
        } else {
            if isMaster, indexPath.row > 0 {
                let delete = UIContextualAction(style: .normal, title: "내보내기") {
                    (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                    print("member delete click! / indexPath: \(indexPath.row)")
                    self.onDeleteBtnClicked(id: String(self.roomId), index: indexPath.row)
                    success(true)
                }
                delete.backgroundColor = .systemPink
                delete.image = UIImage(systemName: "trash")
                
                // actions배열 인덱스 0이 왼쪽에 붙음
                return UISwipeActionsConfiguration(actions: [delete])
            } else {
                return nil
            }
        }
    }
}
