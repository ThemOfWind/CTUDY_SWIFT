//
//  AddBarBtnItem.swift
//  Ctudy
//
//  Created by 김지은 on 2022/03/30.
//

import Foundation
import UIKit

class BarButtonItem: UIBarButtonItem {
    private var leftActionHandler: (() -> ())?
    private var rightActionHandler: (([UIBarButtonItem]) -> ())?
    
    // MARK: - leftBarButtnoItem
    convenience init(title: String?, actionHandler: (() -> ())?) {
        self.init(title: title, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.tintColor = COLOR.SIGNATURE_COLOR
        self.target = self
        self.action = #selector(leftBarButtonItemPressed(sender:))
        self.leftActionHandler = actionHandler
    }
    
    convenience init(image: UIImage?, actionHandler: (() -> ())?) {
        self.init(image: image, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.tintColor = COLOR.SIGNATURE_COLOR
        self.target = self
        self.action = #selector(leftBarButtonItemPressed(sender:))
        self.leftActionHandler = actionHandler
    }
        
    convenience init(image: UIImage?, title: String?, actionHandler: (() -> ())?) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 31))
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 31))
        button.tintColor = COLOR.SIGNATURE_COLOR
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tintColor = UINavigationBar.appearance().tintColor
        
        let label = UIButton(frame: CGRect(x: 20, y: 0, width: 80, height: 31))
        label.tintColor = COLOR.SIGNATURE_COLOR
        label.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.setTitle(title, for: .normal)
        label.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        label.isUserInteractionEnabled = false
        label.setTitleColor(UINavigationBar.appearance().tintColor, for: .normal)
        
        button.addSubview(label)
        view.addSubview(button)
        self.init(customView: view)
        
        button.addTarget(self, action: #selector(leftBarButtonItemPressed(sender:)), for: .touchUpInside)
        self.leftActionHandler = actionHandler
    }
    
    // MARK: - rightBarButtonItem
    convenience init(image: UIImage?, actionHandler: (([UIBarButtonItem]) -> ())?) {
        self.init(image: image, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.tintColor = COLOR.SIGNATURE_COLOR
        self.target = self
        self.action = #selector(rightBarButtonItemPressed(sender:))
        self.rightActionHandler = actionHandler
    }
    
    convenience init(image: UIImage?, title: String?, actionHandler: (([UIBarButtonItem]) -> ())?) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 31))
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 31))
        button.tintColor = COLOR.SIGNATURE_COLOR
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tintColor = UINavigationBar.appearance().tintColor
        
        let label = UIButton(frame: CGRect(x: 20, y: 0, width: 80, height: 31))
        label.tintColor = COLOR.SIGNATURE_COLOR
        label.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.setTitle(title, for: .normal)
        label.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        label.isUserInteractionEnabled = false
        label.setTitleColor(UINavigationBar.appearance().tintColor, for: .normal)
        
        button.addSubview(label)
        view.addSubview(button)
        self.init(customView: view)
        
        button.addTarget(self, action: #selector(rightBarButtonItemPressed(sender:)), for: .touchUpInside)
        self.rightActionHandler = actionHandler
    }
    
    @objc func leftBarButtonItemPressed(sender: UIBarButtonItem) {
        if let actionHandler = self.leftActionHandler {
            actionHandler()
        }
    }
    
    @objc func rightBarButtonItemPressed(sender: [UIBarButtonItem]) {
        if let actionHandler = self.rightActionHandler {
            actionHandler(sender)
        }
    }
}
