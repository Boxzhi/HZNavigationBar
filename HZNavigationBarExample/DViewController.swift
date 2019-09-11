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
        statusBarStyle = .lightContent
        nav.hz_hiddenItemWithLeft(hidden: true)
        nav.hz_setItemsToRight([HZNavigationBarItem.create(normalImage: "releaseIcon", barItemClickHandler: { (item) in
            
        })])
        

        let btn = UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
        view.addSubview(btn)
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
        self.navigationController?.pushViewController(EViewController(), animated: true)
    }
        
}
