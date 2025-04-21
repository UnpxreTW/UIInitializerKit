// swift-tools-version: 6.1

import PackageDescription

let package = Package(
	name: "UIInitializerKit",
	products: [
		.library(name: "UIInitializerKit", targets: ["ConstraintBuilder", "DeclarativeInitialization"])
	],
	targets: [
		.target(name: "ConstraintBuilder")

		,
		.target(name: "DeclarativeInitialization")
	]
)
