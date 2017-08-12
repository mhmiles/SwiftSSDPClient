//
//  SSDPResponseParser.swift
//  SwiftSSDPClient
//
//  Created by Miles Hollingsworth on 7/28/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import Foundation

class SSDPMessageParser {
    private let scanner: Scanner
    
    init(message: String) {
        scanner = Scanner(string: message)
      scanner.charactersToBeSkipped = CharacterSet.newlines
    }
    
    func parse() -> SSDPMessage? {
        guard let firstLine = scanLine(),
          let firstWord = firstLine.components(separatedBy: " ").first else {
            return nil
        }
        
        var keyBuffer: NSString? = nil
        var valueBuffer: NSString? = nil
        
        var messageDictionary = SSDPRequestDictionary()
      let parseDictionary = { (scanner: Scanner) in
          while self.scanner.scanUpTo(":", into: &keyBuffer) {
                self.advancePastColon()
      
            guard scanner.scanLocation < scanner.string.characters.count,
              let currentCharacter = scanner.string[scanner.string.index(scanner.string.startIndex, offsetBy: scanner.scanLocation)].unicodeScalars.first else {
              return
            }
            
            if CharacterSet.newlines.contains(currentCharacter) {
                    valueBuffer = ""
                } else {
              valueBuffer = self.scanLine() as NSString?
                }
                
            messageDictionary[(keyBuffer! as String)] = (valueBuffer!  as String)
            }
        }
        
        if let method = SSDPRequestMethod(rawValue: firstWord) {
            parseDictionary(scanner)
            
            return SSDPRequest(method: method, dictionary: messageDictionary)
        } else if firstWord == "HTTP/1.1" {
            parseDictionary(scanner)
            
            return SSDPResponse(dictionary: messageDictionary)
        } else {
            print("INVALID SSDP MESSAGE")
        }
        
        return nil
    }
    
    private func scanLine() -> String? {
        var buffer: NSString? = nil
      scanner.scanUpToCharacters(from: CharacterSet.newlines, into: &buffer)
        
      return (buffer as String?)
    }
    
    private func advancePastColon() {
        var string: NSString? = nil
      
        let characterSet = CharacterSet(charactersIn: ": ")
      scanner.scanCharacters(from: characterSet, into: &string)
    }
}

public protocol SSDPMessage {
    var searchTarget: String? { get }
}
