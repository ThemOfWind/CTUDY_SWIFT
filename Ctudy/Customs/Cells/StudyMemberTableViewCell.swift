//
//  StudyMemberTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/04/15.
//

import Foundation
import UIKit

class StudyMemberTableViewCell: UITableViewCell {
    @IBOutlet weak var memberImg: UIImageView!
    @IBOutlet weak var member: UILabel!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var couponCnt: UILabel!
//    var isEnableCouponCnt: Bool = false {
//        didSet {
//            if isEnableCouponCnt {
//                // 쿠폰 표시 on
//                self.couponCnt.textColor = COLOR.SIGNATURE_COLOR
//                self.couponCnt.text = "쿠폰 00"
//                // 쿠폰 표시 off
//                self.couponCnt.textColor = .clear
//                self.couponCnt.text = ""
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // image
        self.memberImg.layer.cornerRadius = self.memberImg.bounds.height / 3
        self.memberImg.layer.borderWidth = 1
        self.memberImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        self.memberImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        self.memberImg.tintColor = COLOR.BASIC_TINT_COLOR
        self.memberImg.image = UIImage(named: "user_default.png")
        self.memberImg.contentMode = .scaleAspectFill
        self.memberImg.translatesAutoresizingMaskIntoConstraints = false
        self.couponCnt.textColor = COLOR.SIGNATURE_COLOR
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    

}
