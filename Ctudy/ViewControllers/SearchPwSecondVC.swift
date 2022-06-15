//
//  SearchPwSecondVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/27.
//

import Foundation
import UIKit

class SearchPwSecondVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate {
    // MARK: - 변수
    @IBOutlet weak var inputAuthNumber: UITextField!
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var authTimer: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SearchPwSecondVC.self, action: nil)
    var timer: Timer?
    var second = 180
    var authOKFlag: Bool = false
    
    // MARK: - override func
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("SearchPwSecondVC - viewDidLoad() called")
//        self.config()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SearchPwSecondVC - viewDidLoad() called")
        self.config()
    }
    
    // MARK: fileprivate func
    fileprivate func config() {
        // navigationvar item 설정
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "비밀번호 찾기", isLargeTitles: true)
        
        // inputAuthNumber textField
        inputAuthNumber.textContentType = .oneTimeCode
        
        // authTimer label
        authTimer.text = "03:00"
        authTimer.tintColor = .red
        
        // resend button
        resendBtn.tintColor = COLOR.BASIC_TINT_COLOR
        
        // auth button
        authBtn.tintColor = .white
        authBtn.backgroundColor = COLOR.DISABLE_COLOR
        authBtn.layer.cornerRadius = 10
        authBtn.isEnabled = false
        
        // event 연결
        inputAuthNumber.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        authBtn.addTarget(self, action: #selector(onResendBtnClicked), for: .touchUpInside)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: SearchPwSecondVC.self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
        // delegate 연결
        inputAuthNumber.delegate = self
        tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
    }
    
    fileprivate func authBtnAbleChecked() {
        if authOKFlag {
            authBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            authBtn.isEnabled = true
        } else {
            authBtn.backgroundColor = COLOR.DISABLE_COLOR
            authBtn.isEnabled = false
        }
    }
    
    fileprivate func stopTimer() {
        // 타이머 종료
        timer?.invalidate()
        // 타이머 초기화
        timer = nil
    }
    
    // MARK: - @objc delegate
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            authOKFlag = true
        } else {
            authOKFlag = false
        }
        
        authBtnAbleChecked()
    }
    
    @objc fileprivate func onTimerFires() {
        second -= 1
        // 남은 분
        var minutes = second / 60
        // 남은 초
        var secondes = second % 60
        
        if second > 0 {
            authTimer.text = String(format: "%02d:%02d", minutes, secondes)
        } else {
            authTimer.text = "00:00"
            stopTimer()
        }
    }
    
    @objc fileprivate func onResendBtnClicked() {
        // 타이머 reset
        if timer != nil {
            stopTimer()
            return
        }
        
        // 시간 초기화
        second = 180
        // 타이머
        authTimer.text = "03:00"
        
        // 타이머 생성
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: SearchPwSecondVC.self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    // MARK: - textField delegate
    // textField에서 enter, return 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count ?? 0 > 0 {
            authOKFlag = true
        } else {
            authOKFlag = false
        }
        
        authBtnAbleChecked()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case inputAuthNumber:
            authOKFlag = false
        default:
            break
        }
        
        authBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: inputAuthNumber) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
