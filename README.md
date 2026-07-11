<!-- SPDX-FileCopyrightText: 2026 Unpxre (GitHub: UnpxreTW) -->
<!-- SPDX-License-Identifier: Apache-2.0 -->

# UIInitializerKit

以宣告式風格初始化 UIKit 元件的 Swift Package——閉包初始化器搭配 `@resultBuilder` 約束 DSL。

## 特色

- **DeclarativeInitialization**：任何 `UIView` 子類都能用設定閉包直接初始化；`UIButton`（可帶 `ButtonType`）、`UIStackView`、`UITableView` 另有專用參數版
- **ConstraintBuilder**：`@resultBuilder` 約束 DSL——`addSubview(_:withConstraints:)` 加入子視圖同時掛約束、自動處理 `translatesAutoresizingMaskIntoConstraints` 與 activate，支援 `if` / `for` / `switch` 組約束

## 使用

```swift
import ConstraintBuilder
import DeclarativeInitialization

let titleLabel = UILabel {
    $0.text = "Hello"
    $0.font = .preferredFont(forTextStyle: .title1)
}

view.addSubview(titleLabel) {
    equal(\.centerXAnchor, to: view)
    equal(\.topAnchor, to: view, \.safeAreaLayoutGuide.topAnchor, constant: 16)
    equal(\.heightAnchor, to: 44)
}
```

> 單一 library 內含兩個 module，依需求分別 `import`。

## 安裝

```swift
.package(url: "https://github.com/UnpxreTW/UIInitializerKit", branch: "main")
```

## 規劃中

- `UIButton.Configuration` 專用簡化初始化器（#4）
- `UIVisualEffectView` 快捷初始化器（#1）

## 需求

Swift 6.0+、UIKit（CI 以 Xcode 26.3 iOS Simulator 建置）

## 開發

純 Swift Package，UIKit 依賴僅 iOS SDK 可用（非 macOS），建置走 iOS Simulator：

```shell
xcodebuild build -scheme UIInitializerKit -destination 'generic/platform=iOS Simulator'
```

CI（GitHub Actions）跑同一條指令，見 `.github/workflows/build.yml`。

## 授權

Apache-2.0（REUSE 合規）
