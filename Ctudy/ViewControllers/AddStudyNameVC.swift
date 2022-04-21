//
//  AddRoomVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/22.
//

import Foundation
import UIKit

class AddStudyNameVC : BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var StudyNameView: UIView!
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var registerStudyName: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    var keyboardDismissTabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    var distance: Double = 0
    var studyNameViewY: Double!
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // 다음 화면정보 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "AddStudyMemberVC" {
            if let controller = segue.destination as? AddStudyMemberVC {
                controller.studyName = self.registerStudyName.text
            }
        }
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationBar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "스터디룸 등록", isLargeTitles: true)
        
        // lmg
        self.roomImg.layer.cornerRadius = self.roomImg.bounds.height / 10
//        self.roomImg.layer.borderWidth = 1
//        self.roomImg.layer.borderColor = COLOR.DISABLE_COLOR.cgColor
        self.roomImg.backgroundColor = COLOR.SUBTITLE_COLOR
        self.roomImg.tintColor = COLOR.DISABLE_COLOR
        self.roomImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large))
        self.roomImg.contentMode = .center
        
        // btn
        self.nextBtn.tintColor = .white
        self.nextBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.nextBtn.layer.cornerRadius = self.nextBtn.bounds.height / 2
        self.nextBtn.isEnabled = false
        self.nextBtn.addTarget(self, action: #selector(onNextBtnClicked(_:)), for: .touchUpInside)
        
        // delegate
        self.registerStudyName.delegate = self
        self.keyboardDismissTabGesture.delegate = self
    }
    
    // MARK: - action func
    @IBAction func editingChanged(_ sender: Any) {
        if self.registerStudyName.text!.isEmpty {
            self.nextBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.nextBtn.isEnabled = false
        } else {
            self.nextBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.nextBtn.isEnabled = true
        }
    }
    
    @objc func onNextBtnClicked(_ sender: Any) {
        print("onNextBtnClicked() called")
        self.performSegue(withIdentifier: "AddStudyMemberVC", sender: nil)
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("AddStudyNameVC - keyboardWillShowHandle() called")
        // keyboard 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardSize.height: \(keyboardSize.height)")
            print("nextBtn.frame.origin.y: \(nextBtn.frame.origin.y)")

            if (keyboardSize.height <= nextBtn.frame.origin.y) {
                distance = keyboardSize.height - nextBtn.frame.origin.y
                print("keyboard covered searchbtn / distance: \(distance)")
                print("changed upvalue: \(distance - nextBtn.frame.height)")

                self.StudyNameView.frame.origin.y = distance - nextBtn.frame.height + studyNameViewY
            }
        }
    }
    
    @objc func keyboardWillHideHandle(noti: Notification) {
        print("AddStudyNameVC - keyboardWillHideHandle() called / studyViewY: \(StudyNameView)")
        UIView.animate(withDuration: noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval) {
            // focusing 해제
            self.StudyNameView.frame.origin.y = self.studyNameViewY
        }
    }
}
