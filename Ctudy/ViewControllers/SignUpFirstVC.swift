//
//  SignUpFirstVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation
import UIKit

class SignUpFirstVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
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
        
        // keyboard 올라가는 이벤트를 받는 처리
        // keyboard 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SignUpFirstVC - viewWillDisappear() called")
        // keyboard 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // 다음 화면 이동 시 입력받은 이름정보 넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "SignUpSecondVC" {
            if let controller = segue.destination as? SignUpSecondVC {
                controller.registerName = self.registerName.text
            }
        }
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationBar item
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.none
        self.rightItem = RightItem.none
        
        // btn ui
        self.nextBtn.layer.cornerRadius = 30
        self.nextBtn.layer.borderWidth = 1
        self.nextBtn.layer.borderColor = COLOR.DISABLE_COLOR.cgColor
        self.nextBtn.isEnabled = false
        
        // btn event 연결
        self.goToStartBtn.addTarget(self, action: #selector(onGoToStartBtnClicked), for: .touchUpInside)
        
        // textField event 연결
        self.registerName.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        // delegate
        self.registerName.delegate = self
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
    
    // nextBtn 활성화 & 비활성화 event
    fileprivate func nextBtnAbleChecked() {
        if nameOKFlag {
            self.nextBtn.layer.borderColor = COLOR.SIGNATURE_COLOR.cgColor
            self.nextBtn.isEnabled = true
        } else {
            self.nextBtn.layer.borderColor = COLOR.DISABLE_COLOR.cgColor
            self.nextBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 event
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
    // keyboard event
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
    
    // textField 변경할 때 event
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        print("SignUpFirstVC - textFieldEditingChanged() called / sender.text: \(sender.text)")
        
        switch sender {
        case registerName :
            // 자음 및 모음 X, 2글자 이상, 특수문자 사용 X
            textFieldCheck(textField: sender, msgLabel: nameMsg, inputData: registerName.text ?? "")
        default:
            print("default")
        }
        
        nextBtnAbleChecked()
    }
    
    @objc fileprivate func onGoToStartBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - textField delegate
    // textField에서 enter키 눌렀을때 event
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
                setMsgLabel(flag: nameOKFlag, msgLabel: msgLabel, msgString: "")
            } else {
                setMsgLabel(flag: nameOKFlag, msgLabel: msgLabel, msgString: "이름이 옳바르지 않습니다.")
            }
        default:
            print("default")
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        textFeild.text!.removeAll()
        nameOKFlag = false
        
        nextBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
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
