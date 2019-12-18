//
//  UIColor_Extension.swift
//  HZNavigationBar_Example
//
//  Created by 何志志 on 2019/7/9.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    override open var shouldAutorotate: Bool {
        return (self.selectedViewController?.shouldAutorotate)!
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.selectedViewController?.supportedInterfaceOrientations)!
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return (self.selectedViewController?.preferredInterfaceOrientationForPresentation)!
    }
    
}

extension UIColor {
    
    public static func random(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
    
}

extension CGFloat {
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
}

extension UIButton {
    
    class func setJumpButton(_ target: Any?, action: Selector) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: (UIScreen.main.bounds.size.width - 100) / 2, y: UIScreen.main.bounds.size.height / 2, width: 100, height: 50)
        btn.backgroundColor = .gray
        btn.setTitle("跳转", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
    
}
