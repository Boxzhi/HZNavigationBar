//
//  EViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit
import HZNavigationBar

class EViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        nav?.title = "EViewController"
        nav?.hz.clickLeftBarItem { _ in
            print("拦截返回按钮")
        }
        let rightFirst = HZNavigationBarItem("delegateIcon") { item in
            print("删除按钮")
        }
        let rightSecond = HZNavigationBarItem("updateIcon") { item in
            print("更新按钮")
        }
        let rightButtons = [rightFirst, rightSecond]
        nav?.hz.setItemsToRight(rightButtons)
        nav?.hz.showRightBarItemBadge(1)
        
        UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
//        nav?.hz.insertItemToRight(HZNavigationBarItem("插入", normalColor: .red, clickHandler: { item in
//
//        }), at: 1)
        self.navigationController?.pushViewController(FViewController(), animated: true)
    }

}
