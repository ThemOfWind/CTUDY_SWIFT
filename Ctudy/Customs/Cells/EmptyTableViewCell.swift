//
//  EmptyViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/06/25.
//

import Foundation
import UIKit

class EmptyTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // title
        titleLabel.textColor = COLOR.TITLE_COLOR
        
        // subtitle
        subtitleLabel.textColor = COLOR.SUBTITLE_COLOR
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "EmptyTableViewCell", bundle: Bundle(for: EmptyTableViewCell.self))
    }
    
    // cell간 간격 띄우기 (수정해야돼)
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}

