//
//  SettingVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/08.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftUI

class SettingVC: BasicVC, UITableViewDelegate, UITableViewDataSource {
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
    // 셋팅 항목
//    let settingList = [
//        [ "id" : "profile", "text" : "프로필 설정", "color" : UIColor.black ]
//        , [ "id" : "username", "text" : "계정관리", "color" : UIColor.black ]
//        , [ "id" : "privacy", "text" : "개인정보 처리 방침", "color" : UIColor.black ]
//        , [ "id" : "service", "text" : "이용약관", "color" : UIColor.black ]
//        , [ "id" : "opensource", "text" : "오픈소스 라이센스 이용고지", "color" : UIColor.black ]
//        , [ "id" : "version", "text" : "버전정보", "color" : UIColor.black ]
//        , [ "id" : "logout", "text" : "로그아웃", "color" : UIColor.red ]
//    ]
    var settingList: Array<SettingModel> = []
    
    // MARK: - view load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "설정", isLargeTitles: true)
        
        // list 담기
        let profile = SettingModel(id: "profile", text: "프로필 설정", color: "black", page: "UpdateProfileVC")
        let username = SettingModel(id: "username", text: "계정관리", color: "black", page: "UpdatePasswordVC")
        let privacy = SettingModel(id: "privacy", text: "개인정보 처리 방침", color: "black", page: "PrivacyVC")
        let service = SettingModel(id: "service", text: "이용약관", color: "black", page: "ServiceVC")
        let opensource = SettingModel(id: "opensource", text: "오픈소스 라이센스 이용고지", color: "black", page: "OpenSourceVC")
        let version = SettingModel(id: "version", text: "버전정보", color: "black", page: "VersionVC")
        let logout = SettingModel(id: "logout", text: "로그아웃", color: "red", page: "")
        settingList.append(profile)
        settingList.append(username)
        settingList.append(privacy)
        settingList.append(service)
        settingList.append(opensource)
        settingList.append(version)
        settingList.append(logout)

        // 셀 리소스 파일 가져오기
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
    
    // logoutBtn event
    fileprivate func logout() {
        // logout alert 띄우기
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            
            self.onStartActivityIndicator()
            
            AlamofireManager.shared.getLogout(completion: {
                [weak self] result in
                guard let self = self else { return }
                
                self.onStopActivityIndicator()
                
                switch result {
                case .success(let checkData):
                    print("SettingVC - logout().success")
                    //                    self.navigationController?.popViewController(animated: true)
                    self.performSegue(withIdentifier: "unwindStartVC", sender: self)
                    self.navigationController?.view.makeToast("로그아웃 되었습니다.", duration: 1.0, position: .center)
                case .failure(let error):
                    print("SettingVC - logout().failure / error: \(error)")
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
//        print("SettingVC - tableView() called / cellText: \(settingList[(indexPath as NSIndexPath).row]["text"] as! String)")
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.selectionStyle = .none // 선택 block 없애기
        cell.tag = indexPath.row
//        cell.settingLabel.text = settingList[(indexPath as NSIndexPath).row]["text"] as! String
//        cell.settingLabel.textColor = settingList[(indexPath as NSIndexPath).row]["color"] as! UIColor
        cell.settingLabel.text = settingList[indexPath.row].text
        cell.settingLabel.textColor = UIColor(named: settingList[indexPath.row].color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // switch settingList[(indexPath as NSIndexPath).row]["id"] as! String {
        switch settingList[indexPath.row].id {
        case "logout":
            //로그아웃 (Start화면으로 이동)
            logout()
            break
        default:
            // 해당화면으로 이동 (프로필설정, 계정관리, 개인정보 처리 방침, 이용약관, 오픈소스 라이센스 이용고지, 버전정보)
            self.performSegue(withIdentifier: settingList[indexPath.row].page, sender: self)
        }
    }
}
