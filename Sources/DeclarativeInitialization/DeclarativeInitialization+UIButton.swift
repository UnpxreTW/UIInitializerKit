//
//  DeclarativeInitialization
//
//  Copyright © 2026 Unpxre (GitHub: UnpxreTW)
//  Licensed under the Apache License 2.0. See LICENSE for details.
//
//  SPDX-License-Identifier: Apache-2.0

import class UIKit.UIButton

extension DeclarativeInitialization where Self == UIButton {

	/// `UIButton` 的指定客製化按鈕初始化器
	public init(type: UIButton.ButtonType = .custom, configureHandler: (Self) -> Void) {
		self.init(type: type)
		configureHandler(self)
	}

	/// `UIButton` 的指定客製化按鈕初始化器
	public init(type: UIButton.ButtonType = .custom, configureHandlers: ((Self) -> Void)...) {
		self.init(type: type)
		for configureHandler in configureHandlers {
			configureHandler(self)
		}
	}
}
