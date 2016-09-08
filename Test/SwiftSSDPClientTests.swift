//
//  SwiftSSDPClientTests.swift
//  SwiftSSDPClientTests
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import XCTest
@testable import SwiftSSDPClient

class SwiftSSDPClientTests: XCTestCase {
    var client: SSDPClient!
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        
        client = SSDPClient(delegate: self)
    }
    
    override func tearDown() {
        client.stopDiscovery()
        expectation = nil

        super.tearDown()
    }
    
    func testDiscoverAll() {
        client.discoverAllDevices()
        
        expectation = expectationWithDescription("Discover All")
        waitForExpectationsWithTimeout(10.0) { (error) in
            print(error)
        }
    }
    
    func testDiscoverRootDevice() {
        client.discoverRootDevices()
        
        expectation = expectationWithDescription("Discover Root Devices")
        waitForExpectationsWithTimeout(10.0) { (error) in
            print(error)
        }
    }
}

extension SwiftSSDPClientTests: SSDPClientDelegate {
    func received(request: SSDPRequest) {
        print(request)
    }
    
    func received(response: SSDPResponse) {
        expectation?.fulfill()
        expectation = nil
        print(response)
    }
}
