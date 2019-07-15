//
//  HZNavigationBarItem.swift
//  test
//
//  Created by 何志志 on 2019/3/7.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public enum HZNavigationBarItemType: Int {
    case left = 0     // 左侧
    case right = 1     // 右侧
}

public enum HZBarItemEdgeInsetsStyle: Int {
    case top = 0  // image在上，label在下
    case bottom = 1  // image在下，label在上
    case left = 2  // image在左，label在右
    case right = 3  // image在右，label在左
}

public class HZNavigationBarItem: UIButton {
    
    public var titleColor: UIColor? {
        willSet {
            self._titleColor = newValue
            self.setTitleColor(newValue, for: .normal)
        }
    }
    
    public var newClickBarItemBlock: ((_ sender: HZNavigationBarItem) -> Void)?

    fileprivate var normalTitle: String?
    fileprivate var normalImage: UIImage?
    fileprivate var selectedTitle: String?
    fileprivate var selectedImage: UIImage?
    fileprivate var _titleColor: UIColor?
    fileprivate var titleFont: UIFont?
    private(set) var style: HZBarItemEdgeInsetsStyle!
    private(set) var space: CGFloat!
    private(set) var barItemWidth: CGFloat?
    fileprivate var clickBarItemBlock: ((_ sender: HZNavigationBarItem) -> Void)?
    
    /// 快速创建：title
    public class func create(normalTitle: String, selectedTitle: String? = nil, titleColor: UIColor = .black, titleFont: UIFont = UIFont.systemFont(ofSize: 15), barItemWidth: CGFloat? = nil, clickBarItemBlock: @escaping (_ sender: HZNavigationBarItem) -> Void) -> HZNavigationBarItem? {
        return HZNavigationBarItem.create(normalImage: nil, selectedImage: nil, normalTitle: normalTitle, selectedTitle: selectedTitle, titleColor: titleColor, titleFont: titleFont, style: .left, space: 5, barItemWidth: barItemWidth, clickBarItemBlock: clickBarItemBlock)
    }
    
    /// 快速创建：title、titleColor
    public class func create(normalTitle: String, titleColor: UIColor, barItemWidth: CGFloat? = nil, clickBarItemBlock: @escaping (_ sender: HZNavigationBarItem) -> Void) -> HZNavigationBarItem? {
        return HZNavigationBarItem.create(normalImage: nil, selectedImage: nil, normalTitle: normalTitle, selectedTitle: nil, titleColor: titleColor, titleFont: UIFont.systemFont(ofSize: 15), style: .left, space: 5, barItemWidth: barItemWidth, clickBarItemBlock: clickBarItemBlock)
    }
    
    /// 快速创建：image
    public class func create(normalImage: Any?, selectedImage: Any? = nil, clickBarItemBlock: @escaping (_ sender: HZNavigationBarItem) -> Void) -> HZNavigationBarItem? {
        guard let _normalImage = normalImage else { return nil }
        var norImage: UIImage? = nil
        var selelmage: UIImage? = nil
        if let selectedImage_ = selectedImage as? UIImage {
            selelmage = selectedImage_
        }else if let selectedString = selectedImage as? String {
            selelmage = UIImage(named: selectedString)
        }
        if let normalImage_ = _normalImage as? UIImage {
            norImage = normalImage_
        }else if let normalString = _normalImage as? String {
            norImage = UIImage(named: normalString)
        }else {
            return nil
        }
        return HZNavigationBarItem(normalImage: norImage, selectedImage: selelmage, normalTitle: nil, selectedTitle: nil, titleColor: nil, titleFont: nil, style: .left, space: 5, barItemWidth: nil, clickBarItemBlock: clickBarItemBlock)
    }
    
    /// 快速创建
    public class func create(normalImage: Any? = nil, selectedImage: Any? = nil, normalTitle: String? = nil, selectedTitle: String? = nil, titleColor: UIColor? = .black, titleFont: UIFont? = UIFont.systemFont(ofSize: 15), style: HZBarItemEdgeInsetsStyle = .left, space: CGFloat = 5, barItemWidth: CGFloat? = nil, clickBarItemBlock: @escaping (_ sender: HZNavigationBarItem) -> Void) -> HZNavigationBarItem? {
        if normalTitle == nil, normalImage == nil {
            return nil
        }else {
            var norImage: UIImage? = nil
            var selelmage: UIImage? = nil
            if let selectedImage_ = selectedImage as? UIImage {
                selelmage = selectedImage_
            }else if let selectedString = selectedImage as? String {
                selelmage = UIImage(named: selectedString)
            }
            if let normalImage_ = normalImage as? UIImage {
                norImage = normalImage_
            }else if let normalString = normalImage as? String {
                norImage = UIImage(named: normalString)
            }
            return HZNavigationBarItem(normalImage: norImage, selectedImage: selelmage, normalTitle: normalTitle, selectedTitle: selectedTitle, titleColor: titleColor, titleFont: titleFont, style: style, space: space, barItemWidth: barItemWidth, clickBarItemBlock: clickBarItemBlock)
        }
    }
    
    /**
     初始化创建
     
     - parameter frame:        默认不填（填了也几乎没用）
     - parameter normalTitle:        normal状态显示的文字
     - parameter normalImage:        normal状态显示的图片
     - parameter selectedTitle:        selected状态显示的文字
     - parameter selectedImage:        selected状态显示的图片
     - parameter titleColor:        文字颜色
     - parameter titleFont:        文字字号大小
     - parameter style:        图片文字排列方式
     - parameter space:        图片文字之间间隙
     - parameter barItemWidth:        设置固定宽度
     - parameter clickBarItemBlock:        点击回调
     */
     fileprivate init(normalImage: UIImage?, selectedImage: UIImage?, normalTitle: String?, selectedTitle: String?, titleColor: UIColor?, titleFont: UIFont?, style: HZBarItemEdgeInsetsStyle, space: CGFloat, barItemWidth: CGFloat?, clickBarItemBlock: @escaping (_ sender: HZNavigationBarItem) -> Void) {
        super.init(frame: .zero)
        
        self.normalTitle = normalTitle
        self.normalImage = normalImage
        self.selectedTitle = selectedTitle
        self.selectedImage = selectedImage
        self._titleColor = titleColor
        self.titleFont = titleFont
        self.style = style
        self.space = space
        self.barItemWidth = barItemWidth
        self.clickBarItemBlock = clickBarItemBlock
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        self.titleLabel?.font = titleFont
        self.contentMode = .center
        if normalTitle != nil {
            self.setTitleColor(_titleColor, for: .normal)
            self.setTitle(normalTitle, for: .normal)
        }
        if normalImage != nil {
            self.setImage(normalImage, for: .normal)
        }
        if selectedTitle != nil {
            self.setTitle(selectedTitle, for: .selected)
        }
        if selectedImage != nil {
            self.setImage(selectedImage, for: .selected)
        }
        self.addTarget(self, action: #selector(clickBarItemAction(_:)), for: .touchUpInside)
        
        if normalTitle != nil && normalImage != nil {
            self.barItemButtonLayoutButtonWithEdgeInsetsStyle(style: self.style, space: self.space)
        }
    }
    
    @objc fileprivate func clickBarItemAction(_ sender: HZNavigationBarItem) {
        
        if let _block = newClickBarItemBlock {
            _block(sender)
        }else if let _block = self.clickBarItemBlock {
            _block(sender)
        }
    }
}

extension HZNavigationBarItem {
    
    /**
     - parameter style: 类型
     - parameter space: image与titleLabel的间距
     */
    public func barItemButtonLayoutButtonWithEdgeInsetsStyle(style: HZBarItemEdgeInsetsStyle, space: CGFloat) {
        
        /**
         *  拿到imageView和titleLabel的宽、高
         */
        let imageWidth: CGFloat = (self.imageView?.intrinsicContentSize.width)!
        let imageHeight: CGFloat = (self.imageView?.intrinsicContentSize.height)!
        
        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0
        
        if #available(iOS 8.0, *) {
            labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
            labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        }else{
            labelWidth = (self.titleLabel?.frame.size.width)!
            labelHeight = (self.titleLabel?.frame.size.height)!
        }
        
        /**
         *  声明全局的imageEdgeInsets和labelEdgeInsets
         */
        var imageEdgeInsets: UIEdgeInsets = .zero
        var labelEdgeInsets: UIEdgeInsets = .zero
        
        /**
         *  根据style和space算出imageEdgeInsets和labelEdgeInsets的值
         */
        switch style {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space / 2.0, right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: -space / 2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -(imageHeight + space / 2.0), left: -imageWidth, bottom: 0, right: 0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth + space / 2.0)
        }
        
        /**
         *  赋值
         */
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: space / 2.0)
        
    }
}

