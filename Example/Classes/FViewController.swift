//
//  FViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit
import HZNavigationBar

class FViewController: BaseViewController {
    
    private var currentInterfaceOrientation: UIInterfaceOrientation = .portrait
    
    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    lazy var playerView: UIView = {
       let _playerView = UIView()
        _playerView.backgroundColor = .red
        
        _playerView.frame = CGRect(x: 0, y: HZCustomNavigationBar.statusNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height * 9 / 16)
        return _playerView
    }()
    
    lazy var btn: UIButton = {
        let _btn = UIButton(type: .custom)
        _btn.setTitle("全屏", for: .normal)
        _btn.backgroundColor = .green
        _btn.addTarget(self, action: #selector(clickFullBtn(_:)), for: .touchUpInside)
        _btn.frame = CGRect(x: 50, y: 80, width: 150, height: 50)
        return _btn
    }()
    
    var isFullScreen: Bool = false
    var playerFrame: CGRect = .zero
    var playerSuperView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        nav?.title = "FViewController"
        view.backgroundColor = .green
        
        nav?.hz.setBarItems(.left, items: [HZNavigationBarItem("返回", normalColor: .black) { item in
            
        }, HZNavigationBarItem("addIcon", clickHandler: { item in
            
        }), HZNavigationBarItem("返回", normalColor: .black) { item in
            
        }])
        
        nav?.hz.setBarItems(.right, items: [HZNavigationBarItem("跳转", normalColor: .black) { item in
            self.navigationController?.pushViewController(GViewController(), animated: true)
        }])
        self.playerView.addSubview(self.btn)
        view.addSubview(self.playerView)
        
        if UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func orientationDidChange(_ notification: Notification) {
        super.orientationDidChange(notification)
        self.handleDeviceOrientationChange(notification)
    }
    
    func handleDeviceOrientationChange(_ notification: Notification) {
        let deviceOrientation = UIDevice.current.orientation
        switch deviceOrientation {
        case .faceUp:
            print("屏幕朝上平躺")
        case .faceDown:
            print("屏幕朝下平躺")
        case .unknown:
            print("未知方向")
        case .landscapeLeft:
            if !isFullScreen || currentInterfaceOrientation != .landscapeRight {
                changeToFullScreen()
            }
            print("屏幕向左横置")
        case .landscapeRight:
            if !isFullScreen || currentInterfaceOrientation != .landscapeLeft {
                changeToFullScreen()
            }
            print("屏幕向右横置")
        case .portrait:
            if isFullScreen {
                changeToOriginalFrame()
            }
            print("屏幕直立")
        case .portraitUpsideDown:
            print("屏幕直立, 上下颠倒")
        default:
            print("无法辨识")
        }
    }
    
    @objc fileprivate func clickFullBtn(_ sender: UIButton) {
//        if isFullScreen {
//            self.changeToOriginalFrame()
//        }else {
//            self.changeToFullScreen()
//        }
    }
    
    func changeToOriginalFrame() {   // 变为小屏
        if !isFullScreen {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.interfaceOrientation(orientation: .portrait)
            self.playerView.frame = self.playerFrame
        }) { (finished) in
            self.playerView.removeFromSuperview()
            self.playerSuperView?.addSubview(self.playerView)
            self.isFullScreen = false
        }
    }
    
    func changeToFullScreen() {   // 变为大屏
//        if isFullScreen {
//            return
//        }
        
        guard let lastVc = self.navigationController?.children.last, lastVc.isKind(of: FViewController.self) else {
            return
        }
        
        if !isFullScreen {
            self.playerSuperView = self.playerView.superview
            self.playerFrame = self.playerView.frame
        }
        
        guard let keyWindow = view.window ?? navigationController?.view.window ?? UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: \.isKeyWindow) else {
            return
        }
        let rectInWindow = self.playerView.convert(self.playerView.bounds, to: keyWindow)
        self.playerView.removeFromSuperview()
        self.playerView.frame = rectInWindow
        keyWindow.addSubview(self.playerView)
        
        UIView.animate(withDuration: 0.3, animations: {
            let orientation = UIDevice.current.orientation
            if orientation == UIDeviceOrientation.landscapeRight {
                self.interfaceOrientation(orientation: .landscapeLeft)
            }else {
                self.interfaceOrientation(orientation: .landscapeRight)
            }
            guard let superviewBounds = self.playerView.superview?.bounds else {
                return
            }
            self.playerView.bounds = CGRect(x: 0, y: 0, width: superviewBounds.height, height: superviewBounds.width)
            self.playerView.center = CGPoint(x: superviewBounds.midX, y: superviewBounds.midY)
            
        }) { (finished) in
            self.isFullScreen = true
        }
    }
    
    func interfaceOrientation(orientation: UIInterfaceOrientation) {
        if orientation == .landscapeRight || orientation == .landscapeLeft {
            self.setOrientationLandscapeConstraint(orientation: orientation)
        }else if orientation == .portrait {
            self.setOrientationLandscapeConstraint(orientation: .portrait)
        }
    }
    
    func setOrientationLandscapeConstraint(orientation: UIInterfaceOrientation) {
        self.toOrientation(orientation: orientation)
    }
    
    func toOrientation(orientation: UIInterfaceOrientation) {
        guard currentInterfaceOrientation != orientation else {
            return
        }
        
        currentInterfaceOrientation = orientation
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.playerView.transform = CGAffineTransform.identity
        self.playerView.transform = self.getTransformRotationAngle()
        UIView.commitAnimations()
    }
    
    func getTransformRotationAngle() -> CGAffineTransform {
        if currentInterfaceOrientation == UIInterfaceOrientation.portrait {
            return CGAffineTransform.identity
        }else if currentInterfaceOrientation == UIInterfaceOrientation.landscapeLeft {
            return CGAffineTransform(rotationAngle: -.pi/2)
        }else if currentInterfaceOrientation == UIInterfaceOrientation.landscapeRight {
            return CGAffineTransform(rotationAngle: .pi/2)
        }
        return CGAffineTransform.identity
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft, .landscapeRight]
    }

}
