// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swiftlint: disable file_types_order
import PackageDescription
// this is template package swift for max adapter
let package = Package(
    name: "VoodooMaxAdapter",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [ Constants.mainProduct ],
    dependencies: [Constants.appLovinDependency, Constants.voodooPackage],
    targets: [Constants.mainTarget]
)

private enum Constants {
    static var appLovinPackage: PackageDescription.Target.Dependency {
        .product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package")
    }
    static var appLovinDependency: Package.Dependency {
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", .upToNextMajor(from: "13.0.0"))
    }

    static var voodooPackage: Package.Dependency {
        .package(url: "https://github.com/VoodooTeam/voodooadn-swift-package.git",
                 .upToNextMajor(from: "3.0.0"))
    }

    static var mainTarget: PackageDescription.Target {
        .target(
            name: "VoodooMaxAdapter",
            dependencies: [
                Self.appLovinPackage,
                .product(name: "VoodooAdn", package: "voodooadn-swift-package")
            ],
            path: "Sources"
        )
    }

    static var mainProduct: Product {
        .library(
            name: "VoodooMaxAdapter",
            targets: ["VoodooMaxAdapter"])
    }
}
