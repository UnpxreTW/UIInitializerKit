//
//  UIView+Extension.swift
//  ConstraintBuilder
//
//  Copyright © 2024 UnpxreTW. All rights reserved.
//

import UIKit

extension UIView {

    /// 使用基於定義的設定閉包快速建立約束，並回傳等價的 `NSLayoutConstraint`
    ///
    /// - Parameter constraintDescriptions: 要啟用的約束設定閉包陣列
    /// - Returns: 建立完成的 `NSLayoutContraint`
    /// - note: 使用此方法時會自動將 `translatesAutoresizingMaskIntoConstraints` 設為 `false`
    @discardableResult
    public func addConstraints(
        _ constraintDescriptions: [Constraint]
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = constraintDescriptions.map { $0(self) }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// 使用基於定義的設定閉包快速建立約束，並回傳等價的 `NSLayoutConstraint`
    ///
    /// - Parameter constraintsBuilder: 建立約束建構器
    /// - Returns: 建立完成的 `NSLayoutContraint`
    /// - note: 使用此方法時會自動將 `translatesAutoresizingMaskIntoConstraints` 設為 `false`
    @discardableResult
    public func addConstraints(
        @ConstraintsResultBuilder _ constraintsBuilder: () -> [Constraint]
    ) -> [NSLayoutConstraint] {
        addConstraints(constraintsBuilder())
    }

    @discardableResult
    public func addConstraint(
        _ constraintDescriptions: Constraint
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = constraintDescriptions(self)
        constraint.isActive = true
        return constraint
    }

    /// 新增視圖的同時配置視圖的約束
    public func addSubview(
        _ view: some UIView,
        @ConstraintsResultBuilder withConstraints constraintsBuilder: () -> [Constraint]
    ) {
        addSubview(view)
        view.addConstraints(constraintsBuilder())
    }
}
