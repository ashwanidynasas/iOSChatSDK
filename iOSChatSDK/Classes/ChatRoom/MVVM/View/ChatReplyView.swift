//
//  ChatReplyView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 30/08/24.
//

import UIKit
import Foundation

class ChatReplyView: UIView {
    
    // MARK: - UI Elements
    private let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.text = "label Name translatesAutoresizingMaskIntoConstraints translatesAutoresizingMaskIntoConstraints"
        label.font = ChatConstants.Bubble.messageFont
        label.textColor = .white

        return label
    }()
    
    private let labelDesc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "label desc translatesAutoresizingMaskIntoConstraints translatesAutoresizingMaskIntoConstraints translatesAutoresizingMaskIntoConstraints"
        label.font = ChatConstants.Bubble.messageFont
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.layer.cornerRadius = 12.5
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: ChatConstants.Image.userPlaceholder)
        return imageView
    }()
    
    private let crossButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.setImage(UIImage(named: ChatConstants.Image.replyCancel, in: Bundle(for: ChatReplyView.self), compatibleWith: nil), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(labelName)
        addSubview(imageView)
        addSubview(labelDesc)
        addSubview(crossButton)
        crossButton.addTarget(self, action: #selector(replyCancelView), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            labelDesc.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            labelDesc.topAnchor.constraint(equalTo: imageView.topAnchor), // Align to top of imageView
            labelDesc.heightAnchor.constraint(equalTo: imageView.heightAnchor), // Match height of imageView
            labelDesc.trailingAnchor.constraint(lessThanOrEqualTo: crossButton.leadingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            crossButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            crossButton.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
    
    // MARK: - Actions
    @objc private func replyCancelView() {
        print("Cancel reply")
    }
}
