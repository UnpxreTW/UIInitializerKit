//
//  ConstraintsResultBuilder.swift
//  ConstraintBuilder
//
//  Copyright © 2024 UnpxreTW. All rights reserved.
//

/// 用於建立宣告式視圖約束建構器
@resultBuilder
public enum ConstraintsResultBuilder {

    public static func buildBlock(_ component: Constraint...) -> [Constraint] {
        component
    }

    public static func buildArray(_ components: [Constraint]) -> [Constraint] {
        components
    }

    public static func buildBlock(_ components: [Constraint]...) -> [Constraint] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [Constraint]?) -> [Constraint] {
        component ?? []
    }

    /// 使建構器接受 `if-else` 或是 `switch` 狀態處理
    public static func buildEither(first component: [Constraint]) -> [Constraint] {
        component
    }

    /// 使建構器接受 `if-else` 或是 `switch` 狀態處理
    public static func buildEither(second component: [Constraint]) -> [Constraint] {
        component
    }

    /// 使建構器接受 `if-else` 或是 `switch` 狀態處理
    public static func buildEither(first component: @escaping Constraint) -> [Constraint] {
        [component]
    }

    /// 使建構器接受 `if-else` 或是 `switch` 狀態處理
    public static func buildEither(second component: @escaping Constraint) -> [Constraint] {
        [component]
    }

    /// 將單個佈局宣告轉換為陣列進行處理的方法
    public static func buildExpression(_ expression: @escaping Constraint) -> [Constraint] {
        [expression]
    }

    /// 用於提供閉包內單純使用佈局宣告陣列的情況轉換方法
    public static func buildExpression(_ expression: [Constraint]) -> [Constraint] {
        expression
    }
}
