//
//  SearchPwSecondVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/27.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class SearchPwSecondVC: BasicVC, UITextFieldDelegate {
    // MARK: - 변수
    @IBOutlet weak var inputAuthNumber: UITextField!
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var authTimer: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SearchPwSecondVC.self, action: nil)
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
    var timer: Timer!
    var second = 180 // timer에 사용할 시간 3분
    var authOKFlag: Bool = false // 인증번호 입력 flag
    var certificationData: CertificateResponseRequest! // 전달받고 전달할 email, username, key 정보
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if certificationData.key != "" {
//            inputAuthNumber.text = ""
//            onResendBtnClicked()
//            return
//        }
//
//        // 타이머 생성
//        makeFireTimer()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "SearchPwThirdVC" {
            if let controller = segue.destination as? SearchPwThirdVC {
                controller.certificationData = certificationData
            }
        }
    }
    
    // MARK: confing func
    fileprivate func config() {
        // navigationvar item 설정
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "비밀번호 찾기", isLargeTitles: true)
        
        // inputAuthNumber textField
        inputAuthNumber.textContentType = .oneTimeCode
        
        // authTimer label
        authTimer.textColor = .red
        
        // resend button
        resendBtn.tintColor = COLOR.SUBTITLE_COLOR
        
        // auth button
        authBtn.tintColor = .white
        authBtn.backgroundColor = COLOR.DISABLE_COLOR
        authBtn.layer.cornerRadius = 10
        authBtn.isEnabled = false
        
        // 타이머 생성
        makeFireTimer()
        
        // event 연결
        inputAuthNumber.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        resendBtn.addTarget(self, action: #selector(onResendBtnClicked), for: .touchUpInside)
        authBtn.addTarget(self, action: #selector(onAuthBtnClicked), for: .touchUpInside)
        
        // delegate 연결
        inputAuthNumber.delegate = self
        tabGesture.delegate = self
        
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
    
    // MARK: - timer func
    // 타이머 생성 및 시작 func
    fileprivate func makeFireTimer() {
        // 시간 초기화
        second = 180
//        second = 10
        
        // 타이머
        authTimer.text = "03:00"
//        authTimer.text = "00:10"
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] (timer: Timer) in
            self.onTimerFires()
        })
                                          
//        timer.tolerance = 0.1 // 100밀리초의 오차 허용
        RunLoop.current.add(timer, forMode: .common)
//        self.timer.fire()
    }
    
    // 타이머 종료 func
    fileprivate func stopTimer() {
        // 타이머 종료
        self.timer.invalidate()
        
        // 타이머 초기화
        self.timer = nil
    }
    
    // 타이머 카운트 계산 func
    fileprivate func onTimerFires() {
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
    
    // MARK: - button func
    @objc fileprivate func onResendBtnClicked() {
        print("SearchPwSecondVC - onResendBtnClicked() called")
        // 타이머 reset
        if timer != nil {
            stopTimer()
        }
        
        AlamofireManager.shared.postSearchPw(email: certificationData.email, username: certificationData.username, completion: {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                // 타이머 생성 및 시작
                self.makeFireTimer()
            case .failure(let error):
                print("SearchPwSecondVC - postSearchPw() called / error: \(error.rawValue)")
//                self.view.makeToast("", duration: 1.0, position: .center)
            }
        })
    }
    
    @objc fileprivate func onAuthBtnClicked() {
        onStartActivityIndicator()
        
        AlamofireManager.shared.postCertificate(email: certificationData.email, username: certificationData.username, code: inputAuthNumber.text!, completion: { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let data):
                self.certificationData = data
                self.performSegue(withIdentifier: "SearchPwThirdVC", sender: nil)
            case .failure(let error):
                print("SearchPwThirdVC - postCertificate() called / error: \(error.rawValue)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if indicator.isAnimating {
            onStopActivityIndicator()
        }
    }
    
    // button ui func
    fileprivate func authBtnAbleChecked() {
        if authOKFlag {
            authBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            authBtn.isEnabled = true
        } else {
            authBtn.backgroundColor = COLOR.DISABLE_COLOR
            authBtn.isEnabled = false
        }
    }
    
    // MARK: - textField delegate
    // textfield 변경 시 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            authOKFlag = true
        } else {
            authOKFlag = false
        }
        
        authBtnAbleChecked()
    }
    
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
