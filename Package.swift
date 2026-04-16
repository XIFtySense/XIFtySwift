// swift-tools-version: 6.0
import Foundation
import PackageDescription

let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
let coreDir: String = {
    if let override = ProcessInfo.processInfo.environment["XIFTY_CORE_DIR"] {
        return URL(fileURLWithPath: override).path
    }
    return root.deletingLastPathComponent().appendingPathComponent("XIFty").path
}()

let staticLibrary = "\(coreDir)/target/debug/libxifty_ffi.a"

let package = Package(
    name: "XIFtySwift",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "XIFtySwift", targets: ["XIFtySwift"]),
    ],
    targets: [
        .target(
            name: "CXIFty",
            path: "Sources/CXIFty",
            publicHeadersPath: "include"
        ),
        .target(
            name: "XIFtySwift",
            dependencies: ["CXIFty"],
            path: "Sources/XIFtySwift",
            linkerSettings: [
                .unsafeFlags([staticLibrary])
            ]
        ),
        .testTarget(
            name: "XIFtySwiftTests",
            dependencies: ["XIFtySwift"],
            path: "Tests/XIFtySwiftTests",
            linkerSettings: [
                .unsafeFlags([staticLibrary])
            ]
        ),
    ]
)

