// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let (coreSearchVersion, coreSearchVersionHash) = ("1.4.0", "c8d51c19f62e927a33c6fe1c1b872c61fd4bf6ad4a7851fd139b053bf7b76040")

let commonMinVersion = Version("23.10.1")
let commonMaxVersion = Version("24.0.0")

let package = Package(
    name: "MapboxSearch",
    defaultLocalization: "en",
    platforms: [.iOS(.v12), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MapboxSearch",
            targets: ["MapboxSearch"]
        ),
        .library(name: "MapboxSearchUI",
                 targets: ["MapboxSearchUI"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "MapboxCommon", url: "https://github.com/mapbox/mapbox-common-ios.git", commonMinVersion..<commonMaxVersion),
        .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting.git", from: "2.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MapboxSearch",
            dependencies: [
                "MapboxCoreSearch",
                "MapboxCommon",
            ],
            exclude: ["Info.plist"],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy"),
            ],
            linkerSettings: [.linkedLibrary("c++")]
        ),
        .target(
            name: "MapboxSearchUI",
            dependencies: ["MapboxSearch"],
            exclude: ["Info.plist", "Resources-Info.plist"],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy"),
            ]
        ),

        coreSearchTarget(
            name: "MapboxCoreSearch",
            version: coreSearchVersion,
            checksum: coreSearchVersionHash
        ),

        .testTarget(
            name: "MapboxSearchTests",
            dependencies: [
                "MapboxSearch",
                "MapboxSearchUI",
                "CwlPreconditionTesting",
            ],
            exclude: ["Info.plist"]
        ),
    ],
    cxxLanguageStandard: .cxx14
)

private func coreSearchTarget(name: String, version: String, checksum: String) -> Target {
    let host = "api.mapbox.com"
    let url = "https://\(host)/downloads/v2/search-core-sdk/releases/ios/packages/\(version)/MapboxCoreSearch.xcframework.zip"

    return .binaryTarget(name: name, url: url, checksum: checksum)
}
