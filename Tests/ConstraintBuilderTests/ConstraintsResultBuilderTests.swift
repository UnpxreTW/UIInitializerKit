//
//  ConstraintBuilderTests
//
//  Copyright © 2026 Unpxre (GitHub: UnpxreTW)
//  Licensed under the Apache License 2.0. See LICENSE for details.
//
//  SPDX-License-Identifier: Apache-2.0

import XCTest
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
final class ConstraintsResultBuilderTests: XCTestCase {

	// MARK: - 單條件（builder 內僅一條約束宣告，不含任何控制流）

	func test_singleStatement() {
		let view = UIView()

		let constraints = view.addConstraints {
			equal(\.widthAnchor, to: 100)
		}

		XCTAssertEqual(constraints.count, 1)
		XCTAssertEqual(constraints.first?.constant, 100)
	}

	// MARK: - 多條件（builder 內多條約束宣告依序疊加，不含任何控制流）

	func test_multipleStatements() {
		let view = UIView()

		let constraints = view.addConstraints {
			equal(\.widthAnchor, to: 100)
			equal(\.heightAnchor, to: 50)
		}

		XCTAssertEqual(constraints.count, 2)
		XCTAssertEqual(constraints[0].constant, 100)
		XCTAssertEqual(constraints[1].constant, 50)
	}

	// MARK: - if-else

	func test_ifElse_trueBranch() {
		let view = UIView()
		let useWideLayout = true

		let constraints = view.addConstraints {
			if useWideLayout {
				equal(\.widthAnchor, to: 200)
			} else {
				equal(\.widthAnchor, to: 60)
			}
		}

		XCTAssertEqual(constraints.count, 1)
		XCTAssertEqual(constraints.first?.constant, 200)
	}

	func test_ifElse_falseBranch() {
		let view = UIView()
		let useWideLayout = false

		let constraints = view.addConstraints {
			if useWideLayout {
				equal(\.widthAnchor, to: 200)
			} else {
				equal(\.widthAnchor, to: 60)
			}
		}

		XCTAssertEqual(constraints.count, 1)
		XCTAssertEqual(constraints.first?.constant, 60)
	}

	// MARK: - switch

	private enum Size {
		case small
		case medium
		case large
	}

	private func widthConstraint(for size: Size) -> NSLayoutConstraint? {
		let view = UIView()
		let constraints = view.addConstraints {
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

	func test_switch_allCases() {
		XCTAssertEqual(widthConstraint(for: .small)?.constant, 10)
		XCTAssertEqual(widthConstraint(for: .medium)?.constant, 20)
		XCTAssertEqual(widthConstraint(for: .large)?.constant, 30)
	}

	// MARK: - if（無 else）

	func test_ifWithoutElse_conditionTrue() {
		let view = UIView()
		let addExtraConstraint = true

		let constraints = view.addConstraints {
			equal(\.widthAnchor, to: 100)
			if addExtraConstraint {
				equal(\.heightAnchor, to: 40)
			}
		}

		XCTAssertEqual(constraints.count, 2)
		XCTAssertEqual(constraints[1].constant, 40)
	}

	func test_ifWithoutElse_conditionFalse() {
		let view = UIView()
		let addExtraConstraint = false

		let constraints = view.addConstraints {
			equal(\.widthAnchor, to: 100)
			if addExtraConstraint {
				equal(\.heightAnchor, to: 40)
			}
		}

		XCTAssertEqual(constraints.count, 1)
	}

	// MARK: - 巢狀混寫：if 內 switch

	private func widthConstraint(active: Bool, mode: Size) -> NSLayoutConstraint? {
		let view = UIView()
		let constraints = view.addConstraints {
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

	func test_nested_switchInsideIf() {
		XCTAssertEqual(widthConstraint(active: true, mode: .small)?.constant, 11)
		XCTAssertEqual(widthConstraint(active: true, mode: .medium)?.constant, 22)
		XCTAssertEqual(widthConstraint(active: false, mode: .large)?.constant, 0)
	}

	// MARK: - 巢狀混寫：switch 內 if

	private func widthConstraint(mode: Size, flag: Bool) -> NSLayoutConstraint? {
		let view = UIView()
		let constraints = view.addConstraints {
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

	func test_nested_ifInsideSwitch() {
		XCTAssertEqual(widthConstraint(mode: .small, flag: true)?.constant, 111)
		XCTAssertEqual(widthConstraint(mode: .small, flag: false)?.constant, 222)
		XCTAssertEqual(widthConstraint(mode: .medium, flag: true)?.constant, 333)
	}
}
