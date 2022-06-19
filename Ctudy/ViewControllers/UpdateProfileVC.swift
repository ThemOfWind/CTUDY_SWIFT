//
//  UpdateProfileVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/08.
//

import Foundation
import UIKit
import Kingfisher
import NVActivityIndicatorView

class UpdateProfileVC: BasicVC, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {
    // MARK: - 변수
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var nameMsg: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: UpdateProfileVC.self, action: nil)
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
    var profileId: Int!
    lazy var userImg: String? = KeyChainManager().tokenLoad(API.SERVICEID, account: "image") // 키체인에 존재하는 image 담는 변수
    var nameOKFlag: Bool = true
    var imageFlag: Bool = false // image 초기화 flag
    var imageAlFuncFlag: Bool = false // 내 프로필 이미지 alamofire func 실행 여부 flag
    var imageNilFlag: Bool = false // 내 프로필 설정 alamofire func 실행 여부
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "프로필 설정", isLargeTitles: true)
        
        // profile
        profileImg.layer.cornerRadius = self.profileImg.bounds.height / 2
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        profileImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        profileImg.tintColor = COLOR.BASIC_TINT_COLOR
        if let img = userImg, img != "" {
            profileImg.kf.setImage(with: URL(string: API.IMAGE_URL + img)!)
        } else {
            profileImg.image = UIImage(named: "user_default.png")
        }
        profileImg.contentMode = .scaleAspectFill
//        profileImg.translatesAutoresizingMaskIntoConstraints = false
        profileImg.isUserInteractionEnabled = true
        
        profileId = Int(KeyChainManager().tokenLoad(API.SERVICEID, account: "id")!)
        inputName.text = KeyChainManager().tokenLoad(API.SERVICEID, account: "name")
        profileUsername.text = "@\(KeyChainManager().tokenLoad(API.SERVICEID, account: "username")!)"
        profileUsername.textColor = COLOR.SUBTITLE_COLOR
        
        // button ui
        updateBtn.layer.cornerRadius = 10
        updateBtn.tintColor = .white
        updateBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        
        // event 연결
        inputName.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        updateBtn.addTarget(self, action: #selector(onUpdateBtnClicked), for: .touchUpInside)
        
        // delegate 연결
        inputName.delegate = self
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
    
    // searchButton 활성화 & 비활성화 event
    fileprivate func searchBtnAbleChecked() {
        if nameOKFlag {
            updateBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            updateBtn.isEnabled = true
        } else {
            updateBtn.backgroundColor = COLOR.DISABLE_COLOR
            updateBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 event
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        guard data != "" else { return false }
        let pred : NSPredicate
        
        switch flag {
        case "inputName":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.NAME_REGEX)
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
    
    fileprivate func actionSheetAlert() {
        let alert = UIAlertController(title: "프로필 이미지 변경", message: nil, preferredStyle: .actionSheet)
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
        if let img = userImg, img != "" {
            profileImg.kf.setImage(with: URL(string: API.IMAGE_URL + img)!)
        } else {
            profileImg.image = UIImage(named: "user.png")
        }
    }
    
    // 기본 이미지 picker setting
    fileprivate func presentBasic() {
        imageAlFuncFlag = true
        imageNilFlag = true
        profileImg.image = UIImage(named: "user_default.png")
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
    
    fileprivate func onProfileImageClicked() {
        actionSheetAlert()
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
        
        self.profileImg.contentMode = .scaleAspectFill
        self.profileImg.image = newImage
        imageAlFuncFlag = true
        imageNilFlag = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    func customOverlayView() -> UIView {
        let overlayView = UIView()
        overlayView.frame = self.profileImg.frame
        return overlayView
    }
    
    // MARK: - @objc func
    @objc fileprivate func onUpdateBtnClicked() {
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.putUpdateProfile(name: inputName.text!, completion: {
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
                    AlamofireManager.shared.postUpdateProfile_image(image: self.imageNilFlag ? nil : self.profileImg.image?.pngData(), completion: {
                        [weak self] result in
                        guard let self = self else { return }
                        
                        self.onStopActivityIndicator()
                        
                        switch result {
                        case .success(_):
                            // keychain에 프로필 정보 update
                            self.getProfileInfo()
                            break
                        case .failure(let error):
                            print("UpdateProfileVC - postUpdateProfile_image() called / error: \(error.rawValue)")
                            self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                        }
                    })
                } else {
                    // keychain에 프로필 정보 update
                    self.getProfileInfo()
                }
            case .failure(let error):
                print("UpdateProfileVC - putUpdateProfile() called / error: \(error.rawValue)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // 접속 회원정보 조회 후 keychain 저장
    fileprivate func getProfileInfo() {
        
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.getProfile(completion: { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(_):
                // 프로필 화면으로 이동
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.view.makeToast("프로필이 변경되었습니다.", duration: 1.0, position: .center)
            case .failure(let error):
                print("UpdateProfileVC - getProfile() called / error: \(error.rawValue)")
            }
        })
        
        if indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // textField 변경할 때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case inputName:
            // 이름 형식 체크 (자음 및 모음 X, 2글자 이상, 특수문자 사용 X)
            textFieldCheck(textField: textField, msgLabel: nameMsg, inputData: inputName.text ?? "")
        default:
            break
        }
        
        searchBtnAbleChecked()
    }
    
    // MARK: - textField delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case inputName:
            // 이름 형식 체크 (자음 및 모음 X, 2글자 이상, 특수문자 사용 X)
            textFieldCheck(textField: textField, msgLabel: nameMsg, inputData: inputName.text ?? "" )
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
        case inputName:
            nameOKFlag = isValidData(flag: "inputName", data: inputData)
            if nameOKFlag {
                setMsgLabel(flag: nameOKFlag, msgLabel: msgLabel, msgString: "")
            } else {
                setMsgLabel(flag: nameOKFlag, msgLabel: msgLabel, msgString: "이름이 옳바르지 않습니다.")
            }
        default:
            break
        }
        
        searchBtnAbleChecked()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case inputName:
            nameOKFlag = false
        default:
            break
        }
        
        searchBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: profileImg) == true {
            view.endEditing(true)
            onProfileImageClicked()
            return true
        } else if touch.view?.isDescendant(of: inputName) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
