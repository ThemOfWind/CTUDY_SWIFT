//
//  CouponHistoryVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/24.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class CouponHistoryVC: BasicVC, UITableViewDelegate, UITableViewDataSource {
    // MARK: - 변수
    @IBOutlet weak var couponCount: UILabel!
    @IBOutlet weak var couponHistoryTableView: UITableView!
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
    // MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // navigationbar item 설정
        self.leftItem = LeftItem.backGeneral
        self.titleItem = TitleItem.titleGeneral(title: "히스토리", isLargeTitles: true)
        self.rightItem = RightItem.none
        
        // label ui
        self.couponCount.textColor = COLOR.SIGNATURE_COLOR
        self.couponCount.text = "00"
        
        // 셀 리소스 파일 가져오기
        let couponHistoryCell = UINib(nibName: String(describing: CouponHistoryTableViewCell.self), bundle: nil)
        
        // 셀 리소스 등록하기
        self.couponHistoryTableView.register(couponHistoryCell, forCellReuseIdentifier: "CouponHistoryTableViewCell")
        
        // 셀 설정
        self.couponHistoryTableView.rowHeight = 80
        self.couponHistoryTableView.allowsSelection = false
//        self.couponHistoryTableView.layer.borderWidth = 1
//        self.couponHistoryTableView.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        
        // delegate 연결
        self.couponHistoryTableView.delegate = self
        self.couponHistoryTableView.dataSource = self
        
        // 히스토리 조회
        self.getSearchCouponHistory()
    }
    
    fileprivate func getSearchCouponHistory() {
        
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
    
    // MARK: - delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = couponHistoryTableView.dequeueReusableCell(withIdentifier: "CouponHistoryTableViewCell", for: indexPath) as! CouponHistoryTableViewCell
        
        cell.couponSender.text = "test"
        cell.couponReciver.text = "test"
        return cell
    }
}
