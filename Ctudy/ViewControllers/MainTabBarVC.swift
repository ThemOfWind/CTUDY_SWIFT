//
//  MainTabBarVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/28.
//

import Foundation
import UIKit

class MainTabBarVC : UITabBarController, UITabBarControllerDelegate {
    // MARK: - 변수
    var addBtn : UIButton!
    
    // MARK: - overrid func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    // MARK: - fileprivate func
    fileprivate func config() {
        // tabBarButton ui
        self.tabBar.tintColor = COLOR.SIGNATURE_COLOR
        // navigationBar item
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        guard let Btn = (UINib(nibName: "AddBarButtonItem", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIButton) else { return }
        self.addBtn = Btn
        self.addBtn.addTarget(self, action: #selector(onAddBtnClicked(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: addBtn), animated: true)
        
        // delegate
        self.delegate = self
    }
    
    // MARK: - action func
    // navigationBar item customBtn event
    @objc func onAddBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "AddStudyNameVC", sender: nil)
    }
    
    @IBAction func unwindMainTabBarVC(_ segue: UIStoryboardSegue) {}
    
    // MARK: - tabBar delegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is MainVC {
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: addBtn), animated: true)
        }
        else {
            if self.navigationItem.rightBarButtonItem != nil {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
}
