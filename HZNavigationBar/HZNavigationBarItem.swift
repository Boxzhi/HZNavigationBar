//
//  HZNavigationBarItem.swift
//  test
//
//  Created by 何志志 on 2019/3/7.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public enum HZNavigationBarItemType: Int {
    case left = 0 // 左侧
    case right = 1 // 右侧
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
            self.normalColor = newValue
            self.setTitleColor(newValue, for: .normal)
        }
    }
    
    fileprivate var normalTitle: String?
    fileprivate var normalColor: UIColor?
    fileprivate var selectedTitle: String?
    fileprivate var selectedColor: UIColor?
    fileprivate var font: UIFont = UIFont.systemFont(ofSize: 15)
    fileprivate var normalImage: UIImage?
    fileprivate var selectedImage: UIImage?
    private(set) var style: HZBarItemEdgeInsetsStyle = .left
    private(set) var space: CGFloat = 5.0
    private(set) var barItemWidth: CGFloat?
    var clickHandler: HZNavigationBarItemClickHandler?
    
    /// 创建文字版HZNavigationBarItem
    /// - Parameters:
    ///   - normalTitle: 默认文字
    ///   - normalColor: 默认文字颜色
    ///   - selectedTitle: 选中文字
    ///   - selectedColor: 选中文字颜色
    ///   - font: 字号
    ///   - style: 类型
    ///   - space: 文字图标间距
    ///   - barItemWidth: 宽度
    ///   - clickHandler: 点击回调
    public init(_ normalTitle: String, normalColor: UIColor, selectedTitle: String? = nil, selectedColor: UIColor? = nil, font: UIFont = UIFont.systemFont(ofSize: 15), style: HZBarItemEdgeInsetsStyle = .left, space: CGFloat = 5.0, barItemWidth: CGFloat? = nil, clickHandler: @escaping HZNavigationBarItemClickHandler) {
        super.init(frame: .zero)
        self.normalTitle = normalTitle
        self.normalColor = normalColor
        self.selectedTitle = selectedTitle
        self.selectedColor = selectedColor
        self.font = font
        self.style = style
        self.space = space
        self.barItemWidth = barItemWidth
        self.clickHandler = clickHandler
        setBaseUI()
    }
    
    /// 创建图片版HZNavigationBarItem
    /// - Parameters:
    ///   - normalImage: 默认image
    ///   - selectedImage: 选中image
    ///   - barItemWidth: 宽度
    ///   - clickHandler: 点击回调
    public init(_ normalImage: Any, selectedImage: Any? = nil, barItemWidth: CGFloat? = nil, clickHandler: @escaping HZNavigationBarItemClickHandler) {
        super.init(frame: .zero)
        if let _normalImage = normalImage as? UIImage {
            self.normalImage = _normalImage
        }else if let _normalImageString = normalImage as? String {
            self.normalImage = UIImage(named: _normalImageString)
        }
        if let _selectedImage = selectedImage as? UIImage {
            self.selectedImage = _selectedImage
        }else if let _selectedImageString = selectedImage as? String {
            self.selectedImage = UIImage(named: _selectedImageString)
        }
        self.barItemWidth = barItemWidth
        self.clickHandler = clickHandler
        setBaseUI()
    }
    
    /// 创建文字图片版HZNavigationBarItem
    /// - Parameters:
    ///   - normalTitle: 默认文字
    ///   - normalColor: 默认颜色
    ///   - selectedTitle: 选中文字
    ///   - selectedColor: 选中颜色
    ///   - normalImage: 默认图片
    ///   - selectedImage: 选中图片
    ///   - font: 字号
    ///   - style: 类型
    ///   - space: 文字图片间距
    ///   - barItemWidth: 宽度
    ///   - clickHandler: 点击回调
    public init(_ normalTitle: String, normalColor: UIColor, selectedTitle: String? = nil, selectedColor: UIColor? = nil, normalImage: Any, selectedImage: Any? = nil, font: UIFont = UIFont.systemFont(ofSize: 15), style: HZBarItemEdgeInsetsStyle = .left, space: CGFloat = 5.0, barItemWidth: CGFloat? = nil, clickHandler: @escaping HZNavigationBarItemClickHandler) {
        super.init(frame: .zero)
        self.normalTitle = normalTitle
        self.normalColor = normalColor
        self.selectedTitle = selectedTitle
        self.selectedColor = selectedColor
        if let _normalImage = normalImage as? UIImage {
            self.normalImage = _normalImage
        }else if let _normalImageString = normalImage as? String {
            self.normalImage = UIImage(named: _normalImageString)
        }
        if let _selectedImage = selectedImage as? UIImage {
            self.selectedImage = _selectedImage
        }else if let _selectedImageString = selectedImage as? String {
            self.selectedImage = UIImage(named: _selectedImageString)
        }
        self.font = font
        self.style = style
        self.space = space
        self.barItemWidth = barItemWidth
        self.clickHandler = clickHandler
        setBaseUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBaseUI()
    }
    
    fileprivate func setBaseUI() {
        
        self.contentMode = .center
        if let _normalTitle = self.normalTitle {
            self.titleLabel?.font = self.font
            self.setTitle(_normalTitle, for: .normal)
        }
        if let _selectedTitle = self.selectedTitle {
            self.setTitle(_selectedTitle, for: .selected)
        }
        if let _normalColor = self.normalColor {
            self.setTitleColor(_normalColor, for: .normal)
        }
        if let _selectedColor = self.selectedColor {
            self.setTitleColor(_selectedColor, for: .selected)
        }
        if let _normalImage = self.normalImage {
            self.setImage(_normalImage, for: .normal)
        }
        if let _selectedImage = self.selectedImage {
            self.setImage(_selectedImage, for: .selected)
        }
        if normalTitle != nil, normalImage != nil {
            self.barItemButtonLayoutButtonWithEdgeInsetsStyle(style: self.style, space: self.space)
        }
        self.addTarget(self, action: #selector(clickBarItemAction(_:)), for: .touchUpInside)
        
    }
    
    @objc fileprivate func clickBarItemAction(_ sender: HZNavigationBarItem) {
        if let _clickHandler = self.clickHandler {
            _clickHandler(sender)
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

