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
    
    @IBOutlet weak var btnOutlet:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           self.view.backgroundColor = .white
           self.title = "Sqrcle"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func chatSDKAction(_ sender: UIButton) {
        print("goto detail page just now")
        let frameworkVC = MainChatVC.instantiate()
        self.navigationController?.pushViewController(frameworkVC, animated: true)

    }
}

