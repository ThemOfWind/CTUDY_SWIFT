//
//  RoomSettingVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/18.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class StudyRoomSettingVC: BasicVC, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 변수
    @IBOutlet weak var settingTableView: UITableView!
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        indicatorView.backgroundColor = UIColor.white
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
    var members: Array<SearchStudyMemberResponse>? // 전달받은 멤버 리스트
    var settingRoom: SettingStudyRoomResponse! // 전달받은 room 정보
    var isMaster: Bool! // 사용자가 master인지 체크, 전달받은 master bool값
    var settingList: Array<SettingModel> = [] // 셋팅 항목
    
    // MARK: - view load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        config()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "UpdateStudyRoomVC" {
            if let controller = segue.destination as? UpdateStudyRoomVC {
                controller.members = members
                controller.settingRoom = settingRoom
            }
        } else if let id = segue.identifier, id == "AddStudyRoomMemberVC" {
            if let controller = segue.destination as? AddStudyRoomMemberVC {
                controller.roomId = settingRoom.id
            }
        }
    }
    
    fileprivate func config() {
        // navigationbar
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "스터디룸 관리", isLargeTitles: true)

        // 셀 리소스 파일 가져오기2
        let settingCell = UINib(nibName: String(describing: SettingTableViewCell.self), bundle: nil)
        
        // 셀 리소스 등록하기
        self.settingTableView.register(settingCell, forCellReuseIdentifier: "SettingTableViewCell")
        
        // 셀 설정
        self.settingTableView.rowHeight = 80
        //        self.settingTableView.allowsSelection = true
        self.settingTableView.showsVerticalScrollIndicator = false // scroll 제거
        
        // delegate 연결
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        
        // list 담기
        // 사용자가 master일 경우
        if isMaster {
            let setting = SettingModel(id: "setting", text: "스터디룸 설정", color: "black", page: "UpdateStudyRoomVC")
            let add = SettingModel(id: "add", text: "멤버 초대", color: "black", page: "AddStudyRoomMemberVC")
            settingList.append(setting)
            settingList.append(add)
        }
        
        let out = SettingModel(id: "out", text: "나가기", color: "red", page: "")
        settingList.append(out)
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
    
    // MARK: - out studyroom api
    fileprivate func outStudyRoom() {
        if isMaster {
            print("click!")
            let alert = UIAlertController(title: nil, message: "스터디룸을 나갈 수 없습니다.\n'스터디룸관리>스터디룸설정'에서 방장을 변경해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
            return
//            self.view.makeToast("방장은 스터디룸을 나갈 수 없습니다.\n'스터디룸관리>스터디룸설정'에서 방장을 변경해주세요.", duration: 2.0, position: .center)
        }
        
        // out alert 띄우기
        let alert = UIAlertController(title: nil, message: "스터디룸을 나가시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            
            self.onStartActivityIndicator()
            
            AlamofireManager.shared.deleteOutRoom(id: String(self.settingRoom.id), memberId: KeyChainManager().tokenLoad(API.SERVICEID, account: "id")!, completion: {
                [weak self] result in
                guard let self = self else { return }
                
                self.onStopActivityIndicator()
                
                switch result {
                case .success(let checkData):
                    print("StudyRoomSettingVC - deleteOutRoom().success")
                    self.performSegue(withIdentifier: "unwindMainTabBarVC", sender: self)
                    self.navigationController?.view.makeToast("스터디룸 '\(self.settingRoom.name)'을(를) 탈퇴했습니다.", duration: 1.0, position: .center)
                case .failure(let error):
                    print("StudyRoomSettingVC - deleteOutRoom().failure / error: \(error)")
                }
            })
            
            if self.indicator.isAnimating {
                self.onStopActivityIndicator()
            }
            
        }))
        
        self.present(alert, animated: false)
    }
    
    // MARK: - tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("StudyRoomSettingVC - tableView() called / cellText: \(settingList[(indexPath as NSIndexPath).row]["text"] as! String)")
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.selectionStyle = .none // 선택 block 없애기
//        cell.settingLabel.text = settingList[(indexPath as NSIndexPath).row]["text"] as! String
//        cell.settingLabel.textColor = settingList[(indexPath as NSIndexPath).row]["color"] as! UIColor
        cell.settingLabel.text = settingList[indexPath.row].text
        cell.settingLabel.textColor = UIColor(named: settingList[indexPath.row].color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch settingList[(indexPath as NSIndexPath).row]["id"] as! String {
        switch settingList[indexPath.row].id {
        case "out":
            // 나가기 (스터디룸 화면으로 이동)
            outStudyRoom()
            break
        default:
            self.performSegue(withIdentifier: settingList[indexPath.row].page, sender: self)
            break
        }
    }
}
