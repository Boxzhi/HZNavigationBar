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
    
    /// 整体背景颜色
    public var bgColor: UIColor? {
        willSet {
            hz_setBackground(color: newValue)
        }
    }
    
    /// 整体背景图
    public var bgImage: UIImage? {
        willSet {
            hz_setBackground(image: newValue)
        }
    }
    
    /// 整体背景透明度
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
    
    /// 导航栏背景View
    fileprivate lazy var navigationBarBackgroundView: UIView = {
        let _navigationBarBackgroundView = UIView()
        _navigationBarBackgroundView.backgroundColor = .clear
        return _navigationBarBackgroundView
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
        addSubview(shadowLine)
        navigationBarView.addSubview(navigationBarBackgroundView)
        navigationBarView.addSubview(navigationBarBackgroundImageView)
        navigationBarView.addSubview(_titleView)
        navigationBarView.addSubview(titleLabel)
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        
        makeConstraints(with: backgroundView, constants: [.top: 0, .bottom: 0, .left: 0, .right: 0])
        makeConstraints(with: backgroundImageView, constants: [.top: 0, .bottom: 0, .left: 0, .right: 0])
        makeConstraints(with: statusBarView, constants: [.top: 0, .left: 0, .right: 0, .height: HZCustomNavigationBar.statusBarHeight])
        makeConstraints(with: navigationBarView, constants: [.bottom: 0, .left: 0, .right: 0, .height: HZCustomNavigationBar.navigationBarHeight])
        makeConstraints(with: shadowLine, constants: [.bottom: 0, .left: 0, .right: 0, .height: 0.5])
        navigationBarView.makeConstraints(with: navigationBarBackgroundView, constants: [.top: 0, .bottom: 0, .left: 0, .right: 0])
        navigationBarView.makeConstraints(with: navigationBarBackgroundImageView, constants: [.top: 0, .bottom: 0, .left: 0, .right: 0])
        updateTitleConstraints()
    }
    
    fileprivate func updateTitleConstraints() {
        if titleViewIsCenter {
            navigationBarView.remakeConstraints(with: _titleView, constants: [.top: 0, .bottom: 0, .left: max(leftTitleViewMargin + leftBarItemTotalWidth, rightTitleViewMargin + rightBarItemTotalWidth), .right: -max(leftTitleViewMargin + leftBarItemTotalWidth, rightTitleViewMargin + rightBarItemTotalWidth)], prioritys: [.left: 900.0, .right: 900.0])
        }else {
            navigationBarView.remakeConstraints(with: _titleView, constants: [.top: 0, .bottom: 0, .left: leftTitleViewMargin, .right: -rightTitleViewMargin], toItems: [.left: leftBarItems?.last, .right: rightBarItems?.last], attributes: [.left: leftBarItems?.last == nil ? .left : .right, .right: rightBarItems?.last == nil ? .right : .left], prioritys: [.left: 900.0, .right: 900.0])
        }
        navigationBarView.remakeConstraints(with: titleLabel, constants: [.top: 0, .bottom: 0, .width: min(HZCustomNavigationBar.screenWidth / 2.0, HZCustomNavigationBar.screenWidth - max(leftBarItemTotalWidth, rightBarItemTotalWidth) * 2.0 - leftTitleViewMargin - rightTitleViewMargin), .centerX: 0], prioritys: [.width: 850])
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
    
    /// 设置整体背景色或背景图
    func hz_setBackground(color: UIColor? = nil, image: UIImage? = nil, alpha: CGFloat? = nil) {
        if let _color = color {
            self.statusBarView.backgroundColor = .clear
            self.navigationBarBackgroundView.backgroundColor = .clear
            self.navigationBarBackgroundImageView.isHidden = true
            self.backgroundImageView.isHidden = true
            self.backgroundView.backgroundColor = _color
        }else if let _image = image {
            self.statusBarView.backgroundColor = .clear
            self.navigationBarBackgroundView.backgroundColor = .clear
            self.navigationBarBackgroundImageView.isHidden = true
            self.backgroundImageView.isHidden = false
            self.backgroundImageView.image = _image
        }
        if let _alpha = alpha {
            self.backgroundView.alpha = _alpha
            self.backgroundImageView.alpha = _alpha
            self.statusBarView.alpha = _alpha
            self.navigationBarBackgroundView.alpha = _alpha
            self.navigationBarBackgroundImageView.alpha = _alpha
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
            self.navigationBarView.subviews.forEach({ $0.backgroundColor = _color })
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
            titleLabel.isHidden = false
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
            self._titleView.makeConstraints(with: _button, constants: [.top: 0, .bottom: 0, .centerX: 0])
        }else {
            if let _imageView = view as? UIImageView {
                _imageView.contentMode = .scaleAspectFit
            }
            var viewSize = view.bounds.size
            if let _size = size {
                viewSize = _size
            }
            if viewSize.width == 0, viewSize.height == 0 {
                self._titleView.makeConstraints(with: view, constants: [.top: 0, .bottom: 0, .left: 0, .right: 0])
            }else if viewSize.width != 0, viewSize.height != 0 {
                self._titleView.makeConstraints(with: view, constants: [.width: min(viewSize.width, HZCustomNavigationBar.screenWidth - leftTitleViewMargin - rightTitleViewMargin - leftBarItemTotalWidth - rightBarItemTotalWidth), .height: min(viewSize.height, HZCustomNavigationBar.navigationBarHeight), .centerX: 0, .centerY: 0])
            }else if viewSize.width == 0 {
                self._titleView.makeConstraints(with: view, constants: [.left: 0, .right: 0, .height: min(viewSize.height, HZCustomNavigationBar.navigationBarHeight), .centerY: 0])
            }else if viewSize.height == 0 {
                self._titleView.makeConstraints(with: view, constants: [.top: 0, .bottom: 0, .width: min(viewSize.width, HZCustomNavigationBar.screenWidth - leftTitleViewMargin - rightTitleViewMargin - leftBarItemTotalWidth - rightBarItemTotalWidth), .centerX: 0])
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
            var barItemWidth: CGFloat = element.element.barItemWidth ?? max(element.element.sizeThatFits(.zero).width + 5.0, HZCustomNavigationBar.navigationBarHeight)
            if element.element.title(for: .normal) == nil {
                barItemWidth = HZCustomNavigationBar.navigationBarHeight
            }
        
            if barItemType == .left {
                if element.offset == 0 {
                    self.navigationBarView.remakeConstraints(with: element.element, constants: [.top: 0, .bottom: 0, .left: self.leftBarItemMargin, .width: barItemWidth], prioritys: [.left: Float(1000 - element.offset), .width: Float(1000 - element.offset)])
                }else {
                    self.navigationBarView.remakeConstraints(with: element.element, constants: [.top: 0, .bottom: 0, .left: 0, .width: barItemWidth], toItems: [.left: lastItem], attributes: [.left: .right], prioritys: [.left: Float(1000 - element.offset), .width: Float(1000 - element.offset)])
                }
            }else if barItemType == .right {
                if element.offset == 0 {
                    self.navigationBarView.remakeConstraints(with: element.element, constants: [.top: 0, .bottom: 0, .right: -rightBarItemMargin, .width: barItemWidth], prioritys: [.right: Float(950 - element.offset), .width: Float(950 - element.offset)])
                }else {
                    self.navigationBarView.remakeConstraints(with: element.element, constants: [.top: 0, .bottom: 0, .right: 0, .width: barItemWidth], toItems: [.right: lastItem], attributes: [.right: .left], prioritys: [.right: Float(950 - element.offset), .width: Float(950 - element.offset)])
                }
            }
            totalWidth += barItemWidth
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
                }else if barItemBadgeDic.count > 0 {
                    var temp: [Int: UIView] = [:]
                    barItemBadgeDic.forEach { kv in
                        if kv.key > index {
                            temp[kv.key - 1] = kv.value
                        }else {
                            temp[kv.key] = kv.value
                        }
                    }
                    barItemBadgeDic = temp
                }
            }
            if barItemType == .left {
                self.leftBarItemBadgeDic = barItemBadgeDic
            }else {
                self.rightBarItemBadgeDic = barItemBadgeDic
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
        
        guard let _barItems = barItems, atIndex < _barItems.count else { return }
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
        if let _imageWidth = barItem.imageView?.bounds.width, let _imageHeight = barItem.imageView?.bounds.height {
            self.navigationBarView.makeConstraints(with: badgeView, constants: [.width: _size.width, .height: _size.height, .centerX: _imageWidth / 2.0 + offset.x, .centerY: -(_imageHeight / 2.0) + offset.y], toItems: [.centerX: barItem, .centerY: barItem])
        }else {
            self.navigationBarView.makeConstraints(with: badgeView, constants: [.top: -(_size.height / 2.0) + offset.y, .right: _size.width / 2.0 + offset.x, .width: _size.width, .height: _size.height], toItems: [.top: barItem, .right: barItem])
        }
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
        view.makeConstraints(with: navigationBar, constants: [.top: 0, .left: 0, .right: 0, .height: HZCustomNavigationBar.statusNavigationBarHeight])
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
    
    /// 设置BarItem按钮文字颜色
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
    
    /// 获取已设置的NavigationBarItem数组
    /// - Parameter type: 左边👈🏻👉🏻右边
    /// - Returns: barItem数组
    func getBarItems(_ type: HZNavigationBarItemType) -> [HZNavigationBarItem]? {
        return type == .left ? base.leftBarItems : base.rightBarItems
    }
    
    /// 设置NavigationBarItem
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - leftItems: barItem数组
    func setBarItems(_ type: HZNavigationBarItemType, items: [HZNavigationBarItem]) {
        base.hz_setBarItems(items, barItemType: type)
    }
    
    /// 新增NavigationBarItem
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - leftItems: barItem数组
    func addBarItems(_ type: HZNavigationBarItemType, items: [HZNavigationBarItem]) {
        base.hz_addBarItems(items, barItemType: type)
    }
    
    /// 插入NavigationBarItem
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - item: 要插入的item
    ///   - at: 插入位置
    func insertBarItem(_ type: HZNavigationBarItemType, atIndex: Int, item: HZNavigationBarItem) {
        base.hz_insertItem(item, at: atIndex, barItemType: type)
    }
    
    /// 更新NavigationBarItem
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - atIndex: 更新位置
    ///   - normalTitle: 默认文字
    ///   - selectedTitle: 选中文字
    ///   - normalImage: 默认图片
    ///   - selectedImage: 选中图片
    ///   - barItemClickHandler: 点击回调
    func updateBarItem(_ type: HZNavigationBarItemType, atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil) {
        base.hz_updateBarItem(type, atIndex: atIndex, normalTitle: normalTitle, selectedTitle: selectedTitle, normalImage: normalImage, selectedImage: selectedImage, barItemClickHandler: barItemClickHandler)
    }
    
    /// 移除NavigationBarItem
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - indexs: 移除位置
    func removeBarItems(_ type: HZNavigationBarItemType, indexs: [Int]? = nil) {
        base.hz_removeBarItems(type, barItemIndexs: indexs)
    }
    
    /// 隐藏NavigationBarItem
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - atIndex: 隐藏位置
    ///   - hidden: 是否隐藏
    func hiddenBarItem(_ type: HZNavigationBarItemType, atIndex: Int? = nil, hidden: Bool) {
        base.hz_hiddenBarItem(type, atIndex: atIndex, hidden: hidden)
    }
    
    /// 更新点击事件回调
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - atIndex: 位置
    ///   - barItemClickHandler: 点击回调
    func barItemClickHandler(_ type: HZNavigationBarItemType, atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler) {
        base.hz_clickBarItem(type, atIndex: atIndex, barItemClickHandler: barItemClickHandler)
    }
    
    /// NavigationBarItem显示小圆点颜色badge
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - atIndex: 位置
    ///   - size: badge大小
    ///   - color: badge颜色
    ///   - offset: badge偏移量
    func barItemShowColorBadge(_ type: HZNavigationBarItemType, atIndex: Int, badgeSize: CGSize? = nil, color: UIColor? = nil, offset: CGPoint = .zero) {
        base.hz_showBarItemBadge(type, atIndex: atIndex, color: color, size: badgeSize, offset: offset)
    }
    
    /// NavigationBarItem显示图片badge
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - atIndex: 位置
    ///   - size: badge大小
    ///   - image: badge图片
    ///   - offset: badge偏移量
    func barItemShowImageBadge(_ type: HZNavigationBarItemType, atIndex: Int, badgeSize: CGSize? = nil, image: Any, offset: CGPoint = .zero) {
        base.hz_showBarItemBadge(type, atIndex: atIndex, badgeImage: image, size: badgeSize, offset: offset)
    }
    
    /// 移除NavigationBarItem的badge
    /// - Parameters:
    ///   - type: 左边👈🏻👉🏻右边
    ///   - atIndex: 位置
    func barItemRemoveBadge(_ type: HZNavigationBarItemType, atIndex: Int? = nil) {
        base.hz_hiddenBarItemBadge(type, atIndex: atIndex)
    }
    
}
