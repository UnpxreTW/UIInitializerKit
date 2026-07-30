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
