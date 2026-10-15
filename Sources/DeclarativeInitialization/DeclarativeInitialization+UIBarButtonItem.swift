//
//  DeclarativeInitialization
//
//  Copyright © 2026 Unpxre (GitHub: UnpxreTW)
//  Licensed under the Apache License 2.0. See LICENSE for details.
//
//  SPDX-License-Identifier: Apache-2.0

import class UIKit.UIAction
import class UIKit.UIBarButtonItem
import class UIKit.UIImage
import class UIKit.UIMenu
import class UIKit.UIView

// MARK: - + DeclarativeInitialization

extension UIBarButtonItem: DeclarativeInitialization {}

extension DeclarativeInitialization where Self == UIBarButtonItem {

	/// `UIBarButtonItem` 的指定客製化列按鈕初始化器
	public init(
		title: String? = nil,
		image: UIImage? = nil,
		primaryAction: UIAction? = nil,
		menu: UIMenu? = nil,
		configureHandler: (Self) -> Void
	) {
		self.init(title: title, image: image, primaryAction: primaryAction, menu: menu)
		configureHandler(self)
	}

	/// `UIBarButtonItem` 的指定客製化列按鈕初始化器
	public init(
		title: String? = nil,
		image: UIImage? = nil,
		primaryAction: UIAction? = nil,
		menu: UIMenu? = nil,
		configureHandlers: ((Self) -> Void)...
	) {
		self.init(title: title, image: image, primaryAction: primaryAction, menu: menu)
		for configureHandler in configureHandlers {
			configureHandler(self)
		}
	}

	/// `UIBarButtonItem` 使用系統項目的指定客製化列按鈕初始化器
	public init(
		systemItem: UIBarButtonItem.SystemItem,
		primaryAction: UIAction? = nil,
		menu: UIMenu? = nil,
		configureHandler: (Self) -> Void
	) {
		self.init(systemItem: systemItem, primaryAction: primaryAction, menu: menu)
		configureHandler(self)
	}

	/// `UIBarButtonItem` 使用系統項目的指定客製化列按鈕初始化器
	public init(
		systemItem: UIBarButtonItem.SystemItem,
		primaryAction: UIAction? = nil,
		menu: UIMenu? = nil,
		configureHandlers: ((Self) -> Void)...
	) {
		self.init(systemItem: systemItem, primaryAction: primaryAction, menu: menu)
		for configureHandler in configureHandlers {
			configureHandler(self)
		}
	}

	/// `UIBarButtonItem` 使用自訂視圖的指定客製化列按鈕初始化器
	public init(customView: UIView, configureHandler: (Self) -> Void) {
		self.init(customView: customView)
		configureHandler(self)
	}

	/// `UIBarButtonItem` 使用自訂視圖的指定客製化列按鈕初始化器
	public init(customView: UIView, configureHandlers: ((Self) -> Void)...) {
		self.init(customView: customView)
		for configureHandler in configureHandlers {
			configureHandler(self)
		}
	}
}
