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
        
        super.tearDown()
    }
    
    func testDiscoverAll() {
        client.discoverAllDevices()
      
        expectation = expectation(description: "Discover All")
        waitForExpectations(timeout: 10.0) { (error) in
            print(error)
        }
    }
    
    func testDiscoverRootDevice() {
        client.discoverRootDevices()
      
        expectation = expectation(description: "Discover Root Devices")
        waitForExpectations(timeout: 10.0) { (error) in
            print(error)
        }
    }
}

extension SwiftSSDPClientTests: SSDPClientDelegate {
<<<<<<< HEAD
  func received(_ request: SSDPRequest) {
        print(request)
    }
    
  func received(_ response: SSDPResponse) {
=======
    func received(_ request: SSDPRequest) {
        expectation?.fulfill()
        expectation = nil
    }
    
    func received(_ response: SSDPResponse) {
>>>>>>> 6be79559cc16c7da06fcaede6f68cbb51715b27e
        expectation?.fulfill()
        expectation = nil
    }
}
