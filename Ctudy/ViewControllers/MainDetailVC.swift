//
//  MainDetailVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/21.
//

import Foundation
import UIKit

class MainDetailVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: "", action: nil), animated: true)
    }
}
