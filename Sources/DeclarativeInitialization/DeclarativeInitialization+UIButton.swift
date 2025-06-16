//
//  DeclarativeInitialization+UIButton.swift
//  DeclarativeInitialization
//
//  Copyright © 2025 UnpxreTW. All rights reserved.
//

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
