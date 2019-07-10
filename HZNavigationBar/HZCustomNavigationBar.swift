//
//  HZCustomNavigationBar.swift
//  test
//
//  Created by 何志志 on 2019/3/7.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

fileprivate let HZDefaultBackgroundColor: UIColor = .white
fileprivate let HZDefaultButtonTitleSize: CGFloat = 16.0
fileprivate let HZDefaultTitleSize: CGFloat = 18.0
fileprivate let HZDefaultTitleColor: UIColor = .black
fileprivate let HZTitleLabelMaxWidth: CGFloat = 180.0
fileprivate let HZScreenWidth: CGFloat = UIScreen.main.bounds.size.width
fileprivate let HZStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
fileprivate let HZNavigationBarHeight: CGFloat = 44.0
fileprivate let HZLeftBarItemSpace: CGFloat = 10.0
fileprivate let HZRightBarItemSpace: CGFloat = 13.0
fileprivate let HZBarItemWidth: CGFloat = 44.0

public extension UIViewController {
    
    func hz_toLastViewController(animated: Bool) {
        if let _navigationController = self.navigationController {
            if _navigationController.viewControllers.count == 1 {
                self.dismiss(animated: animated, completion: nil)
            }else {
                _navigationController.popViewController(animated: animated)
            }
        }else if let _presentingViewController = self.presentingViewController {
            _presentingViewController.dismiss(animated: animated, completion: nil)
        }
    }
    
    class func hz_currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return hz_currentViewController(base: nav.visibleViewController)
        }else if let tab = base as? UITabBarController {
            return hz_currentViewController(base: tab.selectedViewController)
        }else if let presented = base?.presentedViewController {
            return hz_currentViewController(base: presented)
        }else {
            return base
        }
    }
}

public class HZCustomNavigationBar: UIView {
    
    //MARK: - 供外部设置NavigationBar的一些基本属性
    /// 是否显示navigationBar底部阴影，默认false
    public var isShowBottomShadow: Bool = false {
        willSet {
            hz_setBottomShadow(newValue, shadowColor: bottomShadowColor, shadowOffset: bottomShadowOffset, shadowOpacity: bottomShadowOpacity, shadowRadius: bottomShadowRadius)
        }
    }
    
    /// 阴影颜色
    public var bottomShadowColor: UIColor? {
        willSet {
            hz_setBottomShadow(isShowBottomShadow, shadowColor: newValue, shadowOffset: bottomShadowOffset, shadowOpacity: bottomShadowOpacity, shadowRadius: bottomShadowRadius)
        }
    }
    
    /// 阴影偏移量
    public var bottomShadowOffset: CGSize? {
        willSet {
            hz_setBottomShadow(isShowBottomShadow, shadowColor: bottomShadowColor, shadowOffset: newValue, shadowOpacity: bottomShadowOpacity, shadowRadius: bottomShadowRadius)
        }
    }
    
    /// 阴影透明度，默认1
    public var bottomShadowOpacity: Float = 1 {
        willSet {
            hz_setBottomShadow(isShowBottomShadow, shadowColor: bottomShadowColor, shadowOffset: bottomShadowOffset, shadowOpacity: newValue, shadowRadius: bottomShadowRadius)
        }
    }
    
    /// 阴影宽度
    public var bottomShadowRadius: CGFloat? {
        willSet {
            hz_setBottomShadow(isShowBottomShadow, shadowColor: bottomShadowColor, shadowOffset: bottomShadowOffset, shadowOpacity: bottomShadowOpacity, shadowRadius: newValue)
        }
    }
    
    /// navigationBar背景颜色
    public var barBackgroundColor: UIColor? {
        willSet {
            hz_setNavigationBarBackground(color: newValue)
        }
    }
    
    /// navigationBar背景图片
    public var barBackgroundImage: UIImage? {
        willSet {
            hz_setNavigationBarBackground(backgroundImage: barBackgroundImage)
        }
    }
    
    /// navigationBar的title
    public var title: String? {
        willSet {
            hz_setTitleLabel(newValue, textColor: titleColor, font: titleFont)
        }
    }
    
    /// navigationBar的title颜色
    public var titleColor: UIColor = HZDefaultTitleColor {
        willSet {
            hz_setTitleLabel(title, textColor: newValue, font: titleFont)
        }
    }
    
    /// navigationBar的title字体
    public var titleFont: UIFont = UIFont.systemFont(ofSize: HZDefaultTitleSize) {
        willSet {
            hz_setTitleLabel(title, textColor: titleColor, font: newValue)
        }
    }
    
    /// navigationBar的titleView
    public var titleView: UIView? {
        willSet {
           hz_setTitleView(newValue)
        }
    }
    
    /// 是否隐藏navigationBar底部的细横线
    public var shadowImageHidden: Bool = false {
        willSet {
            hz_setBottomLineHidden(hidden: newValue)
        }
    }
    
    /// 设置主题颜色（title和BarItem）
    public var themeColor: UIColor? {
        willSet {
            guard let _color = newValue else { return }
            hz_setThemeColor(color: _color)
        }
    }
    
    
    //MARK: - 内部存储使用的属性
    /// leftBarItem数组
    fileprivate var leftBarItems: [HZNavigationBarItem]?
    /// rightBarItem数组
    fileprivate var rightBarItems: [HZNavigationBarItem]?
    /// 导航栏整体高度
    fileprivate static var statusNavigationBarHeight: CGFloat {
        get {
            return HZStatusBarHeight + HZNavigationBarHeight
        }
    }

    //MARK: - NavigationBar的组成UI控件
    ///  背景View
    fileprivate lazy var _backgroundView: UIView = {
        let backgroundView: UIView = UIView()
        return backgroundView
    }()
    
    ///  背景图片
    fileprivate lazy var _backgroundImageView: UIImageView = {
        let backgroundImageView: UIImageView = UIImageView()
        backgroundImageView.isHidden = true
        return backgroundImageView
    }()
    
    /// titleView
    fileprivate lazy var _titleView: UIView = {
        let titleView: UIView = UIView()
        titleView.isHidden = true
        return titleView
    }()
    
    /// titleLabel
    fileprivate lazy var _titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        titleLabel.textColor = HZDefaultTitleColor
        titleLabel.font = UIFont.systemFont(ofSize: HZDefaultTitleSize)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    /// 底部细线条
    fileprivate lazy var _bottomLine: UIView = {
        let bottomLine: UIView = UIView()
        bottomLine.backgroundColor = UIColor(red: (218.0/255.0), green: (218.0/255.0), blue: (218.0/255.0), alpha: 1.0)
        return bottomLine
    }()
    
    //MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        
        backgroundColor = .clear
        addSubview(_backgroundView)
        addSubview(_backgroundImageView)
        addSubview(_titleView)
        addSubview(_titleLabel)
        addSubview(_bottomLine)
        updateFrame()
        
    }
    
    fileprivate func updateFrame() {
        
        _backgroundView.frame = bounds
        _backgroundImageView.frame = bounds
        _titleView.frame = CGRect(x: 0, y: HZStatusBarHeight, width: self.bounds.size.width, height: HZNavigationBarHeight)
        _titleLabel.frame = CGRect(x: (HZScreenWidth - HZTitleLabelMaxWidth) / 2.0, y: HZStatusBarHeight, width: HZTitleLabelMaxWidth, height: HZNavigationBarHeight)
        _bottomLine.frame = CGRect(x: 0, y: bounds.height - 0.5, width: HZScreenWidth, height: 0.5)
        
    }
    
}

//MARK: - 内部实现方法
extension HZCustomNavigationBar {
    
    /// 设置背景色或背景图
    fileprivate func hz_setNavigationBarBackground(color: UIColor? = nil, backgroundImage: UIImage? = nil) {
        
        if let _color = color {
            _backgroundView.isHidden = false
            _backgroundView.backgroundColor = _color
            _backgroundImageView.isHidden = true
        }else if let _backgroundImage = backgroundImage {
            _backgroundView.isHidden = true
            _backgroundImageView.isHidden = false
            _backgroundImageView.image = _backgroundImage
        }
    }
    
    /// 设置titleLabel属性
    fileprivate func hz_setTitleLabel(_ text: String?, textColor: UIColor, font: UIFont) {
        _titleLabel.isHidden = false
        _titleView.isHidden = true
        
        _titleLabel.text = text
        _titleLabel.textColor = textColor
        _titleLabel.font = font
    }
    
    /// 隐藏底部细线条
    fileprivate func hz_setBottomLineHidden(hidden: Bool) {
        _bottomLine.isHidden = hidden
    }
    
    /// BarItem具体添加及布局
    fileprivate func hz_setBarItemsWithLayout(_ barItems: [HZNavigationBarItem], barItemType: HZNavigationBarItemType) {
        for i in 0 ..< barItems.count {
            
            let barItem: HZNavigationBarItem = barItems[i]
            self.addSubview(barItem)
            
            var barItemWidth: CGFloat? = nil
            if let _barItemWidth = barItem.barItemWidth {
                barItemWidth = _barItemWidth
            }else {
                barItemWidth = barItem.title(for: .normal) == nil ? HZBarItemWidth : nil
            }
            
            if barItemType == .left {
                if i == 0 {
                    self.constrainToLeadingTopBottomWidth(barItem, leading: HZLeftBarItemSpace, top: HZStatusBarHeight, width: barItemWidth)
                }else {
                    self.constrainToLeadingTopBottomWidth(barItem, targetView: barItems[i - 1],  width: barItemWidth)
                }
            }else {
                if i == 0 {
                    self.constrainToTrailingTopBottomWidth(barItem, trailing: -HZRightBarItemSpace, top: HZStatusBarHeight, width: barItemWidth)
                }else {
                    self.constrainToTrailingTopBottomWidth(barItem, targetView: barItems[i - 1], width: barItemWidth)
                }
            }
            if themeColor != nil {
                barItem.titleColor = themeColor
            }
        }
        if barItemType == .left {
            self.leftBarItems?.removeAll()
            self.leftBarItems = barItems
        }else {
            self.rightBarItems?.removeAll()
            self.rightBarItems = barItems
        }
    }
    
    /// 设置BarItem
    fileprivate func hz_setBarItems(_ barItems: [HZNavigationBarItem?], barItemType: HZNavigationBarItemType) {
        let _barItems = barItems.compactMap({ return $0 })
        if barItemType == .left {
            if let _leftBarItems = self.leftBarItems {
                for item in _leftBarItems {
                    item.removeFromSuperview()
                }
            }
        }else {
            if let _rightBarItems = self.rightBarItems {
                for item in _rightBarItems {
                    item.removeFromSuperview()
                }
            }
        }
        self.hz_setBarItemsWithLayout(_barItems, barItemType: barItemType)
    }
    
    /// 新增BarItem
    fileprivate func hz_addBarItems(_ barItems: [HZNavigationBarItem?], barItemType: HZNavigationBarItemType) {
        let _barItems = barItems.compactMap({ return $0 })
        if barItemType == .left {
            if let _leftBarItems = self.leftBarItems {
                self.hz_setBarItemsWithLayout(_leftBarItems + _barItems, barItemType: barItemType)
            }else {
                self.hz_setBarItemsWithLayout(_barItems, barItemType: barItemType)
            }
        }else {
            if let _rightBarItems = self.rightBarItems {
                self.hz_setBarItemsWithLayout(_rightBarItems + _barItems, barItemType: barItemType)
            }else {
                self.hz_setBarItemsWithLayout(_barItems, barItemType: barItemType)
            }
        }
    }
    
    /// 更新BarItem
    fileprivate func hz_updateBarItem(_ barItemType: HZNavigationBarItemType, atIndex: Int, normalTitle: String?, selectedTitle: String?, normalImage: UIImage?, selectedImage: UIImage?, clickBarItemBlock: ((_ sender: HZNavigationBarItem) -> Void)?) {
        var barItems: [HZNavigationBarItem]? = nil
        if barItemType == .left {
            barItems = self.leftBarItems
        }else {
            barItems = self.rightBarItems
        }
        
        guard let _barItems = barItems, atIndex < _barItems.count else {
            return
        }
        let item: HZNavigationBarItem = _barItems[atIndex]
        if normalTitle != nil {
            item.setTitle(normalTitle, for: .normal)
        }
        if selectedTitle != nil {
            item.setTitle(selectedTitle, for: .selected)
        }
        if normalImage != nil {
            item.setImage(normalImage, for: .normal)
        }
        if selectedImage != nil {
            item.setImage(selectedImage, for: .selected)
        }
        if let block = clickBarItemBlock {
            item.newClickBarItemBlock = block
        }
        item.barItemButtonLayoutButtonWithEdgeInsetsStyle(style: item.style, space: item.space)
    }
    
    /// 隐藏BarItem
    fileprivate func hz_hiddenBarItem(_ barItemType: HZNavigationBarItemType, index: Int?, hidden: Bool) {
        var barItems: [HZNavigationBarItem]? = nil
        if barItemType == .left {
            barItems = self.leftBarItems
        }else {
            barItems = self.rightBarItems
        }
        
        guard let _barItems = barItems else {
            return
        }
        if let _index = index, _index < _barItems.count {
            for _ in 0 ..< _barItems.count {
                _barItems[_index].isHidden = hidden
            }
        }else {
            for barItem in _barItems {
                barItem.isHidden = hidden
            }
        }
    }
    
    /// 点击BarItem
    fileprivate func hz_clickBarItem(_ barItemType: HZNavigationBarItemType, index: Int, clickBlock: @escaping (_ sender: HZNavigationBarItem) -> Void) {
        var barItems: [HZNavigationBarItem]? = nil
        if barItemType == .left {
            barItems = self.leftBarItems
        }else {
            barItems = self.rightBarItems
        }
        
        guard let _barItems = barItems else {
            return
        }
        if index < _barItems.count {
            let barItem = _barItems[index]
            barItem.newClickBarItemBlock = clickBlock
        }
    }
    
}

//MARK: - 外部可调用方法
public extension HZCustomNavigationBar {
    
    /// 外部快速创建方法
    class func customNavigationBar() -> HZCustomNavigationBar {
        return HZCustomNavigationBar(frame: CGRect(x: 0, y: 0, width: HZScreenWidth, height: statusNavigationBarHeight))
    }
    
    /// 设置NavigationBar的titleView，若view有设置frame，则可不传titleViewSize，若两者都无，则默认占据整个NavigationBar
    /// isCenter: view是否要居中显示在titleView上
    func hz_setTitleView(_ view: UIView?, titleViewSize: CGSize? = nil, isCenter: Bool = true) {
        
        guard let _view = view else { return }
        for subView in _titleView.subviews {
            subView.removeFromSuperview()
        }
        self._titleView.isHidden = false
        self._titleLabel.isHidden = true
        
        if _view.isKind(of: UIButton.self) {
            let _button = _view as! UIButton
            _button.contentMode = .center
            _titleView.addSubview(_button)
            _titleView.constrainCenteredAutoWidth(_button)
            
        }else {
        
            var _viewSize: CGSize = _view.frame.size
            let _titleViewWidth: CGFloat = _titleView.bounds.width
            let _titleViewHeight: CGFloat = _titleView.bounds.height
            
            if _viewSize.width == 0 && _viewSize.height == 0 && titleViewSize == nil {
                _viewSize = CGSize(width: _titleViewWidth, height: _titleViewHeight)
            }else if let _titleViewSize = titleViewSize {
                if _titleViewSize.width == 0 && _titleViewSize.height == 0 {
                    _viewSize = CGSize(width: _titleViewWidth, height: _titleViewHeight)
                }else if _titleViewSize.width == 0 {
                    _viewSize = CGSize(width: _titleViewWidth, height: _titleViewSize.height < _titleViewHeight ? _titleViewSize.height : _titleViewHeight)
                }else {
                    _viewSize = CGSize(width: _titleViewSize.width < _titleViewWidth ? _titleViewSize.width : _titleViewWidth, height: _titleViewHeight)
                }
            }else {
                let height: CGFloat = _viewSize.height < _titleViewHeight ? _viewSize.height : _titleViewHeight
                if _viewSize.width == 0  {
                    _viewSize = CGSize(width: _titleViewWidth, height: height)
                }else if _viewSize.height == 0 {
                    _viewSize = CGSize(width: _viewSize.width < _titleViewWidth ? _viewSize.width : _titleViewWidth, height: _titleViewHeight)
                }else {
                    let width: CGFloat = _viewSize.width * height / _viewSize.height
                    _viewSize = CGSize(width: width, height: height)
                }
            }
            
            if isCenter {
                _titleView.frame = CGRect(x: (self.bounds.width - _viewSize.width) / 2, y: HZStatusBarHeight, width: _viewSize.width, height: HZNavigationBarHeight)
                _view.frame = CGRect(x: 0, y: 0, width: _viewSize.width, height: _viewSize.height)
                _titleView.addSubview(_view)
                _titleView.constrainCentered(_view)
            }else {
                _view.frame = CGRect(x: _view.frame.origin.x, y: _view.frame.origin.y, width: _viewSize.width, height: _viewSize.height)
                _titleView.addSubview(_view)
            }
    
        }
        
    }
    
    /// 设置NavigationBar底部阴影
    func hz_setBottomShadow(_ isShow: Bool = false, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float = 1, shadowRadius: CGFloat? = nil) {
        
        if isShow {
            self.layer.shadowOpacity = shadowOpacity
            if let _shadowColor = shadowColor {
                self.layer.shadowColor = _shadowColor.cgColor
            }
            if let _shadowOffset = shadowOffset {
                self.layer.shadowOffset = _shadowOffset
            }
            if let _shadowRadius = shadowRadius {
                self.layer.shadowRadius = _shadowRadius
            }
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
    }
    
    /// 设置主题颜色（title和BarItem）
    func hz_setThemeColor(color: UIColor) {
        self.titleColor = color
        hz_setBarItemColor(color: color)
    }
    
    /// 设置BarItem按钮颜色
    func hz_setBarItemColor(color: UIColor) {
        if let _leftBarItems = self.leftBarItems {
            for barItem in _leftBarItems {
                barItem.titleColor = color
            }
        }
        if let _rightBarItems = self.rightBarItems {
            for barItem in _rightBarItems {
                barItem.titleColor = color
            }
        }
    }
    
    /// 设置背景透明度
    func hz_setBackgroundAlpha(alpha: CGFloat) {
        _backgroundView.alpha = alpha
        _backgroundImageView.alpha = alpha
        _bottomLine.alpha = alpha
    }
    
}

//MARK: - 供外部对BarItem设置调用的方法
public extension HZCustomNavigationBar {
    
    /// 设置LeftBarItem、若之前已存在barItem、则会先移除后设置.
    /// - leftItems: barItem的数组.
    func hz_setItemsToLeft(leftItems: [HZNavigationBarItem?]) {
        self.hz_setBarItems(leftItems, barItemType: .left)
    }
    
    /// 设置RightBarItem、若之前已存在barItem、则会先移除后设置.
    /// - rightItems: barItem的数组.
    func hz_setItemsToRight(rightItems: [HZNavigationBarItem?]) {
        self.hz_setBarItems(rightItems, barItemType: .right)
    }
    
    /// 新增设置LeftBarItem、若之前已存在barItem、则在其基础上新增（以增量方式进行）.
    /// - leftItems: barItem的数组.
    func hz_addItemsToLeft(leftItems: [HZNavigationBarItem?]) {
        self.hz_addBarItems(leftItems, barItemType: .left)
    }
    
    /// 新增设置RightBarItem、若之前已存在barItem、则在其基础上新增（以增量方式进行）.
    /// - rightItems: barItem的数组.
    func hz_addItemsToRight(rightItems: [HZNavigationBarItem?]) {
        self.hz_addBarItems(rightItems, barItemType: .right)
    }
    
    /// 更新LeftBarItem.
    /// - atIndex: 更新barItem的角标.
    /// - normalTitle: item默认title.
    /// - selectedTitle: item选中title.
    /// - normalImage: item默认image.
    /// - selectedImage: item选中image.
    /// - clickBarItemBlock: 替换barItem的点击方法 (可传nil).
    func hz_updateItemWithLeft(atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: UIImage? = nil, selectedImage: UIImage? = nil, clickBarItemBlock: ((_ sender: HZNavigationBarItem) -> Void)? = nil) {
        self.hz_updateBarItem(.left, atIndex: atIndex, normalTitle: normalTitle, selectedTitle: selectedTitle, normalImage: normalImage, selectedImage: selectedImage, clickBarItemBlock: clickBarItemBlock)
    }
    
    /// 更新RightBarItem.
    /// - atIndex: 更新barItem的角标.
    /// - normalTitle: item默认title.
    /// - selectedTitle: item选中title.
    /// - normalImage: item默认image.
    /// - selectedImage: item选中image.
    /// - clickBarItemBlock: 替换barItem的点击方法 (可传nil).
    func hz_updateItemWithRight(atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: UIImage? = nil, selectedImage: UIImage? = nil, clickBarItemBlock: ((_ sender: HZNavigationBarItem) -> Void)? = nil) {
        self.hz_updateBarItem(.right, atIndex: atIndex, normalTitle: normalTitle, selectedTitle: selectedTitle, normalImage: normalImage, selectedImage: selectedImage, clickBarItemBlock: clickBarItemBlock)
    }
    
    /// 隐藏LeftBarItem.
    /// - index: 需要隐藏的barItem角标，不传默认全隐藏.
    /// - hidden: 隐藏还是显示.
    func hz_hiddenItemWithLeft(_ index: Int? = nil, hidden: Bool) {
        self.hz_hiddenBarItem(.left, index: index, hidden: hidden)
    }
    
    /// 隐藏RightBarItem.
    /// - index: 需要隐藏的barItem角标，不传默认全隐藏.
    /// - hidden: 隐藏还是显示.
    func hz_hiddenItemWithRight(_ index: Int? = nil, hidden: Bool) {
        self.hz_hiddenBarItem(.right, index: index, hidden: hidden)
    }
    
    /// 点击LeftBarItem.
    /// - index: 点击barItem的角标.
    /// - clickBlock: 点击的block回调.
    func hz_clickLeftBarItem(_ index: Int = 0, clickBlock: @escaping (_ sender: HZNavigationBarItem) -> Void) {
        self.hz_clickBarItem(.left, index: index, clickBlock: clickBlock)
    }
    
    /// 点击RightBarItem.
    /// - index: 点击barItem的角标.
    /// - clickBlock: 点击的block回调.
    func hz_clickRightBarItem(_ index: Int = 0, clickBlock: @escaping (_ sender: HZNavigationBarItem) -> Void) {
        self.hz_clickBarItem(.right, index: index, clickBlock: clickBlock)
    }
    
}
