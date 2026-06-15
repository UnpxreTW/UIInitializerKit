//
//  DeclarativeInitialization
//
//  Copyright © 2026 Unpxre (GitHub: UnpxreTW)
//  Licensed under the Apache License 2.0. See LICENSE for details.
//
//  SPDX-License-Identifier: Apache-2.0

import UIKit

// MARK: - UIView + Declarative

extension UIView: DeclarativeInitialization {}

/// 可使用閉包快速建立視圖
extension DeclarativeInitialization where Self: UIView {

	public init(configureHandler: (Self) -> Void) {
		self.init()
		configureHandler(self)
	}

	public init(configureHandlers: ((Self) -> Void)...) {
		self.init()
		for configureHandler in configureHandlers {
			configureHandler(self)
		}
	}
}

extension DeclarativeInitialization where Self == UIStackView {

	/// `UIStackView` 的指定客製化按鈕初始化器
	public init(arrangedSubviews: [UIView], configureHandler: (Self) -> Void) {
		self.init(arrangedSubviews: arrangedSubviews)
		configureHandler(self)
	}
}

extension DeclarativeInitialization where Self == UITableView {

	public init(style: UITableView.Style = .plain, configureHandler: (Self) -> Void) {
		self.init(frame: .zero, style: style)
		configureHandler(self)
	}
}
