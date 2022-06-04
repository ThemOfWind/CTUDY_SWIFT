//
//  SignUpFirstVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation
import UIKit

class SignUpFirstVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var registerName: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nameMsg: UILabel!
    @IBOutlet weak var emailMsg: UILabel!
    @IBOutlet weak var goToStartBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SignUpFirstVC.self, action: nil)
    var memberName: String?
    var nameOKFlag: Bool = false
    var emailOKFlag: Bool = false
    var imageFlag: Bool = false // image 초기화 flag
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpFirstVC - viewDidLoad() called")
        self.config()
    }
    
    // 다음 화면 이동 시 입력받은 이름정보 넘기기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "SignUpSecondVC" {
            if let controller = segue.destination as? SignUpSecondVC {
                controller.userImage = imageFlag ? self.userImg.image?.pngData() : nil
                controller.registerName = self.registerName.text
                controller.registerEmail = self.registerEmail.text
            }
        }
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        self.titleItem = TitleItem.titleGeneral(title: "회원가입", isLargeTitles: true)
        
        // button ui
        self.nextBtn.tintColor = .white
        self.nextBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.nextBtn.layer.cornerRadius = 10
        self.nextBtn.isEnabled = false
        
        // imageView ui
        self.userImg.layer.cornerRadius = self.userImg.layer.bounds.height / 2
        self.userImg.layer.borderWidth = 1
        self.userImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        self.userImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        self.userImg.tintColor = COLOR.BASIC_TINT_COLOR
        self.userImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: self.userImg.bounds.height / 5, weight: .regular, scale: .large))
        self.userImg.contentMode = .center
        self.userImg.isUserInteractionEnabled = true
        
        // button event 연결
        self.goToStartBtn.addTarget(self, action: #selector(onGoToStartBtnClicked), for: .touchUpInside)
        // textField event 연결
        self.registerName.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.registerEmail.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        // delegate 연결
        self.registerName.delegate = self
        self.registerEmail.delegate = self
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
    
    // nextButton 활성화 & 비활성화 event
    fileprivate func nextBtnAbleChecked() {
        if nameOKFlag && emailOKFlag {
            self.nextBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.nextBtn.isEnabled = true
        } else {
            self.nextBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.nextBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 event
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        //        print("SignUpFirstVC - isValidData() called / data: \(data), flag: \(flag)")
        
        guard data != "" else { return false }
        let pred : NSPredicate
        
        switch flag {
        case "registerName":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.NAME_REGEX)
        case "registerEmail":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.EMAIL_REGEX)
        default:
            pred = NSPredicate(format: "SELF MATCHES %@", "")
        }
        
        return pred.evaluate(with: data)
    }
    
    fileprivate func actionSheetAlert() {
        let alert = UIAlertController(title: "내 이미지 설정", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "초기화", style: .cancel, handler: { [weak self] (_) in
            self?.presentCancel()
        })
        let camera = UIAlertAction(title: "카메라", style: .default, handler: { [weak self] (_) in
            self?.presentCamera()
        })
        let album = UIAlertAction(title: "앨범", style: .default, handler: { [weak self] (_) in
            self?.presentAlbum()
        })
        
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        present(alert, animated: true, completion: nil)
    }
    
    // 초기화 picker setting
    fileprivate func presentCancel() {
        self.imageFlag = false
        self.userImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: self.userImg.bounds.height / 5, weight: .regular, scale: .large))
        self.userImg.contentMode = .center
    }
    
    // 카메라 picker setting
    fileprivate func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        vc.cameraFlashMode = .off
        vc.modalPresentationStyle = .fullScreen
        //        vc.cameraOverlayView?.addSubview(customOverlayView())
        present(vc, animated: true, completion: nil)
    }
    
    // 앨범 picker setting
    fileprivate func presentAlbum() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        vc.modalPresentationStyle = .fullScreen
        //        vc.showsCameraControls = false
        //        vc.cameraOverlayView?.addSubview(customOverlayView())
        present(vc, animated: true, completion: nil)
    }
    
    // 취소버튼 click event
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // 카메라 촬영 or 앨범에서 사용하기 버튼 click event
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // update image
        var newImage: UIImage? = nil
        
        // 수정된 image가 있을 경우
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        self.userImg.contentMode = .scaleAspectFill
        self.userImg.image = newImage
        self.imageFlag = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func customOverlayView() -> UIView {
        let overlayView = UIView()
        overlayView.frame = self.userImg.frame
        return overlayView
    }
    
    // MARK: - @objc func
    @objc fileprivate func onProfileImageClicked() {
        actionSheetAlert()
    }
    
    // textField 변경할 때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        //        print("SignUpFirstVC - textFieldEditingChanged() called / sender.text: \(sender.text)")
        
        switch textField {
        case registerName:
            // 이름 형식 체크 (자음 및 모음 X, 2글자 이상, 특수문자 사용 X)
            textFieldCheck(textField: textField, msgLabel: nameMsg, inputData: registerName.text ?? "")
        case registerEmail:
            // @email 형식 체크
            textFieldCheck(textField: textField, msgLabel: emailMsg, inputData: registerEmail.text ?? "")
        default:
            break
        }
        
        nextBtnAbleChecked()
    }
    
    @objc fileprivate func onGoToStartBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - textField delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        print("SignUpFirstVC - textFieldShouldReturn() called")
        
        switch textField {
        case registerName:
            // 이름 형식 체크 (자음 및 모음 X, 2글자 이상, 특수문자 사용 X)
            textFieldCheck(textField: textField, msgLabel: nameMsg, inputData: registerName.text ?? "" )
        case registerEmail:
            // @email 형식 체크
            textFieldCheck(textField: textField, msgLabel: emailMsg, inputData: registerEmail.text ?? "")
        default:
            break
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        print("SignUpFirstVC - textFieldCheck() called / msgLabel: \(msgLabel), inputData: \(inputData)")
        
        guard inputData != "" else {
            msgLabel.text = ""
            return
        }
        
        switch textField {
        case registerName:
            nameOKFlag = isValidData(flag: "registerName", data: inputData)
            if nameOKFlag {
                setMsgLabel(flag: nameOKFlag, msgLabel: msgLabel, msgString: "")
            } else {
                setMsgLabel(flag: nameOKFlag, msgLabel: msgLabel, msgString: "이름이 옳바르지 않습니다.")
            }
        case registerEmail:
            emailOKFlag = isValidData(flag: "registerEmail", data: inputData)
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
        case registerName:
            nameOKFlag = false
        case registerEmail:
            emailOKFlag = false
        default:
            break
        }
        
        nextBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: userImg) == true {
            view.endEditing(true)
            onProfileImageClicked()
            return true
        } else if touch.view?.isDescendant(of: registerName) == true {
            return false
        } else if touch.view?.isDescendant(of: registerEmail) == true {
            return false
        }  else {
            view.endEditing(true)
            return true
        }
    }
}
