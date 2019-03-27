//
//  FViewController.swift
//  test
//
//  Created by 何志志 on 2018/12/13.
//  Copyright © 2018 何志志. All rights reserved.
//

import UIKit

class FViewController: BaseViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    lazy var playerView: UIView = {
       let _playerView = UIView()
        _playerView.backgroundColor = .red
        
//        if #available(iOS 11.0, *) {
//            _playerView.frame = CGRect(x: 0, y: self.view.safeAreaInsets.top, width: self.view.bounds.width, height: self.view.bounds.height * 9 / 16)
//        }else {
//            _playerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 9 / 16)
//        }
        _playerView.frame = CGRect(x: 0, y: 44 + UIApplication.shared.statusBarFrame.size.height, width: self.view.bounds.width, height: self.view.bounds.height * 9 / 16)
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

        nav.title = "FViewController"
        view.backgroundColor = .green
        
        self.playerView.addSubview(self.btn)
        view.addSubview(self.playerView)
        
        if UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func handleDeviceOrientationChange(notification: Notification) {
        let deviceOrientation = UIDevice.current.orientation
        switch deviceOrientation {
        case .faceUp:
            print("屏幕朝上平躺")
        case .faceDown:
            print("屏幕朝下平躺")
        case .unknown:
            print("未知方向")
        case .landscapeLeft:
            if !isFullScreen {
                changeToFullScreen()
            }
            print("屏幕向左横置")
        case .landscapeRight:
            if !isFullScreen {
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
        if isFullScreen {
            self.changeToOriginalFrame()
        }else {
            self.changeToFullScreen()
        }
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
        if isFullScreen {
            return
        }
        
        self.playerSuperView = self.playerView.superview
        self.playerFrame = self.playerView.frame
        
        let rectInWindow = self.playerView.convert(self.playerView.bounds, to: UIApplication.shared.keyWindow)
        self.playerView.removeFromSuperview()
        self.playerView.frame = rectInWindow
        UIApplication.shared.keyWindow?.addSubview(self.playerView)
        
        UIView.animate(withDuration: 0.3, animations: {
            let orientation = UIDevice.current.orientation
            if orientation == UIDeviceOrientation.landscapeRight {
                self.interfaceOrientation(orientation: .landscapeLeft)
            }else {
                self.interfaceOrientation(orientation: .landscapeRight)
            }
            self.playerView.bounds = CGRect(x: 0, y: 0, width: (self.playerView.superview?.bounds.height)!, height: (self.playerView.superview?.bounds.width)!)
            self.playerView.center = CGPoint(x: (self.playerView.superview?.bounds.midX)!, y: (self.playerView.superview?.bounds.midY)!)
            
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
        let currentOrientation = UIApplication.shared.statusBarOrientation
        
        guard currentOrientation != orientation else {
            return
        }
        
        UIApplication.shared.setStatusBarOrientation(orientation, animated: false)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.playerView.transform = CGAffineTransform.identity
        self.playerView.transform = self.getTransformRotationAngle()
        UIView.commitAnimations()
    }
    
    func getTransformRotationAngle() -> CGAffineTransform {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == UIInterfaceOrientation.portrait {
            return CGAffineTransform.identity
        }else if orientation == UIInterfaceOrientation.landscapeLeft {
            return CGAffineTransform(rotationAngle: -.pi/2)
        }else if orientation == UIInterfaceOrientation.landscapeRight {
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
