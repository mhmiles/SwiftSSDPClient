//
//  SSDPClient.swift
//  SSDPClient
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class SSDPClient: NSObject {
    public weak var delegate: SSDPClientDelegate?
    
    private lazy var socket: GCDAsyncUdpSocket = { () -> GCDAsyncUdpSocket in
        let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        try! socket.enableBroadcast(true)
        
        return socket
    }()
    
    public init(delegate: SSDPClientDelegate) {
        self.delegate = delegate
    }
    
    public func discoverAllDevices() {
        let message = SSDPRequest(searchTarget: "ssdp:all")

      socket.send(message.data as Data as Data, toHost: "239.255.255.250", port: 1900, withTimeout: -1, tag: 0)
        try! socket.beginReceiving()
    }
    
    public func discoverRootDevices() {
        let message = SSDPRequest(searchTarget: "upnp:rootdevice")
        
      socket.send(message.data as Data, toHost: "239.255.255.250", port: 1900, withTimeout: -1, tag: 0)
        try! socket.beginReceiving()
    }
    
    public func discover(searchTarget: String) {
        let message = SSDPRequest(searchTarget: searchTarget)
        
      socket.send(message.data as Data, toHost: "239.255.255.250", port: 1900, withTimeout: -1, tag: 0)
        try! socket.beginReceiving()
    }
    
    public func stopDiscovery() {
        socket.close()
    }
    
    deinit {
        stopDiscovery()
    }
}

extension SSDPClient: GCDAsyncUdpSocketDelegate {
  @objc public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
    guard let messageString = String(data: data as Data, encoding: String.Encoding.utf8) else {
            return
        }
        
        let parser = SSDPMessageParser(message: messageString)
        
        guard let message = parser.parse() else {
            print("Message not parsed")
            return
        }
        
        if let response = message as? SSDPResponse {
            delegate?.received(response)
        } else if let request = message as? SSDPRequest {
            delegate?.received(request)
        }
    }
}

public protocol SSDPClientDelegate: class {
    func received(_ request: SSDPRequest)
    func received(_ response: SSDPResponse)
}
