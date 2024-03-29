//
//  MemberTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation
import UIKit

class MemberTableViewCell : UITableViewCell {
    // MARK: - 변수
    @IBOutlet weak var memberImg: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var member: UILabel!
    @IBOutlet weak var checkBtn: MemberCheckButton!
    
    // MARK: - view load func
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
    }
    
    // cell간 간격 띄우기
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
