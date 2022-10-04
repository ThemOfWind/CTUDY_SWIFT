//
//  CouponTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/20.
//

import Foundation
import UIKit

class CouponTableViewCell: UITableViewCell {
    @IBOutlet weak var couponImg: UIImageView!
    @IBOutlet weak var couponName: UILabel!
    @IBOutlet weak var senderImg: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // coupon image
        couponImg.image = UIImage(systemName: "tag.fill")
        couponImg.tintColor = COLOR.SIGNATURE_COLOR
        
        // sender image
        senderImg.layer.cornerRadius = senderImg.bounds.height / 3
        senderImg.layer.borderWidth = 1
        senderImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        senderImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        senderImg.tintColor = COLOR.BASIC_TINT_COLOR
        senderImg.image = UIImage(systemName: "user_default.png")
        senderImg.contentMode = .scaleAspectFill
        senderImg.translatesAutoresizingMaskIntoConstraints = false
        
        // ui
        senderUsername.textColor = COLOR.SUBTITLE_COLOR
    }
    
    // cell간 간격 띄우기 (수정해야돼)
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
