//
//  BaseTabBarController.swift
//  HZNavigationBar_Example
//
//  Created by 何志志 on 2019/3/8.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .white
        
        
        self.viewControllers = [BaseNavigationController(rootViewController: AViewController()), BaseNavigationController(rootViewController: BViewController())]
        
    }
    
    
    
}
