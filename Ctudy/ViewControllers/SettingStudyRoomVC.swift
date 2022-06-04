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
    func onMemberViewClicked(master: SettingMasterRequest)
}

class SettingStudyRoomVC: BasicVC, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SettingSendDelegate{
    // MARK: - 변수
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var roomName: UITextField!
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
    var selectedMaster: SettingMasterRequest! // 선택한 마스터멤버 정보
    var imageFlag: Bool = false // 스터디룸 이미지 입력 flag
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "스터디룸 설정", isLargeTitles: true)
        
        // studyroom image ui
        self.roomImg.layer.cornerRadius = 10
        self.roomImg.layer.borderWidth = 1
        self.roomImg.layer.borderColor = COLOR.BASIC_BACKGROUD_COLOR.cgColor
        self.roomImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        self.roomImg.tintColor = COLOR.BASIC_TINT_COLOR
        self.roomImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: self.roomImg.bounds.height / 5, weight: .regular, scale: .large))
        self.roomImg.contentMode = .center
        self.roomImg.isUserInteractionEnabled = true
        
        // update button ui
        self.updateBtn.layer.cornerRadius = 10
        self.updateBtn.tintColor = .white
        self.updateBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        
        // mastername textfield ui
        self.masterName.isEnabled = false
        
        // event 연결
        self.updateBtn.addTarget(self, action: #selector(onUpdateBtnClicked), for: .touchUpInside)
        
        // delegate 연결
        self.tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
    }
    
    // update button click event
    @objc fileprivate func onUpdateBtnClicked() {
        
    }
    
    // masterName textfield click event
    fileprivate func onMasterNameTextFieldClicked() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "UpdateMasterVC") as? UpdateMasterVC else { return }
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .automatic
//        controller.delegate = self
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
        self.imageFlag = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func customOverlayView() -> UIView {
        let overlayView = UIView()
        overlayView.frame = self.roomImg.frame
        return overlayView
    }
    
    // MARK: - protocol delegate
    func onMemberViewClicked(master: SettingMasterRequest) {
        
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
