//
//  UserInfoVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/28.
//

import Foundation
import UIKit

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.config()
    }
    
    fileprivate func config() {
        // Btn 연결 event
        self.logoutBtn.addTarget(self, action: #selector(onLogoutBtnClicked), for: .touchUpInside)
    }
    
    // logoutBtn event
    @objc func onLogoutBtnClicked() {
        // logout alert 띄우기
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            AlamofireManager.shared.getLogout(completion: {
                [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let checkData):
                    print("UserInfoVC - getLogout.success")
                    
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.view.makeToast("로그아웃 되었습니다.", duration: 1.0, position: .center)
                    
                case .failure(let error):
                    print("UserInfoVC - getLogout.failure / error: \(error)")
                    // 중복사용 문구 띄우기
                    
                    guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC, animated: false)
                    
                    //self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                }
            })
        }))
        
        self.present(alert, animated: false)
    }
}
