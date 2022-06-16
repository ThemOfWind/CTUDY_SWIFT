//
//  WithdrawVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/13.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class WithdrawVC: BasicVC {
    // MARK: - 변수
    @IBOutlet weak var withdrawImg: UIImageView!
    @IBOutlet weak var withdrawNoti: UILabel!
    @IBOutlet weak var withdrawBtn: UIButton!
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
        config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        leftItem = LeftItem.backGeneral
        titleItem = TitleItem.titleGeneral(title: "회원탈퇴", isLargeTitles: true)
        
        // withdraw image ui
//        withdrawImg.layer.cornerRadius = withdrawImg.bounds.height / 2
        withdrawImg.image = UIImage(systemName: "xmark.circle")
        withdrawImg.tintColor = .red
        
        // withdraw textfield ui
        withdrawNoti.numberOfLines = 0
        withdrawNoti.text = "* 회원탈퇴 시\n* 개인정보 삭제\n* 쿠폰 삭제\n* 스터디룸 삭제\n* 현재 계정으로 재가입 불가"
        
        // withdraw button ui
        withdrawBtn.layer.cornerRadius = 10
        withdrawBtn.tintColor = .white
        withdrawBtn.backgroundColor = COLOR.SIGNATURE_COLOR
        
        // event 연결
        withdrawBtn.addTarget(self, action: #selector(onWithdrawBtnClicked), for: .touchUpInside)
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
    
    // MARK: - @objc func
    @objc fileprivate func onWithdrawBtnClicked() {
        // logout alert 띄우기
        let alert = UIAlertController(title: nil, message: "정말 탈퇴하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (_) in
            
            self.onStartActivityIndicator()
            
            AlamofireManager.shared.deleteWithdraw(completion: {
                [weak self] result in
                guard let self = self else { return }
                
                self.onStopActivityIndicator()
                
                switch result {
                case .success(_):
                    self.performSegue(withIdentifier: "unwindStartVC", sender: self)
                    self.navigationController?.view.makeToast("회원탈퇴가 완료되었습니다.", duration: 1.0, position: .center)
                case .failure(let error):
                    print("WithdrawVC - deleteWithdraw().failure / error: \(error)")
                    self.view.makeToast(error.rawValue, duration: 1.0, position: .center)
                }
            })
            
            if self.indicator.isAnimating {
                self.onStopActivityIndicator()
            }
        }))
        
        self.present(alert, animated: false)
    }
}
