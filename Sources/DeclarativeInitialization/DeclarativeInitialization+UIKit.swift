//
//  DeclarativeInitialization+UIKit.swift
//  DeclarativeInitialization
//
//  Copyright © 2023 Skywind. All rights reserved.
//

import UIKit

// MARK: - UIView + Declarative

extension UIView: DeclarativeInitialization {}

/// 可使用閉包快速建立視圖
extension DeclarativeInitialization where Self: UIView {

	public init(configureHandler: (Self) -> Void) {
		self.init()
		configureHandler(self)
	}
}

extension DeclarativeInitialization where Self == UIButton {

	/// `UIButton` 的指定客製化按鈕初始化器
	public init(configureHandler: (Self) -> Void) {
		self.init(type: .custom)
		configureHandler(self)
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
