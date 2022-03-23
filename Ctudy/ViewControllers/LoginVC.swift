//
//  ViewController.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/07.
//

import UIKit

class LoginVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var goToFindIdBtn: UIButton!
    @IBOutlet weak var goToFindPwBtn: UIButton!
    @IBOutlet weak var goToStartBtn: UIButton!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    var keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    var distance: Double = 0
    var loginViewY: Double!
    
    // MARK: - overrid methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LoginVC - viewWillAppear() called / animated: \(animated)")
        
        // refresh
        self.config()
        
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 노티 등록
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("LoginVC - viewWillDisappear() called / animated: \(animated)")
        // 키보드 노티 해제
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // MARK: - objc and fileprivate methods
    // 기본 셋팅
    fileprivate func config() {
        // text 초기화
        self.userName.text = ""
        self.password.text = ""
        
        // UI
        self.loginBtn.layer.cornerRadius = 5
        self.loginBtn.isEnabled = false
        self.loginViewY = self.loginView.frame.origin.y
        
        // 버튼 이벤트 연결
        self.loginBtn.addTarget(self, action: #selector(onLoginBtnClicked), for: .touchUpInside)
        self.goToStartBtn.addTarget(self, action: #selector(onGoToStartBtnClicked), for: .touchUpInside)
        
        // delegate
        self.keyboardDismissTabGesture.delegate = self
        self.userName.delegate = self
        self.password.delegate = self
        
        // 제스처
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    // 로그인 버튼 이벤트
    @objc func onLoginBtnClicked() {
        print("LoginVC - onLoginBtnClicked() called")
        
        actIndicator.startAnimating()
        if actIndicator.isAnimating {
            actIndicator.hidesWhenStopped = false
        }
        
        AlamofireManager.shared.postSignIn(username: userName.text!, password: password.text!, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let memberData):
                print("LoginVC - postSignIn.success")
                
                self.performSegue(withIdentifier: "MainTabBarVC", sender: nil)
                
                /*
                guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC, animated: false)
                 */
                
            case .failure(let error):
                print("LoginVC - postSignIn.failure / error: \(error)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        actIndicator.stopAnimating()
        actIndicator.hidesWhenStopped = true
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("LoginVC - keyboardWillShowHandle() called")
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
        print("LoginVC - keyboardWillHideHandle() called / loginViewY: \(loginViewY)")
        UIView.animate(withDuration: noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            // 포커싱 해제
            self.loginView.frame.origin.y = self.loginViewY
        }
    }
    
    @objc fileprivate func onGoToStartBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - @IBACiton methods
    // 로그인 버튼 활성화 & 비활성화 이벤트
    @IBAction func editingChanged(_ sender: Any) {
        if userName.text!.isEmpty || password.text!.isEmpty {
            loginBtn.isEnabled = false
        } else {
            loginBtn.isEnabled = true
        }
    }
    
    @IBAction func unwindLoginVC(_ segue: UIStoryboardSegue) {}
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("LoginVC - gestureRecognizer shouldReceive() called")
        
        if touch.view?.isDescendant(of: userName) == true {
            print("registerName touched!")
            return false
        } else if touch.view?.isDescendant(of: password) == true {
            print("registerUserName touched!")
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
    
    // MARK: - textField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }
}

