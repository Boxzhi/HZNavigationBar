//
//  FViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit

class FViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        nav.title = "FViewController"
//        nav.hz_setRightItems(rightItems: [HZNavigationBarItem(normalTitle: "测试", normalImage: nil, titleColor: .green, clickBarItemBlock: { (btn) in
//
//        })])
//        nav.hz_setBottomLineHidden(hidden: true)
//        nav.hz_setLeftBarItemHidden(hidden: true)
//        let b = HZNavigationBarItem(normalImage: #imageLiteral(resourceName: "aaaa")) { (btn) in
//
//        }
//        nav.hz_setRightItems(rightItems: [b])
//        UMSocialManager.default().isInstall(.wechatSession)
        view.backgroundColor = .green
        
//        UMSocialManager.default().isInstall(.wechatSession)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
