//
//  EViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit

class EViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        nav.title = "EViewController"
        nav.hz_clickLeftBarItem { _ in
            print("拦截返回按钮")
        }
        let rightFirst = HZNavigationBarItem.create(normalImage: "delegateIcon", barItemClickHandler: { (item) in
            print("删除按钮")
        })
        let rightSecond = HZNavigationBarItem.create(normalImage: "updateIcon", barItemClickHandler: { (item) in
            print("更新按钮")
        })
        let rightButtons = [rightFirst, rightSecond]
        nav.hz_setItemsToRight(rightItems: rightButtons)

        let btn = UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
        view.addSubview(btn)
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
        self.navigationController?.pushViewController(FViewController(), animated: true)
    }

}
