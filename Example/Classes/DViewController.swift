//
//  DViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit
import HZNavigationBar

class DViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav?.title = "D控制器"
        nav?.backgroundColor = .yellow
        nav?.statusBarColor = .green
//        nav?.navigationBarBackgroundColor = .yellow
//        statusBarStyle = .lightContent
        nav?.hz.hiddenBarItem(.left, hidden: true)
        nav?.hz.setBarItems(.right, items: [HZNavigationBarItem("releaseIcon") { item in
            
        }])

        nav?.alpha = 0.5
        UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
        self.navigationController?.pushViewController(EViewController(), animated: true)
//        nav?.bgColor = .yellow
    }
        
}
