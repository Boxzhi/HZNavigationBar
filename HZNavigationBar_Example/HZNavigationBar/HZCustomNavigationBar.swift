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
fileprivate let HZBarItemWidth: CGFloat = 36.0

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
    public var isHiddenBottomLine: Bool = false {
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

//MARK: - 外部可调用方法
public extension HZCustomNavigationBar {
    
    /// 外部快速创建方法
    public class func customNavigationBar() -> HZCustomNavigationBar {
        return HZCustomNavigationBar(frame: CGRect(x: 0, y: 0, width: HZScreenWidth, height: statusNavigationBarHeight))
    }
    
    /// 设置NavigationBar的titleView，若view有设置frame，则可不传titleViewSize，若两者都无，则默认占据整个NavigationBar
    public func hz_setTitleView(_ view: UIView?, titleViewSize: CGSize? = nil) {
        
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
            
            var newTitleViewSize: CGSize? = _view.frame.size
            let _titleViewWidth: CGFloat = _titleView.bounds.width
            let _titleViewHeight: CGFloat = _titleView.bounds.height
            
            if let _titleViewSize = titleViewSize {
                if _titleViewSize.width == 0 && _titleViewSize.height == 0 {
                    newTitleViewSize = CGSize(width: _titleViewWidth, height: _titleViewHeight)
                }else if _titleViewSize.width == 0 {
                    newTitleViewSize = CGSize(width: _titleViewWidth, height: _titleViewSize.height)
                }else {
                    newTitleViewSize = CGSize(width: _titleViewSize.width, height: _titleViewHeight)
                }
            }else if let _newTitleViewSize = newTitleViewSize {
                if _newTitleViewSize.width != 0 && _newTitleViewSize.height != 0 {
                    let height: CGFloat = _newTitleViewSize.height < _titleViewHeight ? _newTitleViewSize.height : _titleViewHeight
                    if _newTitleViewSize.width < _titleViewWidth {
                        newTitleViewSize = CGSize(width: _newTitleViewSize.width, height: height)
                    }else {
                        let width: CGFloat = _newTitleViewSize.width * height / _newTitleViewSize.height
                        newTitleViewSize = CGSize(width: width < _titleViewWidth ? width : _titleViewWidth, height: height)
                    }
                }else if _newTitleViewSize.width == 0 {
                    let height: CGFloat = _newTitleViewSize.height < _titleViewHeight ? _newTitleViewSize.height : _titleViewHeight
                    newTitleViewSize = CGSize(width: _titleViewWidth, height: height)
                }else {
                    let width: CGFloat = _newTitleViewSize.width < _titleViewWidth ? _newTitleViewSize.width : _titleViewWidth
                    newTitleViewSize = CGSize(width: width, height: _titleViewHeight)
                }
            }else {
                newTitleViewSize = CGSize(width: _titleViewWidth, height: _titleViewHeight)
            }
            
            _titleView.frame = CGRect(x: (self.bounds.width - (newTitleViewSize?.width)!) / 2, y: HZStatusBarHeight, width: (newTitleViewSize?.width)!, height: HZNavigationBarHeight)
            _view.frame = CGRect(x: 0, y: 0, width: (newTitleViewSize?.width)!, height: (newTitleViewSize?.height)!)
            _titleView.addSubview(_view)
            _titleView.constrainCentered(_view)
        }
        
    }
    
    /// 设置NavigationBar底部阴影
    public func hz_setBottomShadow(_ isShow: Bool = false, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float = 1, shadowRadius: CGFloat? = nil) {
        
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
    public func hz_setThemeColor(color: UIColor) {
        self.titleColor = color
        hz_setBarItemColor(color: color)
    }
    
    /// 设置BarItem按钮颜色
    public func hz_setBarItemColor(color: UIColor) {
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
    public func hz_setBackgroundAlpha(alpha: CGFloat) {
        _backgroundView.alpha = alpha
        _backgroundImageView.alpha = alpha
        _bottomLine.alpha = alpha
    }
    
    /// 给navigationBar左侧设置batItem，该方法会将该侧已有的barItem全部移除，慎用！！
    /// 若只是新增，请用hz_addItemsToLeft
    public func hz_setAllItemsToLeft(leftItems: [HZNavigationBarItem?]) {
    
        let _leftItems = leftItems.compactMap({ return $0 })
        if let _leftBarItems = self.leftBarItems {
            for item in _leftBarItems {
                item.removeFromSuperview()
            }
        }
        self.setLeftBarItems(_leftItems)
    }
    
    /// 给navigationBar右侧设置batItem，该方法会将该侧已有的barItem全部移除，慎用！！
    /// 若只是新增，请用hz_addItemsToRight
    public func hz_setAllItemsToRight(rightItems: [HZNavigationBarItem?]) {
        
        let _rightItems = rightItems.compactMap({ return $0 })
        if let _rightBarItems = self.rightBarItems {
            for item in _rightBarItems {
                item.removeFromSuperview()
            }
        }
        self.setRightBarItems(_rightItems)
    }
    
    /// 设置或新增左侧BarItem（以增量方式进行）
    public func hz_addItemsToLeft(leftItems: [HZNavigationBarItem?]) {
        
        let _leftItems = leftItems.compactMap({ return $0 })
        if let _leftBarItems = self.leftBarItems {
            self.setLeftBarItems( _leftBarItems + _leftItems)
        }else {
            self.setLeftBarItems(_leftItems)
        }
    }
    
    /// 设置或新增右侧BarItem（以增量方式进行）
    public func hz_addItemsToRight(rightItems: [HZNavigationBarItem?]) {
        
        let _rightItems = rightItems.compactMap({ return $0 })
        if let _rightBarItems = self.rightBarItems {
            self.setRightBarItems(_rightBarItems + _rightItems)
        }else {
            self.setRightBarItems(_rightItems)
        }
    }
    
    /// 更新左侧BarItem
    public func updateLeftItem(atIndex: Int = 0, normalTitle: String? = nil, normalImage: UIImage?, clickBarItemBlock: (() -> Void)?) {
        guard let _leftItems = self.leftBarItems, atIndex < _leftItems.count else {
            return
        }
        
        let item: HZNavigationBarItem = _leftItems[atIndex]
        if normalTitle != nil {
            item.setTitle(normalTitle, for: .normal)
        }
        item.setImage(normalImage, for: .normal)
        item.newClickBarItemBlock = clickBarItemBlock
        item.barItemButtonLayoutButtonWithEdgeInsetsStyle(style: item.style, space: item.space)
    }
    
    /// 更新右侧BarItem
    public func updateRightItem(atIndex: Int = 0, normalTitle: String? = nil, normalImage: UIImage?, clickBarItemBlock: (() -> Void)?) {
        guard let _rightItems = self.rightBarItems, atIndex < _rightItems.count else {
            return
        }
        
        let item: HZNavigationBarItem = _rightItems[atIndex]
        if normalTitle != nil {
            item.setTitle(normalTitle, for: .normal)
        }
        item.setImage(normalImage, for: .normal)
        item.newClickBarItemBlock = clickBarItemBlock
        item.barItemButtonLayoutButtonWithEdgeInsetsStyle(style: item.style, space: item.space)
    }
    
    /// 隐藏左侧BarItem
    public func hz_setLeftBarItemHidden(_ index: Int? = nil, hidden: Bool) {
        guard let _leftBarItems = self.leftBarItems else {
            return
        }
        
        if let _index = index, _index < _leftBarItems.count {
            for _ in 0 ..< _leftBarItems.count {
                _leftBarItems[_index].isHidden = hidden
            }
        }else {
            for barItem in _leftBarItems {
                barItem.isHidden = hidden
            }
        }
    }
    
    /// 隐藏右侧BarItem
    public func hz_setRightBarItemHidden(_ index: Int? = nil, hidden: Bool) {
        guard let _rightBarItems = self.rightBarItems else {
            return
        }
        
        if let _index = index, _index < _rightBarItems.count {
            for _ in 0 ..< _rightBarItems.count {
                _rightBarItems[_index].isHidden = hidden
            }
        }else {
            for barItem in _rightBarItems {
                barItem.isHidden = hidden
            }
        }
    }
    
     /// 点击LeftBarItem方法
     ///  index:  点击第几个item、0代表最左边第一个（默认）
     ///  clickBlock:  点击方法回调
    public func hz_clickLeftBarItem(_ index: Int = 0, clickBlock: @escaping () -> Void) {
        
        guard let _leftBarItems = self.leftBarItems else {
            return
        }
        
        if index < _leftBarItems.count {
            let barItem = _leftBarItems[index]
            barItem.newClickBarItemBlock = clickBlock
        }
    }
    
    /// 点击RightBarItem方法
    ///  index:  点击第几个item、0代表最左边第一个（默认）
    ///  clickBlock:  点击方法回调
    public func hz_clickRightBarItem(_ index: Int = 0, clickBlock: @escaping () -> Void) {
        
        guard let _rightBarItems = self.rightBarItems else {
            return
        }
        
        if index < _rightBarItems.count {
            let barItem = _rightBarItems[index]
            barItem.newClickBarItemBlock = clickBlock
        }
    }
    
}

//MARK: - 内部实现方法
extension HZCustomNavigationBar {
    
    /// 设置背景色或背景图
    fileprivate func hz_setNavigationBarBackground(color: UIColor? = nil, backgroundImage: UIImage? = nil) {
        
        if let _color = color {
            _backgroundView.isHidden = false
            _backgroundImageView.isHidden = true
            _backgroundView.backgroundColor = _color
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
    
    /// 左侧BarItem具体添加及布局
    fileprivate func setLeftBarItems(_ leftItems: [HZNavigationBarItem]) {

        for i in 0 ..< leftItems.count {
            
            let barItem: HZNavigationBarItem = leftItems[i]
            self.addSubview(barItem)
            if i == 0 {
                self.constrainToLeadingTopBottomWidth(barItem, leading: HZLeftBarItemSpace, top: HZStatusBarHeight, width: barItem.title(for: .normal) == nil ? HZBarItemWidth : nil)

            }else {
                self.constrainToLeadingTopBottomWidth(barItem, targetView: leftItems[i - 1],  width: barItem.title(for: .normal) == nil ? HZBarItemWidth : nil)
            }
            
            if themeColor != nil {
                barItem.titleColor = themeColor
            }
        }
        self.leftBarItems?.removeAll()
        self.leftBarItems = leftItems
    }
    
    /// 右侧BarItem具体添加及布局
    fileprivate func setRightBarItems(_ rightItems: [HZNavigationBarItem]) {
        
        for i in 0 ..< rightItems.count {
            
            let barItem: HZNavigationBarItem = rightItems[i]
            self.addSubview(barItem)
            if i == 0 {
                self.constrainToTrailingTopBottomWidth(barItem, trailing: -HZRightBarItemSpace, top: HZStatusBarHeight, width: barItem.title(for: .normal) == nil ? HZBarItemWidth : nil)
            }else {
                self.constrainToTrailingTopBottomWidth(barItem, targetView: rightItems[i - 1], width: barItem.title(for: .normal) == nil ? HZBarItemWidth : nil)
            }
            if themeColor != nil {
                barItem.titleColor = themeColor
            }
        }
        self.rightBarItems?.removeAll()
        self.rightBarItems = rightItems
    }
}
