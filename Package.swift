//
//  Package.swift
//  SwiftSSDPClient
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "SwiftSSDPClient",
    dependencies: [
        .Package(url: "https://github.com/czechboy0/Socks.git", majorVersion: 0, minor: 10),
    ]
)

let libSocks = Product(name: "Socks", type: .Library(.Dynamic), modules: "Socks")
products.append(libSocks)
