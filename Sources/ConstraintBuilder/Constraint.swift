//
//  Constraint.swift
//  ConstraintBuilder
//
//  Copyright © 2024 UnpxreTW. All rights reserved.
//

import UIKit

public typealias Constraint = (UIView) -> NSLayoutConstraint

/// 建立使參考視圖的 `NSLayoutAnchor` 等同於常數的約束
///
/// - Parameters:
///   - keyPath: 呼叫視圖要約束的 `NSLayoutAnchor`
///   - constant: 常數
/// - Returns: 建立約束用的閉包，參考的視圖取決於呼叫視圖
@MainActor
public func equal(
	_ keyPath: KeyPath<UIView, some NSLayoutDimension>,
	to constant: CGFloat
) -> Constraint {
	{ $0[keyPath: keyPath].constraint(equalToConstant: constant) }
}

/// 產生一個描述自己的某個約束大於或等於某個常數的設定閉包
///
/// - Parameters:
///   - keyPath: 呼叫視圖要約束的 `NSLayoutAnchor`
///   - greaterOrEqual: 常數
/// - Returns: 建立約束用的閉包，參考的視圖取決於呼叫視圖
@MainActor
public func equal(
	_ keyPath: KeyPath<UIView, some NSLayoutDimension>,
	greaterOrEqual constant: CGFloat
) -> Constraint {
	{ $0[keyPath: keyPath].constraint(greaterThanOrEqualToConstant: constant) }
}

/// 產生一個描述自己的某個約束點小於或等於某個常數的設定閉包
///
/// - Parameters:
///   - keyPath: 呼叫視圖要約束的 `NSLayoutAnchor`
///   - lessOrEqual: 常數
/// - Returns: 建立約束用的閉包，參考的視圖取決於呼叫視圖
@MainActor
public func equal(
	_ keyPath: KeyPath<UIView, some NSLayoutDimension>,
	lessOrEqual constant: CGFloat
) -> Constraint {
	{ $0[keyPath: keyPath].constraint(lessThanOrEqualToConstant: constant) }
}

/// 產生一個描述自己的某個約束點與另一個視圖約束點的常數關係設定閉包，常數預設為 `0`
///
/// - Parameters:
///   - from: 呼叫視圖要約束的 `NSLayoutAnchor`
///   - view: 要參考的視圖
///   - toAnchor: 要參考視圖內的  `NSLayoutAnchor`
///   - constant: 常數，預設為 0
/// - Returns: 建立約束用的閉包，參考的視圖取決於呼叫視圖
@MainActor
public func equal<Anchor, Axis>(
	_ from: KeyPath<UIView, Anchor>,
	to view: UIView,
	_ toAnchor: KeyPath<UIView, Anchor>,
	constant: CGFloat = 0
) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
	{ $0[keyPath: from].constraint(
		equalTo: view[keyPath: toAnchor],
		constant: constant
	) }
}

/// 產生一個描述自己的某個約束點與另一個視圖約束點的比例關係設定閉包
///
/// - Parameters:
///   - keyPath: 呼叫視圖要約束的 `NSLayoutAnchor`
///   - view: 要參考的視圖
///   - toAnchor: 要參考視圖內的  `NSLayoutAnchor`
///   - ratio: 約束點間的比例
/// - Returns: 建立約束用的閉包，參考的視圖取決於呼叫視圖
@MainActor
public func equal<LayoutDimension>(
	_ keyPath: KeyPath<UIView, LayoutDimension>,
	to view: UIView,
	_ anchor: KeyPath<UIView, LayoutDimension>,
	ratio value: CGFloat
) -> Constraint where LayoutDimension: NSLayoutDimension {
	{ $0[keyPath: keyPath].constraint(
		equalTo: view[keyPath: anchor],
		multiplier: value
	) }
}

/// 產生一個描述自己的某個約束點與另一個視圖約束點的常數關係設定閉包，小於等於設定常數
///
/// - Parameters:
///   - keyPath: 呼叫視圖要約束的 `NSLayoutAnchor`
///   - view: 要參考的視圖
///   - toAnchor: 要參考視圖內的  `NSLayoutAnchor`
///   - lessOrEqual: 常數
/// - Returns: 建立約束用的閉包，參考的視圖取決於呼叫點
@MainActor
public func equal<Anchor, Axis>(
	_ keyPath: KeyPath<UIView, Anchor>,
	to view: UIView,
	_ toAnchor: KeyPath<UIView, Anchor>,
	lessOrEqual: CGFloat
) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
	{ $0[keyPath: keyPath].constraint(
		lessThanOrEqualTo: view[keyPath: toAnchor],
		constant: lessOrEqual
	) }
}

/// 產生一個描述自己的某個約束點與另一個視圖約束點的常數關係設定閉包，大於等於設定常數
///
/// - Parameters:
///   - keyPath: 呼叫視圖要約束的 `NSLayoutAnchor`
///   - view: 要參考的視圖
///   - toAnchor: 要參考視圖內的  `NSLayoutAnchor`
///   - greaterOrEqual: 常數
/// - Returns: 建立約束用的閉包，參考的視圖取決於呼叫視圖
@MainActor
public func equal<Anchor, Axis>(
	_ keyPath: KeyPath<UIView, Anchor>,
	to view: UIView,
	_ toAnchor: KeyPath<UIView, Anchor>,
	greaterOrEqual: CGFloat
) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
	{ $0[keyPath: keyPath].constraint(
		greaterThanOrEqualTo: view[keyPath: toAnchor],
		constant: greaterOrEqual
	) }
}

/// 產生一個描述自己的某個約束點與另一個視圖同一個約束點的常數關係設定閉包
///
/// - Parameters:
///   - view: 要參考的視圖
///   - keyPath: 要參考視圖內的  `NSLayoutAnchor`
///   - constant: 常數，預設為 0
/// - Returns: 建立約束用的閉包，參考的視圖取決於呼叫視圖
@MainActor
public func equal(
	_ keyPath: KeyPath<UIView, some NSLayoutAnchor<some Any>>,
	to view: UIView,
	constant: CGFloat = 0
) -> Constraint {
	equal(keyPath, to: view, keyPath, constant: constant)
}
