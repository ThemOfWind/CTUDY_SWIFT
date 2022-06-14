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
import NVActivityIndicatorView

class SignUpSecondVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate{
    
    // MARK: - 변수
    @IBOutlet weak var registerUsername: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerPasswordChk: UITextField!
    @IBOutlet weak var usernameMsg: UILabel!
    @IBOutlet weak var passwordMsg: UILabel!
    @IBOutlet weak var passwordChkMsg: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    let keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
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
    // 이전 화면에서 데이터 전달
    var userImage: Data?
    var registerName: String?
    var registerEmail: String?
    
    var memberName: String?
    var memberUsername: String?
    var usernameOKFlag: Bool = false
    var passwordOKFlag: Bool = false
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpSecondVC - viewDidLoad() called")
        self.config()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "SignUpSuccessVC" {
            if let controller = segue.destination as? SignUpSuccessVC {
                controller.memberName = self.memberName
                controller.memberUserName = self.memberUsername
            }
        }
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "회원가입", isLargeTitles: true)
        
        // ui
        self.signUpBtn.tintColor = .white
        self.signUpBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.signUpBtn.layer.cornerRadius = 10
        self.signUpBtn.isEnabled = false
        self.registerPassword.isSecureTextEntry = true
        self.registerPasswordChk.isSecureTextEntry = true
        
        // btn event 연결
        self.signUpBtn.addTarget(self, action: #selector(onSignUpBtnClicked), for: .touchUpInside)
        
        // textField event 연결
        self.registerUsername.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.registerPassword.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.registerPasswordChk.addTarget(self, action: #selector(passwordChkEditingChanged(_:)), for: .editingChanged)
        
        // delegate 연결
        self.registerUsername.delegate = self
        self.registerPassword.delegate = self
        self.registerPasswordChk.delegate = self
        self.keyboardDismissTabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    // 아이디 중복체크 api 호출 event
    fileprivate func userNameChecked(inputUserName: String) {
        AlamofireManager.shared.getExistCheck(errorType: "username", username: inputUserName, email: nil, completion: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("SignUpSecondVC - getExistCheck.success")
                // 사용가능 문구 띄우기
                //self.view.makeToast("사용가능한 아이디(이메일)입니다.", duration: 1.0, position: .center)
                self.setMsgLabel(flag: true, msgLabel: self.usernameMsg, msgString: "사용가능한 아이디입니다.")
            case .failure(let error):
                print("SignUpSecondVC - getExistCheck.failure / error: \(error)")
                // 중복사용 문구 띄우기
                //self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                self.setMsgLabel(flag: false, msgLabel: self.usernameMsg, msgString: error.rawValue)
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
        if usernameOKFlag && passwordOKFlag {
            self.signUpBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.signUpBtn.isEnabled = true
        } else {
            self.signUpBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.signUpBtn.isEnabled = false
        }
    }
    
    // 정규식(아이디(이메일), 비밀번호) 체크 event
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        guard data != "" else { return false }
        let pred : NSPredicate
        
        switch flag {
        case "registerUsername":
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
    
    // MARK: - @objc func
    // 회원가입 버튼 event
    @objc func onSignUpBtnClicked() {
        
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.postSignUp(name: registerName!, email: registerEmail!, username: registerUsername.text!, password: registerPassword.text!, image: userImage, completion: { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let memberData):
                // 회원가입 완료 페이지 띄우기
                self.memberName = memberData.name
                self.memberUsername = memberData.username
                self.performSegue(withIdentifier: "SignUpSuccessVC", sender: nil)
            case .failure(let error):
                print("SignUpSecondVC - postSignUp.failure / error: \(error.rawValue)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // textfield 변경할때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case registerUsername:
            // @email 형식 체크
            textFieldCheck(textField: textField, msgLabel: usernameMsg, inputData: registerUsername.text ?? "")
        case registerPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: textField, msgLabel: passwordMsg, inputData: registerPassword.text ?? "")
        default:
            break
        }
        
        signUpBtnAbleChecked()
    }
    
    // 비밀번호 일치하는지 체크하는 editingChanged event
    @objc func passwordChkEditingChanged(_ sender: UITextField) {
        // 비밀번호 & 비밀번호확인 일치 체크
        passwordValueChecked()
        // 버튼 활성화 & 비활성화 체크
        signUpBtnAbleChecked()
    }
    
    // MARK: - textField Delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case registerUsername:
            // 아이디 형식 체크
            textFieldCheck(textField: textField, msgLabel: usernameMsg, inputData: registerUsername.text ?? "")
        case registerPassword:
            // 비밀번호 정규식
            textFieldCheck(textField: textField, msgLabel: passwordMsg, inputData: registerPassword.text ?? "")
        case registerPasswordChk:
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
            if textField == registerPassword { passwordChkMsg.text = "" }
            return
        }
        
        switch textField {
        case registerUsername:
            usernameOKFlag = isValidData(flag: "registerUsername", data: inputData)
            if usernameOKFlag {
                userNameChecked(inputUserName: inputData)
            } else {
                setMsgLabel(flag: usernameOKFlag, msgLabel: msgLabel, msgString: "아이디가 옳바르지 않습니다.")
            }
        case registerPassword:
            let flag = isValidData(flag: "registerPassword", data: inputData)
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
        case registerUsername:
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
        if touch.view?.isDescendant(of: registerUsername) == true {
            return false
        } else if touch.view?.isDescendant(of: registerPassword) == true {
            return false
        } else if touch.view?.isDescendant(of: registerPasswordChk) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
