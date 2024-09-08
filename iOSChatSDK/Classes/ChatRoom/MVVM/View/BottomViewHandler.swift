//
//  BottomViewHandler.swift
//  iOSChatSDK
//
//  Created by Ashwani on 29/07/24.
//

import Foundation
import UIKit

protocol BottomViewDelegate: AnyObject {
    func updateBottomViewHeight(to height: CGFloat)
}

class BottomView: UIView {
    
    weak var delegate: BottomViewDelegate?
    
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
    private var redViewTopConstraint: NSLayoutConstraint!
    private var greenViewTopConstraint: NSLayoutConstraint!
    private var blueViewTopConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        viewMore.setup(.attach)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        viewMore.setup(.attach)
    }
    
    private func setupView() {
        addSubview(viewReply)
        addSubview(viewInput)
        addSubview(viewMore)
        
        // Constraints for redView
        redViewTopConstraint = viewReply.topAnchor.constraint(equalTo: topAnchor)
        NSLayoutConstraint.activate([
            redViewTopConstraint,
            viewReply.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewReply.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewReply.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Constraints for greenView
        greenViewTopConstraint = viewInput.topAnchor.constraint(equalTo: viewReply.bottomAnchor)
        NSLayoutConstraint.activate([
            greenViewTopConstraint,
            viewInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewInput.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewInput.heightAnchor.constraint(equalToConstant: 40),
            viewInput.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        // Constraints for blueView
        blueViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewInput.bottomAnchor)
        NSLayoutConstraint.activate([
            blueViewTopConstraint,
            viewMore.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewMore.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewMore.heightAnchor.constraint(equalToConstant: 50),
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
    
    private func updateConstraintsForVisibility() {
        greenViewTopConstraint.isActive = false
        if viewReply.isHidden {
            greenViewTopConstraint = viewInput.topAnchor.constraint(equalTo: topAnchor)
        } else {
            greenViewTopConstraint = viewInput.topAnchor.constraint(equalTo: viewReply.bottomAnchor)
        }
        greenViewTopConstraint.isActive = true
        
        blueViewTopConstraint.isActive = false
        if viewInput.isHidden {
            blueViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewReply.isHidden ? topAnchor : viewReply.bottomAnchor)
        } else {
            blueViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewInput.bottomAnchor)
        }
        blueViewTopConstraint.isActive = true
        
        layoutIfNeeded()
        if (viewInput.isHidden == true) && (viewReply.isHidden == true)&&(viewMore.isHidden == true) {
            self.viewInput.isHidden = false
        }
    }
    
    private func updateHeight() {
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
            self.viewReply.isHidden = true
            self.viewInput.isHidden = true
            self.viewMore.isHidden = true
            self.viewInput.isAttachVisible = false
            self.updateConstraintsForVisibility()
            self.layoutIfNeeded()
            self.updateHeight()
        }
    }
    
}
