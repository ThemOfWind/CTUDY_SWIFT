//
//  CouponHistoryVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/24.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftUI

class CouponVC: BasicVC, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    // MARK: - 변수
    @IBOutlet weak var couponTableView: UITableView!
//    let tabGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: RegisterStudyRoomFirstVC.self, action: nil)
    lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        indicatorView.backgroundColor = UIColor.white
        indicatorView.isOpaque = false
        return indicatorView
    }()
    lazy var indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                type: .pacman,
                                                color: COLOR.SIGNATURE_COLOR,
                                                padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    lazy var loading: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "loading..."
        label.textColor = COLOR.SIGNATURE_COLOR
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var coupons = [] as! Array<CouponResponse>
    var roomId: Int!
    
    // MARK: - view load func
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == "CouponHistoryVC" {
            if let controller = segue.destination as? CouponHistoryVC {
                controller.roomId = roomId
            }
        }
    }
    
    fileprivate func config() {
        // navigationbar item 설정
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "내 쿠폰", isLargeTitles: true)
        rightItem = RightItem.anyCustoms(items: [.setting], title: nil, rightSpaceCloseToDefault: true)
        
        // 셀 리소스 파일 가져오기
        let couponCell = UINib(nibName: String(describing: CouponTableViewCell.self), bundle: nil)
        let emptyCell = EmptyTableViewCell.nib()
        
        // 셀 리소스 등록하기
        couponTableView.register(couponCell, forCellReuseIdentifier: "CouponTableViewCell")
        couponTableView.register(emptyCell, forCellReuseIdentifier: "EmptyTableViewCell")
        
        // 셀 설정
        couponTableView.rowHeight = 100
        //        self.couponHistoryTableView.layer.borderWidth = 1
        //        self.couponHistoryTableView.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        
        // delegate 연결
        couponTableView.delegate = self
        couponTableView.dataSource = self
//        self.tabGesture.delegate = self
        
        // gesture 연결
//        self.view.addGestureRecognizer(tabGesture)
        
        // 히스토리 조회
        getSearchCoupon()
    }
    
    // MARK: - indicator in api calling
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
    
    // MARK: - coupon history api
    fileprivate func getSearchCoupon() {
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.getSearchCoupon(id: String(roomId), mode: "r", completion: {
            [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let result):
                self.coupons = result
                self.couponTableView.reloadData()
            case .failure(let error):
                print("CouponVC - getSearchCoupon().failure / error: \(error)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // MARK: - use coupon api
    fileprivate func onUseBtnClicked(couponId: String) {
        // coupon alert 띄우기
        let alert = UIAlertController(title: nil, message: "쿠폰을 사용하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            
            self.onStartActivityIndicator()
            
            AlamofireManager.shared.deleteUseCoupon(id: couponId, completion: {
                [weak self] result in
                guard let self = self else { return }
                
                self.onStopActivityIndicator()
                
                switch result {
                case .success(_):
                    self.getSearchCoupon()
                case .failure(let error):
                    print("CouponVC - deleteUseCoupon().failure / error: \(error)")
                    self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                }
            })
            if self.indicator.isAnimating {
                self.onStopActivityIndicator()
            }
        }))
        
        self.present(alert, animated: false)
    }
    
    override func AnyItemAction(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "CouponHistoryVC", sender: nil)
    }
    
    // MARK: - modal View
    fileprivate func presentModal(index: Int) {
        let couponView = CouponDetailVC()
//        couponView.coupon = coupons[index]
        let naviView = UINavigationController(rootViewController: couponView)
        naviView.modalPresentationStyle = .pageSheet
        
        if let sheet = naviView.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        present(naviView, animated: true, completion: nil)
    }
    
    // MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if coupons.count == 0 {
            return 1
        } else {
            return coupons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if coupons.isEmpty == true {
            let cell = couponTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "아직 선물받은 쿠폰이 없습니다.🥲"
            couponTableView.rowHeight = self.couponTableView.bounds.height
            return cell
        } else {
            let cell = couponTableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as! CouponTableViewCell
            cell.selectionStyle = .none // 선택 block 없애기
            cell.couponName.text = coupons[indexPath.row].name
            if coupons[indexPath.row].simage != "" {
                cell.senderImg.kf.setImage(with: URL(string: API.IMAGE_URL + coupons[indexPath.row].simage)!)
            } else {
                cell.senderImg.image = UIImage(named: "user_default.png")
            }
            cell.senderName.text = coupons[indexPath.row].sname
            cell.senderUsername.text = "@\(coupons[indexPath.row].susername)"
            couponTableView.rowHeight = 100
            return cell
        }
    }
    
    // slide button
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if coupons.isEmpty == true {
            return nil
        } else {
            let use = UIContextualAction(style: .normal, title: "사용하기") {
                (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                print("coupon use click! / indexPath: \(indexPath.row)")
                self.onUseBtnClicked(couponId: String(self.coupons[indexPath.row].id))
                success(true)
            }
            use.backgroundColor = .systemCyan
            use.image = UIImage(systemName: "hand.point.up.left.fill")
            
            return UISwipeActionsConfiguration(actions: [use])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if coupons.isEmpty == true {
            return
        } else {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CouponDetailVC") as? CouponDetailVC else { return }
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = .popover
            controller.coupon = coupons[indexPath.row]
            
            if let sheet = controller.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.largestUndimmedDetentIdentifier = .large
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
}
