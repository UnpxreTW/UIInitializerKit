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

/// `UIView.addConstraints(_:)` 在「沒有任何約束要加」時的行為。
///
/// 空結果不是假想輸入：`ConstraintsResultBuilder` 的 `buildOptional` 讓條件式約束成為預期用法，
/// `if` 條件不成立的分支產出的就是空結果。此時若仍關掉 `translatesAutoresizingMaskIntoConstraints`，
/// 視圖會同時失去 autoresizing 佈局與 Auto Layout 約束——無編譯期錯誤、無執行期警示的無聲失效。
@MainActor
private final class UIViewAddConstraintsTests {

	/// 空陣列不動 `translatesAutoresizingMaskIntoConstraints`，也不產生任何約束。
	@Test
	func `addConstraints with empty array leaves autoresizing mask translation untouched`() {
		let view: UIView = .init()
		let noConstraints: [Constraint] = []

		let constraints: [NSLayoutConstraint] = view.addConstraints(noConstraints)

		#expect(view.translatesAutoresizingMaskIntoConstraints)
		#expect(constraints.isEmpty)
		#expect(view.constraints.isEmpty)
	}

	/// 「維持原值」不等於「設回 `true`」：先前已改走 Auto Layout 的視圖，不該被一次空呼叫翻回去。
	@Test
	func `addConstraints with empty array does not restore autoresizing mask translation`() {
		let view: UIView = .init()
		view.translatesAutoresizingMaskIntoConstraints = false
		let noConstraints: [Constraint] = []

		view.addConstraints(noConstraints)

		#expect(view.translatesAutoresizingMaskIntoConstraints == false)
	}

	/// 非空陣列照舊關掉旗標並啟用約束——空結果的早退不得波及正常路徑。
	@Test
	func `addConstraints still disables autoresizing mask translation for a non empty array`() {
		let view: UIView = .init()

		let constraints: [NSLayoutConstraint] = view.addConstraints([equal(\.widthAnchor, to: 100)])

		#expect(view.translatesAutoresizingMaskIntoConstraints == false)
		#expect(constraints.count == 1)
		#expect(constraints.first?.isActive == true)
	}

	/// 建構器路徑的空結果（`if` 條件不成立）與直接傳空陣列一致。
	@Test
	func `addConstraints builder with an unmet condition leaves autoresizing mask translation untouched`() {
		let view: UIView = .init()
		let pinsExplicitHeight: Bool = false

		let constraints: [NSLayoutConstraint] = view.addConstraints {
			if pinsExplicitHeight {
				equal(\.heightAnchor, to: 44)
			}
		}

		#expect(view.translatesAutoresizingMaskIntoConstraints)
		#expect(constraints.isEmpty)
	}

	/// 經 `addSubview(_:withConstraints:)` 進來的空結果同樣不動旗標，但子視圖仍照常掛進階層。
	@Test
	func `addSubview withConstraints with an empty result still adds the view untouched`() {
		let superview: UIView = .init()
		let subview: UIView = .init()
		let pinsExplicitHeight: Bool = false

		superview.addSubview(subview) {
			if pinsExplicitHeight {
				equal(\.heightAnchor, to: 44)
			}
		}

		#expect(subview.superview === superview)
		#expect(subview.translatesAutoresizingMaskIntoConstraints)
		#expect(subview.constraints.isEmpty)
	}
}
