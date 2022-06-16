//
//  UsernameVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/13.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class UpdatePasswordVC: BasicVC, UIGestureRecognizerDelegate, UITextFieldDelegate {
    // MARK: - 변수
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var passwordMsg: UILabel!
    @IBOutlet weak var inputNewPassword: UITextField!
    @IBOutlet weak var newPasswordMsg: UILabel!
    @IBOutlet weak var inputNewPasswordChk: UITextField!
    @IBOutlet weak var newPasswordChkMsg: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var withdrawBtn: UIButton!
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
    var passwordOKFlag: Bool = false
    var newPasswordOKFlag: Bool = false
    var onlyPasswordOKFlag: Bool = true
    
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    // MARK: - fileprivaten func
    fileprivate func config() {
        // navigationbar ui
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "계정관리", isLargeTitles: true)
        
        // password textfield ui
        inputPassword.isSecureTextEntry = true
        inputNewPassword.isSecureTextEntry = true
        inputNewPasswordChk.isSecureTextEntry = true
        
        // update button ui
        updateBtn.layer.cornerRadius = 10
        updateBtn.tintColor = .white
        updateBtn.backgroundColor = COLOR.DISABLE_COLOR
        updateBtn.isEnabled = false
        
        // withdraw button ui
        withdrawBtn.tintColor = COLOR.SIGNATURE_COLOR
        
        // event 연결
        inputPassword.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        inputNewPassword.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        inputNewPasswordChk.addTarget(self, action: #selector(passwordChkEditingChanged), for: .editingChanged)
        updateBtn.addTarget(self, action: #selector(onUpdateBtnClicked), for: .touchUpInside)
        withdrawBtn.addTarget(self, action: #selector(onWithdrawBtnClicked), for: .touchUpInside)
        
        // delegate 연결
        inputNewPassword.delegate = self
        inputNewPasswordChk.delegate = self
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
    
    // messageLabel 셋팅
    fileprivate func setMsgLabel(flag: Bool, msgLabel: UILabel, msgString: String) {
        if flag {
            msgLabel.textColor = .systemGreen
        } else {
            msgLabel.textColor = .systemRed
        }
        msgLabel.text = msgString
    }
    
    // createButton 활성화 & 비활성화 event
    fileprivate func updateBtnAbleChecked() {
        if passwordOKFlag && newPasswordOKFlag && onlyPasswordOKFlag {
            updateBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            updateBtn.isEnabled = true
        } else {
            updateBtn.backgroundColor = COLOR.DISABLE_COLOR
            updateBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 event
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        //        print("SignUpFirstVC - isValidData() called / data: \(data), flag: \(flag)")
        
        guard data != "" else { return false }
        let pred : NSPredicate
        
        switch flag {
        case "password":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.PASSWORD_REGEX)
        default:
            pred = NSPredicate(format: "SELF MATCHES %@", "")
        }
        
        return pred.evaluate(with: data)
    }
    
    // 비밀번호와 비밀번호확인 textfield 일치 여부 event
    fileprivate func passwordValueChecked() {
        if inputNewPassword.text == "" {
            newPasswordOKFlag = false
            newPasswordChkMsg.text = ""
            return
        } else {
            if inputNewPasswordChk.text == "" {
                newPasswordOKFlag = false
                newPasswordChkMsg.text = ""
                return
            }
        }
        
        // 비밀번호 & 비밀번호확인 textField 모두 입력되었을때
        if inputNewPassword.text == inputNewPasswordChk.text {
            newPasswordOKFlag = true
            setMsgLabel(flag: newPasswordOKFlag, msgLabel: newPasswordChkMsg, msgString: "비밀번호가 일치합니다.")
            
        } else {
            newPasswordOKFlag = false
            setMsgLabel(flag: newPasswordOKFlag, msgLabel: newPasswordChkMsg, msgString: "비밀번호가 일치하지 않습니다.")
        }
    }
    
    // MARK: - @objc func
    // 저장하기 button event
    @objc fileprivate func onUpdateBtnClicked() {
        onStartActivityIndicator()
        
        AlamofireManager.shared.putPassword(password: inputPassword.text!, newpassword: inputNewPassword.text!, completion: {
            [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.view.makeToast("비밀번호가 변경되었습니다.", duration: 1.0, position: .center)
            case .failure(let error):
                print("UpdatePasswordVC - putPassword().failure / error: \(error)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if indicator.isAnimating {
            onStopActivityIndicator()
        }
    }
    
    // 회원탈퇴 button event
    @objc fileprivate func onWithdrawBtnClicked() {
        self.performSegue(withIdentifier: "WithdrawVC", sender: nil)
    }
    
    // textField 변경할 때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        //        print("CreateCouponVC - textFieldEditingChanged() called / sender.text: \(sender.text)")
        switch textField {
        case inputPassword:
            passwordCheck(textField: textField, msgLabel: passwordMsg, inputData: textField.text ?? "")
        case inputNewPassword:
            // 이름 형식 체크 (모든 문자 1글자 이상, 공백만 X)
            newPasswordCheck(textField: textField, msgLabel: newPasswordMsg, inputData: textField.text ?? "" )
        default:
            break
        }
    }
    
    // 비밀번호 일치하는지 체크하는 editingChanged event
    @objc func passwordChkEditingChanged(_ sender: UITextField) {
        // 비밀번호 & 비밀번호확인 일치 체크
        passwordValueChecked()
        // 버튼 활성화 & 비활성화 체크
        updateBtnAbleChecked()
    }
    
    // MARK: - textField delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        print("CreateCouponVC - textFieldShouldReturn() called")
        switch textField {
            // 기존 비밀번호
        case inputPassword:
            passwordCheck(textField: textField, msgLabel: passwordMsg, inputData: textField.text ?? "")
        case inputNewPassword:
            // 신규 비밀번호
            newPasswordCheck(textField: textField, msgLabel: newPasswordMsg, inputData: textField.text ?? "" )
        default:
            break
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    // 기존 비밀번호 check event
    func passwordCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        guard inputData != "" else {
            msgLabel.text = ""
            return
        }
        
        passwordOKFlag = isValidData(flag: "password", data: inputData)
        if passwordOKFlag {
            setMsgLabel(flag: passwordOKFlag, msgLabel: msgLabel, msgString: "")
        } else {
            setMsgLabel(flag: passwordOKFlag, msgLabel: msgLabel, msgString: "비밀번호가 옳바르지 않습니다.")
        }
        
        newPasswordCheck(textField: inputNewPassword, msgLabel: newPasswordMsg, inputData: inputNewPassword.text ?? "")
        
        updateBtnAbleChecked()
    }
    
    // 신규 비밀번호 check event
    func newPasswordCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        print("UpdatePasswordVC - textFieldCheck() called / msgLabel: \(msgLabel), inputData: \(inputData)")
        guard inputData != "" else {
            msgLabel.text = ""
            return
        }
        
        if inputPassword.text == inputNewPassword.text {
            onlyPasswordOKFlag = false
            setMsgLabel(flag: onlyPasswordOKFlag, msgLabel: newPasswordMsg, msgString: "기존 비밀번호와 일치합니다.")
        } else {
            onlyPasswordOKFlag = true
            setMsgLabel(flag: onlyPasswordOKFlag, msgLabel: newPasswordMsg, msgString: "")
        
        let flag = isValidData(flag: "password", data: inputData)
        if flag {
            setMsgLabel(flag: flag, msgLabel: msgLabel, msgString: "사용가능한 비밀번호 입니다.")
        } else {
            setMsgLabel(flag: flag, msgLabel: msgLabel, msgString: "비밀번호가 옳바르지 않습니다.")
        }
        
        // 비밀번호 & 비밀번호확인 일치 체크
        passwordValueChecked()
        }
        
        updateBtnAbleChecked()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case inputPassword:
            passwordOKFlag = false
            newPasswordCheck(textField: inputNewPassword, msgLabel: newPasswordMsg, inputData: inputNewPassword.text ?? "")
        case inputNewPassword:
            passwordValueChecked()
        case inputNewPasswordChk:
            passwordValueChecked()
        default:
            break
        }
        
        updateBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: inputPassword) == true {
            return false
        } else if touch.view?.isDescendant(of: inputNewPassword) == true {
            return false
        } else if touch.view?.isDescendant(of: inputNewPasswordChk) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
