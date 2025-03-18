//
//  BaseViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit
import HZNavigationBar

class BaseViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    var nav: HZCustomNavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusBarHidden()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        nav = HZCustomNavigationBar.create(to: view)
        nav?.backgroundColor = .white
        nav?.shadowImageHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
//        nav.isShowBottomShadow = true
        if self.navigationController?.children.count != 1,
            self.navigationController != nil {
            let left = HZNavigationBarItem("back") { item in
                let currentVc = UIViewController.currentViewController()
                currentVc?.backLastViewController(animated: true)
            }
            nav?.hz.addBarItems(.left, items: [left])
        }
        
    }
    
    @objc public func orientationDidChange(_ notification: Notification) {
        statusBarHidden()
    }
    
    /// 解决刘海屏手机在横屏后状态栏消失问题
    fileprivate func statusBarHidden() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            var statusBar: UIView?
            if #available(iOS 13.0, *) {
                statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
                UIApplication.shared.keyWindow?.addSubview(statusBar!)
            } else {
                statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
            }
            statusBar?.isHidden = false
            statusBar?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
