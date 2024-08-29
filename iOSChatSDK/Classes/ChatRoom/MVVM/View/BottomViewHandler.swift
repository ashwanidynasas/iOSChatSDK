//
//  BottomViewHandler.swift
//  iOSChatSDK
//
//  Created by Ashwani on 29/07/24.
//

import Foundation
import UIKit

struct BottomViewConstansts{
    static let replyHeight = 46.0
}

class BottomViewHandler {
    
    let replyBottomView: UIView
    let backTFView: UIView
    let morebottomView: UIView
    let replyBottomViewHeight: NSLayoutConstraint
    let textFieldViewHeight: NSLayoutConstraint
    let moreViewHeight: NSLayoutConstraint
    let backBottomViewHeight: NSLayoutConstraint

    init(replyBottomView: UIView,
         backTFView: UIView,
         morebottomView: UIView,
         replyBottomViewHeight: NSLayoutConstraint, 
         textFieldViewHeight: NSLayoutConstraint,
         moreViewHeight: NSLayoutConstraint, 
         backBottomViewHeight: NSLayoutConstraint) {
        
        self.replyBottomView = replyBottomView
        self.backTFView = backTFView
        self.morebottomView = morebottomView
        self.replyBottomViewHeight = replyBottomViewHeight
        self.textFieldViewHeight = textFieldViewHeight
        self.moreViewHeight = moreViewHeight
        self.backBottomViewHeight = backBottomViewHeight
    }

    func BV_Reply_TF_More_Appear(){
        DispatchQueue.main.async {
            self.replyBottomView.isHidden = false
            self.backTFView.isHidden = false
            self.morebottomView.isHidden = false
            self.replyBottomViewHeight.constant = BottomViewConstansts.replyHeight
            self.textFieldViewHeight.constant = 46.0
            self.moreViewHeight.constant = 46.0
            self.backBottomViewHeight.constant = 170.0
        }
    }
    func BV_Reply_TF_Appear(){
        DispatchQueue.main.async {
            self.replyBottomView.isHidden = false
            self.backTFView.isHidden = false
            self.morebottomView.isHidden = true
            self.replyBottomViewHeight.constant = BottomViewConstansts.replyHeight
            self.textFieldViewHeight.constant = 46.0
            self.moreViewHeight.constant = 0.0
            self.backBottomViewHeight.constant = 114.0
        }
    }
    func BV_TF_More_Appear(){
        DispatchQueue.main.async {
            self.replyBottomView.isHidden = true
            self.backTFView.isHidden = false
            self.morebottomView.isHidden = false
            self.replyBottomViewHeight.constant = 0.0
            self.textFieldViewHeight.constant = 46.0
            self.moreViewHeight.constant = 46.0
            self.backBottomViewHeight.constant = 114.0
        }
    }
    func BV_TF_Appear(){
        DispatchQueue.main.async {
            self.replyBottomView.isHidden = true
            self.backTFView.isHidden = false
            self.morebottomView.isHidden = true
            self.replyBottomViewHeight.constant = 0.0
            self.textFieldViewHeight.constant = 46.0
            self.moreViewHeight.constant = 0.0
            self.backBottomViewHeight.constant = 74.0
        }
    }
    func BV_More_Appear(){
        DispatchQueue.main.async {
            self.replyBottomView.isHidden = true
            self.backTFView.isHidden = true
            self.morebottomView.isHidden = false
            self.replyBottomViewHeight.constant = 0.0
            self.textFieldViewHeight.constant = 0.0
            self.moreViewHeight.constant = 46.0
            self.backBottomViewHeight.constant = 74.0
        }
    }
    func BV_TF_Appear_More_Disappear(){
        DispatchQueue.main.async {
            self.replyBottomView.isHidden = true
            self.backTFView.isHidden = false
            self.morebottomView.isHidden = true
            self.replyBottomViewHeight.constant = 0.0
            self.textFieldViewHeight.constant = 46.0
            self.moreViewHeight.constant = 0.0
            self.backBottomViewHeight.constant = 74.0
        }
    }
    func BV_Reply_Disappear_More_Disappear(){
        DispatchQueue.main.async {
            self.replyBottomView.isHidden = true
            self.backTFView.isHidden = false
            self.morebottomView.isHidden = true
            self.replyBottomViewHeight.constant = 0.0
            self.textFieldViewHeight.constant = 46.0
            self.moreViewHeight.constant = 0.0
            self.backBottomViewHeight.constant = 74.0
        }
    }
}
