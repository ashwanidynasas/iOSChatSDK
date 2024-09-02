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

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(viewReply)
        stackView.addArrangedSubview(viewInput)
        stackView.addArrangedSubview(viewMore)
        addSubview(stackView)
        

        
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
