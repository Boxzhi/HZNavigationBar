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
        nav.titleView = UIImageView(image: UIImage(named: "titleViewImage"))
        nav.shadowImageHidden = true

        UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
        self.navigationController?.pushViewController(DViewController(), animated: true)
    }

}
