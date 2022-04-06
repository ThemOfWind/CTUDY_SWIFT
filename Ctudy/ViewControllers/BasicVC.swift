//
//  NavigationVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/24.
//

protocol NaviBarItemDelegate: AnyObject {
    // 위임해줄 기능
    func rightItemAction(items: [UIBarButtonItem])
}

import Foundation
import UIKit

class BasicVC: UIViewController {
    
    // left navigationBar item
    enum LeftItem {
        case none // nil
        case backSystemDefault // 기본 backItem
        case backGeneral
        case backCustom(image: UIImage?, title: String?, leftSpaceCloseToDefault: Bool) // custom backBtn
        case backFn(visibilityFn:(() -> Bool), backFn:(() -> ())) // backItem func
        case backCustomFn(image: UIImage?, title: String?, leftSpaceCloseToDefault: Bool, visibilityFn:(() -> Bool), backFn:(() -> ())) // custom backItem func
        case customView(view: UIView)
    }
    
    // titleView
    enum TitleItem {
        case none
        case titleGeneral(title: String?)
    }
    
    // right navigationBar item
    enum RightItem {
        case none // nil
        case anyCustoms(items: [Items]?, title: String?, rightSpaceCloseToDefault: Bool)
        case anyFn(visibilityFn:(() -> Bool), anyFn:(() -> ()))
        case anyCustomFn(image: UIImage?, title: String?, rightSpaceCloseToDefault: Bool, visibilityFn:(() -> Bool), anyFn:(() -> ())) // custom anyItem func
        case customView(view: UIView)
    }
    
    // right navigationBar item type
    enum Items {
        case plus
        case camera
    }
    
    // right naviagtionBar item
    var rightItemDelegate: NaviBarItemDelegate?
    
    // leftItem 생성
    var leftItem: LeftItem = LeftItem.backGeneral {
        didSet {
            self.updateNavigationBarLeftUI()
        }
    }
    
    // titleItem 생성
    var titleItem: TitleItem = TitleItem.none {
        didSet {
            self.updateNavigationBarTitleUI()
        }
    }
    
    // rightItem 생성
    var rightItem: RightItem = RightItem.none {
        didSet {
            self.updateNavigationBarRightUI()
        }
    }
    
    // leftItem image
    lazy var backButtonImage = UIImage(systemName: "chevron.backward")
    
    // rightItem image
    lazy var anyButtonImages: Array = [UIImage(systemName: "plus")]
    
    // navigationController pop event
    func navigationControllerPop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // empty leftItem event
    func createEmptyButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    // anyItem click event
    func AnyItemAction(sender: [UIBarButtonItem]) {
        rightItemDelegate?.rightItemAction(items: sender)
    }
    
    // MARK: - leftItem func
    func createCustomBackButton(image: UIImage?, title: String?, leftSpaceCloseToDefault: Bool, backFn: @escaping (() -> ())) -> [UIBarButtonItem] {
        var arr: [UIBarButtonItem] = []
        
        if leftSpaceCloseToDefault {
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -8
            arr.append(negativeSpacer)
        }
        
        if let image = image, let title = title {
            let button = BarButtonItem(image: image, title: title, actionHandler: backFn)
            arr.append(button)
        } else {
            if let image = image {
                let imageButton = BarButtonItem(image: image, actionHandler: backFn)
                imageButton.title = title
                arr.append(imageButton)
            }
            if let title = title {
                let titleButton = BarButtonItem(title: title, actionHandler: backFn)
                arr.append(titleButton)
            }
        }
        
        return arr
    }
    
    // createBackBtn + pop action
    func createBackButtonGeneral(title: String?) -> [UIBarButtonItem] {
        return createCustomBackButton(image: backButtonImage, title: title, leftSpaceCloseToDefault: true, backFn: navigationControllerPop)
    }
    
    // createBackBtn + custom action
    func createBackButtonWithFn(backFn: @escaping (() -> ())) -> [UIBarButtonItem] {
        return createCustomBackButton(image: backButtonImage, title: nil, leftSpaceCloseToDefault: true, backFn: backFn)
    }
    
    // MARK: - rightBtn func
    func createCustomAnyButton(items: [Items]?, title: String?, rightSpaceCloseToDefault: Bool, anyFn: @escaping (([UIBarButtonItem]) -> ())) -> [UIBarButtonItem] {
        var arr: [UIBarButtonItem] = []
    
        if let list = items {
            for item: Items in list {
                if item == Items.plus {
                    if let title = title {
                        let button = BarButtonItem(image: UIImage(systemName: "plus"), title: title, actionHandler: anyFn)
                        arr.append(button)
                    } else {
                        let button = BarButtonItem(image: UIImage(systemName: "plus"), actionHandler: anyFn)
                        arr.append(button)
                    }
                } else if item == Items.camera {
                    if let title = title {
                        let button = BarButtonItem(image: UIImage(systemName: "camera"), title: title, actionHandler: anyFn)
                        arr.append(button)
                    } else {
                        let imageButton = BarButtonItem(image: UIImage(systemName: "camera"), actionHandler: anyFn)
                        imageButton.title = title
                        arr.append(imageButton)
                    }
                }
            }
        }
        
        if rightSpaceCloseToDefault {
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = 30
            arr.append(negativeSpacer)
        }
        
        return arr
    }
    
    // createAnyBtn + custom action
    func createAnyButtons(items: [Items]?, title: String?, rightSpaceCloseToDefault: Bool, anyFn: @escaping (([UIBarButtonItem]) -> ())) -> [UIBarButtonItem] {
        return createCustomAnyButton(items: items, title: title, rightSpaceCloseToDefault: rightSpaceCloseToDefault, anyFn: AnyItemAction(sender:))
    }
    // MARK: - init func
    
    // leftItem setting
    func updateNavigationBarLeftUI() {
        print("BasicVC - updateNavigationBarUI() called")
        
        // leftItem
        switch self.leftItem {
        case .none:
            break
        case .backSystemDefault:
            self.navigationItem.backBarButtonItem = nil
            self.navigationItem.hidesBackButton = false
        case .backGeneral:
            if (self.navigationController?.viewControllers.count ?? 0 > 1) {
                self.navigationItem.leftBarButtonItems = createBackButtonGeneral(title: title)
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
    
    // titleItem setting
    func updateNavigationBarTitleUI() {
        switch self.titleItem {
        case .none:
            break
        case .titleGeneral(title: let title):
            let label = UILabel()
            label.text = title
            label.adjustsFontSizeToFitWidth = true
            self.navigationItem.titleView = label
            self.navigationItem.largeTitleDisplayMode = .always
        default:
            break
        }
    }
    
    // rightItem setting
    func updateNavigationBarRightUI() {
        // rightItem
        switch self.rightItem {
        case .none:
            break
        //case .anyCustoms(items:, title: let title, rightSpaceCloseToDefault: let rightSpaceCloseToDefault):
        case .anyCustoms(items: let items, title: let title, rightSpaceCloseToDefault: let rightSpaceCloseToDefault):
            if (self.navigationController?.viewControllers.count ?? 0 > 1) {
//                self.navigationItem.setRightBarButtonItems(createCustomAnyButton(items: items, title: title, rightSpaceCloseToDefault: rightSpaceCloseToDefault, anyFn: AnyItemAction(sender:)), animated: true)
                self.navigationItem.rightBarButtonItems = createCustomAnyButton(items: items, title: title, rightSpaceCloseToDefault: rightSpaceCloseToDefault, anyFn: AnyItemAction(sender:))
            }
        case .customView(view: let view):
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: view), animated: true)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reset()
        self.updateNavigationBarLeftUI()
        self.updateNavigationBarTitleUI()
        self.updateNavigationBarRightUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reset()
        self.updateNavigationBarLeftUI()
        self.updateNavigationBarTitleUI()
        self.updateNavigationBarRightUI()
    }
    
    fileprivate func reset() {
        self.navigationItem.backBarButtonItem = createEmptyButton()
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.titleView = nil
    }
}
