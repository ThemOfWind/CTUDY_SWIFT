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
}
