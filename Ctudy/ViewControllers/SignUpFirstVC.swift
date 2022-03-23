//
//  SignUpFirstVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation
import UIKit

class SignUpFirstVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var registerName: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nameMsg: UILabel!
    @IBOutlet weak var goToStartBtn: UIButton!
    
    var keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    var memberName: String?
    var nameOKFlag: Bool = false
    
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpFirstVC - viewDidLoad() called")
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SignUpFirstVC - viewWillAppear() called")
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SignUpFirstVC - viewWillDisappear() called")
        // 키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "SignUpSecondVC" {
            if let controller = segue.destination as? SignUpSecondVC {
                controller.registerName = self.registerName.text
            }
        }
    }
    
    
    // MARK: - fileprivate func
    fileprivate func config() {
        
        // 버튼 이벤트 연결
        self.goToStartBtn.addTarget(self, action: #selector(onGoToStartBtnClicked), for: .touchUpInside)
        
        // textField 이벤트 연결
        self.registerName.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        // delegate
        self.registerName.delegate = self
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
    
    // 다음 버튼 활성화 & 비활성화 이벤트
    fileprivate func signUpBtnAleChecked() {
        if nameOKFlag {
            nextBtn.isEnabled = true
        } else {
            nextBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 이벤트
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        print("SignUpFirstVC - isValidData() called / data: \(data), flag: \(flag)")
        
        guard data != "" else { return false }
        
        let pred : NSPredicate
        
        switch flag {
        case "registerName":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.NAME_REGEX)
        default:
            pred = NSPredicate(format: "SELF MATCHES %@", "")
        }
        
        return pred.evaluate(with: data)
    }
    
    // MARK: - @objc func
    // 키보드 이벤트
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("SignUpFirstVC - keyboardWillShowHandle() called")
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        }
    }
    
    @objc func keyboardWillHideHandle() {
        print("SignUpFirstVC - keyboardWillHideHandle() called")
        
        self.view.frame.origin.y = 0
    }
    
    // textfield 변경할때 이벤트
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        print("SignUpFirstVC - textFieldEditingChanged() called / sender.text: \(sender.text)")
        
        switch sender {
        case registerName :
            // 자음 및 모음 X, 2글자 이상, 특수문자 사용 X
            textFieldCheck(textField: sender, msgLabel: nameMsg, inputData: registerName.text ?? "")
        default:
            print("default")
        }
        
        signUpBtnAleChecked()
    }
    
    @objc fileprivate func onGoToStartBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - textField Delegate
    // textField에서 enter키 눌렀을때 이벤트
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("SignUpFirstVC - textFieldShouldReturn() called")
        
        switch textField {
        case registerName :
            // 자음 및 모음 X, 2글자 이상, 특수문자 사용 X
            textFieldCheck(textField: textField, msgLabel: nameMsg, inputData: registerName.text ?? "" )
        default:
            print("default")
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        print("SignUpFirstVC - textFieldCheck() called / msgLabel: \(msgLabel), inputData: \(inputData)")
        
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
        default:
            print("default")
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("SignUpFirstVC - gestureRecognizer shouldReceive() called")
        
        if touch.view?.isDescendant(of: registerName) == true {
            return false
        }
        else {
            view.endEditing(true)
            return true
        }
    }
}
