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

class RegisterCouponFirstVC: BasicVC, UIGestureRecognizerDelegate, UINavigationControllerDelegate, CouponSendDelegate {
    
    // MARK: - 변수
    @IBOutlet weak var senderImg: UIImageView!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var receiverImg: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var receiverUsername: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: RegisterCouponFirstVC.self, action: nil)
    var members: Array<SearchStudyMemberResponse>? // 전달받은 멤버 리스트
    var roomId: Int! // 전달받은 studyroom pk
    var selectedReceiver: CouponReciverRequest! // 선택한 쿠폰 수신자
    
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "RegisterCouponSecondVC" {
            if let controller = segue.destination as? RegisterCouponSecondVC {
                controller.roomId = roomId
                controller.selectedReceiver = selectedReceiver
            }
        }
    }

    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "쿠폰 발급", isLargeTitles: true)
        
        // sender image ui
        senderImg.layer.cornerRadius = senderImg.bounds.height / 2
        senderImg.layer.borderWidth = 1
        senderImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        senderImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        senderImg.tintColor = COLOR.BASIC_TINT_COLOR
        if let myImg = KeyChainManager().tokenLoad(API.SERVICEID, account: "image"), myImg != "" {
            senderImg.kf.setImage(with: URL(string: API.IMAGE_URL + myImg)!)
        } else {
            senderImg.image = UIImage(named: "user_default.png")
        }
        senderImg.contentMode = .scaleAspectFill
        senderImg.translatesAutoresizingMaskIntoConstraints = false
        
        // sender label ui
        senderName.text = KeyChainManager().tokenLoad(API.SERVICEID, account: "name")
        senderUsername.text = "@\(KeyChainManager().tokenLoad(API.SERVICEID, account: "username")!)"
        senderUsername.textColor = COLOR.SUBTITLE_COLOR
        
        // arrow image ui
        arrowImg.image = UIImage(named: "arrow.png")
        arrowImg.contentMode = .scaleAspectFit
        arrowImg.translatesAutoresizingMaskIntoConstraints = false
        
        // reciver image ui
        receiverImg.layer.cornerRadius = senderImg.bounds.height / 2
        receiverImg.layer.borderWidth = 1
        receiverImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        receiverImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        receiverImg.tintColor = COLOR.BASIC_TINT_COLOR
        receiverImg.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: receiverImg.bounds.height / 5, weight: .regular, scale: .large))
        receiverImg.contentMode = .center
        receiverImg.isUserInteractionEnabled = true
        
        // button ui
        nextBtn.layer.cornerRadius = 10
        nextBtn.tintColor = .white
        nextBtn.backgroundColor = COLOR.DISABLE_COLOR
        nextBtn.isEnabled = false
        
        // delegate 연결
        tabGesture.delegate = self
        
        // gesture 연결
        self.view.addGestureRecognizer(tabGesture)
    }
    
    // nextButton 활성화 & 비활성화 event
    fileprivate func nextBtnAbleChecked() {
        if selectedReceiver != nil {
            nextBtn.backgroundColor = COLOR.SIGNATURE_COLOR
            nextBtn.isEnabled = true
        } else {
            nextBtn.backgroundColor = COLOR.DISABLE_COLOR
            nextBtn.isEnabled = false
        }
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
        
        nextBtnAbleChecked()
    }
    
    // MARK: - UIGestureRecognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: receiverImg) == true {
            view.endEditing(true)
            onReciverImageClicked()
            return true
        } else {
            view.endEditing(true)
            return true
        }
    }
}
