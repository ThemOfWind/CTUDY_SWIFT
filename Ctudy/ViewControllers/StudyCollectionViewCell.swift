//
//  StudyCollectionViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/01/06.
//

import Foundation
import UIKit

class StudyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomMasterName: UILabel!
    @IBOutlet weak var roomMembers: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
