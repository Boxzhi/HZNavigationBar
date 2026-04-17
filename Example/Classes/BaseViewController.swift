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
        statusBarOverlayView?.removeFromSuperview()
    }

    var nav: HZCustomNavigationBar?
    private var statusBarOverlayView: UIView?
    
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
            guard let window = currentKeyWindow() else { return }
            let overlayView: UIView
            if let statusBarOverlayView {
                overlayView = statusBarOverlayView
            }else {
                overlayView = UIView()
                overlayView.isUserInteractionEnabled = false
                window.addSubview(overlayView)
                statusBarOverlayView = overlayView
            }
            overlayView.isHidden = false
            overlayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0)
        }
    }
    
    private func currentKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
