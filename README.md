#HZNavigationBar
一个可高度自定义的NavigationBar, 基于[WRNavigationBar](https://github.com/wangrui460/WRNavigationBar_swift)改造而来

###Requirements
- iOS 10.0+
- Xcode 10.1+

###Demo
![](https://upload-images.jianshu.io/upload_images/1115226-e80ceb303c6356eb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1115226-da72d3ed1d2f0ebe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1115226-a50d020d79b35d4b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1115226-37b2196f64512ab8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###How To Use

基础属性设置.
```
/* 注意：title和titleView互斥，以最后的设置为准 */
nav.titleView = UIImageView(image: UIImage(named: "titleViewImage"))
nav.title = "主页"  // 设置导航栏title
nav.titleColor = .red  // 设置导航栏title的颜色
nav.titleFont = UIFont.systemFont(ofSize: 15)   // 设置导航栏title的字体

nav.themeColor = .white   // 设置导航栏主题颜色（含title和barItem的文字颜色）
nav.isHiddenBottomLine = false  // 隐藏导航栏下划线

/* 注意：背景颜色和背景图片互斥，以最后的设置为准 */
nav.barBackgroundColor = .white  // 设置导航栏背景颜色
nav.barBackgroundImage = UIImage(named: "updateIcon")  // 设置导航栏背景图


/// 设置NavigationBar的titleView，若view有设置frame，则可不传titleViewSize，若两者都 
无，则默认占据整个NavigationBar
/// titleViewSize：titleView的Size
/// isCenter：view是否要居中显示在titleView上
func hz_setTitleView(_ view: UIView?, titleViewSize: CGSize? = nil, isCenter: Bool = true)

/// 设置主题颜色（title和BarItem）
func hz_setThemeColor(color: UIColor)

/// 设置BarItem按钮颜色
func hz_setBarItemColor(color: UIColor)

/// 设置背景透明度
func hz_setBackgroundAlpha(alpha: CGFloat)
```
------------------------------------------------------------
设置BarItem、若之前已存在barItem、则会先移除后设置.
```
public func hz_setItemsToLeft(leftItems: [HZNavigationBarItem?]) 
public func hz_setItemsToRight(rightItems: [HZNavigationBarItem?])
```
------------------------------------------------------------
新增设置BarItem、若之前已存在barItem、则在其基础上新增（以增量方式进行）.
```
public func hz_addItemsToLeft(leftItems: [HZNavigationBarItem?])
public func hz_addItemsToRight(rightItems: [HZNavigationBarItem?])
```
------------------------------------------------------------
更新BarItem.
```
public func hz_updateItemWithLeft(atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: UIImage? = nil, selectedImage: UIImage? = nil, clickBarItemBlock: ((_ sender: HZNavigationBarItem) -> Void)? = nil)
public func hz_updateItemWithRight(atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: UIImage? = nil, selectedImage: UIImage? = nil, clickBarItemBlock: ((_ sender: HZNavigationBarItem) -> Void)? = nil)
```
------------------------------------------------------------
隐藏BarItem.
```
public func hz_hiddenItemWithLeft(_ index: Int? = nil, hidden: Bool)
public func hz_hiddenItemWithRight(_ index: Int? = nil, hidden: Bool)
```
------------------------------------------------------------
点击BarItem.
```
public func hz_clickLeftBarItem(_ index: Int = 0, clickBlock: @escaping (_ sender: HZNavigationBarItem) -> Void)
public func hz_clickRightBarItem(_ index: Int = 0, clickBlock: @escaping (_ sender: HZNavigationBarItem) -> Void)
```
