//
//  CouponHistoryTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/05/24.
//

import Foundation
import UIKit

class CouponHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var senderImg: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderUsername: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var recieverImg: UIImageView!
    @IBOutlet weak var recieverName: UILabel!
    @IBOutlet weak var recieverUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // sender image
        senderImg.layer.cornerRadius = senderImg.bounds.height / 3
        senderImg.layer.borderWidth = 1
        senderImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        senderImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        senderImg.tintColor = COLOR.BASIC_TINT_COLOR
        senderImg.image = UIImage(named: "user_default.png")
        senderImg.contentMode = .scaleAspectFill
        senderImg.translatesAutoresizingMaskIntoConstraints = false
        
        // arrow image
        arrowImg.image = UIImage(named: "arrow.png")
        arrowImg.contentMode = .scaleAspectFit
        arrowImg.translatesAutoresizingMaskIntoConstraints = false
        
        // reciever image
        recieverImg.layer.cornerRadius = recieverImg.bounds.height / 3
        recieverImg.layer.borderWidth = 1
        recieverImg.layer.borderColor = COLOR.BORDER_COLOR.cgColor
        recieverImg.backgroundColor = COLOR.BASIC_BACKGROUD_COLOR
        recieverImg.tintColor = COLOR.BASIC_TINT_COLOR
        recieverImg.image = UIImage(named: "user_default.png")
        recieverImg.contentMode = .scaleAspectFill
        recieverImg.translatesAutoresizingMaskIntoConstraints = false
        
        // label
        senderUsername.textColor = COLOR.SUBTITLE_COLOR
        recieverUsername.textColor = COLOR.SUBTITLE_COLOR
    }
    
    // cell간 간격 띄우기 (수정해야돼)
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
