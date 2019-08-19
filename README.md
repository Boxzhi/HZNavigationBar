<div align=center>
![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/logo.png)
</div>


[![Version](https://img.shields.io/badge/pod-v1.1.7-blue.svg)](https://github.com/CoderZZHe/HZNavigationBar) [![Build Status](https://img.shields.io/badge/build-passing-green.svg)]() ![](https://img.shields.io/badge/platform-iOS%2010.0%2B-yellowgreen.svg) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/CoderZZHe/HZNavigationBar/blob/master/LICENSE)



# 要求
- iOS 10.0+
- Xcode 10.1+
- Swift 4.2+


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

![](https://upload-images.jianshu.io/upload_images/1115226-e80ceb303c6356eb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![](https://upload-images.jianshu.io/upload_images/1115226-da72d3ed1d2f0ebe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/1115226-a50d020d79b35d4b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![](https://upload-images.jianshu.io/upload_images/1115226-37b2196f64512ab8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/1115226-7aa11625b21fff6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![](https://upload-images.jianshu.io/upload_images/1115226-5f42424a50151710.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/1115226-a5e34a9827dee22f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![](https://upload-images.jianshu.io/upload_images/1115226-39490f3cbe0a3f3c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](https://upload-images.jianshu.io/upload_images/1115226-3cb510e17181ff5c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![](https://upload-images.jianshu.io/upload_images/1115226-c4076c75dfa0ffb3.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# 用法
具体用法可参考HZNavigationBarExample文件的Demo


### 基础属性设置.
```
/* 注意：title和titleView互斥，以最后的设置为准 */
nav.titleView = UIImageView(image: UIImage(named: "titleViewImage"))
nav.title = "主页"  // 设置导航栏title

/* 注意：背景颜色和背景图片互斥，以最后的设置为准 */
nav.barBackgroundColor = .white  // 设置导航栏背景颜色
nav.barBackgroundImage = UIImage(named: "updateIcon")  // 设置导航栏背景图

nav.titleColor = .red  // 设置导航栏title的颜色
nav.titleFont = UIFont.systemFont(ofSize: 15)   // 设置导航栏title的字体

nav.themeTextColor = .white   // 设置导航栏主题颜色（含title和barItem的文字颜色）
nav.shadowImageHidden = false  // 是否隐藏导航栏下划线

/// 设置NavigationBar的titleView.
/// - view: titleView.
/// - titleViewSize: titleView的size (优先传值的size, 若没有则用view自身size).
/// - isCenter: 是否在bar上居中显示 (默认居中).
func hz_setTitleView(_ view: UIView?, titleViewSize: CGSize? = nil, isCenter: Bool = true)

/// 设置主题颜色（title和BarItem）
func hz_setThemeColor(color: UIColor)

/// 设置BarItem按钮颜色
func hz_setBarItemColor(color: UIColor)

/// 设置背景透明度
func hz_setBackgroundAlpha(alpha: CGFloat)
```
------------------------------------------------------------

### 基本常用方法.

- 设置barItem，若之前已存在barItem，则会先移除后设置.
```
func hz_setItemsToLeft(leftItems: [HZNavigationBarItem?]) 
func hz_setItemsToRight(rightItems: [HZNavigationBarItem?])
```
------------------------------------------------------------
- 新增设置barItem，若之前已存在barItem，则在其基础上新增（以增量方式进行）.
```
func hz_addItemsToLeft(leftItems: [HZNavigationBarItem?])
func hz_addItemsToRight(rightItems: [HZNavigationBarItem?])
```
------------------------------------------------------------
- 更新barItem.
```
func hz_updateItemWithLeft(atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil)
func hz_updateItemWithRight(atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil)
```
------------------------------------------------------------
- 移除barItem.
```
func hz_removeItemWithLeft(indexs: [Int]? = nil)
func hz_removeItemWithRight(indexs: [Int]? = nil)
```
------------------------------------------------------------
- 隐藏barItem.
```
func hz_hiddenItemWithLeft(_ atIndex: Int? = nil, hidden: Bool)
func hz_hiddenItemWithRight(_ atIndex: Int? = nil, hidden: Bool)
```
------------------------------------------------------------
- 更新barItem点击事件方法.（之前的点击方法会失效）.
```
func hz_clickLeftBarItem(_ atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler)
func hz_clickRightBarItem(_ atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler)
```
------------------------------------------------------------
- 设置barItem的badge（大小默认为8*8）.

- 自定义颜色.
```
func hz_showLeftBarItemBadge(atIndex: Int = 0, size: CGSize = .zero, color: UIColor = UIColor(red: 245/255, green: 73/255, blue: 102/255, alpha: 1), offset: CGPoint = .zero)
func hz_showRightBarItemBadge(atIndex: Int = 0, size: CGSize = .zero, color: UIColor = UIColor(red: 245/255, green: 73/255, blue: 102/255, alpha: 1), offset: CGPoint = .zero)
```

- 自定义图片.
```
func hz_showLeftBarItemBadgeImage(atIndex: Int = 0,  size: CGSize = .zero, image: Any, offset: CGPoint = .zero)
func hz_showRightBarItemBadgeImage(atIndex: Int = 0,  size: CGSize = .zero, image: Any, offset: CGPoint = .zero)
```
------------------------------------------------------------
- 隐藏（移除）barItem的badge.
```
func hz_hiddenLeftBarItemBadge(_ atIndex: Int? = nil)
func hz_hiddenRightBarItemBadge(_ atIndex: Int? = nil)
```

# 许可
HZNavigationBar是在MIT许可下发布的。 有关详细信息，请参阅 [LICENSE](https://opensource.org/licenses/mit-license.php)。
