//
//  CViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit

class CViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        nav.title = "C控制器"
        if UIDevice.current.userInterfaceIdiom == .phone {
            nav.titleView = UIImageView(image: UIImage(named: "titleViewImage"))
        }else {
            let imageView = UIImageView(image: UIImage(named: "titleViewImage"))
            imageView.frame = CGRect(x: 0, y: 0, width: 216.667, height: 100)
            nav.titleView = imageView
        }
        nav.shadowImageHidden = true

        UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
        self.navigationController?.pushViewController(DViewController(), animated: true)
    }

}
