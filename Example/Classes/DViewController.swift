//
//  DViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit

class DViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav.title = "D控制器"
        nav.barBackgroundColor = .orange
        nav.statusBarColor = .green
//        statusBarStyle = .lightContent
        nav.hz.hiddenItemWithLeft(hidden: true)
        nav.hz.setItemsToRight([HZNavigationBarItem.create(normalImage: "releaseIcon", barItemClickHandler: { (item) in
            
        })])
        

        UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
        self.navigationController?.pushViewController(EViewController(), animated: true)
    }
        
}
