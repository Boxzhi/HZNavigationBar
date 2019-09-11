//
//  HZCustomNavigationBar.swift
//  test
//
//  Created by 何志志 on 2019/3/7.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public typealias HZNavigationBarItemClickHandler = ((HZNavigationBarItem) -> Void)

fileprivate let HZDefaultBackgroundColor: UIColor = .white
fileprivate let HZDefaultButtonTitleSize: CGFloat = 16.0
fileprivate let HZDefaultTitleSize: CGFloat = 18.0
fileprivate let HZDefaultTitleColor: UIColor = UIColor(red: 37.0/255.0, green: 43.0/255.0, blue: 51.0/255.0, alpha: 1)
fileprivate let HZTitleLabelMaxWidth: CGFloat = 180.0
fileprivate let HZScreenWidth: CGFloat = UIScreen.main.bounds.size.width
fileprivate let HZStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
fileprivate let HZNavigationBarHeight: CGFloat = 44.0
fileprivate let HZBarItemWidth: CGFloat = 44.0
fileprivate let isFullScreen: Bool = (UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight)

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
            return subViewController(base)
        }
    }
    
    class func subViewController(_ baseVc: UIViewController?) -> UIViewController? {
        if let count = baseVc?.children.count, count > 0 {
            return subViewController(baseVc?.children.last)
        }else {
            return baseVc
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
            hz_setNavigationBarBackground(image: newValue)
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
            if newValue != nil {
                hz_setTitleView(newValue!)
            }
        }
    }
    
    /// 是否隐藏navigationBar底部的细横线
    public var shadowImageHidden: Bool = false {
        willSet {
            hz_setBottomLineHidden(hidden: newValue)
        }
    }
    
    /// 设置文字颜色（title和BarItem文字颜色）
    public var themeTextColor: UIColor? {
        willSet {
            guard let _color = newValue else { return }
            hz_setThemeColor(color: _color)
        }
    }
    
    /// 第一个leftBarItem距离左边边缘的间距
    public var leftBarItemSpace: CGFloat = 10.0
    
    /// 第一个rightBarItem距离右边边缘的间距
    public var rightBarItemSpace: CGFloat = 13.0
    
    
    //MARK: - 内部存储使用的属性
    /// leftBarItem数组
    fileprivate var leftBarItems: [HZNavigationBarItem]?
    /// rightBarItem数组
    fileprivate var rightBarItems: [HZNavigationBarItem]?
    
    fileprivate lazy var leftBarItemBadgeDic: [Int: UIView] = [:]
    fileprivate lazy var rightBarItemBadgeDic: [Int: UIView] = [:]
    
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
        backgroundView.backgroundColor = .white
        backgroundView.isHidden = false
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
        titleLabel.textAlignment = .center
        titleLabel.isHidden = true
        return titleLabel
    }()
    
    /// 底部细线条
    fileprivate lazy var _bottomLine: UIView = {
        let bottomLine: UIView = UIView()
        bottomLine.backgroundColor = UIColor(red: (218.0/255.0), green: (218.0/255.0), blue: (218.0/255.0), alpha: 1.0)
        bottomLine.isHidden = false
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
        
        _titleView.frame = CGRect(x: 0, y: HZStatusBarHeight, width: bounds.size.width, height: HZNavigationBarHeight)
        
        self.constrainSubview(_backgroundView)
        self.constrainSubview(_backgroundImageView)
        self.constrainSubviewHeight(_titleView, height: HZNavigationBarHeight)
        self.constrainSubviewHeight(_titleLabel, left: (HZScreenWidth - HZTitleLabelMaxWidth) / 2.0, right:  -(HZScreenWidth - HZTitleLabelMaxWidth) / 2.0, height: HZNavigationBarHeight)
        self.constrainSubviewHeight(_bottomLine, height: 0.5)
    }
    
}

//MARK: - 内部实现方法
private extension HZCustomNavigationBar {
    
    /// 设置主题颜色（title和BarItem）
    func hz_setThemeColor(color: UIColor) {
        self.titleColor = color
        hz_setBarItemColor(color: color)
    }
    
    /// 设置背景色或背景图
    func hz_setNavigationBarBackground(color: UIColor? = nil, image: UIImage? = nil) {
        
        if let _color = color {
            _backgroundImageView.isHidden = true
            _backgroundView.isHidden = false
            _backgroundView.backgroundColor = _color
        }else if let _image = image {
            _backgroundView.isHidden = true
            _backgroundImageView.isHidden = false
            _backgroundImageView.image = _image
        }
    }
    
    /// 设置titleLabel属性
    func hz_setTitleLabel(_ text: String?, textColor: UIColor, font: UIFont) {
        
        guard let _text = text else {
            _titleLabel.isHidden = true
            return
        }
        
        _titleLabel.isHidden = false
        _titleView.isHidden = true
        
        _titleLabel.text = _text
        _titleLabel.textColor = textColor
        _titleLabel.font = font
    }
    
    /// 隐藏底部细线条
    func hz_setBottomLineHidden(hidden: Bool) {
        _bottomLine.isHidden = hidden
    }
    
    /// barItem具体添加及布局
    func hz_setBarItemsWithLayout(_ barItems: [HZNavigationBarItem], barItemType: HZNavigationBarItemType) {
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
                    self.constrainToLeadingTopBottomWidth(barItem, leading: leftBarItemSpace, top: HZStatusBarHeight, width: barItemWidth)
                }else {
                    self.constrainToLeadingTopBottomWidth(barItem, targetView: barItems[i - 1],  width: barItemWidth)
                }
            }else {
                if i == 0 {
                    self.constrainToTrailingTopBottomWidth(barItem, trailing: -rightBarItemSpace, top: HZStatusBarHeight, width: barItemWidth)
                }else {
                    self.constrainToTrailingTopBottomWidth(barItem, targetView: barItems[i - 1], width: barItemWidth)
                }
            }
            if themeTextColor != nil {
                barItem.titleColor = themeTextColor
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
    
    /// 设置barItem
    func hz_setBarItems(_ barItems: [HZNavigationBarItem?], barItemType: HZNavigationBarItemType) {
        let _barItems = barItems.compactMap({ return $0 })
        if barItemType == .left {
            if let _leftBarItems = self.leftBarItems {
                for item in _leftBarItems {
                    item.removeFromSuperview()
                }
            }
            if self.leftBarItemBadgeDic.count > 0 {
                for keyValue in self.leftBarItemBadgeDic {
                    keyValue.value.removeFromSuperview()
                }
                self.leftBarItemBadgeDic.removeAll()
            }
        }else {
            if let _rightBarItems = self.rightBarItems {
                for item in _rightBarItems {
                    item.removeFromSuperview()
                }
            }
            if self.rightBarItemBadgeDic.count > 0 {
                for keyValue in self.rightBarItemBadgeDic {
                    keyValue.value.removeFromSuperview()
                }
                self.rightBarItemBadgeDic.removeAll()
            }
        }
        self.hz_setBarItemsWithLayout(_barItems, barItemType: barItemType)
    }
    
    /// 新增barItem
    func hz_addBarItems(_ barItems: [HZNavigationBarItem?], barItemType: HZNavigationBarItemType) {
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
    
    /// 移除barItem
    func hz_removeBarItems(_ barItemType: HZNavigationBarItemType, barItemIndexs: [Int]? = nil) {
        var barItems: [HZNavigationBarItem]? = nil
        var barItemBadgeDic: [Int: UIView] = [:]
        if barItemType == .left {
            barItems = self.leftBarItems
            barItemBadgeDic = self.leftBarItemBadgeDic
        }else {
            barItems = self.rightBarItems
            barItemBadgeDic = self.rightBarItemBadgeDic
        }
        
        guard var _barItems = barItems else { return }
        if let _barItemIndexs = barItemIndexs {
            for index in _barItemIndexs {
                if index < _barItems.count {
                    _barItems[index].removeFromSuperview()
                    _barItems.remove(at: index)
                    self.hz_setBarItemsWithLayout(_barItems, barItemType: barItemType)
                }
                if barItemBadgeDic.count > 0, let badgeView = barItemBadgeDic[index] {
                    badgeView.removeFromSuperview()
                    barItemBadgeDic = barItemBadgeDic.filter({ $0.key != index })
                }
            }
        }else {
            for i in 0 ..< _barItems.count {
                _barItems[i].removeFromSuperview()
                if let badgeView = barItemBadgeDic[i] {
                    badgeView.removeFromSuperview()
                    barItemBadgeDic = barItemBadgeDic.filter({ $0.key != i })
                }
            }
            _barItems.removeAll()
        }
        
    }
    
    /// 更新barItem
    func hz_updateBarItem(_ barItemType: HZNavigationBarItemType, atIndex: Int, normalTitle: String?, selectedTitle: String?, normalImage: Any?, selectedImage: Any?, barItemClickHandler: HZNavigationBarItemClickHandler?) {
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
        if let normalImageStr = normalImage as? String {
            item.setImage(UIImage(named: normalImageStr), for: .normal)
        }else if let _normalImage = normalImage as? UIImage {
            item.setImage(_normalImage, for: .normal)
        }
        if let selectedImageStr = selectedImage as? String {
            item.setImage(UIImage(named: selectedImageStr), for: .selected)
        }else if let _selectedImage = selectedImage as? UIImage {
            item.setImage(_selectedImage, for: .selected)
        }
        if let block = barItemClickHandler {
            item.barItemNewClickHandler = block
        }
        item.barItemButtonLayoutButtonWithEdgeInsetsStyle(style: item.style, space: item.space)
    }
    
    /// 隐藏barItem
    func hz_hiddenBarItem(_ barItemType: HZNavigationBarItemType, atIndex: Int?, hidden: Bool) {
        var barItems: [HZNavigationBarItem]? = nil
        var barItemBadgeDic: [Int: UIView] = [:]
        if barItemType == .left {
            barItems = self.leftBarItems
            barItemBadgeDic = self.leftBarItemBadgeDic
        }else {
            barItems = self.rightBarItems
            barItemBadgeDic = self.rightBarItemBadgeDic
        }
        
        guard let _barItems = barItems else {
            return
        }
        if let _atIndex = atIndex, _atIndex < _barItems.count {
            _barItems[_atIndex].isHidden = hidden
            if let badgeView = barItemBadgeDic[_atIndex] {
                badgeView.isHidden = hidden
            }
        }else {
            for i in 0 ..< _barItems.count {
                _barItems[i].isHidden = hidden
                if let badgeView = barItemBadgeDic[i] {
                    badgeView.isHidden = hidden
                }
            }
        }
    }
    
    /// 点击barItem
    func hz_clickBarItem(_ barItemType: HZNavigationBarItemType, atIndex: Int, barItemClickHandler: @escaping HZNavigationBarItemClickHandler) {
        var barItems: [HZNavigationBarItem]? = nil
        if barItemType == .left {
            barItems = self.leftBarItems
        }else {
            barItems = self.rightBarItems
        }
        
        guard let _barItems = barItems else {
            return
        }
        if atIndex < _barItems.count {
            let barItem = _barItems[atIndex]
            barItem.barItemNewClickHandler = barItemClickHandler
        }
    }
    
    /// 给barItem设置badge
    func hz_showBarItemBadge(_ barItemType: HZNavigationBarItemType, atIndex: Int, color: UIColor? = nil, badgeImage: Any? = nil, size: CGSize, offset: CGPoint) {
        var barItems: [HZNavigationBarItem]? = nil
        var barItemBadgeDic: [Int: UIView] = [:]
        if barItemType == .left {
            barItems = self.leftBarItems
            barItemBadgeDic = self.leftBarItemBadgeDic
        }else {
            barItems = self.rightBarItems
            barItemBadgeDic = self.rightBarItemBadgeDic
        }
        
        guard let _barItems = barItems  else { return }
        if atIndex < _barItems.count {
            if let _ = barItemBadgeDic[atIndex] {   // 防止重复创建
                return
            }
            var badgeView: UIView = UIView()
            let _size = size == .zero ? CGSize(width: 8.0, height: 8.0) : size
            if let _badgeImage = badgeImage {
                let imageView = UIImageView()
                if let imageStr = _badgeImage as? String {
                    imageView.image = UIImage(named: imageStr)
                }else if let _image = _badgeImage as? UIImage {
                    imageView.image = _image
                }else {
                    return
                }
                badgeView = imageView
            }else {
                badgeView.backgroundColor = color
                badgeView.layer.cornerRadius = min(_size.width, _size.height) / 2.0
            }
            self.addSubview(badgeView)
            let barItem = _barItems[atIndex]
            self.constrainBadgeView(badgeView, targetView: barItem, size: _size, offset: offset)
            if barItemType == .left {
                leftBarItemBadgeDic[atIndex] = badgeView
            }else {
                rightBarItemBadgeDic[atIndex] = badgeView
            }
        }
        
    }
    
    /// 移除barItem的badge
    func hz_hiddenBarItemBadge(_ barItemType: HZNavigationBarItemType, atIndex: Int? = nil) {
        var barItemBadgeDic: [Int: UIView] = [:]
        if barItemType == .left {
            barItemBadgeDic = leftBarItemBadgeDic
        }else {
            barItemBadgeDic = rightBarItemBadgeDic
        }
        
        if let _atIndex = atIndex {
            if let badgeView = barItemBadgeDic[_atIndex] {
                badgeView.removeFromSuperview()
                barItemBadgeDic = barItemBadgeDic.filter({ $0.key != _atIndex })
            }
        }else {
            if barItemBadgeDic.count > 0 {
                for keyValue in barItemBadgeDic {
                    keyValue.value.removeFromSuperview()
                }
                barItemBadgeDic.removeAll()
            }
        }
    }
    
}

//MARK: - 外部可调用方法来设置一些属性
public extension HZCustomNavigationBar {
    
    /// 外部快速创建方法
    class func customNavigationBar() -> HZCustomNavigationBar {
        return HZCustomNavigationBar(frame: CGRect(x: 0, y: 0, width: HZScreenWidth, height: statusNavigationBarHeight))
    }
    
    /// 设置NavigationBar的titleView.
    /// - view: titleView.
    /// - titleViewSize: titleView的size (优先传值的size, 若没有则用view自身size).
    /// - isCenter: 是否在bar上居中显示 (默认居中).
    func hz_setTitleView(_ view: UIView, size: CGSize? = nil, isCenter: Bool = true) {
        
        for subView in _titleView.subviews {
            subView.removeFromSuperview()
        }
        self._titleView.isHidden = false
        self._titleLabel.isHidden = true
        
        if view.isKind(of: UIButton.self) {
            let _button = view as! UIButton
            _button.contentMode = .center
            _titleView.addSubview(_button)
            _titleView.constrainCenteredAutoWidth(_button)
            
        }else {
            
            var viewSize: CGSize = view.frame.size   // 自身size
            let _titleViewWidth: CGFloat = _titleView.bounds.width
            let _titleViewHeight: CGFloat = _titleView.bounds.height
            
            if viewSize.width == 0, viewSize.height == 0, size == nil {
                viewSize = CGSize(width: _titleViewWidth, height: _titleViewHeight)
            }else if let _size = size {
                if _size.width != 0, _size.height != 0 {
                    viewSize = CGSize(width: _titleViewHeight * _size.width / _size.height, height: _titleViewHeight)
                }else if _size.width == 0, _size.height == 0 {
                    viewSize = CGSize(width: _titleViewWidth, height: _titleViewHeight)
                }else if _size.width == 0 {
                    viewSize = CGSize(width: _titleViewWidth, height: _size.height < _titleViewHeight ? _size.height : _titleViewHeight)
                }else {
                    viewSize = CGSize(width: _size.width < _titleViewWidth ? _size.width : _titleViewWidth, height: _titleViewHeight)
                }
            }else {
                let height: CGFloat = viewSize.height < _titleViewHeight ? viewSize.height : _titleViewHeight
                if viewSize.width == 0  {
                    viewSize = CGSize(width: _titleViewWidth, height: height)
                }else if viewSize.height == 0 {
                    viewSize = CGSize(width: viewSize.width < _titleViewWidth ? viewSize.width : _titleViewWidth, height: _titleViewHeight)
                }else {
                    let width: CGFloat = viewSize.width * height / viewSize.height
                    viewSize = CGSize(width: width, height: height)
                }
            }
            
            if isCenter {
                _titleView.frame = CGRect(x: (self.bounds.width - viewSize.width) / 2, y: HZStatusBarHeight, width: viewSize.width, height: HZNavigationBarHeight)
                self.constrainFrameWidthHeight(_titleView)
                view.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
                _titleView.addSubview(view)
                _titleView.constrainCentered(view)
            }else {
                view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: viewSize.width, height: viewSize.height)
                _titleView.addSubview(view)
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
    
    /// 设置LeftBarItem，若之前已存在barItem，则会先移除后设置.
    /// - leftItems: barItem的数组.
    func hz_setItemsToLeft(leftItems: [HZNavigationBarItem?]) {
        self.hz_setBarItems(leftItems, barItemType: .left)
    }
    
    /// 设置RightBarItem，若之前已存在barItem，则会先移除后设置.
    /// - rightItems: barItem的数组.
    func hz_setItemsToRight(rightItems: [HZNavigationBarItem?]) {
        self.hz_setBarItems(rightItems, barItemType: .right)
    }
    
    /// 新增设置LeftBarItem，若之前已存在barItem，则在其基础上新增（以增量方式进行）.
    /// - leftItems: barItem的数组.
    func hz_addItemsToLeft(leftItems: [HZNavigationBarItem?]) {
        self.hz_addBarItems(leftItems, barItemType: .left)
    }
    
    /// 新增设置RightBarItem，若之前已存在barItem，则在其基础上新增（以增量方式进行）.
    /// - rightItems: barItem的数组.
    func hz_addItemsToRight(rightItems: [HZNavigationBarItem?]) {
        self.hz_addBarItems(rightItems, barItemType: .right)
    }
    
    /// 移除LeftBarItem.
    /// - indexs: barItem的角标(从左到右)数组，不传默认全移除.
    func hz_removeItemWithLeft(indexs: [Int]? = nil) {
        self.hz_removeBarItems(.left, barItemIndexs: indexs)
    }
    
    /// 移除RightBarItem.
    /// - indexs: barItem的角标(从右到左)数组，不传默认全移除.
    func hz_removeItemWithRight(indexs: [Int]? = nil) {
        self.hz_removeBarItems(.right, barItemIndexs: indexs)
    }
    
    /// 更新LeftBarItem.
    /// - atIndex: 更新barItem的角标.
    /// - normalTitle: item默认title.
    /// - selectedTitle: item选中title.
    /// - normalImage: item默认image.
    /// - selectedImage: item选中image.
    /// - barItemClickHandler: 替换barItem的点击方法 (可传nil).
    func hz_updateItemWithLeft(atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil) {
        self.hz_updateBarItem(.left, atIndex: atIndex, normalTitle: normalTitle, selectedTitle: selectedTitle, normalImage: normalImage, selectedImage: selectedImage, barItemClickHandler: barItemClickHandler)
    }
    
    /// 更新RightBarItem.
    /// - atIndex: 更新barItem的角标.
    /// - normalTitle: item默认title.
    /// - selectedTitle: item选中title.
    /// - normalImage: item默认image.
    /// - selectedImage: item选中image.
    /// - barItemClickHandler: 替换barItem的点击方法 (可传nil).
    func hz_updateItemWithRight(atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil) {
        self.hz_updateBarItem(.right, atIndex: atIndex, normalTitle: normalTitle, selectedTitle: selectedTitle, normalImage: normalImage, selectedImage: selectedImage, barItemClickHandler: barItemClickHandler)
    }
    
    /// 隐藏LeftBarItem.
    /// - atIndex: 需要隐藏的barItem角标，不传默认全隐藏.
    /// - hidden: 隐藏还是显示.
    func hz_hiddenItemWithLeft(_ atIndex: Int? = nil, hidden: Bool) {
        self.hz_hiddenBarItem(.left, atIndex: atIndex, hidden: hidden)
    }
    
    /// 隐藏RightBarItem.
    /// - atIndex: 需要隐藏的barItem角标，不传默认全隐藏.
    /// - hidden: 隐藏还是显示.
    func hz_hiddenItemWithRight(_ atIndex: Int? = nil, hidden: Bool) {
        self.hz_hiddenBarItem(.right, atIndex: atIndex, hidden: hidden)
    }
    
    /// 更新LeftBarItem点击事件方法.
    /// - atIndex: 点击barItem的角标.
    /// - barItemClickHandler: 点击的block回调.
    func hz_clickLeftBarItem(_ atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler) {
        self.hz_clickBarItem(.left, atIndex: atIndex, barItemClickHandler: barItemClickHandler)
    }
    
    /// 更新RightBarItem点击事件方法.
    /// - atIndex: 点击barItem的角标.
    /// - barItemClickHandler: 点击的block回调.
    func hz_clickRightBarItem(_ atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler) {
        self.hz_clickBarItem(.right, atIndex: atIndex, barItemClickHandler: barItemClickHandler)
    }
    
    /// 设置LeftBarItem的badge (自定义颜色).
    /// - atIndex: barItem的角标.
    /// - size: badge的尺寸 (默认为CGSize(width: 8.0, height: 8.0)).
    /// - color: badge的颜色.
    func hz_showLeftBarItemBadge(atIndex: Int = 0, size: CGSize = .zero, color: UIColor = UIColor(red: 245/255, green: 73/255, blue: 102/255, alpha: 1), offset: CGPoint = .zero) {
        self.hz_showBarItemBadge(.left, atIndex: atIndex, color: color, size: size, offset: offset)
    }
    
    /// 设置RightBarItem的badge (自定义颜色).
    /// - atIndex: barItem的角标.
    /// - size: badge的尺寸 (默认为CGSize(width: 8.0, height: 8.0)).
    /// - color: badge的颜色.
    func hz_showRightBarItemBadge(atIndex: Int = 0, size: CGSize = .zero, color: UIColor = UIColor(red: 245/255, green: 73/255, blue: 102/255, alpha: 1), offset: CGPoint = .zero) {
        self.hz_showBarItemBadge(.right, atIndex: atIndex, color: color, size: size, offset: offset)
    }
    
    /// 设置LeftBarItem的badge (自定义图片).
    /// - atIndex: barItem的角标.
    /// - size: badge的尺寸 (默认为CGSize(width: 8.0, height: 8.0)).
    /// - image: badge的图片.
    func hz_showLeftBarItemBadgeImage(atIndex: Int = 0,  size: CGSize = .zero, image: Any, offset: CGPoint = .zero) {
        self.hz_showBarItemBadge(.left, atIndex: atIndex, badgeImage: image, size: size, offset: offset)
    }
    
    /// 设置RightBarItem的badge (自定义图片).
    /// - atIndex: barItem的角标.
    /// - size: badge的尺寸 (默认为CGSize(width: 8.0, height: 8.0)).
    /// - image: badge的图片.
    func hz_showRightBarItemBadgeImage(atIndex: Int = 0,  size: CGSize = .zero, image: Any, offset: CGPoint = .zero) {
        self.hz_showBarItemBadge(.right, atIndex: atIndex, badgeImage: image, size: size, offset: offset)
    }
    
    /// 隐藏（移除）LeftBarItem的badge.
    /// - atIndex: barItem的角标 (不传默认左侧badge全隐藏).
    func hz_hiddenLeftBarItemBadge(_ atIndex: Int? = nil) {
        self.hz_hiddenBarItemBadge(.left, atIndex: atIndex)
    }
    
    /// 隐藏（移除）LeftBarItem的badge.
    /// - atIndex: barItem的角标 (不传默认右侧badge全隐藏).
    func hz_hiddenRightBarItemBadge(_ atIndex: Int? = nil) {
        self.hz_hiddenBarItemBadge(.right, atIndex: atIndex)
    }
    
}
