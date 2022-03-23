//
//  MainTabBarVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/28.
//

import Foundation
import UIKit

class MainTabBarVC : UITabBarController, UITabBarControllerDelegate {
    public var addBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationItem.hidesBackButton = true
        
        guard let Btn = (UINib(nibName: "AddBarButtonItem", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIButton) else { return }
        self.addBtn = Btn
        self.addBtn.addTarget(self, action: #selector(onAddBtnClicked(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: addBtn), animated: true)
    }
    
    @objc func onAddBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "AddStudyNameVC", sender: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is MainVC {
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: addBtn), animated: true)
        }
        else
        {
            if self.navigationItem.rightBarButtonItem != nil {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
}
