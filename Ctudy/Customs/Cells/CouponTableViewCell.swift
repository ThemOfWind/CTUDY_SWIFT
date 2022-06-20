//
//  CouponTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/20.
//

import Foundation
import UIKit

class CouponTableViewCell: UITableViewCell {
    @IBOutlet weak var couponName: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var couponImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // image
        couponImg.image = UIImage(systemName: "tag.fill")
        couponImg.tintColor = COLOR.SIGNATURE_COLOR
        
        // ui
        senderUsername.textColor = COLOR.SUBTITLE_COLOR
    }
    
    // cell간 간격 띄우기 (수정해야돼)
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
