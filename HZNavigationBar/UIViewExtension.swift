//
//  UIView_Extension.swift
//  test
//
//  Created by 何志志 on 2019/3/7.
//  Copyright © 2019 何志志. All rights reserved.
//

import UIKit

infix operator ???
public func ??? <T>(left: T??, right: T) -> T {
    if let _left = left, let left_ = _left {
        return left_
    }else {
        return right
    }
}

public extension UIView {
    
    /// 设置约束
    /// - Parameters:
    ///   - subView: 设置约束的子View
    ///   - constants: 约束字典  key为子View的约束    value为约束值
    func makeConstraints(with subView: UIView, constants: [NSLayoutConstraint.Attribute: CGFloat]) {
        makeConstraints(with: subView, constants: constants, toItems: nil, attributes: nil, multipliers: nil, prioritys: nil)
    }
    
    /// 设置约束
    /// - Parameters:
    ///   - subView: 设置约束的子View
    ///   - constants: 约束字典  key为子View的约束    value为约束值
    ///   - relatedBys: 相对于字典
    ///   - toItems: 相对View 字典  key为子View的约束    value为相对View
    ///   - attributes: 相对View的约束  [key: value]   key为子View的约束    value为相对View的约束
    ///   - multipliers: 相对View的约束比例  [key: value]   key为子View的约束    value为比例
    ///   - prioritys: 相对View的优先级  [key: value]   key为子View的约束    value为优先级
    func makeConstraints(with subView: UIView, constants: [NSLayoutConstraint.Attribute: CGFloat], relatedBys: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Relation]? = nil, toItems: [NSLayoutConstraint.Attribute: UIView?]? = nil, attributes: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Attribute]? = nil, multipliers: [NSLayoutConstraint.Attribute: CGFloat]? = nil, prioritys: [NSLayoutConstraint.Attribute: Float]? = nil) {
        addConstraints(with: subView, constants: constants, relatedBys: relatedBys, toItems: toItems, attributes: attributes, multipliers: multipliers, prioritys: prioritys)
    }
    
    /// 更新约束
    /// - Parameters:
    ///   - subView: 设置约束的子View
    ///   - constants: 约束字典  key为子View的约束    value为约束值
    ///   - relatedBys: 相对于字典
    ///   - toItems: 相对View 字典  key为子View的约束    value为相对View
    ///   - attributes: 相对View的约束  [key: value]   key为子View的约束    value为相对View的约束
    ///   - multipliers: 相对View的约束比例  [key: value]   key为子View的约束    value为比例
    ///   - prioritys: 相对View的优先级  [key: value]   key为子View的约束    value为优先级
    func updateConstraints(with subView: UIView, constants: [NSLayoutConstraint.Attribute: CGFloat], relatedBys: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Relation]? = nil, toItems: [NSLayoutConstraint.Attribute: UIView?]? = nil, attributes: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Attribute]? = nil, multipliers: [NSLayoutConstraint.Attribute: CGFloat]? = nil, prioritys: [NSLayoutConstraint.Attribute: Float]? = nil) {
        addConstraints(with: subView, constants: constants, relatedBys: relatedBys, toItems: toItems, attributes: attributes, multipliers: multipliers, prioritys: prioritys, isUpdate: true)
    }
    
    /// 更新约束
    /// - Parameters:
    ///   - subView: 设置约束的子View
    ///   - constants: 约束字典  key为子View的约束    value为约束值
    func updateConstraints(with subView: UIView, constants: [NSLayoutConstraint.Attribute: CGFloat]) {
        addConstraints(with: subView, constants: constants, relatedBys: nil, toItems: nil, attributes: nil, multipliers: nil, prioritys: nil, isUpdate: true)
    }
    
    /// 移除已有约束再设置约束
    /// - Parameters:
    ///   - subView: 设置约束的子View
    ///   - constants: 约束字典  key为子View的约束    value为约束值
    ///   - relatedBys: 相对于字典
    ///   - toItems: 相对View 字典  key为子View的约束    value为相对View
    ///   - attributes: 相对View的约束  [key: value]   key为子View的约束    value为相对View的约束
    ///   - multipliers: 相对View的约束比例  [key: value]   key为子View的约束    value为比例
    ///   - prioritys: 相对View的优先级  [key: value]   key为子View的约束    value为优先级
    func remakeConstraints(with subView: UIView, constants: [NSLayoutConstraint.Attribute: CGFloat], relatedBys: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Relation]? = nil, toItems: [NSLayoutConstraint.Attribute: UIView?]? = nil, attributes: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Attribute]? = nil, multipliers: [NSLayoutConstraint.Attribute: CGFloat]? = nil, prioritys: [NSLayoutConstraint.Attribute: Float]? = nil) {
        addConstraints(with: subView, constants: constants, relatedBys: relatedBys, toItems: toItems, attributes: attributes, multipliers: multipliers, prioritys: prioritys, isRemove: true)
    }
    
    /// 移除已有约束再设置约束
    /// - Parameters:
    ///   - subView: 设置约束的子View
    ///   - constants: 约束字典  key为子View的约束    value为约束值
    func remakeConstraints(with subView: UIView, constants: [NSLayoutConstraint.Attribute: CGFloat]) {
        addConstraints(with: subView, constants: constants, relatedBys: nil, toItems: nil, attributes: nil, multipliers: nil, prioritys: nil, isRemove: true)
    }
    
    fileprivate func addConstraints(with subView: UIView, constants: [NSLayoutConstraint.Attribute: CGFloat], relatedBys: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Relation]? = nil, toItems: [NSLayoutConstraint.Attribute: UIView?]? = nil, attributes: [NSLayoutConstraint.Attribute: NSLayoutConstraint.Attribute]? = nil, multipliers: [NSLayoutConstraint.Attribute: CGFloat]? = nil, prioritys: [NSLayoutConstraint.Attribute: Float]? = nil, isUpdate: Bool = false, isRemove: Bool = false) {
        constraints.forEach { layoutConstraint in
            if let _firstItem = layoutConstraint.firstItem as? UIView, _firstItem == subView {
                if (isUpdate && constants.keys.contains(layoutConstraint.firstAttribute)) || isRemove {
                    layoutConstraint.isActive = false
                }
            }
        }
        subView.translatesAutoresizingMaskIntoConstraints = false
        constants.forEach { kv in
            let isWH = (kv.key == .width && toItems?[kv.key] == nil) || (kv.key == .height && toItems?[kv.key] == nil)
            let layoutConstraint = NSLayoutConstraint(item: subView, attribute: kv.key, relatedBy: relatedBys?[kv.key] ?? .equal, toItem: isWH ? nil : (toItems?[kv.key] ??? self), attribute: attributes?[kv.key] ?? ((kv.key == .width && kv.key == .height) ? .notAnAttribute : kv.key), multiplier: multipliers?[kv.key] ?? 1.0, constant: kv.value)
            if let _priority = prioritys?[kv.key] {
                layoutConstraint.priority = UILayoutPriority(_priority)
            }
            addConstraint(layoutConstraint)
        }
    }
    
}
