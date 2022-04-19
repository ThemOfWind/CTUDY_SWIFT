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

class SignUpSecondVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate{
   
    // MARK: - 변수
    @IBOutlet weak var registerUserName: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerPasswordChk: UITextField!
    @IBOutlet weak var userNameMsg: UILabel!
    @IBOutlet weak var passwordMsg: UILabel!
    @IBOutlet weak var passwordChkMsg: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    var keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    var registerName: String?
    var memberName: String?
    var memberUserName: String?
    var usernameOKFlag: Bool = false
    var passwordOKFlag: Bool = false
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpSecondVC - viewDidLoad() called")
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SignUpSecondVC - viewWillAppear() called")
        // keyboard 올라가는 이벤트를 받는 처리
        // keyboard 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SignUpSecondVC - viewWillDisappear() called")
        // keyboard 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "SignUpSuccessVC" {
            if let controller = segue.destination as? SignUpSuccessVC {
                controller.memberName = self.memberName
                controller.memberUserName = self.memberUserName
            }
        }
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.none
        self.rightItem = RightItem.none
        
        // ui
        self.signUpBtn.tintColor = .white
        self.signUpBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.signUpBtn.layer.cornerRadius = 30
        self.signUpBtn.isEnabled = false
        self.registerPassword.isSecureTextEntry = true
        self.registerPasswordChk.isSecureTextEntry = true
        
        // btn event 연결
        self.signUpBtn.addTarget(self, action: #selector(onSignUpBtnClicked), for: .touchUpInside)
        
        // textField event 연결
        self.registerUserName.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.registerPassword.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.registerPasswordChk.addTarget(self, action: #selector(passwordChkEditingChanged(_:)), for: .editingChanged)
        
        // delegate
        self.registerUserName.delegate = self
        self.registerPassword.delegate = self
        self.keyboardDismissTabGesture.delegate = self
        
        // 제스처
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    func btnItemAction(btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 아이디 중복체크 api 호출 event
    fileprivate func userNameChecked(inputUserName: String) {
        AlamofireManager.shared.getUserNameCheck(username: inputUserName, completion: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let checkData):
                print("SignUpSecondVC - getUserNameCheck.success")
                // 사용가능 문구 띄우기
                //self.view.makeToast("사용가능한 아이디(이메일)입니다.", duration: 1.0, position: .center)
                self.setMsgLabel(flag: true, msgLabel: self.userNameMsg, msgString: "사용가능한 아이디(이메일)입니다.")
            case .failure(let error):
                print("SignUpSecondVC - getUserNameCheck.failure / error: \(error)")
                // 중복사용 문구 띄우기
                //self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                self.setMsgLabel(flag: false, msgLabel: self.userNameMsg, msgString: error.rawValue)
            }
        })
    }
    
    // msgLabel 셋팅
    fileprivate func setMsgLabel(flag: Bool, msgLabel: UILabel, msgString: String) {
        if flag {
            msgLabel.textColor = .systemGreen
        } else {
            msgLabel.textColor = .systemRed
        }
        msgLabel.text = msgString
    }
    
    // 회원가입 버튼 활성화 & 비활성화 event
    fileprivate func signUpBtnAbleChecked() {
        print("SignUpSecondVC - signUpBtnAleChecked() called / usernameOKFlage: \(usernameOKFlag), passwordOKFlage: \(passwordOKFlag)")
        if usernameOKFlag && passwordOKFlag {
            self.signUpBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.signUpBtn.isEnabled = true
        } else {
            self.signUpBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.signUpBtn.isEnabled = false
        }
    }
    
    // 정규식(이름, 아이디(이메일), 비밀번호) 체크 event
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
    
    // 비밀번호와 비밀번호확인 textfield 일치 여부 event
    fileprivate func passwordValueChecked() {
        if registerPassword.text == "" {
            passwordOKFlag = false
            passwordChkMsg.text = ""
            return
        } else {
            if registerPasswordChk.text == "" {
                passwordOKFlag = false
                passwordChkMsg.text = ""
                return
            }
        }
        
        // 비밀번호 & 비밀번호확인 textField 모두 입력되었을때
        if registerPassword.text == registerPasswordChk.text {
            passwordOKFlag = true
            setMsgLabel(flag: passwordOKFlag, msgLabel: passwordChkMsg, msgString: "비밀번호가 일치합니다.")
            
        } else {
            passwordOKFlag = false
            setMsgLabel(flag: passwordOKFlag, msgLabel: passwordChkMsg, msgString: "비밀번호가 일치하지 않습니다.")
        }
    }
    
    // MARK: - @objc func
    // 회원가입 버튼 event
    @objc func onSignUpBtnClicked() {
        print("SignUpSecondVC - onSignUpBtnClicked() called")
        
        AlamofireManager.shared.postSignUp(name: registerName!, username: registerUserName.text!, password: registerPassword.text!, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let memberData):
                print("SignUpSecondVC - postSignUp.success")
                
                // 회원가입 완료 페이지 띄우기
                self.memberName = memberData.name
                self.memberUserName = memberData.username
                self.performSegue(withIdentifier: "SignUpSuccessVC", sender: nil)
            case .failure(let error):
                print("SignUpSecondVC - postSignUp.failure / error: \(error.rawValue)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
    }
    
    // keyboard event
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("SignUpSecondVC - keyboardWillShowHandle() called")
        // kboardey 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        }
    }
    
    @objc func keyboardWillHideHandle() {
        print("SignUpSecondVC - keyboardWillHideHandle() called")
        
        self.view.frame.origin.y = 0
    }
    
    
    // textfield 변경할때 event
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        print("SignUpSecondVC - textFieldEditingChanged() called / sender.text: \(sender.text)")
        switch sender {
        case registerUserName:
            // @email 형식 체크
            textFieldCheck(textField: sender, msgLabel: userNameMsg, inputData: registerUserName.text ?? "")
        case registerPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: sender, msgLabel: passwordMsg, inputData: registerPassword.text ?? "")
        default:
            break
        }
        
        signUpBtnAbleChecked()
    }
    
    // 비밀번호 일치하는지 체크하는 editingChanged event
    @objc func passwordChkEditingChanged(_ sender: UITextField) {
        print("SignUpSecondVC - passwordChkEditingChanged() called / sender.text: \(sender.text)")
        
        // 비밀번호 & 비밀번호확인 일치 체크
        passwordValueChecked()
        // 버튼 활성화 & 비활성화 체크
        signUpBtnAbleChecked()
    }
    
    // MARK: - textField Delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("SignUpSecondVC - textFieldShouldReturn() called")
        
        switch textField {
        case registerUserName:
            // @email 형식 체크
            textFieldCheck(textField: textField, msgLabel: userNameMsg, inputData: registerUserName.text ?? "")
        case registerPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: textField, msgLabel: passwordMsg, inputData: registerPassword.text ?? "")
        default:
            break
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    // textField 정규식 체크 event
    func textFieldCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        print("SignUpSecondVC - textFieldCheck() called / msgLabel: \(msgLabel), inputData: \(inputData)")
        
        guard inputData != "" else {
            msgLabel.text = ""
            if textField == registerPassword { passwordChkMsg.text = "" }
            return
        }
        
        switch textField {
        case registerUserName:
            usernameOKFlag = isValidData(flag: "registerUserName", data: inputData)
            if usernameOKFlag {
                userNameChecked(inputUserName: inputData)
            } else {
                setMsgLabel(flag: usernameOKFlag, msgLabel: msgLabel, msgString: "아이디(이메일)가 옳바르지 않습니다.")
            }
        case registerPassword:
            let OKFlag = isValidData(flag: "registerPassword", data: inputData)
            if OKFlag {
                setMsgLabel(flag: OKFlag, msgLabel: msgLabel, msgString: "사용가능한 비밀번호 입니다.")
            } else {
                setMsgLabel(flag: OKFlag, msgLabel: msgLabel, msgString: "비밀번호가 옳바르지 않습니다.")
            }
            
            // 비밀번호 & 비밀번호확인 일치 체크
            passwordValueChecked()
        default:
            break
        }
    }
    
    // textField clearBtn event
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case registerUserName:
            usernameOKFlag = false
        case registerPassword:
            passwordValueChecked()
        case registerPasswordChk:
            passwordValueChecked()
        default:
            break
        }
        
        signUpBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("SignUpSecondVC - gestureRecognizer shouldReceive() called")
        
        if touch.view?.isDescendant(of: registerUserName) == true {
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
