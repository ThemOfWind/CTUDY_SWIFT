//
//  MainVC.swift
//  Ctudy
//
//  Created by 김지은 on 2021/12/09.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MainVC - viewDidLoad() called")
        
        self.navigationController?.isNavigationBarHidden = true
        
        let tk = TokenManager()
        if let accessToken = tk.tokenLoad(API.SERVICEID, account: "accessToken") {
            print("accessToken: \(accessToken)")
        } else {
            print("accessToken is nil")
        }
    }
}
