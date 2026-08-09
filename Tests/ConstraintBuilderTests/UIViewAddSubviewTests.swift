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

/// `UIView.addSubview(_:withConstraints:)` 的整合測試。
///
/// 驗證此方法同時完成兩件事：把子視圖掛進視圖階層、並啟用 builder 描述的約束——
/// 兩者缺一都會讓呼叫端埋下難查的執行期 bug（漏掛階層仍可編譯、漏啟用約束仍可編譯）。
@MainActor
private final class UIViewAddSubviewTests {

	/// 子視圖確實被加入父視圖階層。
	@Test
	func `addSubview withConstraints adds view to hierarchy`() {
		let superview: UIView = .init()
		let subview: UIView = .init()

		superview.addSubview(subview) {
			equal(\.widthAnchor, to: 100)
		}

		#expect(subview.superview === superview)
		#expect(superview.subviews.contains(subview))
	}

	/// 子視圖的 `translatesAutoresizingMaskIntoConstraints` 被自動設為 `false`。
	@Test
	func `addSubview withConstraints disables autoresizing mask translation`() {
		let superview: UIView = .init()
		let subview: UIView = .init()

		superview.addSubview(subview) {
			equal(\.heightAnchor, to: 40)
		}

		#expect(subview.translatesAutoresizingMaskIntoConstraints == false)
	}

	/// builder 描述的約束確實被啟用（`isActive == true`）並掛在子視圖上。
	@Test
	func `addSubview withConstraints activates described constraints`() {
		let superview: UIView = .init()
		let subview: UIView = .init()

		superview.addSubview(subview) {
			equal(\.widthAnchor, to: 120)
			equal(\.heightAnchor, to: 60)
		}

		let activeConstraints: [NSLayoutConstraint] = subview.constraints.filter(\.isActive)
		#expect(activeConstraints.count == 2)
		#expect(activeConstraints.contains { $0.constant == 120 })
		#expect(activeConstraints.contains { $0.constant == 60 })
	}

	/// 回傳的約束就是實際被啟用的那幾條——數量與 builder 宣告數相符、皆 `isActive`，
	/// 且與子視圖身上的約束是同一批物件（呼叫端拿到的是 handle，不是複本）。
	///
	/// 此處用的是自參考的尺寸約束，故安裝點就在子視圖身上；跨視圖約束會安裝到共同祖先，
	/// 見 `addSubview withConstraints returns cross view constraints installed on the ancestor`。
	@Test
	func `addSubview withConstraints returns the activated constraints`() {
		let superview: UIView = .init()
		let subview: UIView = .init()

		let constraints: [NSLayoutConstraint] = superview.addSubview(subview) {
			equal(\.widthAnchor, to: 100)
			equal(\.heightAnchor, to: 44)
		}

		// 先算成 Bool 再交給 #expect：`allSatisfy` 是 rethrows，直接寫進巨集會展開成需要 try 的形式。
		let allActive: Bool = constraints.allSatisfy(\.isActive)
		let allAttachedToSubview: Bool = constraints.allSatisfy { subview.constraints.contains($0) }
		#expect(constraints.count == 2)
		#expect(allActive)
		#expect(allAttachedToSubview)
	}

	/// 跨視圖約束由 Auto Layout 安裝到共同祖先（此處＝父視圖）而非子視圖身上，
	/// 但回傳值一樣拿得到——而這正是呼叫端最需要 handle 的情形（改 offset 做動畫）。
	@Test
	func `addSubview withConstraints returns cross view constraints installed on the ancestor`() {
		let superview: UIView = .init()
		let subview: UIView = .init()

		let constraints: [NSLayoutConstraint] = superview.addSubview(subview) {
			equal(\.topAnchor, to: superview, \.topAnchor, constant: 16)
		}

		#expect(constraints.count == 1)
		#expect(constraints.first?.isActive == true)
		#expect(superview.constraints.contains { $0 === constraints.first })
		#expect(subview.constraints.isEmpty)
	}

	/// 回傳值可直接當 handle 使用：改 `constant` 立即反映在子視圖身上那條約束，
	/// 不必退回「先 `addSubview` 再 `addConstraints`」兩步寫法才拿得到。
	@Test
	func `returned constraints stay mutable handles onto the live layout`() {
		let superview: UIView = .init()
		let subview: UIView = .init()

		let constraints: [NSLayoutConstraint] = superview.addSubview(subview) {
			equal(\.widthAnchor, to: 100)
		}
		constraints.first?.constant = 250

		#expect(subview.constraints.contains { $0.constant == 250 })
	}

	/// builder 支援控制流（`if`）：確認 `addSubview(_:withConstraints:)` 有把 builder 正確轉發給
	/// `addConstraints`，非重複測試 `ConstraintsResultBuilder` 控制流本身。
	@Test
	func `addSubview withConstraints forwards result builder control flow`() {
		let superview: UIView = .init()
		let subview: UIView = .init()
		let useTallLayout: Bool = true

		superview.addSubview(subview) {
			if useTallLayout {
				equal(\.heightAnchor, to: 200)
			} else {
				equal(\.heightAnchor, to: 50)
			}
		}

		let activeConstraints: [NSLayoutConstraint] = subview.constraints.filter(\.isActive)
		#expect(activeConstraints.count == 1)
		#expect(activeConstraints.first?.constant == 200)
	}
}
