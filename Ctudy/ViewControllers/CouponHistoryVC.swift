//
//  CouponHistoryVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class CouponHistoryVC: BasicVC, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 변수
    @IBOutlet weak var couponHistoryTableView: UITableView!
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
    
    fileprivate func config() {
        // navigationbar item 설정
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "히스토리", isLargeTitles: true)
        
        // 셀 리소스 파일 가져오기
        let couponCell = UINib(nibName: String(describing: CouponHistoryTableViewCell.self), bundle: nil)
        let emptyCell = EmptyTableViewCell.nib()
        
        // 셀 리소스 등록하기
        couponHistoryTableView.register(couponCell, forCellReuseIdentifier: "CouponHistoryTableViewCell")
        couponHistoryTableView.register(emptyCell, forCellReuseIdentifier: "EmptyTableViewCell")
        
        // 셀 설정
        couponHistoryTableView.rowHeight = 100
//        couponHistoryTableView.allowsSelection = false
//        self.couponHistoryTableView.layer.borderWidth = 1
//        self.couponHistoryTableView.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        
        // delegate 연결
        couponHistoryTableView.delegate = self
        couponHistoryTableView.dataSource = self
        
        // 히스토리 조회
        getSearchCouponHistory()
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
    fileprivate func getSearchCouponHistory() {
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.getSearchCoupon(id: String(roomId), mode: "r", completion: {
            [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let result):
                self.coupons = result
                self.couponHistoryTableView.reloadData()
            case .failure(let error):
                print("CouponVC - getSearchCoupon().failure / error: \(error)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
    }
    
    // MARK: - search coupon history api
    fileprivate func onUseBtnClicked(couponId: String) {
        self.onStartActivityIndicator()
        
        AlamofireManager.shared.getSearchCoupon(id: String(roomId), mode: nil, completion: {
            [weak self] result in
            guard let self = self else { return }
            
            self.onStopActivityIndicator()
            
            switch result {
            case .success(let result):
                self.coupons = result
                self.couponHistoryTableView.reloadData()
            case .failure(let error):
                print("CouponVC - getSearchCoupon().failure / error: \(error)")
                self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
            }
        })
        
        if self.indicator.isAnimating {
            self.onStopActivityIndicator()
        }
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
            let cell = couponHistoryTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "아직 쿠폰을 주고받은 내역이 없습니다.🥲"
            couponHistoryTableView.rowHeight = self.couponHistoryTableView.bounds.height
            return cell
        } else {
            let cell = couponHistoryTableView.dequeueReusableCell(withIdentifier: "CouponHistoryTableViewCell", for: indexPath) as! CouponHistoryTableViewCell
            cell.selectionStyle = .none // 선택 block 없애기
            // sender
            if coupons[indexPath.row].simage != "" {
                cell.senderImg.kf.setImage(with: URL(string: API.IMAGE_URL + coupons[indexPath.row].simage)!)
            } else {
                cell.senderImg.image = UIImage(named: "user_default.png")
            }
            cell.senderName.text = coupons[indexPath.row].sname
            cell.senderUsername.text = "@\(coupons[indexPath.row].susername)"
            
            // reciever
            if coupons[indexPath.row].rimage != "" {
                cell.recieverImg.kf.setImage(with: URL(string: API.IMAGE_URL + coupons[indexPath.row].rimage)!)
            } else {
                cell.recieverImg.image = UIImage(named: "user_default.png")
            }
            cell.recieverName.text = coupons[indexPath.row].rname
            cell.recieverUsername.text = "@\(coupons[indexPath.row].rusername)"
            couponHistoryTableView.rowHeight = 100
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "CouponDetailVC") as? CouponDetailVC else { return }
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = .pageSheet
        controller.coupon = coupons[indexPath.row]
        
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        self.present(controller, animated: true, completion: nil)
    }
}
