//
//  MainTabBarVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/28.
//

import Foundation
import UIKit

class MainTabBarVC: UITabBarController, UITabBarControllerDelegate {
    // MARK: - 변수
    let addBtn: UIButton = {
        var Btn = (UINib(nibName: "AddBarButtonItem", bundle: nil).instantiate(withOwner: MainTabBarVC.self, options: nil).first as! UIButton)
        return Btn
    }()
    let settingBtn: UIButton = {
        var Btn = (UINib(nibName: "SettingBarButtonItem", bundle: nil).instantiate(withOwner: MainTabBarVC.self, options: nil).first as! UIButton)
        return Btn
    }()
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // proxy객체 사용 : for문으로 접근하지 않아도 가능
        // 탭바 아이템에 일일이 할 필요 없이, 일괄적 적용
        let tabBarItemProxy = UITabBarItem.appearance()
//        tabBarItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:COLOR.SIGNATURE_COLOR], for: .selected)
//        tabBarItemProxy.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:COLOR.DISABLE_COLOR], for: .disabled)
        tabBarItemProxy.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        
        // tabBar ui
        self.tabBar.tintColor = COLOR.SIGNATURE_COLOR
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = true // 큰 이미지 자르기: 이미지가 tabBar보다 큰 경우 밖으로 튀어나옴
        self.tabBar.barTintColor = .white
        self.tabBar.standardAppearance.backgroundColor = .white
        self.tabBar.standardAppearance.shadowColor = .white
        
        // navigationBar reset
        self.navigationItem.hidesBackButton = true
        
        // navigationBar title item
        self.navigationItem.title = "스터디룸"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    
        // navigationBar right item
        self.addBtn.addTarget(self, action: #selector(onAddBtnClicked(sender:)), for: .touchUpInside)
        self.settingBtn.addTarget(self, action: #selector(onSettingBtnClicked(sender:)), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: addBtn), animated: true)
        
        // delegate
        self.delegate = self
    }
    
    //    fileprivate func navigationBarReset() {
    //        // navigationBar setting
    //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    //        // navigationBar left item
    //        self.navigationItem.leftBarButtonItem = nil
    //        self.navigationItem.hidesBackButton = true
    //    }
    
    // MARK: - action func
    // navigationBar item customBtn event
    @objc func onAddBtnClicked(sender: UIButton) {
        performSegue(withIdentifier: "RegisterStudyRoomFirstVC", sender: nil)
    }
    
    @objc func onSettingBtnClicked(sender: UIButton) {
        performSegue(withIdentifier: "SettingVC", sender: nil)
    }
    
    @IBAction func unwindMainTabBarVC(_ segue: UIStoryboardSegue) {}
    
    // MARK: - tabBar delegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is MainVC {
            self.navigationItem.title = nil
            self.navigationController?.navigationBar.topItem?.title = "스터디룸"
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: addBtn), animated: true)
        } else if viewController is ProfileVC {
            self.navigationController?.navigationBar.sizeToFit() // UIKit에 포함된 특정 View를 자체 내부 요구의 사이즈로 resize 해주는 함수
            self.navigationItem.title = nil
            self.navigationController?.navigationBar.topItem?.title = "프로필"
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: settingBtn), animated: true)
        }
    }
}
