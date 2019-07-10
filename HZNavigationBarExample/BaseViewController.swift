//
//  BaseViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var nav = HZCustomNavigationBar.customNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(nav)
        nav.barBackgroundColor = .white
        nav.shadowImageHidden = false
//        nav.isShowBottomShadow = true

        if self.navigationController?.children.count != 1,
            self.navigationController != nil {
            let left = HZNavigationBarItem.create( normalImage: #imageLiteral(resourceName: "back")) { (btn) in
                let currentVc = UIViewController.hz_currentViewController()
                currentVc?.hz_toLastViewController(animated: true)
            }
            nav.hz_addItemsToLeft(leftItems: [left])
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
