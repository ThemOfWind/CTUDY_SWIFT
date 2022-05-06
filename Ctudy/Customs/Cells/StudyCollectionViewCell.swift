//
//  StudyCollectionViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/01/06.
//

import Foundation
import UIKit

class StudyCollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet weak var roomStackViewCell: UIStackView!
    @IBOutlet weak var roomImg: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomMasterImg: UIImageView!
    @IBOutlet weak var roomMasterName: UILabel!
    @IBOutlet weak var roomMemberImg: UIImageView!
    @IBOutlet weak var roomMembers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // room Cell
        self.roomStackViewCell.layer.cornerRadius = 10
        self.roomStackViewCell.layer.borderWidth = 1
        self.roomStackViewCell.layer.borderColor = COLOR.SUBTITLE_COLOR.cgColor
        
        // room lmg
        self.roomImg.backgroundColor = COLOR.SUBTITLE_COLOR
        self.roomImg.tintColor = COLOR.DISABLE_COLOR
        self.roomImg.image = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .large))
        self.roomImg.contentMode = .center
        self.roomImg.translatesAutoresizingMaskIntoConstraints = false
        
        // roomName label
        self.roomName.textColor = COLOR.SIGNATURE_COLOR
        
        // roomMaster
        self.roomMasterImg.tintColor = COLOR.SIGNATURE_COLOR
        self.roomMasterName.textColor = COLOR.SIGNATURE_COLOR
        
        // roomMembers
        self.roomMemberImg.tintColor = COLOR.SIGNATURE_COLOR
        self.roomMembers.textColor = COLOR.SIGNATURE_COLOR
    }
}
