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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: SSDPClientDelegate {
    func received(response: SSDPResponse) {
        textView.text = (textView.text ?? "") + response.description
    }
    
    func received(request: SSDPRequest) {
        textView.text = (textView.text ?? "") + request.description
    }
}

