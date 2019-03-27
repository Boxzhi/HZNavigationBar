//
//  UINavigationController.swift
//  HZNavigationBar_Example
//
//  Created by 何志志 on 2019/3/27.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var shouldAutorotate: Bool {
        return (self.topViewController?.shouldAutorotate)!
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.topViewController?.supportedInterfaceOrientations)!
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return (self.topViewController?.preferredInterfaceOrientationForPresentation)!
    }
    
}
