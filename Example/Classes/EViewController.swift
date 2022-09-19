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
        nav?.hz.barItemClickHandler(.left, barItemClickHandler: { item in
            print("拦截返回按钮")
        })
        let rightFirst = HZNavigationBarItem("delegateIcon") { item in
            if self.nav?.hz.getBarItems(.right)?.count != 2 {
                self.nav?.hz.removeBarItems(.right, indexs: [1])
            }
            print("删除按钮")
            
        }
        let rightSecond = HZNavigationBarItem("updateIcon") { item in
            self.nav?.hz.insertBarItem(.right, atIndex: 1, item: HZNavigationBarItem("插入", normalColor: .red, clickHandler: { item in
                
            }))
            print("更新按钮")
        }
        let rightButtons = [rightFirst, rightSecond]
        nav?.hz.setBarItems(.right, items: rightButtons)
        nav?.hz.barItemShowColorBadge(.right, atIndex: 1)
        
        UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
        self.navigationController?.pushViewController(FViewController(), animated: true)
    }

}
