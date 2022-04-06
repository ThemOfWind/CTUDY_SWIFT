//
//  NaviBar.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/29.
//

import Foundation
import UIKit

class NaviBar: UINavigationBar {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // backItem 설정
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = COLOR.SIGNATURE_COLOR
        self.backItem?.backBarButtonItem = backItem
    }
    
    func setRightBtnItem(used: Bool, for btnItem: UIBarButtonItem...) {
        if used {
            if var list = self.backItem?.rightBarButtonItems {
                for item : UIBarButtonItem in btnItem {
                    list.append(item)
                }
                self.backItem?.rightBarButtonItems = list
            }
        } else {
            let list = backItem?.rightBarButtonItems?.dropLast()
            self.backItem?.rightBarButtonItems = Array(list!)
        }
    }
    
    func setLeftBtnItem(isHideleftBtn: Bool, text: String) {
        self.backItem?.hidesBackButton = isHideleftBtn
        self.backItem?.title = text
    }
    
    //    fileprivate func config() {
    ////        let nav = self.navigationController?.navigationBar
    ////        nav?.barTintColor = COLOR.SIGNATURE_COLOR
    ////        nav?.backItem?.title = ""
    //        let backItem = UIBarButtonItem()
    //        backItem.title = "뒤로"
    //        backItem.tintColor = COLOR.SIGNATURE_COLOR
    //        self.navigationItem.backBarButtonItem = backItem
    //    }
    //
}

