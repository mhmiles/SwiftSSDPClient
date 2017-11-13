//
//  ViewController.swift
//  Sample App
//
//  Created by Miles Hollingsworth on 8/1/16.
//  Copyright © 2016 Miles Hollingsworth. All rights reserved.
//

import UIKit
import SwiftSSDPClient

class ViewController: UIViewController {
  var client: SSDPClient!
  
  @IBOutlet weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    client = SSDPClient(delegate: self)
    client.discoverRootDevices()
  }
  
  func appendToTextView(_ text: String) {
    DispatchQueue.main.async {
      self.textView.text = (self.textView.text ?? "") + text
    }
  }
}

extension ViewController: SSDPClientDelegate {
  func received(_ response: SSDPResponse) {
    appendToTextView(response.description)
  }
  
  func received(_ request: SSDPRequest) {
    appendToTextView(request.description)
  }
}

