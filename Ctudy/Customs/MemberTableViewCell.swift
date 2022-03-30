//
//  MemberTableViewCell.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/23.
//

import Foundation
import UIKit

//// 범용성을 위해 class가 아닌 Anyobject로 선언
//protocol MemberCellToBtnActionDelegate: AnyObject {
//    // 위임해줄 기능
//    func CellToBtnAction(btn: UIButton, index: Int, checked: Bool)
//}

class MemberTableViewCell : UITableViewCell {
    
    @IBOutlet weak var memberImg: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var member: UILabel!
    @IBOutlet weak var checkBtn: MemberCheckButton!
    
//    //delegate(위임자) 생성
//    var cellDelegate: MemberCellToBtnActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("MemeberTableViewCell - awakeFromNib() called")
        //self.checkBtn.awakeFromNib()
    }
    
    // cell간 간격 띄우기 (수정해야돼)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
//    // cell click event
//    @objc private func onCheckBtnClicked(sender: UIButton) {
//        print("MemberTableViewCell - onCheckBtnClicked() called / sender.tag: \(sender.tag)")
//
////        cellDelegate?.CellToBtnAction(btn: sender, index: sender.tag, checked: checked)
//
//        // check off 상태일때
//        if !checked {
//            checked = true
//            sender.setTitle("", for: .normal)
//            sender.setTitleColor(.white, for: .normal)
//            sender.setImage(UIImage(named: "checkmark"), for: .normal)
//            sender.setBackgroundColor(.brown, for: .normal)
//            //            sender.setBackgroundColor(UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1), for: .normal)
//        }
//        // check on 상태일때
//        else {
//            checked = false
//            sender.setTitle("초대", for: .normal)
//            sender.setTitleColor(UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1), for: .normal)
//            sender.setImage(nil, for: .normal)
//            sender.setBackgroundColor(.white, for: .normal)
//        }
//    }
}
