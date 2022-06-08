//
//  SearchIDVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/26.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class SearchIdFirstVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate {
    // MARK: - 변수
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var emailMsg: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SearchIdFirstVC.self, action: nil)
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
    var emailOKFlag: Bool = false
    var searchId: String? // 다음화면으로 넘겨줄 찾은 id
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchIdFirstVC - viewDidLoad() called")
        self.config()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "SearchIdSuccessVC" {
            if let controller = segue.destination as? SearchIdSuccessVC {
                controller.searchId = searchId
            }
        }
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "아이디 찾기", isLargeTitles: true)
        
        // button ui
        self.searchBtn.tintColor = .white
        self.searchBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.searchBtn.layer.cornerRadius = 10
        self.searchBtn.isEnabled = false
        
        // button & textField event 연결
        self.searchBtn.addTarget(self, action: #selector(onSearchBtnClicked), for: .touchUpInside)
        self.inputEmail.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        // delegate 연결
        self.inputEmail.delegate = self
        self.tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
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
    
    // searchButton 활성화 & 비활성화 event
    fileprivate func searchBtnAbleChecked() {
        if emailOKFlag {
            self.searchBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.searchBtn.isEnabled = true
        } else {
            self.searchBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.searchBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 event
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        guard data != "" else { return false }
        let pred : NSPredicate
        
        switch flag {
        case "inputEmail":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.EMAIL_REGEX)
        default:
            pred = NSPredicate(format: "SELF MATCHES %@", "")
        }
        
        return pred.evaluate(with: data)
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
    @objc fileprivate func onSearchBtnClicked() {
        
        onStartActivityIndicator()
        
        AlamofireManager.shared.postSearchId(email: inputEmail.text!, completion: { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let username):
                // 다음 화면으로 넘기기
                self.searchId = username
                self.performSegue(withIdentifier: "SearchIdSuccessVC", sender: nil)
            case .failure(let error):
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if indicator.isAnimating {
            onStopActivityIndicator()
        }
    }
    
    // textField 변경할 때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case inputEmail:
            // @email 형식 체크
            textFieldCheck(textField: textField, msgLabel: emailMsg, inputData: inputEmail.text ?? "")
        default:
            break
        }
        
        searchBtnAbleChecked()
    }
    
    // MARK: - textField delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case inputEmail:
            // @email 형식 체크
            textFieldCheck(textField: textField, msgLabel: emailMsg, inputData: inputEmail.text ?? "" )
        default:
            break
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        guard inputData != "" else {
            msgLabel.text = ""
            return
        }
        
        switch textField {
        case inputEmail:
            emailOKFlag = isValidData(flag: "inputEmail", data: inputData)
            if emailOKFlag {
                setMsgLabel(flag: emailOKFlag, msgLabel: msgLabel, msgString: "")
            } else {
                setMsgLabel(flag: emailOKFlag, msgLabel: msgLabel, msgString: "이메일(email)이 옳바르지 않습니다.")
            }
        default:
            break
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case inputEmail:
            emailOKFlag = false
        default:
            break
        }
        
        searchBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: inputEmail) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
