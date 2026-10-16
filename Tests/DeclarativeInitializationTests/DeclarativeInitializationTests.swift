//
//  DeclarativeInitializationTests
//
//  Copyright © 2026 Unpxre (GitHub: UnpxreTW)
//  Licensed under the Apache License 2.0. See LICENSE for details.
//
//  SPDX-License-Identifier: Apache-2.0

import Testing
import UIKit
import DeclarativeInitialization

/// `DeclarativeInitialization` 各特化 `init` 的行為驗證。
///
/// 涵蓋 `UIButton`／`UIStackView`／`UITableView`／`UIVisualEffectView`／`UIBarButtonItem` 的專用初始化器：
/// 確認閉包內的設定確實套用到新建的實例上，且各參數（如 `type`／`style`／`effect`／`title`）被正確
/// 傳入底層原生初始化器；連帶涵蓋 `UIView` 通用的 `configureHandler(s)` 基底初始化器。
@MainActor
private final class DeclarativeInitializationTests {

	// MARK: - UIView 通用初始化器

	/// `init(configureHandler:)`：單一設定閉包套用到新建視圖。
	@Test
	func `configureHandler init applies configuration`() {
		let view: UIView = .init { view in
			view.tag = 42
		}

		#expect(view.tag == 42)
	}

	/// `init(configureHandlers:)`：多個設定閉包依序套用、後者可覆蓋前者。
	@Test
	func `configureHandlers init applies handlers in order`() {
		let view: UIView = .init(
			configureHandlers: { view in view.tag = 1 },
			{ view in view.tag = 2 }
		)

		#expect(view.tag == 2)
	}

	// MARK: - UIButton

	/// `init(type:configureHandler:)`：`type` 傳入底層初始化器、設定閉包套用到按鈕。
	@Test
	func `button init with type applies configuration`() {
		let button: UIButton = .init(type: .system) { button in
			button.tag = 7
		}

		#expect(button.buttonType == .system)
		#expect(button.tag == 7)
	}

	/// `init(type:configureHandler:)`：`type` 未指定時預設為 `.custom`。
	@Test
	func `button init defaults type to custom`() {
		let button: UIButton = .init { _ in }

		#expect(button.buttonType == .custom)
	}

	/// `init(type:configureHandlers:)`：多個設定閉包依序套用到按鈕。
	@Test
	func `button init with type applies multiple handlers in order`() {
		let button: UIButton = .init(
			type: .system,
			configureHandlers: { button in button.tag = 1 },
			{ button in button.tag = 2 }
		)

		#expect(button.tag == 2)
	}

	/// `init(configuration:configureHandler:)`：`UIButton.Configuration` 傳入底層初始化器、
	/// 設定閉包套用到按鈕。
	@available(iOS 15.0, *)
	@Test
	func `button init with configuration applies configuration`() {
		let button: UIButton = .init(configuration: .plain()) { button in
			button.tag = 9
		}

		#expect(button.configuration != nil)
		#expect(button.tag == 9)
	}

	/// `init(configuration:configureHandlers:)`：多個設定閉包依序套用到帶 `Configuration` 的按鈕。
	@available(iOS 15.0, *)
	@Test
	func `button init with configuration applies multiple handlers in order`() {
		let button: UIButton = .init(
			configuration: .plain(),
			configureHandlers: { button in button.tag = 1 },
			{ button in button.tag = 2 }
		)

		#expect(button.tag == 2)
	}

	// MARK: - UIStackView

	/// `init(arrangedSubviews:configureHandler:)`：排列子視圖傳入底層初始化器、設定閉包套用到堆疊視圖。
	@Test
	func `stackView init applies arrangedSubviews and configuration`() {
		let subview: UIView = .init()

		let stackView: UIStackView = .init(arrangedSubviews: [subview]) { stackView in
			stackView.axis = .vertical
		}

		#expect(stackView.arrangedSubviews == [subview])
		#expect(stackView.axis == .vertical)
	}

	// MARK: - UITableView

	/// `init(style:configureHandler:)`：`style` 傳入底層初始化器、設定閉包套用到表格視圖。
	@Test
	func `tableView init with style applies configuration`() {
		let tableView: UITableView = .init(style: .grouped) { tableView in
			tableView.tag = 3
		}

		#expect(tableView.style == .grouped)
		#expect(tableView.tag == 3)
	}

	/// `init(style:configureHandler:)`：`style` 未指定時預設為 `.plain`。
	@Test
	func `tableView init defaults style to plain`() {
		let tableView: UITableView = .init { _ in }

		#expect(tableView.style == .plain)
	}

	// MARK: - UIVisualEffectView

	/// `init(effect:configureHandler:)`：`effect` 傳入底層初始化器、設定閉包套用到視覺效果檢視。
	@Test
	func `visualEffectView init with effect applies configuration`() {
		let effect: UIBlurEffect = .init(style: .light)

		let visualEffectView: UIVisualEffectView = .init(effect: effect) { visualEffectView in
			visualEffectView.tag = 5
		}

		#expect(visualEffectView.effect === effect)
		#expect(visualEffectView.tag == 5)
	}

	/// `init(effect:configureHandlers:)`：多個設定閉包依序套用到帶 `effect` 的視覺效果檢視。
	@Test
	func `visualEffectView init with effect applies multiple handlers in order`() {
		let visualEffectView: UIVisualEffectView = .init(
			effect: nil,
			configureHandlers: { visualEffectView in visualEffectView.tag = 1 },
			{ visualEffectView in visualEffectView.tag = 2 }
		)

		#expect(visualEffectView.tag == 2)
	}

	// MARK: - UIBarButtonItem

	/// `init(title:image:primaryAction:menu:configureHandler:)`：各參數傳入底層初始化器、
	/// 設定閉包套用到列按鈕。
	@Test
	func `barButtonItem init with title applies configuration`() {
		let image: UIImage = .init()
		let primaryAction: UIAction = .init(title: "Primary", identifier: .init("primary")) { _ in }
		let menu: UIMenu = .init(title: "Menu", identifier: .init("menu"), children: [])

		let barButtonItem: UIBarButtonItem = .init(
			title: "Done",
			image: image,
			primaryAction: primaryAction,
			menu: menu
		) { barButtonItem in
			barButtonItem.tag = 11
		}

		#expect(barButtonItem.title == "Done")
		#expect(barButtonItem.image === image)
		// UIKit 不保留傳入的 `primaryAction`／`menu` 實例（見原生初始化器對照測試），改比對 identifier。
		#expect(barButtonItem.primaryAction?.identifier == primaryAction.identifier)
		#expect(barButtonItem.menu?.identifier == menu.identifier)
		#expect(barButtonItem.tag == 11)
	}

	/// 對照組：直接使用原生 `init(title:image:primaryAction:menu:)`（不經本套件），取回的
	/// `primaryAction`／`menu` 也與傳入者非同一實例，`image` 則是同一實例。
	///
	/// 證明上方測試改比對 identifier 的原因是 UIKit 本身的行為，而非本套件初始化器造成；
	/// 若 UIKit 日後改為保留同一實例，此測試會失敗以提醒回頭檢視上方測試的比對方式。
	@Test
	func `native barButtonItem init does not keep primaryAction and menu instances`() {
		let image: UIImage = .init()
		let primaryAction: UIAction = .init(title: "Primary", identifier: .init("primary")) { _ in }
		let menu: UIMenu = .init(title: "Menu", identifier: .init("menu"), children: [])

		let barButtonItem: UIBarButtonItem = .init(
			title: "Done",
			image: image,
			primaryAction: primaryAction,
			menu: menu
		)

		#expect(barButtonItem.image === image)
		#expect(barButtonItem.primaryAction !== primaryAction)
		#expect(barButtonItem.primaryAction?.identifier == primaryAction.identifier)
		#expect(barButtonItem.menu !== menu)
		#expect(barButtonItem.menu?.identifier == menu.identifier)
	}

	/// `init(title:image:primaryAction:menu:configureHandler:)`：參數皆未指定時僅套用設定閉包。
	@Test
	func `barButtonItem init defaults to empty item`() {
		let barButtonItem: UIBarButtonItem = .init { barButtonItem in
			barButtonItem.tag = 12
		}

		#expect(barButtonItem.title == nil)
		#expect(barButtonItem.image == nil)
		#expect(barButtonItem.primaryAction == nil)
		#expect(barButtonItem.menu == nil)
		#expect(barButtonItem.tag == 12)
	}

	/// `init(title:image:primaryAction:menu:configureHandlers:)`：多個設定閉包依序套用到列按鈕。
	@Test
	func `barButtonItem init with title applies multiple handlers in order`() {
		let barButtonItem: UIBarButtonItem = .init(
			title: "Done",
			configureHandlers: { barButtonItem in barButtonItem.tag = 1 },
			{ barButtonItem in barButtonItem.tag = 2 }
		)

		#expect(barButtonItem.title == "Done")
		#expect(barButtonItem.tag == 2)
	}

	/// `init(systemItem:primaryAction:menu:configureHandler:)`：系統項目建立、設定閉包套用到列按鈕。
	@Test
	func `barButtonItem init with systemItem applies configuration`() {
		let menu: UIMenu = .init(title: "Menu", identifier: .init("menu"), children: [])

		let barButtonItem: UIBarButtonItem = .init(systemItem: .add, menu: menu) { barButtonItem in
			barButtonItem.tag = 13
		}

		#expect(barButtonItem.menu?.identifier == menu.identifier)
		#expect(barButtonItem.tag == 13)
	}

	/// `init(systemItem:primaryAction:menu:configureHandlers:)`：多個設定閉包依序套用到系統項目列按鈕。
	@Test
	func `barButtonItem init with systemItem applies multiple handlers in order`() {
		let barButtonItem: UIBarButtonItem = .init(
			systemItem: .done,
			configureHandlers: { barButtonItem in barButtonItem.tag = 1 },
			{ barButtonItem in barButtonItem.tag = 2 }
		)

		#expect(barButtonItem.tag == 2)
	}

	/// `init(customView:configureHandler:)`：自訂視圖傳入底層初始化器、設定閉包套用到列按鈕。
	@Test
	func `barButtonItem init with customView applies configuration`() {
		let customView: UIView = .init()

		let barButtonItem: UIBarButtonItem = .init(customView: customView) { barButtonItem in
			barButtonItem.tag = 14
		}

		#expect(barButtonItem.customView === customView)
		#expect(barButtonItem.tag == 14)
	}

	/// `init(customView:configureHandlers:)`：多個設定閉包依序套用到自訂視圖列按鈕。
	@Test
	func `barButtonItem init with customView applies multiple handlers in order`() {
		let barButtonItem: UIBarButtonItem = .init(
			customView: .init(),
			configureHandlers: { barButtonItem in barButtonItem.tag = 1 },
			{ barButtonItem in barButtonItem.tag = 2 }
		)

		#expect(barButtonItem.tag == 2)
	}
}
