//
//  SearchPwThirdVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/27.
//

import Foundation
import UIKit

class SearchPwThirdVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate{
    // MARK: - 변수
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordChk: UITextField!
    @IBOutlet weak var passwordMsg: UILabel!
    @IBOutlet weak var passwordChkMsg: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SearchPwThirdVC.self, action: nil)
    var passwordOKFlag: Bool = false
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchPwThirdVC - viewDidLoad() called")
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "새로운 비밀번호", isLargeTitles: true)
        
        // button & textField ui
        self.updateBtn.tintColor = .white
        self.updateBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.updateBtn.layer.cornerRadius = 10
        self.updateBtn.isEnabled = false
        self.newPassword.isSecureTextEntry = true
        self.newPasswordChk.isSecureTextEntry = true
        
        // event 연결
        self.updateBtn.addTarget(self, action: #selector(onUpdateBtnClicked), for: .touchUpInside)
        self.newPassword.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.newPasswordChk.addTarget(self, action: #selector(passwordChkEditingChanged(_:)), for: .editingChanged)
        
        // delegate 연결
        self.newPassword.delegate = self
        self.newPasswordChk.delegate = self
        self.tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
    }
    
    // messageLabel 셋팅
    fileprivate func setMsgLabel(flag: Bool, msgLabel: UILabel, msgString: String) {
        if flag {
            msgLabel.textColor = .systemGreen
        } else {
            msgLabel.textColor = .systemRed
        }
        msgLabel.text = msgString
    }
    
    // searchButton 활성화 & 비활성화 event
    fileprivate func updateBtnAbleChecked() {
        if passwordOKFlag {
            self.updateBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.updateBtn.isEnabled = true
        } else {
            self.updateBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.updateBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 event
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        guard data != "" else { return false }
        let pred : NSPredicate
        
        switch flag {
        case "newPassword":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.PASSWORD_REGEX)
        default:
            pred = NSPredicate(format: "SELF MATCHES %@", "")
        }
        
        return pred.evaluate(with: data)
    }
    
    // 비밀번호와 비밀번호확인 textfield 일치 여부 event
    fileprivate func passwordValueChecked() {
        if newPassword.text == "" {
            passwordOKFlag = false
            passwordChkMsg.text = ""
            return
        } else {
            if newPasswordChk.text == "" {
                passwordOKFlag = false
                passwordChkMsg.text = ""
                return
            }
        }
        
        // 비밀번호 & 비밀번호확인 textField 모두 입력되었을때
        if newPassword.text == newPasswordChk.text {
            passwordOKFlag = true
            setMsgLabel(flag: passwordOKFlag, msgLabel: passwordChkMsg, msgString: "비밀번호가 일치합니다.")
            
        } else {
            passwordOKFlag = false
            setMsgLabel(flag: passwordOKFlag, msgLabel: passwordChkMsg, msgString: "비밀번호가 일치하지 않습니다.")
        }
    }
    
    
    // MARK: - @objc func
    @objc fileprivate func onUpdateBtnClicked() {
        print("SearchPwThirdVC - onUpdateBtnClicked() called")
    }
    
    // textfield 변경할때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case newPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: textField, msgLabel: passwordMsg, inputData: newPassword.text ?? "")
        default:
            break
        }
        
        updateBtnAbleChecked()
    }
    
    // 비밀번호 일치하는지 체크하는 editingChanged event
    @objc func passwordChkEditingChanged(_ sender: UITextField) {
        // 비밀번호 & 비밀번호확인 일치 체크
        passwordValueChecked()
        // 버튼 활성화 & 비활성화 체크
        updateBtnAbleChecked()
    }
    
    // MARK: - textField Delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case newPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: textField, msgLabel: passwordMsg, inputData: newPassword.text ?? "")
        case newPasswordChk:
            // 비밀번호 & 비밀번호확인 일치 체크
            passwordValueChecked()
        default:
            break
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    // textField 정규식 체크 event
    func textFieldCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        guard inputData != "" else {
            msgLabel.text = ""
            if textField == newPassword { passwordChkMsg.text = "" }
            return
        }
        
        switch textField {
        case newPassword:
            let flag = isValidData(flag: "newPassword", data: inputData)
            if flag {
                setMsgLabel(flag: flag, msgLabel: msgLabel, msgString: "사용가능한 비밀번호 입니다.")
            } else {
                setMsgLabel(flag: flag, msgLabel: msgLabel, msgString: "비밀번호가 옳바르지 않습니다.")
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
        case newPassword:
            passwordValueChecked()
        case newPasswordChk:
            passwordValueChecked()
        default:
            break
        }
        
        updateBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: newPassword) == true {
            return false
        } else if touch.view?.isDescendant(of: newPasswordChk) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
