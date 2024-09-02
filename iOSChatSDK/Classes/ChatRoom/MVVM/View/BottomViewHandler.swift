//
//  BottomViewHandler.swift
//  iOSChatSDK
//
//  Created by Ashwani on 29/07/24.
//

import Foundation
import UIKit


class BottomView: UIView {
    
    open var viewReply : ChatReplyView{
        let view = ChatReplyView()
        return view
    }
    open var viewInput = ChatInputView()
    open var viewMore  = MoreView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        intialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        intialSetup()
    }
    
    func intialSetup(){
//        viewReply.delegate = self
//        viewInput.delegateInput = self
        viewInput.clipsToBounds = true
        viewMore.setup(.attach)
    }
    
    func setupView() {
//        
//        viewReply.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
//        //viewReply.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
//        
//        viewInput.heightAnchor.constraint(equalToConstant: 72.0).isActive = true
//        //viewInput.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
//        
//        viewMore.heightAnchor.constraint(equalToConstant: 102.0).isActive = true
//        //viewMore.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .bottom
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(viewReply)
        stackView.addArrangedSubview(viewInput)
        stackView.addArrangedSubview(viewMore)
        addSubview(stackView)
        
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: self.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//        ])
//        
//        NSLayoutConstraint.activate([
//            viewReply.bottomAnchor.constraint(equalTo: viewInput.topAnchor),
//            viewReply.heightAnchor.constraint(equalToConstant: 72),
//            viewReply.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            viewReply.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
//        ])
//        
//        NSLayoutConstraint.activate([
//            viewInput.bottomAnchor.constraint(equalTo: viewMore.topAnchor),
//            viewInput.heightAnchor.constraint(equalToConstant: 72),
//            viewInput.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            viewInput.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
//        ])
        
        
        NSLayoutConstraint.activate([
            viewMore.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            viewMore.heightAnchor.constraint(equalToConstant: 102),
            viewMore.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            viewMore.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the width of the tab bar matches the screen width
        if let superview = superview {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalTo: superview.widthAnchor)
            ])
        }
    }  
    
    func layout( _ children : [SendChild]){
        DispatchQueue.main.async {
            self.viewReply.isHidden = !children.contains(.reply)
            self.viewInput.isHidden = !children.contains(.input)
            self.viewMore.isHidden = !children.contains(.more)
         }
    }
}
