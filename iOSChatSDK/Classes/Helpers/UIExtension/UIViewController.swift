//
//  ChatRoomVC+Keyboard.swift
//  iOSChatSDK
//
//  Created by Ashwani on 19/09/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Setup keyboard observers
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatkeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatkeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Remove keyboard observers
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Keyboard will show
    @objc func ChatkeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.window?.frame.origin.y == 0 {
                self.view.window?.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // Keyboard will hide
    @objc func ChatkeyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y = 0
        }
    }
    // Background Color
    func addGradientView(color : UIColor) {
        let gradientView: MultipleColorGradientView! = MultipleColorGradientView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gradientView.topColor = .black
        gradientView.bottomColor = color
        gradientView.backgroundColor = color
        self.view.insertSubview(gradientView, at: 0)
        Threads.performTaskAfterDelay(0.1) {
            gradientView.animate(duration: 0.1,
                                 newTopColor: .black,
                                 newBottomColor: color )
        }
    }
}
