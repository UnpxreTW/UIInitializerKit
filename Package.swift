// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "UIInitializerKit",
	products: [
		.library(name: "UIInitializerKit", targets: ["ConstraintBuilder"])
	],
	targets: [
		.target(name: "ConstraintBuilder")
	]
)
