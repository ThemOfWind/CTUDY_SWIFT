//
//  ViewController.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/07.
//

import UIKit
import NVActivityIndicatorView

class LoginVC: BasicVC, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var goToFindIdBtn: UIButton!
    @IBOutlet weak var goToFindPwBtn: UIButton!
    @IBOutlet weak var goToStartBtn: UIButton!
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
    let keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: LoginVC.self, action: nil)
    var distance: Double = 0
    var loginViewY: Double!
    var token: SignInResponse?
    
    // MARK: - view load func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        token = nil
        
        // refresh
        self.config()
        
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 노티 등록
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // keyboard 노티 해제
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    // 기본 셋팅
    fileprivate func config() {
        // textField 초기화
        self.userName.text = ""
        self.password.text = ""
        
        // navigationBar item
        self.titleItem = TitleItem.titleGeneral(title: "로그인", isLargeTitles: true)
        
        // btn ui
        self.loginBtn.tintColor = .white
        self.loginBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.loginBtn.layer.cornerRadius = 10
        self.loginBtn.isEnabled = false
        self.loginViewY = self.loginView.frame.origin.y
        
        // btn event 연결
        self.loginBtn.addTarget(self, action: #selector(onLoginBtnClicked), for: .touchUpInside)
        self.goToStartBtn.addTarget(self, action: #selector(onGoToStartBtnClicked), for: .touchUpInside)
        
        // delegate 연결
        self.keyboardDismissTabGesture.delegate = self
        self.userName.delegate = self
        self.password.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    // MARK: - indicator in api calling
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
    
    // MARK: - login api
    // loginBtn event
    @objc func onLoginBtnClicked() {
        print("LoginVC - onLoginBtnClicked() called")
        
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.postSignIn(username: userName.text!, password: password.text!, completion: { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let token):
                print("LoginVC - postSignIn.success")
                self.token = token
                self.getProfileInfo()
            case .failure(let error):
                print("LoginVC - postSignIn.failure / error: \(error.rawValue)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // MARK: - search profile api
    // 접속 회원정보 조회 후 keychain 저장
    fileprivate func getProfileInfo() {
        
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.getProfile(completion: { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(_):
                // 다음 화면으로 이동
                self.performSegue(withIdentifier: "MainTabBarVC", sender: nil)
            case .failure(let error):
                print("LoginVC - getProfileInfo() called / error: \(error.rawValue)")
            }
        })
        
        if indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // MARK: - keyboard func
    @objc func keyboardWillShowHandle(noti: NSNotification) {
        //        print("LoginVC - keyboardWillShowHandle() called")
        // keyboard 사이즈 가져오기
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardSize.height: \(keyboardSize.height)")
            print("loginBtn.frame.origin.y: \(loginBtn.frame.origin.y)")
            
            if (keyboardSize.height <= loginBtn.frame.origin.y) {
                distance = keyboardSize.height - loginBtn.frame.origin.y
                print("keyboard covered searchbtn / distance: \(distance)")
                print("changed upvalue: \(distance - loginBtn.frame.height)")
                
                self.loginView.frame.origin.y = distance - loginBtn.frame.height + loginViewY
            }
        }
    }
    
    @objc func keyboardWillHideHandle(noti: Notification) {
        //        print("LoginVC - keyboardWillHideHandle() called / loginViewY: \(loginViewY)")
        UIView.animate(withDuration: noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            // focusing 해제
            self.loginView.frame.origin.y = self.loginViewY
        }
    }
    
    // MARK: - go to startview func
    @objc fileprivate func onGoToStartBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - button ui change func
    // loginBtn 활성화 & 비활성화 event
    @IBAction func editingChanged(_ sender: Any) {
        if userName.text!.isEmpty || password.text!.isEmpty {
            self.loginBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.loginBtn.isEnabled = false
        } else {
            self.loginBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.loginBtn.isEnabled = true
        }
    }
    
    // MARK: - textField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: userName) == true {
            return false
        } else if touch.view?.isDescendant(of: password) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}

