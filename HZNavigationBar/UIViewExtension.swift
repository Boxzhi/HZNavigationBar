//
//  UIView_Extension.swift
//  test
//
//  Created by 何志志 on 2019/3/7.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

infix operator ???
public func ??? <T: Any>(left: Optional<Optional<T>>, right: T) -> T {
    if let _left = left, let left_ = _left {
        return left_
    }else {
        return right
    }
}

public extension UIView {
    
    /// 设置约束
    /// - Parameters:
    ///   - subView: 要设置约束的子View
    ///   - top: 上
    ///   - bottom: 下
    ///   - left: 左
    ///   - right: 右
    ///   - width: 宽
    ///   - height: 高
    ///   - centerX: 垂直居中
    ///   - centerY: 水平居中
    ///   - toItem: 相对View   key为子View的约束    value为相对View
    ///   - itemAttributes: 相对View的约束  [key: value]   key为子View的约束    value为相对View的约束
    func addConstraints(with subView: UIView, top: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil, toItems: [NSLayoutConstraint.Attribute: UIView?]? = nil, itemAttributes: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Attribute]? = nil, prioritys: [NSLayoutConstraint.Attribute: Float]? = nil) {
        constraints.forEach { layoutConstraint in
            if let _firstItem = layoutConstraint.firstItem as? UIView, _firstItem == subView {
                layoutConstraint.isActive = false
            }
        }
        subView.translatesAutoresizingMaskIntoConstraints = false
        if let _top = top {
            let subViewTop = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: toItems?[.top] ??? self, attribute: itemAttributes?[.top] ?? .top, multiplier: 1.0, constant: _top)
            if let _priority = prioritys?[.top] {
                subViewTop.priority = UILayoutPriority(_priority)
            }
            addConstraint(subViewTop)
        }
        if let _bottom = bottom {
            let subViewBottom = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: toItems?[.bottom] ??? self, attribute: itemAttributes?[.bottom] ?? .bottom, multiplier: 1.0, constant: _bottom)
            if let _priority = prioritys?[.bottom] {
                subViewBottom.priority = UILayoutPriority(_priority)
            }
            addConstraint(subViewBottom)
        }
        if let _left = left {
            let subViewLeft = NSLayoutConstraint(item: subView, attribute: .left, relatedBy: .equal, toItem: toItems?[.left] ??? self, attribute: itemAttributes?[.left] ?? .left, multiplier: 1.0, constant: _left)
            if let _priority = prioritys?[.left] {
                subViewLeft.priority = UILayoutPriority(_priority)
            }
            addConstraint(subViewLeft)
        }
        if let _right = right {
            let subViewRight = NSLayoutConstraint(item: subView, attribute: .right, relatedBy: .equal, toItem: toItems?[.right] ??? self, attribute: itemAttributes?[.right] ?? .right, multiplier: 1.0, constant: _right)
            if let _priority = prioritys?[.right] {
                subViewRight.priority = UILayoutPriority(_priority)
            }
            addConstraint(subViewRight)
        }
        if let _width = width {
            let subViewWidth = NSLayoutConstraint(item: subView, attribute: .width, relatedBy: .equal, toItem: toItems?[.width] as Any?, attribute: itemAttributes?[.width] ?? .notAnAttribute, multiplier: 1.0, constant: _width)
            if let _priority = prioritys?[.width] {
                subViewWidth.priority = UILayoutPriority(_priority)
            }
            addConstraint(subViewWidth)
        }
        if let _height = height {
            let subViewHeight = NSLayoutConstraint(item: subView, attribute: .height, relatedBy: .equal, toItem: toItems?[.height] as Any?, attribute: itemAttributes?[.height] ?? .notAnAttribute, multiplier: 1.0, constant: _height)
            if let _priority = prioritys?[.height] {
                subViewHeight.priority = UILayoutPriority(_priority)
            }
            addConstraint(subViewHeight)
        }
        if let _centerX = centerX {
            let subViewCenterX = NSLayoutConstraint(item: subView, attribute: .centerX, relatedBy: .equal, toItem: toItems?[.centerX] ??? self, attribute: itemAttributes?[.centerX] ?? .centerX, multiplier: 1.0, constant: _centerX)
            if let _priority = prioritys?[.centerX] {
                subViewCenterX.priority = UILayoutPriority(_priority)
            }
            addConstraint(subViewCenterX)
        }
        if let _centerY = centerY {
            let subViewCenterY = NSLayoutConstraint(item: subView, attribute: .centerY, relatedBy: .equal, toItem: toItems?[.centerY] ??? self, attribute: itemAttributes?[.centerY] ?? .centerY, multiplier: 1.0, constant: _centerY)
            if let _priority = prioritys?[.centerY] {
                subViewCenterY.priority = UILayoutPriority(_priority)
            }
            addConstraint(subViewCenterY)
        }
    }
    
    /// badgeView的约束
    func constrainBadgeView(_ subview: UIView, targetView: HZNavigationBarItem, size: CGSize, offset: CGPoint) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        if let imageWidth = targetView.imageView?.bounds.width, let imageHeight = targetView.imageView?.bounds.height {
            let horizontalContraint = NSLayoutConstraint(
                item: subview,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: targetView,
                attribute: .centerX,
                multiplier: 1,
                constant: imageWidth / 2.0 + offset.x)

            let verticalContraint = NSLayoutConstraint(
                item: subview,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: targetView,
                attribute: .centerY,
                multiplier: 1,
                constant: -(imageHeight / 2.0) + offset.y)
            
            addConstraints([
                horizontalContraint,
                verticalContraint])

        }else {
            let topContraint = NSLayoutConstraint(
                item: subview,
                attribute: .top,
                relatedBy: .equal,
                toItem: targetView,
                attribute: .top,
                multiplier: 1,
                constant: -(size.height / 2.0) + offset.y)

            let trailingContraint = NSLayoutConstraint(
                item: subview,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: targetView,
                attribute: .trailing,
                multiplier: 1,
                constant: size.width / 2.0 + offset.x)

            addConstraints([
                topContraint,
                trailingContraint])
        }
        
        let widthContraint = NSLayoutConstraint(
            item: subview,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: size.width)
        
        let heightContraint = NSLayoutConstraint(
            item: subview,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: size.height)
        
        addConstraints([
            widthContraint,
            heightContraint])
    }
    
}
