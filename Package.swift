// swift-tools-version: 6.0

import PackageDescription

let package: Package = .init(
	name: "UIInitializerKit",
	platforms: [.iOS(.v14)],
	products: [
		.library(name: "UIInitializerKit", targets: ["ConstraintBuilder", "DeclarativeInitialization"])
	],
	dependencies: [
		.package(url: "https://github.com/UnpxreTW/SwiftStyleKit.git", from: "2.0.1"),
	],
	targets: [
		.target(
			name: "ConstraintBuilder",
			plugins: [.plugin(name: "SwiftStyleLint", package: "SwiftStyleKit")]
		),
		.target(
			name: "DeclarativeInitialization",
			plugins: [.plugin(name: "SwiftStyleLint", package: "SwiftStyleKit")]
		),
		.testTarget(
			name: "ConstraintBuilderTests",
			dependencies: ["ConstraintBuilder"],
			plugins: [.plugin(name: "SwiftStyleLint", package: "SwiftStyleKit")]
		),
		.testTarget(
			name: "DeclarativeInitializationTests",
			dependencies: ["DeclarativeInitialization"],
			plugins: [.plugin(name: "SwiftStyleLint", package: "SwiftStyleKit")]
		),
	]
)
