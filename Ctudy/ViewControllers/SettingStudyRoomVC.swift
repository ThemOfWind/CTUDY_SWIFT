//
//  UpdateStudyMasterVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/04.
//

import Foundation
import UIKit
import Kingfisher
import NVActivityIndicatorView

protocol SettingSendDelegate: AnyObject {
    func onMemberViewClicked(master: SettingMasterResponse)
}

class SettingStudyRoomVC: BasicVC, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SettingSendDelegate, UITextFieldDelegate{
    // MARK: - 변수
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var roomName: UITextField!
    @IBOutlet weak var roomNameMsg: UILabel!
    @IBOutlet weak var masterName: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: SettingStudyRoomVC.self, action: nil)
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
    var members: Array<SearchStudyMemberResponse>? // 전달받은 멤버 리스트
    var settingRoom: SettingStudyRoomResponse! // 전달받은 room 정보
    var selectedMaster: SettingMasterResponse! // 선택한 마스터멤버 정보
    var roomNameOKFlag: Bool = false // 스터디룸 이름 입력 flag
    var imageAlFuncFlag: Bool = false // 스터디룸 이미지 alamofire func 실행 여부 flag
    var imageNilFlag: Bool = false // 스터디룸 설정 alamofire func 실행 여부
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "스터디룸 설정", isLargeTitles: true)
        
        // studyroom image ui
        roomImg.layer.cornerRadius = 10
        roomImg.layer.borderWidth = 1
        roomImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        roomImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        roomImg.tintColor = COLOR.BASIC_TINT_COLOR
        if settingRoom.banner != "" {
            roomImg.kf.setImage(with: URL(string: API.IMAGE_URL + settingRoom.banner)!, options: [.forceRefresh])
        } else {
            roomImg.image = UIImage(named: "studyroom_default.png")
        }
        roomImg.contentMode = .scaleAspectFill
        roomImg.isUserInteractionEnabled = true
        
        // update button ui
        updateBtn.layer.cornerRadius = 10
        updateBtn.tintColor = .white
        updateBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        
        // roomname textfield ui
        //        roomName.placeholder = settingRoom.name
        roomName.text = settingRoom.name
        
        // mastername textfield ui
        let master = SettingMasterResponse(id: settingRoom.masterid, name: settingRoom.mastername)
        selectedMaster = master
        masterName.text = selectedMaster.name
        masterName.isUserInteractionEnabled = true // readonly
        
        // event 연결
        roomName.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        updateBtn.addTarget(self, action: #selector(onUpdateBtnClicked), for: .touchUpInside)
        
        // delegate 연결
        roomName.delegate = self
        masterName.delegate = self
        tabGesture.delegate = self
        
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
    
    // createButton 활성화 & 비활성화 event
    fileprivate func createBtnAbleChecked() {
        print("roomNameOKFlag: \(roomNameOKFlag), selectedMaster: \(selectedMaster)")
        if roomNameOKFlag && (selectedMaster != nil) {
            updateBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            updateBtn.isEnabled = true
        } else {
            updateBtn.backgroundColor = COLOR.DISABLE_COLOR
            updateBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 event
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        //        print("SignUpFirstVC - isValidData() called / data: \(data), flag: \(flag)")
        
        guard data != "" else { return false }
        let pred : NSPredicate
        
        switch flag {
        case "roomName":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.CTUDYNAME_REGEX)
        default:
            pred = NSPredicate(format: "SELF MATCHES %@", "")
        }
        
        return pred.evaluate(with: data)
    }
    
    // masterName textfield click event
    fileprivate func onMasterNameTextFieldClicked() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "UpdateMasterVC") as? UpdateMasterVC else { return }
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .automatic
        controller.members = members
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    // 쿠폰 imageView event
    fileprivate func onRoomImageClicked() {
        actionSheetAlert()
    }
    
    fileprivate func actionSheetAlert() {
        let alert = UIAlertController(title: "새로운 스터디룸 이미지 설정", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "초기화", style: .cancel, handler: { [weak self] (_) in
            self?.presentCancel()
        })
        let basic = UIAlertAction(title: "기본 이미지", style: .default, handler: { [weak self] (_) in
            self?.presentBasic()
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
        alert.addAction(basic)
        present(alert, animated: true, completion: nil)
    }
    
    // 초기화 picker setting
    fileprivate func presentCancel() {
        imageAlFuncFlag = false
        if settingRoom.banner != "" {
            roomImg.kf.setImage(with: URL(string: API.IMAGE_URL + settingRoom.banner)!, options: [.forceRefresh])
        } else {
            roomImg.image = UIImage(named: "studyroom_default.png")
        }
    }
    
    // 기본 이미지 picker setting
    fileprivate func presentBasic() {
        imageAlFuncFlag = true
        imageNilFlag = true
        roomImg.image = UIImage(named: "studyroom_default.png")
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
        
        self.roomImg.contentMode = .scaleAspectFill
        self.roomImg.image = newImage
        imageAlFuncFlag = true
        imageNilFlag = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    func customOverlayView() -> UIView {
        let overlayView = UIView()
        overlayView.frame = self.roomImg.frame
        return overlayView
    }
    
    // textField 변경할 때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        //        print("SettingStudyRoomVC - textFieldEditingChanged() called / sender.text: \(sender.text)")
        switch textField {
        case roomName:
            // 이름 형식 체크 (모든 문자 1글자 이상, 공백만 X)
            textFieldCheck(textField: textField, msgLabel: roomNameMsg, inputData: roomName.text ?? "" )
        default:
            break
        }
    }
    
    // update button click event
    @objc fileprivate func onUpdateBtnClicked() {
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.putUpdateRoom(id: settingRoom.id, name: roomName.text!, master: selectedMaster.id, completion: {
            [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(_):
                /* imageAlFuncFlag :
                 true : 카메라 & 앨범 & 기본이미지
                 false : 초기화
                 */
                if self.imageAlFuncFlag {
                    /* imageNilFlag
                     true : roomImg.image?.pngData()
                     false : nil
                     */
                    AlamofireManager.shared.postUpdateRoom_image(id: self.settingRoom.id, image: self.imageNilFlag ? nil : self.roomImg.image?.pngData()
                                                                 , completion: {
                        [weak self] result in
                        guard let self = self else { return }
                        
                        self.onStopActivityIndicator()
                        
                        switch result {
                        case .success(_):
                            self.view.makeToast("스터디룸 설정이 변경되었습니다.", duration: 1.0, position: .center)
                            self.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                        }
                    })
                } else {
                    self.view.makeToast("스터디룸 설정이 변경되었습니다.", duration: 1.0, position: .center)
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // MARK: - protocol delegate
    func onMemberViewClicked(master: SettingMasterResponse) {
        selectedMaster = master
        
        masterName.text = selectedMaster.name
    }
    
    // MARK: - textField delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        print("SettingStudyRoomVC - textFieldShouldReturn() called")
        switch textField {
        case roomName:
            // 이름 형식 체크 (모든 문자 1글자 이상, 공백만 X)
            textFieldCheck(textField: textField, msgLabel: roomNameMsg, inputData: roomName.text ?? "" )
        default:
            break
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        print("SettingStudyRoomVC - textFieldCheck() called / msgLabel: \(msgLabel), inputData: \(inputData)")
        
        guard inputData != "" else {
            msgLabel.text = ""
            return
        }
        
        switch textField {
        case roomName:
            roomNameOKFlag = isValidData(flag: "roomName", data: inputData)
            if roomNameOKFlag {
                setMsgLabel(flag: roomNameOKFlag, msgLabel: msgLabel, msgString: "")
            } else {
                setMsgLabel(flag: roomNameOKFlag, msgLabel: msgLabel, msgString: "이름이 옳바르지 않습니다. (공백X)")
            }
        default:
            break
        }
        
        createBtnAbleChecked()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case roomName:
            roomNameOKFlag = false
        default:
            break
        }
        
        createBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: roomImg) == true {
            view.endEditing(true)
            onRoomImageClicked()
            return true
        } else if touch.view?.isDescendant(of: masterName) == true {
            view.endEditing(true)
            onMasterNameTextFieldClicked()
            return true
        } else if touch.view?.isDescendant(of: roomName) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
