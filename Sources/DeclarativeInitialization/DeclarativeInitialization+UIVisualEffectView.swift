//
//  DeclarativeInitialization
//
//  Copyright © 2026 Unpxre (GitHub: UnpxreTW)
//  Licensed under the Apache License 2.0. See LICENSE for details.
//
//  SPDX-License-Identifier: Apache-2.0

import class UIKit.UIVisualEffect
import class UIKit.UIVisualEffectView

extension DeclarativeInitialization where Self == UIVisualEffectView {

	/// `UIVisualEffectView` 的指定客製化視覺效果檢視初始化器
	public init(effect: UIVisualEffect?, configureHandler: (Self) -> Void) {
		self.init(effect: effect)
		configureHandler(self)
	}

	/// `UIVisualEffectView` 的指定客製化視覺效果檢視初始化器
	public init(effect: UIVisualEffect?, configureHandlers: ((Self) -> Void)...) {
		self.init(effect: effect)
		for configureHandler in configureHandlers {
			configureHandler(self)
		}
	}
}
