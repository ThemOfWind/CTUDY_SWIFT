//
//  NavigationVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/24.
//

import Foundation
import UIKit

class BasicVC: UIViewController {
    enum LeftItem {
        case none // nil
        case backSystemDefault //
        case backGeneral // backBtn
        case backCustom(image: UIImage?, title: String?, leftSpaceCloseToDefault: Bool) // custom backBtn
        case backFn(visibilityFn:(() -> Bool), backFn:(() -> ())) // backItem func
        case backCustomFn(image: UIImage?, title: String?, leftSpaceCloseToDefault: Bool, visibilityFn:(() -> Bool), backFn:(() -> ())) // custom backItem func
        case customView(view: UIView)
    }
    
    // leftItem 생성
    var leftItem: LeftItem = LeftItem.backGeneral {
        didSet {
            self.updateNavigationBarUI()
        }
    }
    // leftItem Image
    lazy var backButtonImage = UIImage(systemName: "chevron.backward")
    
    // MARK: - func
    func navigationControllerPop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // empty leftItem action
    func createEmptyButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    //
    func createCustomBackButton(image: UIImage?, title: String?, leftSpaceCloseToDefault: Bool, backFn: @escaping (() -> ())) -> [UIBarButtonItem] {
        var arr: [UIBarButtonItem] = []
        
        if leftSpaceCloseToDefault {
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -8
            arr.append(negativeSpacer)
        }
        
        if let image = image, let title = title {
            let button = LeftBarButtonItem(image: image, title: title, actionHandler: backFn)
            arr.append(button)
        } else {
            if let image = image {
                let imageButton = LeftBarButtonItem(image: image, actionHandler: backFn)
                imageButton.title = title
                arr.append(imageButton)
            }
            if let title = title {
                let titleButton = LeftBarButtonItem(title: title, actionHandler: backFn)
                arr.append(titleButton)
            }
        }
        
        return arr
    }
    
    func createBackButtonGeneral() -> [UIBarButtonItem] {
        return createCustomBackButton(image: backButtonImage, title: nil, leftSpaceCloseToDefault: true, backFn: navigationControllerPop)
    }
    
    func createBackButtonWithFn(backFn: @escaping (() -> ())) -> [UIBarButtonItem] {
        return createCustomBackButton(image: backButtonImage, title: nil, leftSpaceCloseToDefault: true, backFn: backFn)
    }
    
    // btn setting
    func updateNavigationBarUI() {
        print("BasicVC - updateNavigationBarUI() called")
        
        self.navigationItem.backBarButtonItem = createEmptyButton()
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.hidesBackButton = true
        
        switch self.leftItem {
        case .none:
            break
        case .backSystemDefault:
            self.navigationItem.backBarButtonItem = nil
            self.navigationItem.hidesBackButton = false
        case .backGeneral:
            if (self.navigationController?.viewControllers.count ?? 0 > 1) {
                self.navigationItem.leftBarButtonItems = createBackButtonGeneral()
            }
        case .backFn(visibilityFn: let visibilityFn, backFn: let backFn):
            if (visibilityFn()) {
                self.navigationItem.leftBarButtonItems = createBackButtonWithFn(backFn: backFn)
            }
        case .backCustom(image: let image, title: let title, leftSpaceCloseToDefault: let leftSpaceCloseToDefault):
            if (self.navigationController?.viewControllers.count ?? 0 > 1) {
                self.navigationItem.leftBarButtonItems = createCustomBackButton(image: image, title: title, leftSpaceCloseToDefault: leftSpaceCloseToDefault, backFn: navigationControllerPop)
            }
        case .customView(view: let view):
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateNavigationBarUI()
    }
}
