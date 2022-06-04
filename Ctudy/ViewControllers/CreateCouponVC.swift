//
//  CreateCouponVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/27.
//

import Foundation
import UIKit
import Kingfisher
import NVActivityIndicatorView

// receiver 목록 view에서 선택 event 연결 protocol
protocol CouponSendDelegate: AnyObject {
    func onMemberViewClicked(receiver: CouponReciverRequest)
}

class CreateCouponVC: BasicVC, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CouponSendDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var senderImg: UIImageView!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var receiverImg: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var receiverUsername: UILabel!
    @IBOutlet weak var couponName: UITextField!
    @IBOutlet weak var couponNameMsg: UILabel!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var endDateMsg: UILabel!
    @IBOutlet weak var couponImg: UIImageView!
    @IBOutlet weak var createBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: CreateCouponVC.self, action: nil)
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
    var roomId: Int! // 전달받은 studyroom pk
    var selectedReceiver: CouponReciverRequest! // 선택한 쿠폰 수신자
    var startDate: String? // 오늘 날짜
    let datePicker = UIDatePicker() // 날짜 피커
    let formatter = DateFormatter() // 날짜 포맷
    var nameOKFlag: Bool = false // 이름 입력 flag
    var dateOKFlag: Bool = false // 날짜 입력 flag
    var imageFlag: Bool = false // 쿠폰이미지 입력 flag
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // modalView 실행에서 이미지처리 또는 많은 가상메모리를 소비하는 액션을 진행할때 메모리 경고를 받게 되어 modal 창이 죽게 되는 경우를 대비
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "쿠폰 발급", isLargeTitles: true)
        
        // sender image ui
        self.senderImg.layer.cornerRadius = self.senderImg.bounds.height / 2
        self.senderImg.layer.borderWidth = 1
        self.senderImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        self.senderImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        self.senderImg.tintColor = COLOR.BASIC_TINT_COLOR
        if let myImg = KeyChainManager().tokenLoad(API.SERVICEID, account: "image"), myImg != "" {
            self.senderImg.kf.setImage(with: URL(string: API.IMAGE_URL + myImg)!)
        } else {
            self.senderImg.image = UIImage(named: "user_default.png")
        }
        self.senderImg.contentMode = .scaleAspectFill
        self.senderImg.translatesAutoresizingMaskIntoConstraints = false
        
        // sender label ui
        self.senderName.text = KeyChainManager().tokenLoad(API.SERVICEID, account: "name")
        self.senderUsername.text = "@\(KeyChainManager().tokenLoad(API.SERVICEID, account: "username")!)"
        self.senderUsername.textColor = COLOR.SUBTITLE_COLOR
        
        // arrow image ui
        self.arrowImg.image = UIImage(named: "arrow.png")
        self.arrowImg.contentMode = .scaleAspectFit
        self.arrowImg.translatesAutoresizingMaskIntoConstraints = false
        
        // reciver image ui
        self.receiverImg.layer.cornerRadius = self.senderImg.bounds.height / 2
        self.receiverImg.layer.borderWidth = 1
        self.receiverImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        self.receiverImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        self.receiverImg.tintColor = COLOR.BASIC_TINT_COLOR
        self.receiverImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: self.receiverImg.bounds.height / 5, weight: .regular, scale: .large))
        self.receiverImg.contentMode = .center
        self.receiverImg.isUserInteractionEnabled = true
        
        // coupon image ui
        self.couponImg.layer.cornerRadius = 10
        self.couponImg.layer.borderWidth = 1
        self.couponImg.layer.borderColor = COLOR.BASIC_BACKGROUD_COLOR.cgColor
        self.couponImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        self.couponImg.tintColor = COLOR.BASIC_TINT_COLOR
        self.couponImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: self.couponImg.bounds.height / 5, weight: .regular, scale: .large))
        self.couponImg.contentMode = .center
        self.couponImg.isUserInteractionEnabled = true // 유저의 event가 event queue로부터 무시되고 삭제됐는지 판단하는 boolean 값
        
        // button ui
        self.createBtn.layer.cornerRadius = 10
        self.createBtn.tintColor = .white
        self.createBtn.backgroundColor = COLOR.DISABLE_COLOR
        self.createBtn.isEnabled = false
        
        // date format, startDate 셋팅
        formatter.timeStyle = .none
        //        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        self.startDate = formatter.string(from: Date())
        
        // event 연결
        self.createBtn.addTarget(self, action: #selector(onCreateBtnClicked), for: .touchUpInside)
        self.couponName.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        self.endDate.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        // delegate 연결
        self.couponName.delegate = self
        self.endDate.delegate = self
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
    
    // createButton 활성화 & 비활성화 event
    fileprivate func createBtnAbleChecked() {
        print("nameOKFlag: \(nameOKFlag), dateOKFlag: \(dateOKFlag), receiver_isSelected: \(selectedReceiver != nil)")
        if nameOKFlag && dateOKFlag && (selectedReceiver != nil) {
            self.createBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            self.createBtn.isEnabled = true
        } else {
            self.createBtn.backgroundColor = COLOR.DISABLE_COLOR
            self.createBtn.isEnabled = false
        }
    }
    
    // 이름 정규식 체크 event
    fileprivate func isValidData(flag: String, data: String) -> Bool {
        //        print("SignUpFirstVC - isValidData() called / data: \(data), flag: \(flag)")
        
        guard data != "" else { return false }
        let pred : NSPredicate
        
        switch flag {
        case "couponName":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.CTUDYNAME_REGEX)
        case "endDate":
            pred = NSPredicate(format: "SELF MATCHES %@", REGEX.DATE_REGEX)
        default:
            pred = NSPredicate(format: "SELF MATCHES %@", "")
        }
        
        return pred.evaluate(with: data)
    }
    
    // 쿠폰 수신자 imageView event
    fileprivate func onReciverImageClicked() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddCouponReciverVC") as? AddCouponReciverVC else { return }
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .automatic
        controller.members = members
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    // 쿠폰 imageView event
    fileprivate func onCouponImageClicked() {
        actionSheetAlert()
    }
    
    fileprivate func actionSheetAlert() {
        let alert = UIAlertController(title: "쿠폰 이미지 설정", message: nil, preferredStyle: .actionSheet)
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
        self.couponImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: self.couponImg.bounds.height / 5, weight: .regular, scale: .large))
        self.couponImg.contentMode = .center
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
    
    // 쿠폰등록 button event
    @objc fileprivate func onCreateBtnClicked() {
        
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.postCreateCoupon(name: couponName.text!, roomId: roomId, receiverId: selectedReceiver.id, startDate: startDate!, endData: endDate.text!, image: imageFlag ? self.couponImg.image?.pngData() : nil, completion: { [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(_):
                self.view.makeToast("쿠폰이 등록되었습니다.", duration: 1.0, position: .center)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
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
        
        self.couponImg.contentMode = .scaleAspectFill
        self.couponImg.image = newImage
        self.imageFlag = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func customOverlayView() -> UIView {
        let overlayView = UIView()
        overlayView.frame = self.couponImg.frame
        return overlayView
    }
    
    // MARK: - UIDatePicker func
    fileprivate func actionDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onDoneBtnClicked))
        toolbar.setItems([doneButton], animated: false)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        datePicker.datePickerMode = .date
        
        endDate.inputAccessoryView = toolbar
        endDate.inputView = datePicker
        
        textFieldCheck(textField: endDate, msgLabel: endDateMsg, inputData: endDate.text ?? "")
    }
    
    @objc func onDoneBtnClicked() {
        print("CreateCouponVC - onDoneBtnClicked() / endDate: \(datePicker.date)")
        endDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        textFieldCheck(textField: endDate, msgLabel: endDateMsg, inputData: endDate.text ?? "")
    }
    
    // textField 변경할 때 event
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        //        print("CreateCouponVC - textFieldEditingChanged() called / sender.text: \(sender.text)")
        switch textField {
        case couponName:
            // 이름 형식 체크 (모든 문자 1글자 이상, 공백만 X)
            textFieldCheck(textField: textField, msgLabel: couponNameMsg, inputData: couponName.text ?? "" )
        case endDate:
            // 날짜 형식 체크 (yyyy-MM-dd)
            textFieldCheck(textField: textField, msgLabel: endDateMsg, inputData: endDate.text ?? "")
        default:
            break
        }
        
        //        createBtnAbleChecked()
    }
    
    // MARK: - protocol delegate
    func onMemberViewClicked(receiver: CouponReciverRequest) {
        self.selectedReceiver = receiver
        
        // reciver를 선택했을때
        if selectedReceiver.image != "" {
            self.receiverImg.kf.setImage(with: URL(string: API.IMAGE_URL + selectedReceiver.image)!)
        } else {
            self.receiverImg.image = UIImage(named: "user_default.png")
        }
        self.receiverImg.contentMode = .scaleAspectFill
        self.receiverName.text = selectedReceiver.name
        self.receiverUsername.text = "@\(selectedReceiver.username)"
        self.receiverUsername.textColor = COLOR.SUBTITLE_COLOR
        
        createBtnAbleChecked()
    }
    
    // MARK: - textField delegate
    // textField에서 enter키 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        print("CreateCouponVC - textFieldShouldReturn() called")
        switch textField {
        case couponName:
            // 이름 형식 체크 (모든 문자 1글자 이상, 공백만 X)
            textFieldCheck(textField: textField, msgLabel: couponNameMsg, inputData: couponName.text ?? "" )
        case endDate:
            // 날짜 형식 체크 (yyyy-MM-dd)
            textFieldCheck(textField: textField, msgLabel: endDateMsg, inputData: endDate.text ?? "")
        default:
            break
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldCheck(textField: UITextField, msgLabel: UILabel, inputData: String) {
        print("CreateCouponVC - textFieldCheck() called / msgLabel: \(msgLabel), inputData: \(inputData)")
        
        guard inputData != "" else {
            msgLabel.text = ""
            return
        }
        
        switch textField {
        case couponName:
            nameOKFlag = isValidData(flag: "couponName", data: inputData)
            if nameOKFlag {
                setMsgLabel(flag: nameOKFlag, msgLabel: msgLabel, msgString: "")
            } else {
                setMsgLabel(flag: nameOKFlag, msgLabel: msgLabel, msgString: "이름이 옳바르지 않습니다. (공백X)")
            }
        case endDate:
            dateOKFlag = isValidData(flag: "endDate", data: inputData)
            if dateOKFlag {
                setMsgLabel(flag: dateOKFlag, msgLabel: msgLabel, msgString: "")
            } else {
                setMsgLabel(flag: dateOKFlag, msgLabel: msgLabel, msgString: "일자가 옳바르지 않습니다. (yyyy-MM-dd)")
            }
        default:
            break
        }
        
        createBtnAbleChecked()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case couponName:
            nameOKFlag = false
        case endDate:
            dateOKFlag = false
        default:
            break
        }
        
        createBtnAbleChecked()
        return true
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: receiverImg) == true {
            view.endEditing(true)
            onReciverImageClicked()
            return true
        } else if touch.view?.isDescendant(of: endDate) == true {
            view.endEditing(true)
            actionDatePicker()
            return true
        } else if touch.view?.isDescendant(of: couponImg) == true {
            view.endEditing(true)
            onCouponImageClicked()
            return true
        } else if touch.view?.isDescendant(of: couponName) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}
