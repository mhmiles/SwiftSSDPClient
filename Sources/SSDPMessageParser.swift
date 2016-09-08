//
//  SSDPResponseParser.swift
//  SwiftSSDPClient
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation

class SSDPMessageParser {
    private let scanner: NSScanner
    
    init(message: String) {
        scanner = NSScanner(string: message)
        scanner.charactersToBeSkipped = NSCharacterSet.newlineCharacterSet()
    }
    
    func parse() -> SSDPMessage? {
        guard let firstLine = scanLine(), firstWord = firstLine.componentsSeparatedByString(" ").first else {
            return nil
        }
        
        var keyBuffer: NSString? = nil
        var valueBuffer: NSString? = nil
        
        var messageDictionary = SSDPRequestDictionary()
        let parseDictionary = {
            while self.scanner.scanUpToString(":", intoString: &keyBuffer) {
                self.advancePastColon()
                
                if NSCharacterSet.newlineCharacterSet().characterIsMember((self.scanner.string as NSString).characterAtIndex(self.scanner.scanLocation)) {
                    valueBuffer = ""
                } else {
                    valueBuffer = self.scanLine()
                }
                
                messageDictionary[(keyBuffer as! String)] = (valueBuffer  as! String)
            }
        }
        
        if let method = SSDPRequestMethod(rawValue: firstWord) {
            parseDictionary()
            
            return SSDPRequest(method: method, dictionary: messageDictionary)
        } else if firstWord == "HTTP/1.1" {
            parseDictionary()
            
            return SSDPResponse(dictionary: messageDictionary)
        } else {
            print("INVALID SSDP MESSAGE")
        }
        
        return nil
    }
    
    private func scanLine() -> String? {
        var buffer: NSString? = nil
        scanner.scanUpToCharactersFromSet(NSCharacterSet.newlineCharacterSet(), intoString: &buffer)
        
        return (buffer as? String)
    }
    
    private func advancePastColon() {
        var string: NSString? = nil
        
        let characterSet = NSCharacterSet(charactersInString: ": ")
        scanner.scanCharactersFromSet(characterSet, intoString: &string)
    }
}

public protocol SSDPMessage {
    var searchTarget: String? { get }
}