//
//  HZCustomNavigationBar.swift
//  test
//
//  Created by 何志志 on 2019/3/7.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

public typealias HZNavigationBarItemClickHandler = ((HZNavigationBarItem) -> Void)

public extension UIViewController {
    
    /// 返回上个页面
    func backLastViewController(animated: Bool) {
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
    
    static func currentViewController(with baseVc: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = baseVc as? UINavigationController {
            return currentViewController(with: nav.visibleViewController)
        }else if let tab = baseVc as? UITabBarController {
            return currentViewController(with: tab.selectedViewController)
        }else if let presented = baseVc?.presentedViewController {
            return currentViewController(with: presented)
        }else {
            return lastChildController(with: baseVc)
        }
    }
    
    static func lastChildController(with baseVc: UIViewController?) -> UIViewController? {
        if let count = baseVc?.children.count, count > 0 {
            return lastChildController(with: baseVc?.children.last)
        }else {
            return baseVc
        }
    }
    
}

public struct HZNavigationBarWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
public protocol HZCustomNavigationBarCompatible: AnyObject { }
extension HZCustomNavigationBarCompatible {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var hz: HZNavigationBarWrapper<Self> {
        get { return HZNavigationBarWrapper(self) }
        set { }
    }
}
extension HZCustomNavigationBar: HZCustomNavigationBarCompatible {}

open class HZCustomNavigationBar: UIView {
    
    /// 是否是iPad
    public static var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 是否刘海屏
    public static var isNotch: Bool {
        return HZCustomNavigationBar.statusBarHeight > 20.0
    }
    
    /// 屏幕宽度
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// 状态栏高度
    public static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let _statusBarHeight = HZCustomNavigationBar.isiPad ? 24.0 : 20.0
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return _statusBarHeight }
            guard let statusBarManager = windowScene.statusBarManager else { return _statusBarHeight }
            return statusBarManager.statusBarFrame.height
        }else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    /// 导航栏高度
    public static var navigationBarHeight: CGFloat {
        return HZCustomNavigationBar.isiPad ? 50.0 : 44.0
    }
    
    /// 状态栏+导航栏高度
    public static var statusNavigationBarHeight: CGFloat {
        return HZCustomNavigationBar.statusBarHeight + HZCustomNavigationBar.navigationBarHeight
    }
    
    /// 背景默认颜色
    fileprivate static let defaultBackgroundColor: UIColor = .white
    
    /// titleLabel文字默认大小
    fileprivate static let defaultTitleSize: CGFloat = 18.0
    
    /// titleLabel文字默认颜色
    fileprivate static let defaultTitleColor: UIColor = UIColor(red: 37.0/255.0, green: 43.0/255.0, blue: 51.0/255.0, alpha: 1)

    //MARK: - 外部设置属性
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
    
    /// 大背景颜色
    public var bgColor: UIColor? {
        willSet {
            hz_setBackground(color: newValue)
        }
    }
    
    /// 大背景图
    public var bgImage: UIImage? {
        willSet {
            hz_setBackground(image: newValue)
        }
    }
    
    /// 大背景透明度
    public var bgAlpha: CGFloat? {
        willSet {
            hz_setBackground(alpha: newValue)
        }
    }
    
    /// statusBar背景颜色
    public var statusBarColor: UIColor? {
        willSet {
            hz_setStatusBarBackgroundColor(newValue)
        }
    }
    
    /// navigationBar背景颜色
    public var navigationBarBackgroundColor: UIColor? {
        willSet {
            hz_setNavigationBarBackground(color: newValue)
        }
    }
    
    /// navigationBar背景图片
    public var navigationBarBackgroundImage: UIImage? {
        willSet {
            hz_setNavigationBarBackground(image: newValue)
        }
    }
    
    /// navigationBar标题文字
    public var title: String? {
        willSet {
            hz_setTitleLabel(newValue)
        }
    }
    
    /// navigationBar标题颜色
    public var titleColor: UIColor? {
        willSet {
            hz_setTitleLabel(titleColor: newValue)
        }
    }
    
    /// navigationBar标题字体
    public var titleFont: UIFont? {
        willSet {
            hz_setTitleLabel(font: newValue)
        }
    }
    
    /// navigationBar标题富文本
    public var titleAttributedString: NSAttributedString? {
        willSet {
            hz_setTitleLabel(titleAttributedString: newValue)
        }
    }
    
    /// navigationBar的titleView
    public var titleView: UIView? {
        willSet {
            guard let _newValue = newValue else { return }
            hz_setTitleView(_newValue)
        }
    }
    
    /// 是否隐藏navigationBar底部的细横线
    public var shadowImageHidden: Bool = false {
        willSet {
            hz_setShadowLineHidden(newValue)
        }
    }
    
    /// 设置主题颜色（title和BarItem文字颜色）
    public var themeColor: UIColor? {
        willSet {
            hz_setThemeColor(newValue)
        }
    }
    
    /// 第一个leftBarItem距离左边边缘的间距
    public var leftBarItemMargin: CGFloat = 10.0
    
    /// 第一个rightBarItem距离右边边缘的间距
    public var rightBarItemMargin: CGFloat = 10.0
    
    /// titleView是否居中
    public var titleViewIsCenter: Bool = true
    
    /// titleView左边间距
    public var leftTitleViewMargin: CGFloat = 0
    
    /// titleView右边间距
    public var rightTitleViewMargin: CGFloat = 0
    
    //MARK: - 内部使用属性
    /// leftBarItem数组
    fileprivate var leftBarItems: [HZNavigationBarItem]?
    fileprivate var leftBarItemTotalWidth: CGFloat = 0
    /// rightBarItem数组
    fileprivate var rightBarItems: [HZNavigationBarItem]?
    fileprivate var rightBarItemTotalWidth: CGFloat = 0
    
    fileprivate lazy var leftBarItemBadgeDic: [Int: UIView] = [:]
    fileprivate lazy var rightBarItemBadgeDic: [Int: UIView] = [:]
    
    //MARK: - 子View
    /// 背景View
    fileprivate lazy var backgroundView: UIView = {
        let _backgroundView = UIView()
        _backgroundView.backgroundColor = HZCustomNavigationBar.defaultBackgroundColor
        return _backgroundView
    }()
    
    /// 背景ImageView
    fileprivate lazy var backgroundImageView: UIImageView = {
        let _backgroundImageView = UIImageView()
        _backgroundImageView.backgroundColor = .clear
        _backgroundImageView.isHidden = true
        return _backgroundImageView
    }()

    /// statusBarView
    fileprivate lazy var statusBarView: UIView = {
        let _statusBarView = UIView()
        _statusBarView.backgroundColor = .clear
        return _statusBarView
    }()
    
    /// navigationBarView
    fileprivate lazy var navigationBarView: UIView = {
        let _navigationBarView = UIView()
        _navigationBarView.backgroundColor = .clear
        return _navigationBarView
    }()
    
    /// 导航栏背景ImageView
    fileprivate lazy var navigationBarBackgroundImageView: UIImageView = {
        let _navigationBarBackgroundImageView = UIImageView()
        _navigationBarBackgroundImageView.backgroundColor = .clear
        _navigationBarBackgroundImageView.isHidden = true
        return _navigationBarBackgroundImageView
    }()
    
    /// titleView
    fileprivate lazy var _titleView: UIView = {
        let titleView_ = UIView()
        titleView_.backgroundColor = .clear
        titleView_.isHidden = true
        return titleView_
    }()
    
    /// titleLabel
    fileprivate lazy var titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.backgroundColor = .clear
        _titleLabel.text = ""
        _titleLabel.textColor = HZCustomNavigationBar.defaultTitleColor
        _titleLabel.font = UIFont.systemFont(ofSize: HZCustomNavigationBar.defaultTitleSize)
        _titleLabel.textAlignment = .center
        return _titleLabel
    }()
    
    /// 底部细线条
    fileprivate lazy var shadowLine: UIView = {
        let _shadowLine = UIView()
        _shadowLine.backgroundColor = UIColor(red: (218.0/255.0), green: (218.0/255.0), blue: (218.0/255.0), alpha: 1.0)
        _shadowLine.isHidden = shadowImageHidden
        return _shadowLine
    }()
    
    //MARK: - 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setBaseUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBaseUI()
    }
    
    fileprivate func setBaseUI() {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.backgroundColor = .clear
        addSubview(backgroundView)
        addSubview(backgroundImageView)
        addSubview(statusBarView)
        addSubview(navigationBarView)
        navigationBarView.addSubview(navigationBarBackgroundImageView)
        navigationBarView.addSubview(_titleView)
        navigationBarView.addSubview(titleLabel)
        navigationBarView.addSubview(shadowLine)
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        
        addConstraints(with: backgroundView, top: 0, bottom: 0, left: 0, right: 0)
        addConstraints(with: backgroundImageView, top: 0, bottom: 0, left: 0, right: 0)
        addConstraints(with: statusBarView, top: 0, left: 0, right: 0, height: HZCustomNavigationBar.statusBarHeight)
        addConstraints(with: navigationBarView, bottom: 0, left: 0, right: 0, height: HZCustomNavigationBar.navigationBarHeight)
        navigationBarView.addConstraints(with: navigationBarBackgroundImageView, top: 0, bottom: 0, left: 0, right: 0)
        updateTitleConstraints()
        navigationBarView.addConstraints(with: shadowLine, bottom: 0, left: 0, right: 0, height: 0.5)
    }
    
    fileprivate func updateTitleConstraints() {
        if titleViewIsCenter {
            navigationBarView.addConstraints(with: _titleView, top: 0, bottom: 0, left: max(leftTitleViewMargin + leftBarItemTotalWidth, rightTitleViewMargin + rightBarItemTotalWidth), right: -max(leftTitleViewMargin + leftBarItemTotalWidth, rightTitleViewMargin + rightBarItemTotalWidth), prioritys: [.left: 900.0, .right: 900.0])
        }else {
            navigationBarView.addConstraints(with: _titleView, top: 0, bottom: 0, left: leftTitleViewMargin, right: -rightTitleViewMargin, toItems: [.left: leftBarItems?.last, .right: rightBarItems?.last], itemAttributes: [.left: leftBarItems?.last == nil ? .left : .right, .right: rightBarItems?.last == nil ? .right : .left], prioritys: [.left: 900.0, .right: 900.0])
        }
        navigationBarView.addConstraints(with: titleLabel, top: 0, bottom: 0, width: min(HZCustomNavigationBar.screenWidth / 2.0, HZCustomNavigationBar.screenWidth - max(leftBarItemTotalWidth, rightBarItemTotalWidth) * 2.0 - leftTitleViewMargin - rightTitleViewMargin), centerX: 0, prioritys: [.width: 850])
    }
    
}

//MARK: - 内部属性设置方法
private extension HZCustomNavigationBar {
    
    /// 设置主题颜色（title和BarItem文字颜色）
    func hz_setThemeColor(_ color: UIColor?) {
        if let _color = color {
            self.titleColor = _color
            hz_setBarItemColor(_color)
        }
    }
    
    /// 设置大背景色或背景图
    func hz_setBackground(color: UIColor? = nil, image: UIImage? = nil, alpha: CGFloat? = nil) {
        if let _color = color {
            self.statusBarView.backgroundColor = .clear
            self.navigationBarView.backgroundColor = .clear
            self.navigationBarBackgroundImageView.isHidden = true
            self.titleLabel.backgroundColor = .clear
            self.backgroundImageView.isHidden = true
            self.backgroundView.backgroundColor = _color
        }else if let _image = image {
            self.statusBarView.backgroundColor = .clear
            self.navigationBarView.backgroundColor = .clear
            self.navigationBarBackgroundImageView.isHidden = true
            self.titleLabel.backgroundColor = .clear
            self.backgroundImageView.isHidden = false
            self.backgroundImageView.image = _image
        }
        if let _alpha = alpha {
            self.backgroundView.alpha = _alpha
            self.shadowLine.alpha = _alpha
        }
    }
    
    /// 设置statusBar背景色
    func hz_setStatusBarBackgroundColor(_ color: UIColor?) {
        if let _color = color {
            self.statusBarView.backgroundColor = _color
        }
    }
    
    /// 设置导航栏背景
    func hz_setNavigationBarBackground(color: UIColor? = nil, image: UIImage? = nil) {
        if let _color = color {
            self.navigationBarBackgroundImageView.isHidden = true
            self.navigationBarView.backgroundColor = _color
        }else if let _image = image {
            self.navigationBarBackgroundImageView.isHidden = false
            self.navigationBarBackgroundImageView.image = _image
        }
    }
    
    /// 设置titleLabel属性
    func hz_setTitleLabel(_ text: String? = nil, titleColor: UIColor? = nil, font: UIFont? = nil, titleAttributedString: NSAttributedString? = nil) {
        if let _text = text {
            _titleView.isHidden = true
            titleLabel.isHidden = false
            titleLabel.text = _text
        }else if let _titleColor = titleColor {
            _titleView.isHidden = true
            titleLabel.isHidden = false
            titleLabel.textColor = _titleColor
        }else if let _font = font {
            _titleView.isHidden = true
            titleLabel.isHidden = false
            titleLabel.font = _font
        }else if let _titleAttributedString = titleAttributedString {
            _titleView.isHidden = true
            titleLabel.attributedText = _titleAttributedString
        }
    }
    
    /// 设置titleView
    func hz_setTitleView(_ view: UIView, size: CGSize? = nil) {
        self._titleView.subviews.forEach({ $0.removeFromSuperview() })
        self._titleView.addSubview(view)
        self._titleView.isHidden = false
        self.titleLabel.isHidden = true
        if let _button = view as? UIButton {
            _button.contentMode = .center
            self._titleView.addConstraints(with: _button, top: 0, bottom: 0, centerX: 0)
        }else {
            if let _imageView = view as? UIImageView {
                _imageView.contentMode = .scaleAspectFit
            }
            var viewSize = view.bounds.size
            if let _size = size {
                viewSize = _size
            }
            if viewSize.width == 0, viewSize.height == 0 {
                self._titleView.addConstraints(with: view, top: 0, bottom: 0, left: 0, right: 0)
            }else if viewSize.width != 0, viewSize.height != 0 {
                self._titleView.addConstraints(with: view, width: min(viewSize.width, HZCustomNavigationBar.screenWidth - leftTitleViewMargin - rightTitleViewMargin - leftBarItemTotalWidth - rightBarItemTotalWidth), height: min(viewSize.height, HZCustomNavigationBar.navigationBarHeight), centerX: 0, centerY: 0)
            }else if viewSize.width == 0 {
                self._titleView.addConstraints(with: view, left: 0, right: 0, height: min(viewSize.height, HZCustomNavigationBar.navigationBarHeight), centerY: 0)
            }else if viewSize.height == 0 {
                self._titleView.addConstraints(with: view, top: 0, bottom: 0, width: min(viewSize.width, HZCustomNavigationBar.screenWidth - leftTitleViewMargin - rightTitleViewMargin - leftBarItemTotalWidth - rightBarItemTotalWidth), centerX: 0)
            }
        }
    }
    
    /// 隐藏底部细线条
    func hz_setShadowLineHidden(_ hidden: Bool) {
        shadowLine.isHidden = hidden
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
        }else {
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowPath = nil
        }
    }
    
    /// 设置BarItem按钮颜色
    func hz_setBarItemColor(_ color: UIColor) {
        self.leftBarItems?.forEach({ $0.titleColor = color })
        self.rightBarItems?.forEach({ $0.titleColor = color })
    }
    
}

//MARK: - barItem内部设置方法
private extension HZCustomNavigationBar {
    
    /// barItem具体添加及布局
    func hz_setBarItemsWithLayout(_ barItems: [HZNavigationBarItem], barItemType: HZNavigationBarItemType) {
        var lastItem: HZNavigationBarItem?
        var totalWidth: CGFloat = barItemType == .left ? self.leftBarItemMargin : self.rightBarItemMargin
        barItems.enumerated().forEach { element in
            self.navigationBarView.addSubview(element.element)
            var barItemWidth = element.element.barItemWidth
            if element.element.title(for: .normal) == nil {
                barItemWidth = HZCustomNavigationBar.navigationBarHeight
            }else if barItemWidth == nil {
                barItemWidth = max(element.element.sizeThatFits(.zero).width + 5.0, HZCustomNavigationBar.navigationBarHeight)
            }
            if barItemType == .left {
                if element.offset == 0 {
                    self.navigationBarView.addConstraints(with: element.element, top: 0, bottom: 0, left: self.leftBarItemMargin, width: barItemWidth, prioritys: [.left: Float(1000 - element.offset), .width: Float(1000 - element.offset)])
                }else {
                    self.navigationBarView.addConstraints(with: element.element, top: 0, bottom: 0, left: 0, width: barItemWidth, toItems: [.left: lastItem], itemAttributes: [.left: .right], prioritys: [.left: Float(1000 - element.offset), .width: Float(1000 - element.offset)])
                }
            }else if barItemType == .right {
                if element.offset == 0 {
                    self.navigationBarView.addConstraints(with: element.element, top: 0, bottom: 0, right: -rightBarItemMargin, width: barItemWidth, prioritys: [.right: Float(950 - element.offset), .width: Float(950 - element.offset)])
                }else {
                    self.navigationBarView.addConstraints(with: element.element, top: 0, bottom: 0, right: 0, width: barItemWidth, toItems: [.right: lastItem], itemAttributes: [.right: .left], prioritys: [.right: Float(950 - element.offset), .width: Float(950 - element.offset)])
                }
            }
            totalWidth += (barItemWidth ?? 0)
            lastItem = element.element
            if let _themeColor = self.themeColor {
                element.element.titleColor = _themeColor
            }
        }
        if barItemType == .left {
            self.leftBarItems?.removeAll()
            self.leftBarItems = barItems
            self.leftBarItemTotalWidth = totalWidth
        }else {
            self.rightBarItems?.removeAll()
            self.rightBarItems = barItems
            self.rightBarItemTotalWidth = totalWidth
        }
        updateTitleConstraints()
    }
    
    /// 设置barItem
    func hz_setBarItems(_ barItems: [HZNavigationBarItem?], barItemType: HZNavigationBarItemType) {
        let _barItems = barItems.compactMap({ $0 })
        if barItemType == .left {
            self.leftBarItems?.forEach({ $0.removeFromSuperview() })
            self.leftBarItemBadgeDic.values.forEach({ $0.removeFromSuperview() })
            self.leftBarItemBadgeDic.removeAll()
        }else {
            self.rightBarItems?.forEach({ $0.removeFromSuperview() })
            self.rightBarItemBadgeDic.values.forEach({ $0.removeFromSuperview() })
            self.rightBarItemBadgeDic.removeAll()
        }
        self.hz_setBarItemsWithLayout(_barItems, barItemType: barItemType)
    }
    
    /// 新增barItem
    func hz_addBarItems(_ barItems: [HZNavigationBarItem?], barItemType: HZNavigationBarItemType) {
        var _barItems = barItems.compactMap({ $0 })
        if barItemType == .left, let _leftBarItems = self.leftBarItems {
            _barItems = _leftBarItems + _barItems
        }else if barItemType == .right, let _rightBarItems = self.rightBarItems {
            _barItems = _rightBarItems + _barItems
        }
        self.hz_setBarItemsWithLayout(_barItems, barItemType: barItemType)
    }
    
    /// 插入barItem
    func hz_insertItem(_ barItem: HZNavigationBarItem, at: Int, barItemType: HZNavigationBarItemType) {
        var barItems = barItemType == .left ? leftBarItems : rightBarItems
        if let _barItems = barItems {
            if at >= _barItems.count {
                barItems?.append(barItem)
            }else {
                barItems?.insert(barItem, at: at)
                var tempDic: [Int: UIView] = [:]
                if barItemType == .left {
                    self.leftBarItemBadgeDic.forEach { kv in
                        if kv.key < at {
                            tempDic[kv.key] = kv.value
                        }else {
                            tempDic[kv.key + 1] = kv.value
                        }
                    }
                    self.leftBarItemBadgeDic = tempDic
                }else {
                    self.rightBarItemBadgeDic.forEach { kv in
                        if kv.key < at {
                            tempDic[kv.key] = kv.value
                        }else {
                            tempDic[kv.key + 1] = kv.value
                        }
                    }
                    self.rightBarItemBadgeDic = tempDic
                }
            }
        }else {
            barItems = [barItem]
        }
        guard let barItems_ = barItems else { return }
        self.hz_setBarItemsWithLayout(barItems_, barItemType: barItemType)
    }
    
    /// 移除barItem
    func hz_removeBarItems(_ barItemType: HZNavigationBarItemType, barItemIndexs: [Int]? = nil) {
        var barItems: [HZNavigationBarItem]?
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
            _barItemIndexs.forEach { index in
                if index < _barItems.count {
                    _barItems[index].removeFromSuperview()
                    _barItems.remove(at: index)
                }
                if let _badgeView = barItemBadgeDic[index] {
                    _badgeView.removeFromSuperview()
                    barItemBadgeDic = barItemBadgeDic.filter({ $0.key != index })
                }
            }
            self.hz_setBarItemsWithLayout(_barItems, barItemType: barItemType)
        }else {
            _barItems.forEach({ $0.removeFromSuperview() })
            barItemBadgeDic.values.forEach({ $0.removeFromSuperview() })
            if barItemType == .left {
                self.leftBarItems?.removeAll()
                self.leftBarItemBadgeDic.removeAll()
            }else {
                self.rightBarItems?.removeAll()
                self.rightBarItemBadgeDic.removeAll()
            }
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
        
        guard let _barItems = barItems, atIndex < _barItems.count else { return }
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
        if let _handler = barItemClickHandler {
            item.clickHandler = _handler
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
        guard let _barItems = barItems else { return }
        if let _atIndex = atIndex, _atIndex < _barItems.count {
            _barItems[_atIndex].isHidden = hidden
            if let _badgeView = barItemBadgeDic[_atIndex] {
                _badgeView.isHidden = hidden
            }
        }else {
            _barItems.enumerated().forEach { element in
                element.element.isHidden = hidden
                if let _badgeView = barItemBadgeDic[element.offset] {
                    _badgeView.isHidden = hidden
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
        
        guard let _barItems = barItems, atIndex > _barItems.count else { return }
        let barItem = _barItems[atIndex]
        barItem.clickHandler = barItemClickHandler
    }
    
    /// 给barItem设置badge
    func hz_showBarItemBadge(_ barItemType: HZNavigationBarItemType, atIndex: Int, color: UIColor? = nil, badgeImage: Any? = nil, size: CGSize?, offset: CGPoint) {
        var barItems: [HZNavigationBarItem]? = nil
        var barItemBadgeDic: [Int: UIView] = [:]
        if barItemType == .left {
            barItems = self.leftBarItems
            barItemBadgeDic = self.leftBarItemBadgeDic
        }else {
            barItems = self.rightBarItems
            barItemBadgeDic = self.rightBarItemBadgeDic
        }
        
        guard let _barItems = barItems, atIndex < _barItems.count, barItemBadgeDic[atIndex] == nil else { return }
        
        var badgeView: UIView = UIView()
        var _size = CGSize(width: 8.0, height: 8.0)
        if let size_ = size, size_.width != 0, size_.height != 0 {
            _size = size_
        }
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
            badgeView.backgroundColor = color ?? UIColor(red: 245/255, green: 73/255, blue: 102/255, alpha: 1)
            badgeView.layer.cornerRadius = min(_size.width, _size.height) / 2.0
        }
        self.navigationBarView.addSubview(badgeView)
        let barItem = _barItems[atIndex]
        self.navigationBarView.constrainBadgeView(badgeView, targetView: barItem, size: _size, offset: offset)
        if barItemType == .left {
            leftBarItemBadgeDic[atIndex] = badgeView
        }else {
            rightBarItemBadgeDic[atIndex] = badgeView
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
            if let _badgeView = barItemBadgeDic[_atIndex] {
                _badgeView.removeFromSuperview()
                barItemBadgeDic.removeValue(forKey: _atIndex)
            }
        }else {
            barItemBadgeDic.forEach({ $0.value.removeFromSuperview() })
            barItemBadgeDic.removeAll()
        }
        if barItemType == .left {
            leftBarItemBadgeDic = barItemBadgeDic
        }else {
            rightBarItemBadgeDic = barItemBadgeDic
        }
    }
    
}

//MARK: - 外部快速创建方法
public extension HZCustomNavigationBar {
    static func create(to view: UIView) -> HZCustomNavigationBar {
        let navigationBar = HZCustomNavigationBar(frame: .zero)
        view.addSubview(navigationBar)
        view.addConstraints(with: navigationBar, top: 0, left: 0, right: 0, height: HZCustomNavigationBar.statusBarHeight + HZCustomNavigationBar.navigationBarHeight)
        return navigationBar
    }
}

//MARK: - 外部可调用方法来设置一些属性
public extension HZNavigationBarWrapper where Base: HZCustomNavigationBar {
    
    /// 设置NavigationBar的titleView.
    /// - view: titleView.
    /// - titleViewSize: titleView的size (优先传值的size, 若没有则用view自身size).
    /// - isCenter: 是否在bar上居中显示 (默认居中).
    func setTitleView(_ view: UIView, size: CGSize? = nil) {
        base.hz_setTitleView(view, size: size)
    }
    
    /// 设置NavigationBar底部阴影
    func setBottomShadow(_ isShow: Bool = false, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float = 1, shadowRadius: CGFloat? = nil) {
        base.hz_setBottomShadow(isShow, shadowColor: shadowColor, shadowOffset: shadowOffset, shadowOpacity: shadowOpacity, shadowRadius: shadowRadius)
    }
    
    /// 设置BarItem按钮颜色
    func setBarItemColor(_ color: UIColor) {
        base.hz_setBarItemColor(color)
    }
    
    /// 设置背景透明度
    func setBackgroundAlpha(_ alpha: CGFloat) {
        base.hz_setBackground(alpha: alpha)
    }
    
}

//MARK: - 供外部对BarItem设置调用的方法
public extension HZNavigationBarWrapper where Base: HZCustomNavigationBar {
    
    /// 设置LeftBarItem，若之前已存在barItem，则会先移除后设置.
    /// - leftItems: barItem的数组.
    func setItemsToLeft(_ leftItems: [HZNavigationBarItem?]) {
        base.hz_setBarItems(leftItems, barItemType: .left)
    }
    
    /// 设置RightBarItem，若之前已存在barItem，则会先移除后设置.
    /// - rightItems: barItem的数组.
    func setItemsToRight(_ rightItems: [HZNavigationBarItem?]) {
        base.hz_setBarItems(rightItems, barItemType: .right)
    }
    
    /// 新增设置LeftBarItem，若之前已存在barItem，则在其基础上新增（以增量方式进行）.
    /// - leftItems: barItem的数组.
    func addItemsToLeft(_ leftItems: [HZNavigationBarItem?]) {
        base.hz_addBarItems(leftItems, barItemType: .left)
    }
    
    /// 新增设置RightBarItem，若之前已存在barItem，则在其基础上新增（以增量方式进行）.
    /// - rightItems: barItem的数组.
    func addItemsToRight(_ rightItems: [HZNavigationBarItem?]) {
        base.hz_addBarItems(rightItems, barItemType: .right)
    }
    
    /// 左边插入item
    /// - Parameters:
    ///   - leftItem: 要插入的item
    ///   - at: 插入的位置
    func insertItemToLeft(_ leftItem: HZNavigationBarItem, at: Int) {
        base.hz_insertItem(leftItem, at: at, barItemType: .left)
    }
    
    /// 右边插入item
    /// - Parameters:
    ///   - leftItem: 要插入的item
    ///   - at: 插入的位置
    func insertItemToRight(_ rightItem: HZNavigationBarItem, at: Int) {
        base.hz_insertItem(rightItem, at: at, barItemType: .right)
    }
    
    /// 更新LeftBarItem.
    /// - atIndex: 更新barItem的角标.
    /// - normalTitle: item默认title.
    /// - selectedTitle: item选中title.
    /// - normalImage: item默认image.
    /// - selectedImage: item选中image.
    /// - barItemClickHandler: 替换barItem的点击方法 (可传nil).
    func updateItemWithLeft(_ atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil) {
        base.hz_updateBarItem(.left, atIndex: atIndex, normalTitle: normalTitle, selectedTitle: selectedTitle, normalImage: normalImage, selectedImage: selectedImage, barItemClickHandler: barItemClickHandler)
    }
    
    /// 更新RightBarItem.
    /// - atIndex: 更新barItem的角标.
    /// - normalTitle: item默认title.
    /// - selectedTitle: item选中title.
    /// - normalImage: item默认image.
    /// - selectedImage: item选中image.
    /// - barItemClickHandler: 替换barItem的点击方法 (可传nil).
    func updateItemWithRight(_ atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil) {
        base.hz_updateBarItem(.right, atIndex: atIndex, normalTitle: normalTitle, selectedTitle: selectedTitle, normalImage: normalImage, selectedImage: selectedImage, barItemClickHandler: barItemClickHandler)
    }
    
    /// 移除LeftBarItem.
    /// - indexs: barItem的角标(从左到右)数组，不传默认全移除.
    func removeItemsWithLeft(_ indexs: [Int]? = nil) {
        base.hz_removeBarItems(.left, barItemIndexs: indexs)
    }
    
    /// 移除RightBarItem.
    /// - indexs: barItem的角标(从右到左)数组，不传默认全移除.
    func removeItemsWithRight(_ indexs: [Int]? = nil) {
        base.hz_removeBarItems(.right, barItemIndexs: indexs)
    }
    
    /// 隐藏LeftBarItem.
    /// - atIndex: 需要隐藏的barItem角标，不传默认全隐藏.
    /// - hidden: 隐藏还是显示.
    func hiddenItemWithLeft(_ atIndex: Int? = nil, hidden: Bool) {
        base.hz_hiddenBarItem(.left, atIndex: atIndex, hidden: hidden)
    }
    
    /// 隐藏RightBarItem.
    /// - atIndex: 需要隐藏的barItem角标，不传默认全隐藏.
    /// - hidden: 隐藏还是显示.
    func hiddenItemWithRight(_ atIndex: Int? = nil, hidden: Bool) {
        base.hz_hiddenBarItem(.right, atIndex: atIndex, hidden: hidden)
    }
    
    /// 更新LeftBarItem点击事件方法.
    /// - atIndex: 点击barItem的角标.
    /// - barItemClickHandler: 点击的block回调.
    func clickLeftBarItem(_ atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler) {
        base.hz_clickBarItem(.left, atIndex: atIndex, barItemClickHandler: barItemClickHandler)
    }
    
    /// 更新RightBarItem点击事件方法.
    /// - atIndex: 点击barItem的角标.
    /// - barItemClickHandler: 点击的block回调.
    func clickRightBarItem(_ atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler) {
        base.hz_clickBarItem(.right, atIndex: atIndex, barItemClickHandler: barItemClickHandler)
    }
    
    /// 设置LeftBarItem的badge (自定义颜色).
    /// - atIndex: barItem的角标.
    /// - size: badge的尺寸 (默认为CGSize(width: 8.0, height: 8.0)).
    /// - color: badge的颜色.
    func showLeftBarItemBadge(_ atIndex: Int, size: CGSize? = nil, color: UIColor? = nil, offset: CGPoint = .zero) {
        base.hz_showBarItemBadge(.left, atIndex: atIndex, color: color, size: size, offset: offset)
    }
    
    /// 设置RightBarItem的badge (自定义颜色).
    /// - atIndex: barItem的角标.
    /// - size: badge的尺寸 (默认为CGSize(width: 8.0, height: 8.0)).
    /// - color: badge的颜色.
    func showRightBarItemBadge(_ atIndex: Int, size: CGSize? = nil, color: UIColor? = nil, offset: CGPoint = .zero) {
        base.hz_showBarItemBadge(.right, atIndex: atIndex, color: color, size: size, offset: offset)
    }
    
    /// 设置LeftBarItem的badge (自定义图片).
    /// - atIndex: barItem的角标.
    /// - size: badge的尺寸 (默认为CGSize(width: 8.0, height: 8.0)).
    /// - image: badge的图片.
    func showLeftBarItemBadgeImage(_ atIndex: Int, size: CGSize? = nil, image: Any, offset: CGPoint = .zero) {
        base.hz_showBarItemBadge(.left, atIndex: atIndex, badgeImage: image, size: size, offset: offset)
    }
    
    /// 设置RightBarItem的badge (自定义图片).
    /// - atIndex: barItem的角标.
    /// - size: badge的尺寸 (默认为CGSize(width: 8.0, height: 8.0)).
    /// - image: badge的图片.
    func showRightBarItemBadgeImage(_ atIndex: Int, size: CGSize? = nil, image: Any, offset: CGPoint = .zero) {
        base.hz_showBarItemBadge(.right, atIndex: atIndex, badgeImage: image, size: size, offset: offset)
    }
    
    /// 隐藏（移除）LeftBarItem的badge.
    /// - atIndex: barItem的角标 (不传默认左侧badge全隐藏).
    func hiddenLeftBarItemBadge(_ atIndex: Int? = nil) {
        base.hz_hiddenBarItemBadge(.left, atIndex: atIndex)
    }
    
    /// 隐藏（移除）LeftBarItem的badge.
    /// - atIndex: barItem的角标 (不传默认右侧badge全隐藏).
    func hiddenRightBarItemBadge(_ atIndex: Int? = nil) {
        base.hz_hiddenBarItemBadge(.right, atIndex: atIndex)
    }
    
}
