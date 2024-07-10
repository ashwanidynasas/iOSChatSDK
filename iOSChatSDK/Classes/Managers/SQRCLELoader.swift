//
//  SQRCLELoader.swift
//  Dynasas
//
//  Created by Dynasas on 29/04/23.
//

import Foundation
import JGProgressHUD

class SQRCLELoader {
    
    private var loader = JGProgressHUD(style: .extraLight)
    
    static var shared : SQRCLELoader = {
        let handler = SQRCLELoader()
        return handler
    }()
    
    func showLoader(_ message : String?, source : UIViewController? = UIWindow(frame: UIScreen.main.bounds).rootViewController) {
        Threads.performTaskInMainQueue {
            if self.loader.isVisible == false {
                self.loader.textLabel.text = message
                if let vc = source {
                    self.loader.show(in: vc.view)
                }
            } else {
                self.loader.textLabel.text = message
            }
        }
    }
    
    func hideLoader() {
        Threads.performTaskInMainQueue {
            self.loader.dismiss()
        }
    }
}
