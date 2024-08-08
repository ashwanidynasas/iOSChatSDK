//
//  ReplyTextCell.swift
//  iOSChatSDK
//
//  Created by Ashwani on 30/07/24.
//

import Foundation
import SDWebImage

class ReplyTextCell: UITableViewCell {
    private let bubbleBackgroundView = UIView()
    private let upperbubbleBackgroundView = UIView()
    private let messageLabel = UILabel()
    private let timestampLabel = UILabel()
    private let readIndicatorImageView = UIImageView()
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var minWidthConstraint: NSLayoutConstraint!
    private var maxWidthConstraint: NSLayoutConstraint!
    private var upperbubbleBackgroundViewHeightConstraint: NSLayoutConstraint!
    private let titleLabel = UILabel()
    private let replyImageView = UIImageView()
    private let descriptionLabel = UILabel()

    private enum MessageType: String {
        case text = "m.text"
        case video = "m.video"
        case image = "m.image"
        case audio = "m.audio"
    }

    private struct Constants {
        static let bubbleCornerRadius: CGFloat = 20
        static let bubbleShadowColor: CGColor = UIColor.black.cgColor
        static let bubbleShadowOffset = CGSize(width: 0, height: 2)
        static let bubbleShadowOpacity: Float = 0.3
        static let bubbleShadowRadius: CGFloat = 4
        static let messageFont: UIFont = .systemFont(ofSize: 12)
        static let timestampFont: UIFont = .systemFont(ofSize: 8)
        static let timestampColor: UIColor = .lightGray
        static let readIndicatorSize: CGFloat = 7
        static let padding: CGFloat = 12
        static let timestampPadding: CGFloat = 4
        static let minBubbleWidth: CGFloat = 100
        static let maxBubbleWidthRatio: CGFloat = 0.75
        static let dateFormat: String = "hh:mm a"
        static let imageViewSize: CGSize = CGSize(width: 30, height: 30)
        static let imageViewSizeZero: CGSize = CGSize(width: 0, height: 0)

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    override func prepareForReuse() {
            super.prepareForReuse()
            // Reset the content of the cell
            messageLabel.text = nil
            // Reset other UI elements if necessary
        }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = Constants.bubbleCornerRadius
        bubbleBackgroundView.layer.shadowColor = Constants.bubbleShadowColor
        bubbleBackgroundView.layer.shadowOffset = Constants.bubbleShadowOffset
        bubbleBackgroundView.layer.shadowOpacity = Constants.bubbleShadowOpacity
        bubbleBackgroundView.layer.shadowRadius = Constants.bubbleShadowRadius

        bubbleBackgroundView.addSubview(upperbubbleBackgroundView)
        upperbubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        upperbubbleBackgroundView.layer.cornerRadius = 5
        upperbubbleBackgroundView.clipsToBounds = true
        
        bubbleBackgroundView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.font = Constants.messageFont
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleBackgroundView.addSubview(timestampLabel)
        timestampLabel.font = Constants.timestampFont
        timestampLabel.textColor = Constants.timestampColor
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleBackgroundView.addSubview(readIndicatorImageView)
        readIndicatorImageView.contentMode = .scaleAspectFit
        readIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
     
        // Adding subviews to upperbubbleBackgroundView
        upperbubbleBackgroundView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 10)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        upperbubbleBackgroundView.addSubview(replyImageView)
        replyImageView.layer.cornerRadius = 15 // Half of width/height
        replyImageView.layer.masksToBounds = true // Ensures image is clipped to the bounds

        replyImageView.backgroundColor = .gray // Replace with actual image
        replyImageView.translatesAutoresizingMaskIntoConstraints = false
        replyImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize.width).isActive = true
        replyImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize.height).isActive = true

        upperbubbleBackgroundView.addSubview(descriptionLabel)
        descriptionLabel.font = .systemFont(ofSize: 10)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    }

    private func setupConstraints() {
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
        minWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minBubbleWidth)
        maxWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * Constants.maxBubbleWidthRatio)

        upperbubbleBackgroundViewHeightConstraint = upperbubbleBackgroundView.heightAnchor.constraint(equalToConstant: 0)
        
        // Constraints for replyImageView
        let replyImageViewWidthConstraint = replyImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize.width)
        replyImageViewWidthConstraint.priority = .defaultHigh

        let replyImageViewHeightConstraint = replyImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize.height)
        replyImageViewHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            minWidthConstraint,
            maxWidthConstraint,

            upperbubbleBackgroundView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
            upperbubbleBackgroundView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: Constants.padding),
            upperbubbleBackgroundView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -Constants.padding),
            upperbubbleBackgroundViewHeightConstraint,
            
            // Constraints for titleLabel
            titleLabel.topAnchor.constraint(equalTo: upperbubbleBackgroundView.topAnchor,constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: upperbubbleBackgroundView.leadingAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalToConstant: 70), // Fixed width
            titleLabel.heightAnchor.constraint(equalToConstant: 15), // Fixed height

            replyImageViewWidthConstraint,
            replyImageViewHeightConstraint,
            replyImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            replyImageView.leadingAnchor.constraint(equalTo: upperbubbleBackgroundView.leadingAnchor, constant: 8),

//            replyImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
//            replyImageView.leadingAnchor.constraint(equalTo: upperbubbleBackgroundView.leadingAnchor, constant: 8),
//            replyImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize.width),
//            replyImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize.height),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: replyImageView.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: upperbubbleBackgroundView.trailingAnchor, constant: -Constants.padding),
            
            messageLabel.topAnchor.constraint(equalTo: upperbubbleBackgroundView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: Constants.padding),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -Constants.padding),

            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Constants.timestampPadding),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -Constants.padding),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),

            readIndicatorImageView.widthAnchor.constraint(equalToConstant: Constants.readIndicatorSize),
            readIndicatorImageView.heightAnchor.constraint(equalToConstant: Constants.readIndicatorSize),
            readIndicatorImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -2),
            readIndicatorImageView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -10)
            
        ])
    }

    func configure(with message: Messages, currentUser: String) {
        
        let isCurrentUser = message.sender == currentUser
        bubbleBackgroundView.backgroundColor = isCurrentUser ? UIColor.black.withAlphaComponent(0.5) : Colors.Circles.violet
        upperbubbleBackgroundView.backgroundColor = isCurrentUser ? Colors.Circles.violet :UIColor.black.withAlphaComponent(0.5)

        titleLabel.textColor = .white
        descriptionLabel.textColor = .white
        messageLabel.textColor = .white
        timestampLabel.textColor = .white
        applyBubbleShape(isCurrentUser: isCurrentUser)

        if isCurrentUser {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            readIndicatorImageView.isHidden = false
        } else {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            readIndicatorImageView.isHidden = true
        }

        let timestamp = Date(timeIntervalSince1970: Double(message.originServerTs ?? 0) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        timestampLabel.text = dateFormatter.string(from: timestamp)

        // Adjust bubble width based on timestampLabel size
        let timestampSize = timestampLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: timestampLabel.frame.height))
        let minWidth = timestampSize.width + 2 * Constants.padding

        minWidthConstraint.constant = max(minWidth, Constants.minBubbleWidth)

        // Configure read indicator
        readIndicatorImageView.image = UIImage(named: "read_indicator", in: Bundle(for: ChatMessageCell.self), compatibleWith: nil)

        configureTextMessage(message.content?.body ?? "", replyText: message.content?.relatesTo?.inReplyTo?.sender ?? "", replyImage: message.content?.relatesTo?.inReplyTo?.content?.S3MediaUrl ?? "", replyDesc: message.content?.relatesTo?.inReplyTo?.content?.body ?? "")

        // Handle different message types
        if let msgType = MessageType(rawValue: message.content?.relatesTo?.inReplyTo?.content?.msgtype ?? "") {
            switch msgType {
            case .video:
                self.replyImageView.isHidden = false
//                descriptionLabel.leadingAnchor.constraint(equalTo: replyImageView.trailingAnchor, constant: 8).isActive = true
            case .text:
                self.replyImageView.isHidden = true
//                descriptionLabel.leadingAnchor.constraint(equalTo: upperbubbleBackgroundView.leadingAnchor, constant: 8).isActive = true
            case .image:
                self.replyImageView.isHidden = false
//                descriptionLabel.leadingAnchor.constraint(equalTo: replyImageView.trailingAnchor, constant: 8).isActive = true
            case .audio:
                self.replyImageView.isHidden = false
//                descriptionLabel.leadingAnchor.constraint(equalTo: replyImageView.trailingAnchor, constant: 8).isActive = true
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
    }

    private func configureTextMessage(_ text: String, replyText:String,replyImage:String, replyDesc:String) {
        
        messageLabel.text = text
        titleLabel.text = replyText
        descriptionLabel.text = replyDesc
        upperbubbleBackgroundViewHeightConstraint.constant = 60
        
        guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(replyImage)") else {
            print("Error: Invalid video URL")
            return
        }
        DispatchQueue.main.async {
            self.replyImageView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: MediaContentCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
        }
    }
                                                  
    private func applyBubbleShape(isCurrentUser: Bool) {
        bubbleBackgroundView.layer.cornerRadius = 12
        if isCurrentUser {
            bubbleBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            bubbleBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        }
    }
}
