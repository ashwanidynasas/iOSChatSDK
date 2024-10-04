//
//  BottomViewHandler.swift
//  iOSChatSDK
//
//  Created by Ashwani on 29/07/24.
//

let replyHeight:CGFloat = 72
let inputHeight:CGFloat = 72
let moreHeight:CGFloat = 102

import Foundation
import UIKit

protocol BottomViewDelegate: AnyObject {
    func updateBottomViewHeight(to height: CGFloat)
}

open class BottomView: UIView {
    
    weak var delegate: BottomViewDelegate?
    // Shadow view
    public lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex:ChatConstants.CircleColor.hexString)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 1.0
        return view
    }()
    public lazy var viewReply: ChatReplyView = {
        let view = ChatReplyView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var viewInput: ChatInputView = {
        let view = ChatInputView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public lazy var viewMore: MoreView = {
        let view = MoreView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Constraints
    public var replyViewTopConstraint: NSLayoutConstraint!
    public var inputViewTopConstraint: NSLayoutConstraint!
    public var moreViewTopConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        viewMore.setup(.attach)
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        viewMore.setup(.attach)
    }
    
    public func setupView() {
        addSubview(shadowView)
        addSubview(viewReply)
        addSubview(viewInput)
        addSubview(viewMore)
        
        // Constraints for shadow view
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: 1)
        ])
        // Constraints for redView
        replyViewTopConstraint = viewReply.topAnchor.constraint(equalTo: shadowView.bottomAnchor)
        NSLayoutConstraint.activate([
            replyViewTopConstraint,
            viewReply.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewReply.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewReply.heightAnchor.constraint(equalToConstant: replyHeight)
        ])
        
        // Constraints for greenView
        inputViewTopConstraint = viewInput.topAnchor.constraint(equalTo: viewReply.bottomAnchor)
        NSLayoutConstraint.activate([
            inputViewTopConstraint,
            viewInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewInput.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewInput.heightAnchor.constraint(equalToConstant: inputHeight),
            //            viewInput.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        // Constraints for blueView
        moreViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewInput.bottomAnchor)
        NSLayoutConstraint.activate([
            moreViewTopConstraint,
            viewMore.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewMore.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewMore.heightAnchor.constraint(equalToConstant: moreHeight),
            viewMore.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
    }
    
    func layout(_ children: [SendChild]) {
        DispatchQueue.main.async {
            self.viewReply.isHidden = !children.contains(.reply)
            self.viewInput.isHidden = !children.contains(.input)
            self.viewMore.isHidden = !children.contains(.more)
            self.updateConstraintsForVisibility()
            self.layoutIfNeeded()
            self.updateHeight()
        }
    }
    
    public func updateConstraintsForVisibility() {
        inputViewTopConstraint.isActive = false
        if viewReply.isHidden {
            inputViewTopConstraint = viewInput.topAnchor.constraint(equalTo: topAnchor)
        } else {
            inputViewTopConstraint = viewInput.topAnchor.constraint(equalTo: viewReply.bottomAnchor)
        }
        inputViewTopConstraint.isActive = true
        
        moreViewTopConstraint.isActive = false
        if viewInput.isHidden {
            moreViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewReply.isHidden ? topAnchor : viewReply.bottomAnchor)
        } else {
            moreViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewInput.bottomAnchor)
        }
        moreViewTopConstraint.isActive = true
        
        layoutIfNeeded()
        if (viewInput.isHidden == true) && (viewReply.isHidden == true)&&(viewMore.isHidden == true) {
            self.viewInput.isHidden = false
        }
    }
    
    public func updateHeight() {
        layoutIfNeeded()
        let visibleSubviews = [viewReply, viewInput, viewMore].filter { !$0.isHidden }
        var totalHeight: CGFloat = 0
        
        for subview in visibleSubviews {
            totalHeight += subview.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
        delegate?.updateBottomViewHeight(to: totalHeight)
    }
    // MARK: - Reset Method
    func resetViews() {
        DispatchQueue.main.async {
            [self.viewReply, self.viewInput, self.viewMore].forEach { $0.isHidden = true }
            self.viewInput.textfieldMessage.text = ""
            self.viewInput.mode = .audio
            self.viewInput.isAttachVisible = false
            self.updateConstraintsForVisibility()
            self.layoutIfNeeded()
            self.updateHeight()
        }
    }
}
