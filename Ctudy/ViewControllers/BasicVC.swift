//
//  NavigationVC.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/24.
//

import Foundation
import UIKit
import CoreMedia

class BasicVC: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
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
        case titleGeneral(title: String?, isLargeTitles: Bool)
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
        case setting
    }
    
    // leftItem 생성
    var leftItem: LeftItem = LeftItem.none {
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
    lazy var backButtonImage = UIImage(systemName: "arrow.left")
    
    // rightItem image (추가, 사진, 설정)
    lazy var anyButtonImages: Array = [UIImage(systemName: "plus"), UIImage(systemName: "camera"), UIImage(systemName: "gearshape")]
    
    // navigationController pop event
    func navigationControllerPop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // empty leftItem event
    func createEmptyButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    // anyItem click event
    func anyItemAction(sender: UIBarButtonItem) {
        // custom action event
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
    func createCustomAnyButton(items: [Items]?, title: String?, rightSpaceCloseToDefault: Bool, anyFn: @escaping ((UIBarButtonItem) -> ())) -> [UIBarButtonItem] {
        var arr: [UIBarButtonItem] = []
        
        if let list = items {
            for item: Items in list {
                switch item {
                case .plus:
                    if let title = title {
                        let button = BarButtonItem(image: anyButtonImages[0], title: title, actionHandler: anyFn)
                        arr.append(button)
                    } else {
                        let button = BarButtonItem(image: anyButtonImages[0], actionHandler: anyFn)
                        arr.append(button)
                    }
                case .camera:
                    if let title = title {
                        let button = BarButtonItem(image: anyButtonImages[1], title: title, actionHandler: anyFn)
                        arr.append(button)
                    } else {
                        let button = BarButtonItem(image: anyButtonImages[1], actionHandler: anyFn)
                        button.title = title
                        arr.append(button)
                    }
                case .setting:
                    if let title = title {
                        let button = BarButtonItem(image: anyButtonImages[2], title: title, actionHandler: anyFn)
                        button.title = title
                        arr.append(button)
                    } else {
                        let button = BarButtonItem(image: anyButtonImages[2], actionHandler: anyFn)
                        button.title = title
                        arr.append(button)
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
    func createAnyButtons(items: [Items]?, title: String?, rightSpaceCloseToDefault: Bool, anyFn: @escaping ((UIBarButtonItem) -> ())) -> [UIBarButtonItem] {
        return createCustomAnyButton(items: items, title: title, rightSpaceCloseToDefault: rightSpaceCloseToDefault, anyFn: anyFn)
    }
    // MARK: - init func
    // leftItem setting
    func updateNavigationBarLeftUI() {
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
        case .titleGeneral(title: let title, isLargeTitles: let isLargeTitles):
            if (self.navigationController?.viewControllers.count ?? 0 > 1) {
                self.navigationController?.navigationBar.prefersLargeTitles = isLargeTitles
                self.navigationItem.largeTitleDisplayMode = .always
                self.navigationItem.title = title
            }
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
                self.navigationItem.setRightBarButtonItems(createAnyButtons(items: items, title: title, rightSpaceCloseToDefault: rightSpaceCloseToDefault, anyFn: anyItemAction(sender:)), animated: true)
                //                self.navigationItem.setRightBarButtonItems(createAnyButtons(items: items, title: title, rightSpaceCloseToDefault: rightSpaceCloseToDefault, anyFn: AnyItemAction(sender: items ?? [])), animated: true)
                //                self.navigationItem.rightBarButtonItems = createAnyButtons(items: items, title: title, rightSpaceCloseToDefault: rightSpaceCloseToDefault, anyFn: AnyItemAction(sender:))
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
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    fileprivate func reset() {
        self.navigationController?.navigationBar.sizeToFit() // UIKit에 포함된 특정 View를 자체 내부 요구의 사이즈로 resize 해주는 함수
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backBarButtonItem = createEmptyButton()
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = nil
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK :  Navigation Stack에 쌓인 뷰가 1개를 초과하고 leftItem이 .none이 아닌 경우 제스처가 동작
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        var enable = (self.navigationController?.viewControllers.count ?? 0 > 0)
        var enable: Bool = false
        switch leftItem {
        case .none:
            enable = false
        default:
            enable = true
        }
          
        return enable
    }
    
}
