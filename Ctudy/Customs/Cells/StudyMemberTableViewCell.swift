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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.couponCnt.textColor = COLOR.SIGNATURE_COLOR
        self.couponCnt.text = "쿠폰 "
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
