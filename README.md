![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/logo.png)


[![Version](https://img.shields.io/badge/pod-1.3.3-blue.svg)](https://github.com/CoderZZHe/HZNavigationBar) [![Build Status](https://img.shields.io/badge/build-passing-green.svg)]() ![](https://img.shields.io/badge/platform-iOS%2010.0%2B-yellowgreen.svg) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/CoderZZHe/HZNavigationBar/blob/master/LICENSE)



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

![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_1.png)![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_2.png)
![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_3.png)![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_4.png)
![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_5.png)![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_6.png)
![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_7.png)![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_8.png)
![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_9.png)![](https://raw.githubusercontent.com/Boxzhi/HZNavigationBar/master/Images/demo_10.jpeg)


# 用法
具体用法可参考HZNavigationBarExample文件的Demo
 - 通过`let nav = HZCustomNavigationBar.customNavigationBar()`创建，可放在在baseViewController
 - 添加到UI的最上层
 - 每个VC都有个独立的自定义navigationBar，可在对应的VC中设置所需属性


### 基础属性设置.
```
/* 注意：title和titleView互斥，以最后的设置为准 */
nav.titleView = UIImageView(image: UIImage(named: "titleViewImage"))
nav.title = "主页"

/* 注意：背景颜色和背景图片互斥，以最后的设置为准 */
nav.barBackgroundColor = .white
nav.barBackgroundImage = UIImage(named: "updateIcon")

// 设置导航栏背景色
nav.barBackgroundColor = .red
// 设置状态栏背景色   不设置或设置为nil默认不显示
nav.statusBarColor = .green

// 设置导航栏title的颜色
nav.titleColor = .red
// 设置导航栏title的字体
nav.titleFont = UIFont.systemFont(ofSize: 15)
// 设置导航栏主题颜色（含title和barItem的文字颜色）
nav.themeTextColor = .white
// 是否隐藏导航栏下划线
nav.shadowImageHidden = false
// 设置第一个leftBarItem距离左边边缘的间距（默认为10.0）
nav.leftBarItemSpace = 10.0
// 设置第一个rightBarItem距离右边边缘的间距（默认为13.0）
nav.rightBarItemSpace = 13.0

/**
设置NavigationBar的titleView.
- parameter view:     要设置为titleView的View
- parameter titleViewSize:     titleView的尺寸 (优先使用该size, 若没有则用view自身size).
- parameter isCenter:     是否在bar上居中显示 (默认居中).
*/
func setTitleView(_ view: UIView?, titleViewSize: CGSize? = nil, isCenter: Bool = true)

/// 设置主题颜色（title和BarItem）
func setThemeColor(color: UIColor)

/// 设置BarItem按钮颜色
func setBarItemColor(color: UIColor)

/// 设置背景透明度
func setBackgroundAlpha(alpha: CGFloat)
```
------------------------------------------------------------

### 基本常用方法.

- 设置barItem，若之前已存在barItem，则会先移除后设置.
```
func setItemsToLeft(_ leftItems: [HZNavigationBarItem?])
func setItemsToRight(_ rightItems: [HZNavigationBarItem?])
```
------------------------------------------------------------
- 新增设置barItem，若之前已存在barItem，则在其基础上新增（以增量方式进行）.
```
func addItemsToLeft(_ leftItems: [HZNavigationBarItem?])
func addItemsToRight(_ rightItems: [HZNavigationBarItem?])
```
------------------------------------------------------------
- 更新barItem.
```
func updateItemWithLeft(_ atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil)
func updateItemWithRight(_ atIndex: Int = 0, normalTitle: String? = nil, selectedTitle: String? = nil, normalImage: Any? = nil, selectedImage: Any? = nil, barItemClickHandler: HZNavigationBarItemClickHandler? = nil)
```
------------------------------------------------------------
- 移除barItem.
```
func removeItemsWithLeft(_ indexs: [Int]? = nil)
func removeItemsWithRight(_ indexs: [Int]? = nil)
```
------------------------------------------------------------
- 隐藏barItem.
```
func hiddenItemWithLeft(_ atIndex: Int? = nil, hidden: Bool)
func hiddenItemWithRight(_ atIndex: Int? = nil, hidden: Bool)
```
------------------------------------------------------------
- 更新barItem点击事件方法.（之前的点击方法会失效）.
```
func clickLeftBarItem(_ atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler)
func clickRightBarItem(_ atIndex: Int = 0, barItemClickHandler: @escaping HZNavigationBarItemClickHandler)
```
------------------------------------------------------------
- 设置barItem的badge（大小默认为8*8）.

- 自定义颜色.
```
func showLeftBarItemBadge(_ atIndex: Int = 0, size: CGSize = .zero, color: UIColor = UIColor(red: 245/255, green: 73/255, blue: 102/255, alpha: 1), offset: CGPoint = .zero)
func showRightBarItemBadge(_ atIndex: Int = 0, size: CGSize = .zero, color: UIColor = UIColor(red: 245/255, green: 73/255, blue: 102/255, alpha: 1), offset: CGPoint = .zero)
```

- 自定义图片.
```
func showLeftBarItemBadgeImage(_ atIndex: Int = 0,  size: CGSize = .zero, image: Any, offset: CGPoint = .zero)
func showRightBarItemBadgeImage(_ atIndex: Int = 0,  size: CGSize = .zero, image: Any, offset: CGPoint = .zero)
```
------------------------------------------------------------
- 隐藏（移除）barItem的badge.
```
func hiddenLeftBarItemBadge(_ atIndex: Int? = nil)
func hiddenRightBarItemBadge(_ atIndex: Int? = nil)
```

# 许可
HZNavigationBar是在MIT许可下发布的。 有关详细信息，请参阅 [LICENSE](https://opensource.org/licenses/mit-license.php)。
