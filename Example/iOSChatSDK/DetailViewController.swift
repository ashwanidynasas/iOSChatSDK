//
//  DetailViewController.swift
//  iOSChatSDK_Example
//
//  Created by Ashwani on 25/06/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import iOSChatSDK

class DetailViewController: UIViewController {
    @IBOutlet weak var btnOutlet:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("details page view")
        self.view.backgroundColor = .white
        // Set the navigation title
        self.title = "Detail Viewas"
        
        // Add a label to the view
                let label = UILabel()
                label.text = "Welcome to the Detail View"
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false
                
                view.addSubview(label)
                
                // Set constraints for the label
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
        
    }
    @IBAction func chatSDKAction(_ sender: UIButton) {
        print("goto detail page just now")
        iOSChatSDKInitiated.getChatSDK()
    }

}
