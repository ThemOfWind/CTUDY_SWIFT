//
//  SearchIDVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/26.
//

import Foundation
import UIKit

class SearchIdFirstVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate {
    // MARK: - 변수
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var emailMsg: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SearchIdFirstVC.self, action: nil)
    var emailOKFlag: Bool = false
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchIdFirstVC - viewDidLoad() called")
        self.config()
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
//        self.searchBtn.addTarget(self, action: #selector(onSearchBtnClicked), for: .touchUpInside)
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
    
    // MARK: - @objc func
//    @objc fileprivate func onSearchBtnClicked() {
//        print("ID Search Button click!")
//    }
    
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
