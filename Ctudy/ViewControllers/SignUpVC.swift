//
//  SingUpVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/08.
//

import Foundation
import UIKit
import Toast_Swift

class SignUpVC : UIViewController {
    
    @IBOutlet weak var registerName: UITextField!
    @IBOutlet weak var registerUserName: UITextField!
    @IBOutlet weak var registerUserPw: UITextField!
    @IBOutlet weak var registerUserPwChk: UITextField!
    @IBOutlet weak var userNameMsg: UILabel!
    @IBOutlet weak var userPwMsg: UILabel!
    @IBOutlet weak var userPwChkMsg: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var goToLoginBtn: UIButton!
    @IBOutlet weak var checkIdBtn: UIButton!
    
    var memberName : String?
    var memberUserName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SignUpVC - viewDidLoad() called")
        
        self.config()
    }
    
    
    // MARK: - objc and fileprivate methods
    fileprivate func config() {
        // UI
        self.navigationController?.isNavigationBarHidden = true
        checkIdBtn.layer.cornerRadius = 5
        signUpBtn.layer.cornerRadius = 5
        
        // add Btn methods
        checkIdBtn.addTarget(self, action: #selector(onCheckIdBtnClicked), for: .touchUpInside)
        goToLoginBtn.addTarget(self, action: #selector(onGoToLoginBtnClicked), for: .touchUpInside)
    }
    
    @objc func onCheckIdBtnClicked() {
        print("SignUpVC - onCheckIdBtnClicked() called")
        
        
    }
    
    @IBAction func onSignUpBtnClicked(_ sender: Any) {
        print("SignUpVC - onSignUpBtnClicked() called")
        
//        guard let name = registerName.text else {
//
//            return
//        }
//        guard let let username = registerUserName.text,
//              let password = registerUserPw.text else { return }
        
        AlamofireManager.shared.postSignUp(name: registerName.text!, username: registerUserName.text!, password: registerUserPw.text!, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let memberData):
                print("SignUpVC - postSignUp.success")
                // 회원가입 완료 페이지 띄우기
                self.memberName = memberData.name
                self.memberUserName = memberData.username
                self.performSegue(withIdentifier: "signUpSuccessVC", sender: nil)
                
            case .failure(let error):
                print("SignUpVC - postSignUp.failure / error : \(error)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
    }
    
    @objc func onGoToLoginBtnClicked() {
        print("SignUpVC - onGoToLoginBtnClicked() called / naviggationController poped")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - overrid methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "signUpSuccessVC" {
            if let controller = segue.destination as? SignUpSuccessVC {
                controller.memberName = self.memberName
                controller.memberUserName = self.memberUserName
            }
        }
    }
}
