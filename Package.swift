// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextFieldsCatalog",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "TextFieldsCatalog",
            targets: ["TextFieldsCatalog"])
    ],
    dependencies: [
        .package(
            name: "InputMask",
            url: "https://github.com/RedMadRobot/input-mask-ios.git",
            .exact("6.0.0")
        )
    ],
    targets: [
        .target(
            name: "TextFieldsCatalog",
            dependencies: ["InputMask"],
            path: "TextFieldsCatalog",
            exclude: [
                "Info.plist"
            ],
            resources: [
                .process("Resources/Images/leftArrow@2x.png"),
                .process("Resources/Images/leftArrow@3x.png"),
                .process("Resources/Images/close@3x.png"),
                .process("Resources/Images/eyeOff.png"),
                .process("Resources/Images/eyeOff@3x.png"),
                .process("Resources/Images/eyeOn.png"),
                .process("Resources/Images/close@2x.png"),
                .process("Resources/Images/eyeOff@2x.png"),
                .process("Resources/Images/rightArrow@2x.png"),
                .process("Resources/Images/rightArrow.png"),
                .process("Resources/Images/leftArrow.png"),
                .process("Resources/Images/rightArrow@3x.png"),
                .process("Resources/Images/eyeOn@3x.png"),
                .process("Resources/Images/eyeOn@2x.png"),
                .process("Resources/Images/close.png")
            ]
        ),
        .testTarget(
            name: "TextFieldsCatalogTests",
            dependencies: ["TextFieldsCatalog"],
            path: "TextFieldsCatalogTests",
            exclude: [
                "Info.plist"
            ]
        )
    ]
)
