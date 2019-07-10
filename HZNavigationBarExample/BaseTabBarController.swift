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
        
        self.tabBar.backgroundColor = .gray
        self.tabBar.tintColor = .red
        
        let aNav = BaseNavigationController(rootViewController: AViewController())
        aNav.tabBarItem.title = "A控制器"
        let bNav = BaseNavigationController(rootViewController: BViewController())
        bNav.tabBarItem.title = "B控制器"
        self.viewControllers = [aNav, bNav]
        
    }
    
    
    
}
