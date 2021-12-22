//
//  ViewController.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/07.
//

import UIKit

class LoginVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var goToSignUpBtn: UIButton!
    var keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    var distance: Double = 0
    
    // MARK: - overrid methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LoginVC - viewWillAppear() called")
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("LoginVC - viewWillDisappear() called")
        // 키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // MARK: - objc and fileprivate methods
    @objc func onLoginBtnClicked() {
        print("LoginVC - onLoginBtnClicked() called")
        
        AlamofireManager.shared.postSignIn(username: userName.text!, password: password.text!, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let memberData):
                print("LoginVC - postSignIn.success")
                
                self.performSegue(withIdentifier: "MainVC", sender: nil)
                
            case .failure(let error):
                print("LoginVC - postSignIn.failure / error : \(error)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
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

                self.view.frame.origin.y = distance - loginBtn.frame.height + 30
            }
        }
    }
    
    @objc func keyboardWillHideHandle() {
        print("LoginVC - keyboardWillHideHandle() called")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001, execute: {
            // 포커싱 해제
            self.view.frame.origin.y = 0
        })
    }
    
    fileprivate func config() {
        // UI
        loginBtn.layer.cornerRadius = 5
        loginBtn.isEnabled = false
        
        // add Btn methods
        loginBtn.addTarget(self, action: #selector(onLoginBtnClicked), for: .touchUpInside)
        
        // delegate
        self.keyboardDismissTabGesture.delegate = self
        
        // 제스처
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    // MARK: - @IBACiton methods
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
}

