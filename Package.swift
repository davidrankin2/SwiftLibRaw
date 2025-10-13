// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

// Copyright © 2025 David W. Rankin Jr.

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import PackageDescription

let package = Package(
    name: "SwiftLibRaw",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftLibRaw",
            targets: ["SwiftLibRaw"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .systemLibrary(name: "libraw_r", pkgConfig: "libraw_r", providers: [.brew(["libraw"])]),
        .target(
        	name: "libraw_glue",
            dependencies: ["libraw_r"],
            // sources: [ "libraw_glue.cpp" ],
            swiftSettings: [.interoperabilityMode(.Cxx)],
        ),
        .target(
            name: "SwiftLibRaw",
            dependencies: ["libraw_r", "libraw_glue" ],
            swiftSettings: [.interoperabilityMode(.Cxx)],
        ),
        .testTarget(
            name: "SwiftLibRawTests",
            dependencies: ["SwiftLibRaw"],
        ),
    ]
)
