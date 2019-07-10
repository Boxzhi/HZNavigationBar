//
//  AViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit

class AViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.random()
        nav.title = "A控制器"
        
        //
        let btn = UIButton.setJumpButton(self, action: #selector(jumpToNext(_:)))
        view.addSubview(btn)
    }
    
    @objc func jumpToNext(_ sender: UIButton) {
        self.navigationController?.pushViewController(CViewController(), animated: true)
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
