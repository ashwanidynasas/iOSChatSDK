//
//  ChatReplyView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 30/08/24.
//

import UIKit
import Foundation



open class ChatReplyView: UIView {
    
    weak var delegate : DelegateReply?
    
    // MARK: - UI Elements
    public let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.font = UIFont(name: "Roboto-Bold", size: 12)
        label.textColor = .white
        
        return label
    }()
    
    public let labelDesc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ChatConstants.Bubble.messageFont
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: ChatConstants.Image.userPlaceholder)
        return imageView
    }()
    
    public let crossButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true
        button.setImage(UIImage(named: ChatConstants.Image.replyCancel, in: Bundle(for: ChatReplyView.self), compatibleWith: nil), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // Constraints
    private var labelDescLeadingToImageViewConstraint: NSLayoutConstraint!
    private var labelDescLeadingToSuperviewConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2

    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    public func setupView() {
        addSubview(labelName)
        addSubview(imageView)
        addSubview(labelDesc)
        addSubview(crossButton)
        crossButton.addTarget(self, action: #selector(replyCancelView), for: .touchUpInside)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        labelDescLeadingToImageViewConstraint = labelDesc.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16)
        labelDescLeadingToSuperviewConstraint = labelDesc.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            labelDesc.topAnchor.constraint(equalTo: imageView.topAnchor),
            labelDesc.trailingAnchor.constraint(lessThanOrEqualTo: crossButton.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            crossButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            crossButton.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
    
    // MARK: - Actions
    @objc private func replyCancelView() {
        delegate?.cancelReply()
    }
    
    func configure(with message: Messages?) {
        labelName.text = (/message?.sender == /UserDefaultsHelper.getCurrentUser() ? "You" : /UserDefaultsHelper.getOtherUser())//message?.sender
        labelDesc.text = /message?.content?.body
        if let image = message?.content?.url, !image.isEmpty {
            imageView.isHidden = false
            if image.modifiedString.mediaURL != nil {
                let urlString = image.modifiedString
                self.imageView.setImage(placeholder: ChatConstants.Image.placeholder, url: urlString)
            }
//            if let url = image.modifiedString.mediaURL {
//                let urlString = image.modifiedString
//                
//                self.imageView.setImage(placeholder: ChatConstants.Image.placeholder, url: urlString)
////                self.imageView.sd_setImage(with: url, placeholderImage: UIImage.init(systemName: "person.circle.fill"), options: .transformAnimatedImage, progress: nil, completed: nil)
//            }
            labelDescLeadingToSuperviewConstraint.isActive = false
            labelDescLeadingToImageViewConstraint.isActive = true
        } else {
            imageView.isHidden = true
            labelDescLeadingToImageViewConstraint.isActive = false
            labelDescLeadingToSuperviewConstraint.isActive = true
        }
        layoutIfNeeded()
    }
    
}
