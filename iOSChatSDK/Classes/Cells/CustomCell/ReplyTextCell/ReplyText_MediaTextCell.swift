//
//  ReplyText_MediaTextCell.swift
//  iOSChatSDK
//
//  Created by Ashwani on 08/08/24.
//
import Foundation
//import SDWebImage


open class ReplyText_MediaTextCell: UITableViewCell {
    
    public let bubbleBackgroundView = UIView()
    let playButton = UIButton() // Added play button
    weak var delegate: DelegatePlay?
    public let upperbubbleBackgroundView = UIView()
    public let messageMediaImage = UIImageView()
    public let messageLabel = UILabel()
    public let timestampLabel = UILabel()
    public let readIndicatorImageView = UIImageView()
    public var leadingConstraint: NSLayoutConstraint!
    public var trailingConstraint: NSLayoutConstraint!
    public var minWidthConstraint: NSLayoutConstraint!
    public var maxWidthConstraint: NSLayoutConstraint!
    public var upperbubbleBackgroundViewHeightConstraint: NSLayoutConstraint!
    public let titleLabel = UILabel()
    public let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        messageLabel.text = nil
        messageMediaImage.image = nil
        messageLabel.isHidden = false
        messageMediaImage.isHidden = false
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = ChatConstants.ReplyBubble.cornerRadius
        bubbleBackgroundView.layer.shadowColor = ChatConstants.Bubble.shadowColor
        bubbleBackgroundView.layer.shadowOffset = ChatConstants.Bubble.shadowOffset
        bubbleBackgroundView.layer.shadowOpacity = ChatConstants.Bubble.shadowOpacity
        bubbleBackgroundView.layer.shadowRadius = ChatConstants.Bubble.shadowRadius

        playButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playButton)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        playButton.addGestureRecognizer(tapGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        playButton.addGestureRecognizer(longPressGestureRecognizer)

        bubbleBackgroundView.addSubview(upperbubbleBackgroundView)
        upperbubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        upperbubbleBackgroundView.layer.cornerRadius = 5
        upperbubbleBackgroundView.clipsToBounds = true

        bubbleBackgroundView.addSubview(messageMediaImage)
        messageMediaImage.contentMode = .scaleAspectFit
        messageMediaImage.contentMode = .scaleAspectFill
        messageMediaImage.translatesAutoresizingMaskIntoConstraints = false
        messageMediaImage.layer.cornerRadius = 60
        messageMediaImage.clipsToBounds = true

        bubbleBackgroundView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.font = ChatConstants.Bubble.messageFont
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleBackgroundView.addSubview(timestampLabel)
        timestampLabel.font = ChatConstants.Bubble.timeStampFont
        timestampLabel.textColor = ChatConstants.Bubble.timeStampColor
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleBackgroundView.addSubview(readIndicatorImageView)
        readIndicatorImageView.contentMode = .scaleAspectFit
        readIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
     
        // Adding subviews to upperbubbleBackgroundView
        upperbubbleBackgroundView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 10)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        upperbubbleBackgroundView.addSubview(descriptionLabel)
        descriptionLabel.font = .systemFont(ofSize: 10)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    }

    public func setupConstraints() {
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ChatConstants.Bubble.leadAnchor)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ChatConstants.Bubble.trailAnchor)
        minWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: ChatConstants.ReplyBubble.minBubbleWidth)
        maxWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * ChatConstants.ReplyBubble.maxBubbleWidthRatio)

        upperbubbleBackgroundViewHeightConstraint = upperbubbleBackgroundView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            minWidthConstraint,
            maxWidthConstraint,

            upperbubbleBackgroundView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
            upperbubbleBackgroundView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: ChatConstants.Bubble.padding),
            upperbubbleBackgroundView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -ChatConstants.Bubble.padding),
            upperbubbleBackgroundViewHeightConstraint,
            
            // Constraints for titleLabel
            titleLabel.topAnchor.constraint(equalTo: upperbubbleBackgroundView.topAnchor,constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: upperbubbleBackgroundView.leadingAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalToConstant: 70), // Fixed width
            titleLabel.heightAnchor.constraint(equalToConstant: 15), // Fixed height
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: upperbubbleBackgroundView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: upperbubbleBackgroundView.trailingAnchor, constant: -ChatConstants.Bubble.padding),
                        
            // Constraints for messageMediaImage
            messageMediaImage.topAnchor.constraint(equalTo: upperbubbleBackgroundView.bottomAnchor, constant: 8),
            messageMediaImage.centerXAnchor.constraint(equalTo: bubbleBackgroundView.centerXAnchor),
            messageMediaImage.widthAnchor.constraint(equalToConstant: 120),
            messageMediaImage.heightAnchor.constraint(equalToConstant: 120),

            // Constraints for messageLabel
            messageLabel.topAnchor.constraint(equalTo: messageMediaImage.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: ChatConstants.Bubble.padding),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -ChatConstants.Bubble.padding),

            // Constraints for playButton to fill the bubbleBackgroundView
//            playButton.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor),
//            playButton.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor),
//            playButton.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor),
//            playButton.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),
            playButton.topAnchor.constraint(equalTo: upperbubbleBackgroundView.bottomAnchor, constant: 8),
            playButton.centerXAnchor.constraint(equalTo: bubbleBackgroundView.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 120),
            playButton.heightAnchor.constraint(equalToConstant: 120),

            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: ChatConstants.Bubble.timeStampPadding),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -ChatConstants.Bubble.padding),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),

            readIndicatorImageView.widthAnchor.constraint(equalToConstant: ChatConstants.Bubble.readIndicatorSize),
            readIndicatorImageView.heightAnchor.constraint(equalToConstant: ChatConstants.Bubble.readIndicatorSize),
            readIndicatorImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -2),
            readIndicatorImageView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -10)
            
        ])
    }

    func configure(with message: Messages) {
        
        if let body = message.content?.body {
            messageLabel.text = body
            messageLabel.isHidden = false
        } else {
            messageLabel.isHidden = true
        }
        if message.content?.msgtype == MessageType.video {
            if let thumbNailURL = message.content?.S3thumbnailUrl {
                guard URL(string: "\(ChatConstants.S3Media.URL)\(thumbNailURL)") != nil else {
                    return
                }
                let videoImgURLString = "\(ChatConstants.S3Media.URL)\(thumbNailURL)"
                self.messageMediaImage.setImage(placeholder: ChatConstants.Image.videoPlaceholder, url: videoImgURLString)
//                self.messageMediaImage.sd_setImage(with: videoImgURL, placeholderImage:  UIImage(named: ChatConstants.Image.videoPlaceholder, in: Bundle(for: ReplyText_MediaTextCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
            }
            playButton.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: ReplyText_MediaCell.self), compatibleWith: nil), for: .normal)
        }else{
            playButton.setImage(nil, for: .normal)
            if let imageUrlString = message.content?.url, !imageUrlString.modifiedString.isEmpty {
                self.messageMediaImage.setImage(placeholder: ChatConstants.Image.userPlaceholder, url: imageUrlString.modifiedString)
            }
//            if let image = message.content?.url {
//                if let url = image.modifiedString.mediaURL {
//                    let urlString = image.modifiedString
//                    self.messageMediaImage.setImage(placeholder: ChatConstants.Image.userPlaceholder, url: urlString)
////                    self.messageMediaImage.sd_setImage(with: url, placeholderImage:  UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: ReplyText_MediaTextCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
//                }
//            }
        }
        
        updateConstraintsForVisibility()
        
        let isCurrentUser = message.sender == UserDefaultsHelper.getCurrentUser()
        bubbleBackgroundView.backgroundColor = isCurrentUser ? ChatConstants.Bubble.backgroundColor : UIColor(hex:ChatConstants.CircleColor.borderHexString)
        upperbubbleBackgroundView.backgroundColor = ChatConstants.Bubble.backgroundColor
        
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
        dateFormatter.dateFormat = ChatConstants.Bubble.dateFormat
        timestampLabel.text = dateFormatter.string(from: timestamp)
        
        // Adjust bubble width based on timestampLabel size
        let timestampSize = timestampLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: timestampLabel.frame.height))
        let minWidth = timestampSize.width + 2 * ChatConstants.Bubble.padding
        
        minWidthConstraint.constant = max(minWidth, ChatConstants.ReplyBubble.minBubbleWidth)
        
        // Configure read indicator
        readIndicatorImageView.image = UIImage(named: ChatConstants.Image.readIndicator, in: Bundle(for: ReplyText_MediaTextCell.self), compatibleWith: nil)
        
//        messageMediaImage.image = UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: ReplyText_MediaTextCell.self), compatibleWith: nil)
        
        configureTextMessage(message.content?.body ?? "", replyText: (/message.content?.relatesTo?.inReplyTo?.sender == /UserDefaultsHelper.getCurrentUser() ? "You" : /UserDefaultsHelper.getOtherUser()), replyImage: message.content?.relatesTo?.inReplyTo?.content?.S3thumbnailUrl ?? "", replyDesc: message.content?.relatesTo?.inReplyTo?.content?.body ?? "")
        

    }

    public func configureTextMessage(_ text: String, replyText:String,replyImage:String, replyDesc:String) {
        messageLabel.text = text
        titleLabel.text = replyText
        descriptionLabel.text = replyDesc
        upperbubbleBackgroundViewHeightConstraint.constant = 60
    }
    
    public func updateConstraintsForVisibility() {
        if messageLabel.isHidden && messageMediaImage.isHidden {
            timestampLabel.topAnchor.constraint(equalTo: upperbubbleBackgroundView.bottomAnchor, constant: 8).isActive = true
        } else if messageLabel.isHidden {
            timestampLabel.topAnchor.constraint(equalTo: messageMediaImage.bottomAnchor, constant: 8).isActive = true
        } else if messageMediaImage.isHidden {
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: ChatConstants.Bubble.timeStampPadding).isActive = true
        } else {
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: ChatConstants.Bubble.timeStampPadding).isActive = true
        }
        
    }
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        delegate?.didTapPlayButton(in: self)
    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.didLongPressPlayButton(in: self)
        }
    }
    public func applyBubbleShape(isCurrentUser: Bool) {
        bubbleBackgroundView.layer.cornerRadius = 12
        if isCurrentUser {
            bubbleBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            bubbleBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        }
    }
}
