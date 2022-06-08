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
    var members: Array<SearchStudyMemberResponse> = [] // 전달할 멤버 리스트
    var settingRoom: SettingStudyRoomResponse! // 전달할 room 정보
    let userId = Int(KeyChainManager().tokenLoad(API.SERVICEID, account: "id")!) // 사용자 id
    var profileId: Int? // 접속 회원 id
    var roomId: Int! // 스터디룸 id
//    var roomName: String? // 스터디룸 name
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        indicatorView.backgroundColor = COLOR.INDICATOR_BACKGROUND_COLOR
        return indicatorView
    }()
    lazy var indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                type: .pacman,
                                                color: COLOR.BASIC_TINT_COLOR,
                                                padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    lazy var loading: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "loading..."
        label.textColor = COLOR.BASIC_TINT_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - override func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getSearchStudyMemeber(id: String(roomId))
        config()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.members.removeAll()
        super.viewDidDisappear(animated)
    }
    
    // 다음 화면 이동 시 입력받은 이름정보 넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "RegisterCouponVC" {
            if let controller = segue.destination as? RegisterCouponVC {
                var memberList = [SearchStudyMemberResponse]()
                
                for index in 0..<members.count {
                    if userId != members[index].id {
                        let member = SearchStudyMemberResponse(id: members[index].id, name: members[index].name, username: members[index].username, image: members[index].image)
                        memberList.append(member)
                    }
                }
                
                controller.members = memberList
                controller.roomId = roomId
            }
        } else if let id = segue.identifier, id == "SettingStudyRoomVC" {
            if let controller = segue.destination as? SettingStudyRoomVC {
                if let controller = segue.destination as? SettingStudyRoomVC {
                    var memberList = [SearchStudyMemberResponse]()
                    
                    for index in 0..<members.count {
                        if userId != members[index].id {
                            let member = SearchStudyMemberResponse(id: members[index].id, name: members[index].name, username: members[index].username, image: members[index].image)
                            memberList.append(member)
                        }
                    }
                    
                    controller.members = memberList
                    controller.settingRoom = settingRoom
                }
            }
        }
    }
     
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item 설정
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "", isLargeTitles: true)
//        rightItem = RightItem.none
        
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
        
        profileId = Int(KeyChainManager().tokenLoad(API.SERVICEID, account: "id")!)
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
        
        // 셀 리소스 등록하기
        memberTableView.register(memberCell, forCellReuseIdentifier: "StudyMemberTableViewCell")
        
        // 셀 설정
        memberTableView.rowHeight = 90
        memberTableView.allowsSelection = false
        memberTableView.showsVerticalScrollIndicator = false // scroll 제거
        
        // delegete
        memberTableView.delegate = self
        memberTableView.dataSource = self
    }
    
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
    
    // 스터디룸 멤버 조회
    fileprivate func getSearchStudyMemeber(id: String) {
        
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.getSearchStudyMember(id: id, completion: {
            [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let response):
                // 마스터 정보
                let masterList = response["master"]
                guard let id = masterList["id"].int
                    , let username = masterList["username"].string
                    , let name = masterList["name"].string else { return }
                let image = masterList["image"].string ?? ""
                
                let masterItem = SearchStudyMemberResponse(id: id, name: name + "⭐️", username: username, image: image)
                self.members.append(masterItem)
                
                // 멤버 정보
                let memberList = response["members"]
                for (_, subJson) : (String, JSON) in memberList {
                    guard let id = subJson["id"].int
                        , let username = subJson["username"].string
                        , let name = subJson["name"].string else { return }
                    let image = subJson["image"].string ?? ""
                    
                    let memberItem = SearchStudyMemberResponse(id: id, name: name, username: username, image: image)
                    self.members.append(memberItem)
                }

                self.settingRoom = SettingStudyRoomResponse(id: response["id"].int!, name: response["name"].string!, masterid: id, mastername: name, banner: response["banner"].string ?? "")
                
                self.titleItem = TitleItem.titleGeneral(title: self.settingRoom.name, isLargeTitles: true)
                if self.settingRoom.masterid == self.userId {
                    self.rightItem = RightItem.anyCustoms(items: [.setting], title: nil, rightSpaceCloseToDefault: false)
                }
                
                // view reload
                self.memberTableView.reloadData()
            case .failure(let error):
                print("MainDetailVC - getSearchStudyMember.failure / error: \(error.rawValue)")
            }
            
        })
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // MARK: - btn action func
    override func AnyItemAction(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "SettingStudyRoomVC", sender: nil)
    }
    
    // MARK: - delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "StudyMemberTableViewCell", for: indexPath) as! StudyMemberTableViewCell
        cell.member.text = members[indexPath.row].name
        cell.memberName.text = "@\(members[indexPath.row].username)"
        cell.couponCnt.text = "쿠폰 00"
        if members[indexPath.row].image != "" {
            cell.memberImg.kf.setImage(with: URL(string: API.IMAGE_URL + members[indexPath.row].image)!)
        } else {
            cell.memberImg.image = UIImage(named: "user_default.png")
        }

        return cell
    }
}
