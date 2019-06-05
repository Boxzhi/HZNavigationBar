//
//  DViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit

class DViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        nav.title = "D控制器"
//        nav.titleImage = #imageLiteral(resourceName: "sasda")
        nav.barBackgroundColor = .white
//        nav.hz_setBottomShadow(hidden: false)
        nav.hz_setLeftBarItemHidden(hidden: true)
        
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        nav.hz_setAllItemsToRight(rightItems: [HZNavigationBarItem.create(normalImage: UIImage(named: "dddd"), normalTitle: "哈哈哈", style: .left, space: 10, barItemWidth: 100, clickBarItemBlock: { (btn) in
            
        })])
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 200, width: 100, height: 60)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(goto), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc func goto() {
        self.navigationController?.pushViewController(EViewController(), animated: true)
        
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
