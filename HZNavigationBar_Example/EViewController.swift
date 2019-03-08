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
        let a = HZNavigationBarItem.create( #imageLiteral(resourceName: "cccc")) { (btn) in
            
        }
        nav.hz_addItemsToRight(rightItems: [a])

        nav.barBackgroundColor = .orange
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 200, width: 100, height: 60)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(goto), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc func goto() {
        self.navigationController?.pushViewController(FViewController(), animated: true)
        
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
