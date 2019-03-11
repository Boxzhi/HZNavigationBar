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
//        nav.barBackgroundImage = #imageLiteral(resourceName: "aaaaaa")
        let button = UIButton(type: .custom)
        button.setTitle("测试啊啊啊啊", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setImage(UIImage(named: "cccc"), for: .normal)
        nav.hz_setTitleView(button)
        let rignta = HZNavigationBarItem.create( #imageLiteral(resourceName: "aaaa")) { (btn) in
            
        }
        let rightb = HZNavigationBarItem.create( #imageLiteral(resourceName: "cccc")) { (btn) in
            
        }
        
        nav.hz_addItemsToRight(rightItems:  [rightb, rignta])
        nav.hz_clickLeftBarItem {
            print("拦截测试")
            let alertVc: UIAlertController = UIAlertController(title: "", message: "拦截测试", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            }))
            UIViewController.hz_currentViewController()?.present(alertVc, animated: true, completion: {
                
            })
        }
        
        nav.hz_clickLeftBarItem(2) {
            
        }
        view.backgroundColor = .white
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 200, width: 100, height: 60)
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(goto), for: .touchUpInside)
        view.addSubview(btn)
        
        let btna = UIButton(type: .custom)
        btna.frame = CGRect(x: 100, y: 400, width: 100, height: 60)
        btna.backgroundColor = .green
        btna.addTarget(self, action: #selector(gotoa), for: .touchUpInside)
        view.addSubview(btna)
        
        let btnc = UIButton(type: .custom)
        btnc.frame = CGRect(x: 100, y: 500, width: 100, height: 60)
        btnc.backgroundColor = .green
        btnc.addTarget(self, action: #selector(gotocaaa), for: .touchUpInside)
        view.addSubview(btnc)
        
        let btnab = UIButton(type: .custom)
        btnab.frame = CGRect(x: 100, y: 600, width: 100, height: 60)
        btnab.backgroundColor = .green
        btnab.addTarget(self, action: #selector(gotoab), for: .touchUpInside)
        view.addSubview(btnab)
        // Do any additional setup after loading the view.
    }

    @objc func goto() {
        let item = HZNavigationBarItem.create(normalImage: #imageLiteral(resourceName: "eeee"), normalTitle: "测试", titleColor: .red) { (btn) in
            print("测试")
        }

        nav.hz_addItemsToLeft(leftItems: [item])
//        self.navigationController?.pushViewController(DViewController(), animated: true)
    }
    
    @objc func gotoa() {
        let a = HZNavigationBarItem.create( #imageLiteral(resourceName: "dddd")) { (btn) in
            
        }
        nav.hz_addItemsToLeft(leftItems: [a])
        nav.hz_clickLeftBarItem(1) {
            
        }
    }
    
    @objc func gotocaaa() {
        let aaa = HZNavigationBarItem.create(normalTitle: "测试", titleColor: .green) { (btn) in
            
        }
        nav.hz_setAllItemsToLeft(leftItems: [aaa])

    }
    
    @objc func gotoab() {
        self.navigationController?.pushViewController(DViewController(), animated: true)
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
