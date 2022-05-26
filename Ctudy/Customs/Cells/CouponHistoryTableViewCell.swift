//
//  CouponHistoryTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/24.
//

import Foundation
import UIKit

class CouponHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var couponSender: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var couponReciver: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // arrow image
        self.arrowImg.image = UIImage(named: "arrow.png")
        self.arrowImg.contentMode = .scaleAspectFit
        self.arrowImg.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // cell간 간격 띄우기 (수정해야돼)
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
