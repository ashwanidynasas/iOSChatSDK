//
//  BottomViewHandler.swift
//  iOSChatSDK
//
//  Created by Ashwani on 29/07/24.
//

import Foundation
import UIKit

enum SendChild{
    case input
    case more
    case reply
}

struct ViewHeight {
    static let child = 46.0
    static let three = 170.0
    static let two   = 114.0
    static let one   = 74.0
}

//class BottomViewHandler {
//    
//    let reply: UIView
//    let input: UIView
//    let more : UIView
//    
//    let replyHeight: NSLayoutConstraint
//    let inputHeight: NSLayoutConstraint
//    let moreHeight: NSLayoutConstraint
//    
//    let sendHeight: NSLayoutConstraint
//
//    init(reply: UIView,
//         input: UIView,
//         more: UIView,
//         replyHeight: NSLayoutConstraint,
//         inputHeight: NSLayoutConstraint,
//         moreHeight: NSLayoutConstraint,
//         sendHeight: NSLayoutConstraint) {
//        
//        self.reply = reply
//        self.input = input
//        self.more = more
//        self.replyHeight = replyHeight
//        self.inputHeight = inputHeight
//        self.moreHeight = moreHeight
//        self.sendHeight = sendHeight
//    }
//    
//    
//}
