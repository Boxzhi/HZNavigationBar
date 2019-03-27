//
//  UITabBarController_Extension.swift
//  HZNavigationBar_Example
//
//  Created by 何志志 on 2019/3/27.
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
