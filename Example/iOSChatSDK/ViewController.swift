//
//  ViewController.swift
//  iOSChatSDK
//
//  Created by Ashwani Sharma on 06/24/2024.
//  Copyright (c) 2024 Ashwani Sharma. All rights reserved.
//

import UIKit
import iOSChatSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        iOSChatSDKInitiated.getChatSDK()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

