//
//  AgreementTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/07/19.
//
import Foundation
import UIKit

class AgreementTableViewCell: UITableViewCell {
    // MARK: - 변수
    @IBOutlet weak var agreementCheckBtn: AgreementCheckButton!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var goToViewBtn: GoToNextViewButton!
    
    // MARK: - view load func
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
