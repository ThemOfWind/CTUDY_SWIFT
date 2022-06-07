//
//  AddRoomVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/22.
//

import Foundation
import UIKit
//import YPImagePicker

class RegisterStudyRoomFirstVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // UIImagePickerControllerDelegate - 이미지를 선택하고 카메라를 찍었을때 다양한 동작을 도와줌
    // UINavigationControllerDelegate - 앨범사진을 선택했을때 화면전환을 네비게이션으로 이동함
    // MARK: - 변수
    @IBOutlet weak var studyNameView: UIView!
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var registerStudyName: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: RegisterStudyRoomFirstVC.self, action: nil)
    
    //    let imagePicker: UIImagePickerController = {
    //        let picker = UIImagePickerController()
    //        picker.sourceType = .photoLibrary // 앨범열기 설정
    //        picker.allowsEditing = true // 수정 가능 여부
    //        return picker
    //    }()
    
    var imageFlag: Bool = false
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // 다음 화면정보 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "RegisterStudyRoomSecondVC" {
            if let controller = segue.destination as? RegisterStudyRoomSecondVC {
                controller.studyName = self.registerStudyName.text
                controller.studyImage = imageFlag ? self.roomImg.image?.pngData() : nil
            }
        }
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationBar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "스터디룸 등록", isLargeTitles: true)
        
        // lmageView ui
        self.roomImg.layer.cornerRadius = 10
        self.roomImg.layer.borderWidth = 1
        self.roomImg.layer.borderColor = COLOR.BASIC_BACKGROUD_COLOR.cgColor
        self.roomImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        self.roomImg.tintColor = COLOR.BASIC_TINT_COLOR
        self.roomImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: self.roomImg.bounds.height / 5, weight: .regular, scale: .large))
        self.roomImg.contentMode = .center
        self.roomImg.isUserInteractionEnabled = true
        
        // button ui, event 연결
        self.nextBtn.layer.cornerRadius = 10
        self.nextBtn.tintColor = .white
        self.nextBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.nextBtn.isEnabled = false
        self.nextBtn.addTarget(self, action: #selector(onNextBtnClicked(_:)), for: .touchUpInside)
        
        // delegate 연결
        self.registerStudyName.delegate = self
        self.tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
    }
    
    fileprivate func actionSheetAlert() {
        let alert = UIAlertController(title: "스터디룸 이미지 설정", message: nil, preferredStyle: .actionSheet)
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
        self.roomImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: self.roomImg.bounds.height / 5, weight: .regular, scale: .large))
        self.roomImg.contentMode = .center
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
    
    // 취소 버튼 click event
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
        
        self.roomImg.contentMode = .scaleAspectFill
        self.roomImg.image = newImage
        self.imageFlag = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func customOverlayView() -> UIView {
        let overlayView = UIView()
        overlayView.frame = self.roomImg.frame
        return overlayView
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
    
    @objc fileprivate func onProfileImageClicked() {
        actionSheetAlert()
    }
    
    @objc fileprivate func onNextBtnClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "RegisterStudyRoomSecondVC", sender: nil)
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: registerStudyName) == true {
            return false
        } else if touch.view?.isDescendant(of: roomImg) == true {
            view.endEditing(true)
            onProfileImageClicked()
            return true
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
