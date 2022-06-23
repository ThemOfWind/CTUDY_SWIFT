//
//  CouponAlert.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/23.
//

import Foundation
import UIKit

class CouponDetailVC: UIViewController {
    // MARK: - 변수
    @IBOutlet weak var couponName: UILabel!
    @IBOutlet weak var recieverName: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var couponImg: UIImageView!
    var coupon: CouponResponse!
    
    // view load func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        config()
    }
    
    fileprivate func config() {
        // label
        couponName.text = coupon.name
        recieverName.text = coupon.rname
        endDate.text = coupon.enddate
       
        // coupon image
        couponImg.layer.cornerRadius = 10
        couponImg.layer.borderWidth = 1
        couponImg.layer.borderColor = COLOR.BASIC_BACKGROUD_COLOR.cgColor
        couponImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        couponImg.tintColor = COLOR.BASIC_TINT_COLOR
        couponImg.contentMode = .scaleAspectFill
        couponImg.translatesAutoresizingMaskIntoConstraints = false
        if coupon.image != "" {
            couponImg.kf.setImage(with: URL(string: API.IMAGE_URL + coupon.image)!)
        } else {
            couponImg.image = UIImage(named: "study_default.png")
        }
        
        // text label
        label1.textColor = COLOR.TITLE_COLOR
        label2.textColor = COLOR.TITLE_COLOR
        label3.textColor = COLOR.TITLE_COLOR
    }
}
