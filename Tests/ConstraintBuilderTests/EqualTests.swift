//
//  ConstraintBuilderTests
//
//  Copyright © 2026 Unpxre (GitHub: UnpxreTW)
//  Licensed under the Apache License 2.0. See LICENSE for details.
//
//  SPDX-License-Identifier: Apache-2.0

import Testing
import UIKit
import ConstraintBuilder

/// `equal()` 各重載函式的行為驗證。
///
/// 逐一涵蓋 `Constraint.swift` 內每個 `equal` 重載：確認回傳的 `Constraint` 閉包套用到呼叫視圖後，
/// 會產生對應 `relation`／`constant`／`multiplier` 與正確參考 anchor 的 `NSLayoutConstraint`。
@MainActor
private final class EqualTests {

	// MARK: - 單視圖與常數的關係

	/// `equal(_:to:)`：與常數的 `.equal` 關係。
	@Test
	func `equal to constant produces equal relation`() {
		let view: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.widthAnchor, to: 100)(view)

		#expect(constraint.relation == .equal)
		#expect(constraint.constant == 100)
	}

	/// `equal(_:greaterOrEqual:)`：與常數的 `.greaterThanOrEqual` 關係。
	@Test
	func `equal greaterOrEqual constant produces greaterThanOrEqual relation`() {
		let view: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.heightAnchor, greaterOrEqual: 40)(view)

		#expect(constraint.relation == .greaterThanOrEqual)
		#expect(constraint.constant == 40)
	}

	/// `equal(_:lessOrEqual:)`：與常數的 `.lessThanOrEqual` 關係。
	@Test
	func `equal lessOrEqual constant produces lessThanOrEqual relation`() {
		let view: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.widthAnchor, lessOrEqual: 200)(view)

		#expect(constraint.relation == .lessThanOrEqual)
		#expect(constraint.constant == 200)
	}

	// MARK: - 雙視圖對應 anchor 的關係

	/// `equal(_:to:_:constant:)`：兩視圖對應 anchor 的 `.equal` 常數關係，且參考正確的兩端 anchor。
	@Test
	func `equal to view anchor produces equal relation with constant`() {
		let view: UIView = .init()
		let reference: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.leadingAnchor, to: reference, \.trailingAnchor, constant: 8)(view)

		#expect(constraint.relation == .equal)
		#expect(constraint.constant == 8)
		#expect(constraint.firstItem === view)
		#expect(constraint.secondItem === reference)
	}

	/// `equal(_:to:_:constant:)`：`constant` 未指定時預設為 `0`。
	@Test
	func `equal to view anchor defaults constant to zero`() {
		let view: UIView = .init()
		let reference: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.topAnchor, to: reference, \.bottomAnchor)(view)

		#expect(constraint.constant == 0)
	}

	/// `equal(_:to:constant:)`：便利重載，兩視圖同一 anchor 的 `.equal` 常數關係。
	@Test
	func `equal to view same anchor produces equal relation`() {
		let view: UIView = .init()
		let reference: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.centerXAnchor, to: reference, constant: 4)(view)

		#expect(constraint.relation == .equal)
		#expect(constraint.constant == 4)
		#expect(constraint.firstItem === view)
		#expect(constraint.secondItem === reference)
	}

	// MARK: - 雙視圖比例關係

	/// `equal(_:to:_:ratio:)`：兩視圖 dimension anchor 的比例（`multiplier`）關係。
	@Test
	func `equal to view anchor ratio produces multiplier relation`() {
		let view: UIView = .init()
		let reference: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.widthAnchor, to: reference, \.widthAnchor, ratio: 0.5)(view)

		#expect(constraint.relation == .equal)
		#expect(constraint.multiplier == 0.5)
		#expect(constraint.firstItem === view)
		#expect(constraint.secondItem === reference)
	}

	// MARK: - 雙視圖對應 anchor 的不等式關係

	/// `equal(_:to:_:lessOrEqual:)`：兩視圖對應 anchor 的 `.lessThanOrEqual` 關係。
	@Test
	func `equal to view anchor lessOrEqual produces lessThanOrEqual relation`() {
		let view: UIView = .init()
		let reference: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.trailingAnchor, to: reference, \.trailingAnchor, lessOrEqual: -8)(view)

		#expect(constraint.relation == .lessThanOrEqual)
		#expect(constraint.constant == -8)
	}

	/// `equal(_:to:_:greaterOrEqual:)`：兩視圖對應 anchor 的 `.greaterThanOrEqual` 關係。
	@Test
	func `equal to view anchor greaterOrEqual produces greaterThanOrEqual relation`() {
		let view: UIView = .init()
		let reference: UIView = .init()

		let constraint: NSLayoutConstraint = equal(\.leadingAnchor, to: reference, \.leadingAnchor, greaterOrEqual: 8)(view)

		#expect(constraint.relation == .greaterThanOrEqual)
		#expect(constraint.constant == 8)
	}
}
