//
//  SearchPwThirdVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/27.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class SearchPwThirdVC: BasicVC, UITextFieldDelegate{
    // MARK: - 변수
    @IBOutlet weak var inputNewPassword: UITextField!
    @IBOutlet weak var inputNewPasswordChk: UITextField!
    @IBOutlet weak var passwordMsg: UILabel!
    @IBOutlet weak var passwordChkMsg: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var goToStartBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SearchPwThirdVC.self, action: nil)
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        indicatorView.backgroundColor = UIColor.white
        return indicatorView
    }()
    lazy var indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                type: .pacman,
                                                color: COLOR.SIGNATURE_COLOR,
                                                padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    lazy var loading: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "loading..."
        label.textColor = COLOR.SIGNATURE_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var passwordOKFlag: Bool = false
    var certificationData: CertificateResponseRequest! // 전달받은 email, username, key 정보
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchPwThirdVC - viewDidLoad() called")
        self.config()
    }
    
    // MARK: - config func
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.none
        self.titleItem = TitleItem.titleGeneral(title: "새로운 비밀번호", isLargeTitles: true)
        
        // button & textField ui
        self.updateBtn.tintColor = .white
        self.updateBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.updateBtn.layer.cornerRadius = 10
        self.updateBtn.isEnabled = false
        self.inputNewPassword.isSecureTextEntry = true
        self.inputNewPasswordChk.isSecureTextEntry = true
        
        // event 연결
        self.updateBtn.addTarget(self, action: #selector(onUpdateBtnClicked), for: .touchUpInside)
        self.inputNewPassword.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.inputNewPasswordChk.addTarget(self, action: #selector(passwordChkEditingChanged(_:)), for: .editingChanged)
        self.goToStartBtn.addTarget(self, action: #selector(onGoToStartBtnClicked), for: .touchUpInside)
        
        // delegate 연결
        self.inputNewPassword.delegate = self
        self.inputNewPasswordChk.delegate = self
        self.tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
    }
    
    // MARK: - indicator func
    // indicator star func
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
    
    // indicator stop func
    fileprivate func onStopActivityIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // 애니메이션 정지.
            // 서버 통신 완료 후 다음의 메서드를 실행해서 통신의 끝나는 느낌을 줄 수 있다.
            self.indicator.stopAnimating()
            self.indicatorView.removeFromSuperview()
        }
    }
   
    // MARK: - button func
    @objc fileprivate func onUpdateBtnClicked() {
        print("SearchPwThirdVC - onUpdateBtnClicked() called")
        onStartActivityIndicator()
        
        AlamofireManager.shared.postResetPw(email: certificationData.email, username: certificationData.username, key: certificationData.key, newpassword: inputNewPassword.text!, completion: { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: "SearchPwSuccessVC", sender: nil)
            case .failure(let error):
                print("SearchPwThirdVC - postResetPw() called / error: \(error.rawValue)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if indicator.isAnimating {
            onStopActivityIndicator()
        }
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
    
    @objc fileprivate func onGoToStartBtnClicked() {
        performSegue(withIdentifier: "unwindStartVC", sender: self)
    }
    
    // MARK: - textField Delegate
    // textfield 변경할때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case inputNewPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: textField, msgLabel: passwordMsg, inputData: inputNewPassword.text ?? "")
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
    
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case inputNewPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: textField, msgLabel: passwordMsg, inputData: inputNewPassword.text ?? "")
        case inputNewPasswordChk:
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
            if textField == inputNewPassword { passwordChkMsg.text = "" }
            return
        }
        
        switch textField {
        case inputNewPassword:
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
    
    // 비밀번호와 비밀번호확인 textfield 일치 여부 event
    fileprivate func passwordValueChecked() {
        if inputNewPassword.text == "" {
            passwordOKFlag = false
            passwordChkMsg.text = ""
            return
        } else {
            if inputNewPasswordChk.text == "" {
                passwordOKFlag = false
                passwordChkMsg.text = ""
                return
            }
        }
        
        // 비밀번호 & 비밀번호확인 textField 모두 입력되었을때
        if inputNewPassword.text == inputNewPasswordChk.text {
            passwordOKFlag = true
            setMsgLabel(flag: passwordOKFlag, msgLabel: passwordChkMsg, msgString: "비밀번호가 일치합니다.")
            
        } else {
            passwordOKFlag = false
            setMsgLabel(flag: passwordOKFlag, msgLabel: passwordChkMsg, msgString: "비밀번호가 일치하지 않습니다.")
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
    
    // 정규식 체크 event
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
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: inputNewPassword) == true {
            return false
        } else if touch.view?.isDescendant(of: inputNewPasswordChk) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
