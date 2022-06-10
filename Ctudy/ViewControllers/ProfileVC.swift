//
//  ProfileVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/28.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ProfileVC: UIViewController, UIGestureRecognizerDelegate {
    // MARK: - 변수
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileSettingBtn: UIButton!
    @IBOutlet weak var profileUsername: UILabel!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: ProfileVC.self, action: nil)
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
    
    // MARK: - overrid func
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.config()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar ui
        
        // profile
        profileImg.layer.cornerRadius = profileImg.bounds.height / 2
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        profileImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        profileImg.tintColor = COLOR.BASIC_TINT_COLOR
        if let userImg = KeyChainManager().tokenLoad(API.SERVICEID, account: "image"), userImg != "" {
            profileImg.kf.setImage(with: URL(string: API.IMAGE_URL + userImg)!, options: [.forceRefresh])
        } else {
            profileImg.image = UIImage(named: "user_default.png")
        }
        profileImg.contentMode = .scaleAspectFill
        profileImg.translatesAutoresizingMaskIntoConstraints = false
        profileImg.isUserInteractionEnabled = true
        
        profileName.text = KeyChainManager().tokenLoad(API.SERVICEID, account: "name")
        profileUsername.text = "@\(KeyChainManager().tokenLoad(API.SERVICEID, account: "username")!)"
        profileUsername.textColor = COLOR.SUBTITLE_COLOR
        
        // btn ui
        profileSettingBtn.tintColor = COLOR.SIGNATURE_COLOR
        profileSettingBtn.setImage(UIImage(systemName: "pencil"), for: .normal)
        profileSettingBtn.contentMode = .center
        
        // image, btn 연결 event
        profileSettingBtn.addTarget(self, action: #selector(onProfileSettingBtnClicked), for: .touchUpInside)
        
        // delegate 연결
        tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
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
    
    // MARK: - @objc func
    @objc fileprivate func onProfileSettingBtnClicked() {
        self.performSegue(withIdentifier: "ProfileSettingVC", sender: nil)
    }
    
    fileprivate func onProfileImageClicked() {
        self.performSegue(withIdentifier: "ProfileSettingVC", sender: nil)
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: profileImg) == true {
            view.endEditing(true)
            onProfileImageClicked()
            return true
        } else {
            view.endEditing(true)
            return true
        }
        return true
    }
}
