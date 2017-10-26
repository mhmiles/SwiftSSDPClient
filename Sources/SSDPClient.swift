//
//  SSDPClient.swift
//  SSDPClient
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

private let broadcastAddress = "239.255.255.250"

open class SSDPClient: NSObject {
    open weak var delegate: SSDPClientDelegate?

    fileprivate lazy var socket: GCDAsyncUdpSocket = { () -> GCDAsyncUdpSocket in
      let socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: .main)
        try! socket.enableBroadcast(true)
        
        return socket
    }()

    public init(delegate: SSDPClientDelegate) {
        self.delegate = delegate
    }

    open func discoverAllDevices() {
        let message = SSDPRequest(searchTarget: "ssdp:all")

        socket.send(message.data, toHost: broadcastAddress, port: 1900, withTimeout: -1, tag: 0)
        try! socket.beginReceiving()
    }

    open func discoverRootDevices() {
        let message = SSDPRequest(searchTarget: "upnp:rootdevice")

        socket.send(message.data, toHost: broadcastAddress, port: 1900, withTimeout: -1, tag: 0)
        try! socket.beginReceiving()
    }

    open func discover(_ searchTarget: String) {
        let message = SSDPRequest(searchTarget: searchTarget)

        socket.send(message.data, toHost: "239.255.255.250", port: 1900, withTimeout: -1, tag: 0)
        try! socket.beginReceiving()
    }

    open func stopDiscovery() {
        socket.close()
    }

    deinit {
        stopDiscovery()
    }
}

extension SSDPClient: GCDAsyncUdpSocketDelegate {
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
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
