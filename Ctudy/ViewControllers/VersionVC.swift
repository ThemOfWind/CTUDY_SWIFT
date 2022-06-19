//
//  VersionVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/17.
//

import Foundation
import UIKit

class VersionVC: BasicVC {
    // MARK: - 변수
    @IBOutlet weak var ctudyImg: UIImageView!
    @IBOutlet weak var versionMsg: UILabel!
    @IBOutlet weak var currentVersion: UILabel!
    var updateBtn = UIButton()
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar
        self.navigationController?.navigationBar.sizeToFit() // UIKit에 포함된 특정 View를 자체 내부 요구의 사이즈로 resize 해주는 함수
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "버전정보", isLargeTitles: false)
        
        // ctudy image
        ctudyImg.image = UIImage(named: "ctudy_icon.png")
        
        // version message label
        checkVersionTask()
        self.versionMsg.text = "최신 버전을 사용 중입니다."
        self.versionMsg.textColor = COLOR.SUBTITLE_COLOR
        self.currentVersion.text = "현재 버전 \(APP.VERSION)"
        self.currentVersion.textColor = COLOR.SUBTITLE_COLOR
    }
    
    fileprivate func checkVersionTask() {
        _ = try? AppVersionCheck.isUpdateAvailable { (update, error) in
            
            if let error = error {
                print("VersionVC - AppVersionCheck() error: \(error)")
            } else if let update = update {
                if update {
                    print("This App is old version")
                    self.versionMsg.text = "현재 버전은 최신 버전이 아닙니다."
                    self.createButton()
                    return
                } else {
                    print("This App is latest version")
                }
            }
        }
    }
    
    fileprivate func createButton() {
        self.view.addSubview(updateBtn)
        updateBtn.translatesAutoresizingMaskIntoConstraints = false
        updateBtn.topAnchor.constraint(equalTo: self.currentVersion.topAnchor, constant: 20).isActive = true
        updateBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        updateBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        updateBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 20).isActive = true
        updateBtn.setTitle("업 데 이 트 하 러 가 기", for: .normal)
        updateBtn.setTitleColor(.white, for: .normal)
        updateBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        updateBtn.addTarget(self, action: #selector(onUpdateBtnClicked), for: .touchUpInside)
    }
    
    @objc fileprivate func onUpdateBtnClicked() {
        // 앱 스토어 일반 정보의 Apple ID
        let appleId = ""
        
        // UIApplication은 Main Thread에서 처리
        DispatchQueue.main.async {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleId)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
    }
}
