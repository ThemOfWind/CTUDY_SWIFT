//
//  NaviBarItem.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/29.
//

protocol NaviBarItemDelegate: AnyObject {
    // 위임해줄 기능
    func btnItemAction(btn: UIButton)
}

import Foundation
import UIKit

class NaviBarItem: UIBarButtonItem {
    var leftBtn: UIBarButtonItem? {
        let backBtn = UIButton()
        backBtn.setTitle("", for: .normal)
        backBtn.tintColor = COLOR.SIGNATURE_COLOR
        backBtn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.addTarget(self, action: #selector(onLeftBtnClicked(_:)), for: .touchUpInside)
        let view = UIView()
        view.addSubview(backBtn)
        return type(of: self).init(customView: view)
    }
    
    var addBtn: UIBarButtonItem? {
        let addBtn = UIButton()
        addBtn.setTitle("", for: .normal)
        addBtn.tintColor = COLOR.SIGNATURE_COLOR
        addBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        addBtn.addTarget(self, action: #selector(onLeftBtnClicked(_:)), for: .touchUpInside)
        let view = UIView()
        view.addSubview(addBtn)
        return type(of: self).init(customView: view)
    }
    
    var itemDelegate: NaviBarItemDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc fileprivate func onLeftBtnClicked(_ sender: UIButton) {
        print("backBtn click!!")
        
        itemDelegate?.btnItemAction(btn: sender)
    }
    
    @objc fileprivate func onCustomBtnClicked(_ sender: UIButton) {
        itemDelegate?.btnItemAction(btn: sender)
    }
    
    
    
//    override var navigationController: UINavigationController? {
//            self.navigationController?.navigationBar.tintColor = UIColor(red: 180/255, green: 125/255, blue: 200/255, alpha: 1)
//            self.navigationController?.navigationBar.topItem?.title = ""
//
//            return self.navigationController
//        }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        self.config()
//    }
//
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
//    func setRightBtnItem(used: Bool, for btnItem: UIBarButtonItem...) {
//        self.isNavigationBarHidden = false
//
//        if used {
//            if var list = navigationItem.rightBarButtonItems {
//                for item : UIBarButtonItem in btnItem {
//                    list.append(item)
//                }
//                self.navigationItem.rightBarButtonItems = list
//            }
//        } else {
//            let list = navigationItem.rightBarButtonItems?.dropLast()
//            self.navigationItem.rightBarButtonItems = Array(list!)
//        }
//    }
//
//    func setLeftBtnItem(isHideleftBtn: Bool, text: String) {
//        self.navigationItem.hidesBackButton = isHideleftBtn
//        self.navigationItem.backButtonTitle = text
//    }
}
