//
//  BaseNavigationController.swift
//  HZNavigationBar_Example
//
//  Created by 何志志 on 2019/3/8.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //    override var shouldAutorotate: Bool {
    //        return self.topViewController!.shouldAutorotate
    //    }
}

extension BaseNavigationController
{
    override func pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
