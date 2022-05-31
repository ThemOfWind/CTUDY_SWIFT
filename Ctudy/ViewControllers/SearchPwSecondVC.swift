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
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SearchPwSecondVC.self, action: nil)
    var authOKFlag: Bool = false
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchPwSecondVC - viewDidLoad() called")
        self.config()
    }
    
    // MARK: fileprivate func
    fileprivate func config() {
        // navigationvar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "비밀번호 찾기", isLargeTitles: true)
        
        // button & textField ui
        self.authBtn.tintColor = .white
        self.authBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.authBtn.layer.cornerRadius = 10
        self.authBtn.isEnabled = false
        self.inputAuthNumber.textContentType = .oneTimeCode
        
        // textField event 연결
        self.inputAuthNumber.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        // delegate 연결
        self.inputAuthNumber.delegate = self
        self.tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
    }
    
    fileprivate func authBtnAbleChecked() {
        if authOKFlag {
            self.authBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.authBtn.isEnabled = true
        } else {
            self.authBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.authBtn.isEnabled = false
        }
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
