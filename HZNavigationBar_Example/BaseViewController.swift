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
        view.addSubview(nav)
        nav.barBackgroundColor = .white
        nav.isHiddenBottomLine = true
        nav.isShowBottomShadow = true

        if self.navigationController?.children.count != 1,
            self.navigationController != nil {
            let left = HZNavigationBarItem.create( #imageLiteral(resourceName: "back")) { (btn) in
                let currentVc = UIViewController.hz_currentViewController()
                currentVc?.hz_toLastViewController(animated: true)
            }
            nav.hz_addItemsToLeft(leftItems: [left])
        }
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
