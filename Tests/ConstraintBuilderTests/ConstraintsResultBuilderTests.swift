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

/// `ConstraintsResultBuilder` 的使用情境測試。
///
/// 目的是把 DSL 目前實際支援的控制流組合釘成 characterization baseline（記錄現行行為，
/// 不是驗證「正確」行為）——之後若要調整 `ConstraintsResultBuilder` 的重載組成，這份測試
/// 應該仍然全綠；若某個組合的行為被無意改動，這裡會先紅。
///
/// `for-in` 迴圈刻意不在本檔涵蓋範圍：目前 `buildArray` 的參數型別收 `[Constraint]`，
/// 但 `for-in` 迴圈每一輪由 `buildBlock` 產出的是 `[Constraint]`，整個迴圈收攏後應為
/// `[[Constraint]]`——型別不符，`for-in` 目前完全無法通過編譯。待該簽名修復後再補上對應測試。
@MainActor
private final class ConstraintsResultBuilderTests {

	// MARK: - 單條件（builder 內僅一條約束宣告，不含任何控制流）

	/// 單條件：builder 內僅一條約束宣告，回傳單一約束。
	@Test
	func `single statement adds one constraint`() {
		let view: UIView = .init()

		let constraints: [NSLayoutConstraint] = view.addConstraints {
			equal(\.widthAnchor, to: 100)
		}

		#expect(constraints.count == 1)
		#expect(constraints.first?.constant == 100)
	}

	// MARK: - 多條件（builder 內多條約束宣告依序疊加，不含任何控制流）

	/// 多條件：builder 內多條約束宣告依序疊加。
	@Test
	func `multiple statements accumulate in order`() {
		let view: UIView = .init()

		let constraints: [NSLayoutConstraint] = view.addConstraints {
			equal(\.widthAnchor, to: 100)
			equal(\.heightAnchor, to: 50)
		}

		#expect(constraints.count == 2)
		#expect(constraints[0].constant == 100)
		#expect(constraints[1].constant == 50)
	}

	// MARK: - if-else

	/// if-else：條件成立時走真分支。
	@Test
	func `if else picks true branch`() {
		let view: UIView = .init()
		let useWideLayout: Bool = true

		let constraints: [NSLayoutConstraint] = view.addConstraints {
			if useWideLayout {
				equal(\.widthAnchor, to: 200)
			} else {
				equal(\.widthAnchor, to: 60)
			}
		}

		#expect(constraints.count == 1)
		#expect(constraints.first?.constant == 200)
	}

	/// if-else：條件不成立時走假分支。
	@Test
	func `if else picks false branch`() {
		let view: UIView = .init()
		let useWideLayout: Bool = false

		let constraints: [NSLayoutConstraint] = view.addConstraints {
			if useWideLayout {
				equal(\.widthAnchor, to: 200)
			} else {
				equal(\.widthAnchor, to: 60)
			}
		}

		#expect(constraints.count == 1)
		#expect(constraints.first?.constant == 60)
	}

	// MARK: - switch

	private enum Size {
		case small
		case medium
		case large
	}

	private func widthConstraint(for size: Size) -> NSLayoutConstraint? {
		let view: UIView = .init()
		let constraints: [NSLayoutConstraint] = view.addConstraints {
			switch size {
			case .small:
				equal(\.widthAnchor, to: 10)
			case .medium:
				equal(\.widthAnchor, to: 20)
			case .large:
				equal(\.widthAnchor, to: 30)
			}
		}
		return constraints.first
	}

	/// switch：多 case 依序解析出對應約束。
	@Test
	func `switch resolves each case`() {
		#expect(widthConstraint(for: .small)?.constant == 10)
		#expect(widthConstraint(for: .medium)?.constant == 20)
		#expect(widthConstraint(for: .large)?.constant == 30)
	}

	// MARK: - if（無 else）

	/// if（無 else）：條件成立時附加約束。
	@Test
	func `if without else adds constraint when true`() {
		let view: UIView = .init()
		let addExtraConstraint: Bool = true

		let constraints: [NSLayoutConstraint] = view.addConstraints {
			equal(\.widthAnchor, to: 100)
			if addExtraConstraint {
				equal(\.heightAnchor, to: 40)
			}
		}

		#expect(constraints.count == 2)
		#expect(constraints[1].constant == 40)
	}

	/// if（無 else）：條件不成立時不附加約束。
	@Test
	func `if without else adds no constraint when false`() {
		let view: UIView = .init()
		let addExtraConstraint: Bool = false

		let constraints: [NSLayoutConstraint] = view.addConstraints {
			equal(\.widthAnchor, to: 100)
			if addExtraConstraint {
				equal(\.heightAnchor, to: 40)
			}
		}

		#expect(constraints.count == 1)
	}

	// MARK: - 巢狀混寫：if 內 switch

	private func widthConstraint(active: Bool, mode: Size) -> NSLayoutConstraint? {
		let view: UIView = .init()
		let constraints: [NSLayoutConstraint] = view.addConstraints {
			if active {
				switch mode {
				case .small:
					equal(\.widthAnchor, to: 11)
				case .medium:
					equal(\.widthAnchor, to: 22)
				case .large:
					equal(\.widthAnchor, to: 33)
				}
			} else {
				equal(\.widthAnchor, to: 0)
			}
		}
		return constraints.first
	}

	/// 巢狀混寫：if 內 switch 正確解析。
	@Test
	func `nested switch inside if resolves correctly`() {
		#expect(widthConstraint(active: true, mode: .small)?.constant == 11)
		#expect(widthConstraint(active: true, mode: .medium)?.constant == 22)
		#expect(widthConstraint(active: false, mode: .large)?.constant == 0)
	}

	// MARK: - 巢狀混寫：switch 內 if

	private func widthConstraint(mode: Size, flag: Bool) -> NSLayoutConstraint? {
		let view: UIView = .init()
		let constraints: [NSLayoutConstraint] = view.addConstraints {
			switch mode {
			case .small:
				if flag {
					equal(\.widthAnchor, to: 111)
				} else {
					equal(\.widthAnchor, to: 222)
				}
			case .medium, .large:
				equal(\.widthAnchor, to: 333)
			}
		}
		return constraints.first
	}

	/// 巢狀混寫：switch 內 if 正確解析。
	@Test
	func `nested if inside switch resolves correctly`() {
		#expect(widthConstraint(mode: .small, flag: true)?.constant == 111)
		#expect(widthConstraint(mode: .small, flag: false)?.constant == 222)
		#expect(widthConstraint(mode: .medium, flag: true)?.constant == 333)
	}
}
