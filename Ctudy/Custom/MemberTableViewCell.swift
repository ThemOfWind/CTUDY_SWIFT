//
//  MemberTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation
import UIKit

class MemberTableViewCell : UITableViewCell {
    
    @IBOutlet weak var memberViewCell: UIView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var member: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
