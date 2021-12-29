//
//  SingUpVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/08.
//

import Foundation
import UIKit
import Toast_Swift
import Alamofire

class SignUpVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var registerName: UITextField!
    @IBOutlet weak var registerUserName: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerPasswordChk: UITextField!
    @IBOutlet weak var nameMsg: UILabel!
    @IBOutlet weak var userNameMsg: UILabel!
    @IBOutlet weak var passwordMsg: UILabel!
    @IBOutlet weak var passwordChkMsg: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var goToLoginBtn: UIButton!
    
    var keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    var memberName: String?
    var memberUserName: String?
    var nameOKFlag: Bool = false
    var usernameOKFlag: Bool = false
    var passwordOKFlag: Bool = false
    
    // MARK: - overrid methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SignUpVC - viewDidLoad() called")
        
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SignUpVC - viewWillAppear() called")
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SignUpVC - viewWillDisappear() called")
        // 키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "signUpSuccessVC" {
            if let controller = segue.destination as? SignUpSuccessVC {
                controller.memberName = self.memberName
                controller.memberUserName = self.memberUserName
            }
        }
    }
    
    // MARK: - fileprivate methods
    fileprivate func config() {
        // UI
        self.navigationController?.isNavigationBarHidden = true
        self.signUpBtn.layer.cornerRadius = 5
        self.signUpBtn.isEnabled = false
        self.registerPassword.isSecureTextEntry = true
        self.registerPasswordChk.isSecureTextEntry = true
        
        // add Btn methods
        self.signUpBtn.addTarget(self, action: #selector(onSignUpBtnClicked), for: .touchUpInside)
        self.goToLoginBtn.addTarget(self, action: #selector(onGoToLoginBtnClicked), for: .touchUpInside)
        
        // add textField methods
        self.registerName.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.registerUserName.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.registerPassword.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.registerPasswordChk.addTarget(self, action: #selector(passwordChkEditingChanged(_:)), for: .editingChanged)
        
        // delegate
        self.registerName.delegate = self
        self.registerUserName.delegate = self
        self.registerPassword.delegate = self
        self.keyboardDismissTabGesture.delegate = self
        
        // 제스처
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    // 아이디 중복체크
    fileprivate func userNameChecked(inputUserName: String) {
        AlamofireManager.shared.getUserNameCheck(username: inputUserName, completion: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let checkData):
                print("SignUpVC - getUserNameCheck.success")
                // 사용가능 문구 띄우기
                //self.view.makeToast("사용가능한 아이디(이메일)입니다.", duration: 1.0, position: .center)
                self.trueMsgSetting(msgLabel: self.userNameMsg, msgString: "사용가능한 아이디(이메일)입니다.")
            case .failure(let error):
                print("SignUpVC - getUserNameCheck.failure / error: \(error)")
                // 중복사용 문구 띄우기
                //self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                self.falseMsgSetting(msgLabel: self.userNameMsg, msgString: error.rawValue)
            }
        })
    }
    
    // textField 맞게 입력 되었을때
    fileprivate func trueMsgSetting(msgLabel: UILabel, msgString: String) {
        msgLabel.textColor = .systemGreen
        msgLabel.text = msgString
    }
    
    // textField 잘못 입력 되었을때
    fileprivate func falseMsgSetting(msgLabel: UILabel, msgString: String) {
        msgLabel.textColor = .systemRed
        msgLabel.text = msgString
    }
    
    // 회원가입 버튼 활성화 & 비활성화 체크
    fileprivate func signUpBtnAleChecked() {
        print("SignUpVC - signUpBtnAleChecked() called / nameOKFlage: \(nameOKFlag), usernameOKFlage: \(usernameOKFlag), passwordOKFlage: \(passwordOKFlag)")
        if nameOKFlag && usernameOKFlag && passwordOKFlag {
            signUpBtn.isEnabled = true
        } else {
            signUpBtn.isEnabled = false
        }
    }
    
    // 이름, 아이디(이메일), 비밀번호 정규식 체크 이벤트
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        print("SignUpVC - isValidData() called / data: \(data), flag: \(flag)")
        
        guard data != "" else { return false }
        
        let pred : NSPredicate
        
        switch flag {
        case "registerName":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.NAME_REGEX)
        case "registerUserName":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.USERNAME_REGEX)
        case "registerPassword":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.PASSWORD_REGEX)
        default:
            pred = NSPredicate(format: "SELF MATCHES %@", "")
        }
        
        return pred.evaluate(with: data)
    }
    
    // 비밀번호와 비밀번호 확인 textfield 일치 여부
    fileprivate func passwordValueChecked() {
        guard registerPassword.text != "" else {
            if registerPasswordChk.text != "" {
                falseMsgSetting(msgLabel: passwordChkMsg, msgString: "비밀번호가 일치하지 않습니다.")
            } else {
                passwordChkMsg.text = ""
            }
            return
        }
        
        if registerPassword.text == registerPasswordChk.text {
            trueMsgSetting(msgLabel: passwordChkMsg, msgString: "비밀번호가 일치합니다.")
            passwordOKFlag = true
        } else {
            falseMsgSetting(msgLabel: passwordChkMsg, msgString: "비밀번호가 일치하지 않습니다.")
            passwordOKFlag = false
        }
    }
    
    // MARK: - @objc methods
    // 회원가입 버튼 이벤트
    @objc func onSignUpBtnClicked() {
        print("SignUpVC - onSignUpBtnClicked() called")
        
        AlamofireManager.shared.postSignUp(name: registerName.text!, username: registerUserName.text!, password: registerPassword.text!, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let memberData):
                print("SignUpVC - postSignUp.success")
                
                // 회원가입 완료 페이지 띄우기
                self.memberName = memberData.name
                self.memberUserName = memberData.username
                self.performSegue(withIdentifier: "signUpSuccessVC", sender: nil)
            case .failure(let error):
                print("SignUpVC - postSignUp.failure / error: \(error)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
    }
    
    // 로그인화면으로 이동 버튼 이벤트
    @objc func onGoToLoginBtnClicked() {
        print("SignUpVC - onGoToLoginBtnClicked() called / naviggationController poped")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // keyboard event
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("SignUpVC - keyboardWillShowHandle() called")
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        }
    }
    
    @objc func keyboardWillHideHandle() {
        print("SignUpVC - keyboardWillHideHandle() called")
        
        self.view.frame.origin.y = 0
    }
    
    
    // textfield editingChanged event
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        print("SignUpVC - textFieldEditingChanged() called / sender.text: \(sender.text)")
        
        switch sender {
        case registerName :
            // 자음 및 모음 X, 2글자 이상, 특수문자 사용 X
            textFieldCheck(textField: sender, msgLabel: nameMsg, inputData: registerName.text ?? "")
        case registerUserName:
            // @email 형식 체크
            textFieldCheck(textField: sender, msgLabel: userNameMsg, inputData: registerUserName.text ?? "")
        case registerPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: sender, msgLabel: passwordMsg, inputData: registerPassword.text ?? "")
        default:
            print("default")
        }
        
        signUpBtnAleChecked()
    }
    
    // 비밀번호 일치하는지 체크하는 editingChanged
    @objc func passwordChkEditingChanged(_ sender: UITextField) {
        print("SignUpVC - passwordChkEditingChanged() called / sender.text: \(sender.text)")
        
        passwordValueChecked()
        
        signUpBtnAleChecked()
    }
    
    // MARK: - textField Delegate
    // textField에서 enter키 눌렀을때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("SignUpVC - textFieldShouldReturn() called")
        
        switch textField {
        case registerName :
            // 자음 및 모음 X, 2글자 이상, 특수문자 사용 X
            textFieldCheck(textField: textField, msgLabel: nameMsg, inputData: registerName.text ?? "" )
        case registerUserName:
            // @email 형식 체크
            textFieldCheck(textField: textField, msgLabel: userNameMsg, inputData: registerUserName.text ?? "")
        case registerPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: textField, msgLabel: passwordMsg, inputData: registerPassword.text ?? "")
        default:
            print("default")
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        print("SignUpVC - textFieldCheck() called / msgLabel: \(msgLabel), inputData: \(inputData)")
        
        guard inputData != "" else {
            msgLabel.text = ""
            return
        }
        
        switch textField {
        case registerName:
            nameOKFlag = isValidData(flag: "registerName", data: inputData)
            
            if nameOKFlag {
                trueMsgSetting(msgLabel: msgLabel, msgString: "사용가능한 이름입니다.")
            } else {
                falseMsgSetting(msgLabel: msgLabel, msgString: "이름이 옳바르지 않습니다.")
            }
        case registerUserName:
            usernameOKFlag = isValidData(flag: "registerUserName", data: inputData)
            
            if usernameOKFlag {
                userNameChecked(inputUserName: inputData)
            } else {
                falseMsgSetting(msgLabel: msgLabel, msgString: "아이디(이메일)가 옳바르지 않습니다.")
            }
        case registerPassword:
            let OKFlag = isValidData(flag: "registerPassword", data: inputData)
            
            if OKFlag {
                trueMsgSetting(msgLabel: msgLabel, msgString: "사용가능한 비밀번호 입니다.")
            } else {
                falseMsgSetting(msgLabel: msgLabel, msgString: "비밀번호가 옳바르지 않습니다.")
            }
            
            passwordValueChecked()
            
        default:
            print("default")
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("SignUpVC - gestureRecognizer shouldReceive() called")
        
        if touch.view?.isDescendant(of: registerName) == true {
            return false
        }
        else if touch.view?.isDescendant(of: registerUserName) == true {
            return false
        }
        else if touch.view?.isDescendant(of: registerPassword) == true {
            return false
        }
        else if touch.view?.isDescendant(of: registerPasswordChk) == true {
            return false
        }
        else {
            view.endEditing(true)
            return true
        }
    }
}
