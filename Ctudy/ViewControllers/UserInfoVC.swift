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
        
        print("UserInfoVC - viewDidLoad() called")
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.config()
    }
    
    fileprivate func config() {
        self.logoutBtn.addTarget(self, action: #selector(onLogoutBtnClicked), for: .touchUpInside)
    }
    
    @objc func onLogoutBtnClicked() {
        print("UserInfoVC - onLogoutBtnClicked() called")
        
        AlamofireManager.shared.getLogout(completion: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let checkData):
                print("UserInfoVC - getLogout.success")
                // 로컬 데이터 삭제 처리
                //UserInfos.localLogout()
                // 사용가능 문구 띄우기
                self.view.makeToast("로그아웃 되었습니다.", duration: 1.0, position: .center)
                
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    // 로그인화면으로 이동
                    self.navigationController?.popViewController(animated: true)
                })
            case .failure(let error):
                print("UserInfoVC - getLogout.failure / error: \(error)")
                // 중복사용 문구 띄우기
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
    }
}
