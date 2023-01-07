![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/logo.png)


[![Version](https://img.shields.io/badge/pod-2.0.2-blue.svg)](https://github.com/CoderZZHe/HZNavigationBar) [![Build Status](https://img.shields.io/badge/build-passing-green.svg)]() ![](https://img.shields.io/badge/platform-iOS%2010.0%2B-yellowgreen.svg) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/CoderZZHe/HZNavigationBar/blob/master/LICENSE)



# 要求
- iOS 10.0+     
- Xcode 10.1+     
- Swift 4.2+

# 版本更新记录
- v2.0.0 - 2022.09.19
  - 创建方法create更新，传入HZNavigationBar所在的父View即可添加并设置约束
  - UI图层更新，可设置整体背景，也可单独设置状态栏或导航栏背景
  - 设置BarItem方法大更新，通过type判断左或右
  - titleView可居中或不居中

# 安装
打开 Podfile，在您项目的 target 下加入以下内容。（此处示例可能是旧版本，使用时请替换为最新版，最新版信息可以从这里获取：<a href="https://github.com/CoderZZHe/HZNavigationBar/blob/master/HZNavigationBar.podspec"><img src="https://img.shields.io/badge/pod-GetLatestVersion-blue.svg?style=flat"></a>）

在文件 `Podfile` 中加入以下内容：
```
pod 'HZNavigationBar'
```
然后在终端中运行以下命令：
```
pod install
```

# Demo图片

<img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_1.png"/>    <img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_2.png"/>
<img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_3.png"/>    <img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_4.png"/>
<img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_5.png"/>    <img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_6.png"/>
<img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_7.png"/>    <img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_8.png"/>
<img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_9.png"/>    <img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_10.png"/>
<img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_11.png"/>    <img width="400" src="https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_12.png"/>

# 用法
具体用法可参考HZNavigationBarExample文件的Demo
 - 通过`let nav = HZCustomNavigationBar.create(to: navSupView)`创建，可放在在baseViewController
 - 添加到UI的最上层
 - 每个VC都有个独立的自定义navigationBar，可在各自VC中设置所需属性

------------------------------------------------------------

### 基础属性设置.
```
    /*************************** 阴影设置 ***************************/
    // 是否显示navigationBar底部阴影，默认false
    public var isShowBottomShadow: Bool = false
    // 阴影颜色
    public var bottomShadowColor: UIColor?
    // 阴影偏移量
    public var bottomShadowOffset: CGSize?
    // 阴影透明度，默认1
    public var bottomShadowOpacity: Float = 1
    // 阴影宽度
    public var bottomShadowRadius: CGFloat?
    
    /*************************** 整体设置 ***************************/
    // 整体背景颜色
    public var bgColor: UIColor?
    // 整体背景图
    public var bgImage: UIImage?
    // 整体背景透明度
    public var bgAlpha: CGFloat?
    // 是否隐藏navigationBar底部的细横线
    public var shadowImageHidden: Bool = false
    // 设置主题颜色（title和BarItem文字颜色）
    public var themeColor: UIColor?
    
    /*************************** statusBar设置 ***************************/
    // statusBar背景颜色
    public var statusBarColor: UIColor?
    
    /*************************** navigationBar设置 ***************************/
    // navigationBar背景颜色
    public var navigationBarBackgroundColor: UIColor?
    // navigationBar背景图片
    public var navigationBarBackgroundImage: UIImage?
    // navigationBar标题文字
    public var title: String?
    // navigationBar标题颜色
    public var titleColor: UIColor?
    // navigationBar标题字体
    public var titleFont: UIFont?
    // navigationBar标题富文本
    public var titleAttributedString: NSAttributedString?
    // navigationBar的titleView
    public var titleView: UIView?
    
    // 第一个leftBarItem距离左边边缘的间距, 默认10.0
    public var leftBarItemMargin: CGFloat = 10.0
    // 第一个rightBarItem距离右边边缘的间距, 默认10.0
    public var rightBarItemMargin: CGFloat = 10.0
    // titleView是否居中, 默认居中true
    public var titleViewIsCenter: Bool = true
    // titleView左边间距, 默认0
    public var leftTitleViewMargin: CGFloat = 0
    // titleView右边间距, 默认0
    public var rightTitleViewMargin: CGFloat = 0
    
    /*************************** 相关属性设置方法 ***************************/
    /// 设置titleView.
    func setTitleView(_ view: UIView, size: CGSize? = nil)
    /// 设置navigationBar底部阴影
    func setBottomShadow(_ isShow: Bool = false, shadowColor: UIColor? = nil, shadowOffset: CGSize? = nil, shadowOpacity: Float = 1, shadowRadius: CGFloat? = nil)
    /// 设置BarItem按钮文字颜色
    func setBarItemColor(_ color: UIColor)
    /// 设置背景透明度
    func setBackgroundAlpha(_ alpha: CGFloat)
    
```
------------------------------------------------------------

### 基本常用方法.

- 获取已设置的NavigationBarItem数组.
```
    func getBarItems(_ type: HZNavigationBarItemType) -> [HZNavigationBarItem]?
```
------------------------------------------------------------
- 设置NavigationBarItem（若之前已存在barItem，则会先移除后设置）.
```
    func setBarItems(_ type: HZNavigationBarItemType, items: [HZNavigationBarItem])
```
------------------------------------------------------------
- 新增NavigationBarItem（若之前已存在barItem，则在其基础上新增（以增量方式进行））.
```
    func addBarItems(_ type: HZNavigationBarItemType, items: [HZNavigationBarItem])
```
------------------------------------------------------------
- 插入NavigationBarItem.
```
    func insertBarItem(_ type: HZNavigationBarItemType, atIndex: Int, item: HZNavigationBarItem)
```
------------------------------------------------------------
- 更新NavigationBarItem.
```
    func updateBarItem(_ type: HZNavigationBarItemType, atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil)
```
------------------------------------------------------------
- 移除NavigationBarItem.
```
    func removeBarItems(_ type: HZNavigationBarItemType, indexs: [Int]? = nil)
```
------------------------------------------------------------
- 隐藏NavigationBarItem.
```
    func hiddenBarItem(_ type: HZNavigationBarItemType, atIndex: Int? = nil, hidden: Bool)
```
------------------------------------------------------------
- 更新点击事件回调.
```
    func barItemClickHandler(_ type: HZNavigationBarItemType, atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler)
```
------------------------------------------------------------
- NavigationBarItem显示小圆点颜色badge.
```
    func barItemShowColorBadge(_ type: HZNavigationBarItemType, atIndex: Int, badgeSize: CGSize? = nil, color: UIColor? = nil, offset: CGPoint = .zero)
```
------------------------------------------------------------
- NavigationBarItem显示图片badge.
```
    func barItemShowImageBadge(_ type: HZNavigationBarItemType, atIndex: Int, badgeSize: CGSize? = nil, image: Any, offset: CGPoint = .zero)
```
- 移除NavigationBarItem的badge.
```
    func barItemRemoveBadge(_ type: HZNavigationBarItemType, atIndex: Int? = nil)
```
------------------------------------------------------------

# 许可
HZNavigationBar是在MIT许可下发布的。 有关详细信息，请参阅 [LICENSE](https://opensource.org/licenses/mit-license.php)。
