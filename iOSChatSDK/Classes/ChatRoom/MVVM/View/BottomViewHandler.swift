//
//  BottomViewHandler.swift
//  iOSChatSDK
//
//  Created by Ashwani on 29/07/24.
//

import Foundation
import UIKit

// Define the delegate protocol
protocol BottomViewDelegate: AnyObject {
    func updateBottomViewHeight(to height: CGFloat)
}

//class BottomView: UIView {
//
//    weak var delegate: BottomViewDelegate?
//
//    public lazy var viewReply: ChatReplyView = {
//        let view = ChatReplyView()
//        view.isHidden = true
//        view.backgroundColor = .red
//        return view
//    }()
//
//    public lazy var viewInput: ChatInputView = {
//        let view = ChatInputView()
//        view.isHidden = false
//        view.backgroundColor = .green
//
//        return view
//    }()
//
//    public lazy var viewMore: MoreView = {
//        let view = MoreView()
//        view.isHidden = true
//        view.backgroundColor = .blue
//
//        return view
//    }()
//
//    public var stackView: UIStackView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        initialSetup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//        initialSetup()
//    }
//
//    private func initialSetup() {
////        viewInput.clipsToBounds = true
//        viewMore.setup(.attach)
//    }
//
//    private func setupView() {
//            // Initialize stackView
//            stackView = UIStackView(arrangedSubviews: [viewReply, viewInput, viewMore])
//            stackView.axis = .vertical
//            stackView.distribution = .fill
//            stackView.alignment = .fill
//            stackView.spacing = 10
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(stackView)
//
//            // Constraints for stackView
//            NSLayoutConstraint.activate([
//                stackView.topAnchor.constraint(equalTo: topAnchor),
//                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
//            ])
//        }
//
//    func layout(_ children: [SendChild]) {
//        DispatchQueue.main.async {
//            // Update visibility without removing subviews
//            self.viewReply.isHidden = !children.contains(.reply)
//            self.viewInput.isHidden = !children.contains(.input)
//            self.viewMore.isHidden = !children.contains(.more)
//            
//            print(self.viewReply.isHidden)
//            print(self.viewInput.isHidden)
//            print(self.viewMore.isHidden)
//
//            // Update height
//            self.updateHeight()
//        }
//    }
//    
//    private func updateHeight() {
//        layoutIfNeeded()
//        let visibleSubviews = stackView.arrangedSubviews.filter { !$0.isHidden }
//        var totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.height }
//        if visibleSubviews.count > 1 {
//            totalHeight = 120
//        }else{
//            totalHeight = 65
//        }
//        delegate?.updateBottomViewHeight(to: totalHeight)
//    }
//}

class BottomView: UIView {
    
    weak var delegate: BottomViewDelegate?
    
    public lazy var viewReply: ChatReplyView = {
        let view = ChatReplyView()
        view.backgroundColor = .red
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var viewInput: ChatInputView = {
        let view = ChatInputView()
        view.backgroundColor = .green
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public lazy var viewMore: MoreView = {
        let view = MoreView()
        view.backgroundColor = .blue
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
            viewInput.heightAnchor.constraint(equalToConstant: 50),
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
        // Update constraints for greenView based on visibility of viewReply
           greenViewTopConstraint.isActive = false
           if viewReply.isHidden {
               // If redView (viewReply) is hidden, greenView (viewInput) should be at the top
               greenViewTopConstraint = viewInput.topAnchor.constraint(equalTo: topAnchor)
           } else {
               // If redView is visible, greenView should be below redView
               greenViewTopConstraint = viewInput.topAnchor.constraint(equalTo: viewReply.bottomAnchor)
           }
           greenViewTopConstraint.isActive = true

           // Update constraints for blueView based on visibility of viewInput
           blueViewTopConstraint.isActive = false
           if viewInput.isHidden {
               // If greenView (viewInput) is hidden, blueView (viewMore) should be directly below redView if visible, otherwise at the top
               blueViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewReply.isHidden ? topAnchor : viewReply.bottomAnchor)
           } else {
               // If greenView is visible, blueView should be below greenView
               blueViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewInput.bottomAnchor)
           }
           blueViewTopConstraint.isActive = true

           // Force layout update after changing constraints
           layoutIfNeeded()
//        if viewReply.isHidden {
//            // If redView is hidden, greenView should be at the top
//            greenViewTopConstraint.isActive = false
//            greenViewTopConstraint = viewInput.topAnchor.constraint(equalTo: topAnchor)
//            greenViewTopConstraint.isActive = true
//        } else {
//            // If redView is visible, greenView should be below redView
//            greenViewTopConstraint.isActive = false
//            greenViewTopConstraint = viewInput.topAnchor.constraint(equalTo: viewReply.bottomAnchor)
//            greenViewTopConstraint.isActive = true
//        }
//        if viewInput.isHidden {
//            // If greenView is hidden, blueView should be directly below redView or at the top if redView is also hidden
//            blueViewTopConstraint.isActive = false
//            blueViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewReply.isHidden ? topAnchor : viewReply.bottomAnchor)
//            blueViewTopConstraint.isActive = true
//        } else {
//            // If greenView is visible, blueView should be below greenView
//            blueViewTopConstraint.isActive = false
//            blueViewTopConstraint = viewMore.topAnchor.constraint(equalTo: viewInput.bottomAnchor)
//            blueViewTopConstraint.isActive = true
//        }
    }
    
    private func updateHeight() {
        layoutIfNeeded()
        let visibleSubviews = [viewReply, viewInput, viewMore].filter { !$0.isHidden }
        var totalHeight: CGFloat = 0
        
        for subview in visibleSubviews {
            totalHeight += subview.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        }
//                if visibleSubviews.count > 1 {
//                    totalHeight += CGFloat((visibleSubviews.count - 1) * 4)
//                }
        print(totalHeight)
        delegate?.updateBottomViewHeight(to: totalHeight)
    }
    // MARK: - Reset Method
        func resetViews() {
            DispatchQueue.main.async {
                self.viewReply.isHidden = true
                self.viewInput.isHidden = false
                self.viewMore.isHidden = true
                
                self.updateConstraintsForVisibility()
                self.layoutIfNeeded()
                self.updateHeight()
            }
        }
}
