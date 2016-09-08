//
//  SSDPResponse.swift
//  SwiftSSDPClient
//
//  Created by Miles Hollingsworth on 8/1/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation

typealias SSDPResponseDictionary = [String: String]

open class SSDPResponse {
    fileprivate let responseDictionary: [String: String]
    
    var data: Data {
        return responseString.data(using: String.Encoding.utf8)!
    }
    
    fileprivate var responseString: String {
        let responseString = responseDictionary.reduce("HTTP/1.1 200 OK\r\n") { (accumulator, parameter) -> String in
            return accumulator + "\(parameter.0): \(parameter.1)\r\n"
        }
        
        return responseString+"\r\n"
    }
    
    init(dictionary: SSDPResponseDictionary) {
        self.responseDictionary = dictionary
    }
}

extension SSDPResponse: SSDPMessage {
    var searchTarget: String? {
        return responseDictionary["ST"]
    }
}

extension SSDPResponse: CustomStringConvertible {
    public var description: String {
        return responseString
    }
}
