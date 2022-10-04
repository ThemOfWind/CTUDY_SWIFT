//
//  SettingTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/10.
//

import Foundation
import UIKit

class SettingTableViewCell: UITableViewCell {
    // MARK: - 변수
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settinglmg: UIImageView!
    
    // MARK: - view load func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settinglmg.tintColor = COLOR.SIGNATURE_COLOR
    }
    
    // cell간 간격 띄우기
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
