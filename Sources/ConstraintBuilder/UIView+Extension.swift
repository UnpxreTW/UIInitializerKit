//
//  ConstraintBuilder
//
//  Copyright © 2026 Unpxre (GitHub: UnpxreTW)
//  Licensed under the Apache License 2.0. See LICENSE for details.
//
//  SPDX-License-Identifier: Apache-2.0

import UIKit

extension UIView {

	/// 使用基於定義的設定閉包快速建立約束，並回傳等價的 `NSLayoutConstraint`
	///
	/// - Parameter constraintDescriptions: 要啟用的約束設定閉包陣列
	/// - Returns: 建立完成的 `NSLayoutContraint`
	/// - note: 使用此方法時會自動將 `translatesAutoresizingMaskIntoConstraints` 設為 `false`；
	/// 但傳入空陣列時視為沒有事情要做，此旗標維持原值、不做任何變更
	@discardableResult
	public func addConstraints(
		_ constraintDescriptions: [Constraint]
	) -> [NSLayoutConstraint] {
		// 空陣列代表沒有約束要接手佈局。此時仍關掉 autoresizing mask 轉換的話，視圖會同時
		// 失去 autoresizing 佈局與 Auto Layout 約束而塌成零尺寸，且無編譯期錯誤、無執行期警示。
		guard !constraintDescriptions.isEmpty else { return [] }
		translatesAutoresizingMaskIntoConstraints = false
		let constraints = constraintDescriptions.map { $0(self) }
		NSLayoutConstraint.activate(constraints)
		return constraints
	}

	/// 使用基於定義的設定閉包快速建立約束，並回傳等價的 `NSLayoutConstraint`
	///
	/// - Parameter constraintsBuilder: 建立約束建構器
	/// - Returns: 建立完成的 `NSLayoutContraint`
	/// - note: 使用此方法時會自動將 `translatesAutoresizingMaskIntoConstraints` 設為 `false`；
	/// 但建構器產出空結果時（例如 `if` 條件不成立）視為沒有事情要做，此旗標維持原值
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
