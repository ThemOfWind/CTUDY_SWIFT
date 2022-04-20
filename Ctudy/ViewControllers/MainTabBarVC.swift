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
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // tabBarButton ui
        self.tabBar.tintColor = COLOR.SIGNATURE_COLOR
        
        // navigationBar reset
        navigationBarReset()
        
        // navigationBar title item
        self.navigationItem.title = "스터디룸"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        // navigationBar right item
        self.addBtn.addTarget(self, action: #selector(onAddBtnClicked(sender:)), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: addBtn), animated: true)
        
        // delegate
        self.delegate = self
    }
    
    fileprivate func navigationBarReset() {
        // navigationBar setting
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        // navigationBar left item
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - action func
    // navigationBar item customBtn event
    @objc func onAddBtnClicked(sender: UIButton) {
        performSegue(withIdentifier: "AddStudyNameVC", sender: nil)
    }
    
    @IBAction func unwindMainTabBarVC(_ segue: UIStoryboardSegue) {}
    
    // MARK: - tabBar delegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is MainVC {
//            navigationBarReset()
            self.navigationItem.title = "스터디룸"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: addBtn), animated: true)
        }
        else {
            if self.navigationItem.rightBarButtonItem != nil {
//                navigationBarReset()
                self.navigationItem.title = ""
//                self.navigationController?.navigationBar.prefersLargeTitles = false
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
}
