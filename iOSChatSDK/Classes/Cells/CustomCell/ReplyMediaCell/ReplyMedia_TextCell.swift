//
//  ReplyMedia_TextCell.swift
//  iOSChatSDK
//
//  Created by Ashwani on 08/08/24.
//
import Foundation
import SDWebImage



open class ReplyMedia_TextCell: UITableViewCell {
    
    public let bubbleBackgroundView = UIView()
    let playButton = UIButton() // Added play button
    weak var delegate: DelegatePlay?
    public let upperbubbleBackgroundView = UIView()
    public let messageLabel = UILabel()
    public let timestampLabel = UILabel()
    public let readIndicatorImageView = UIImageView()
    public var leadingConstraint: NSLayoutConstraint!
    public var trailingConstraint: NSLayoutConstraint!
    public var minWidthConstraint: NSLayoutConstraint!
    public var maxWidthConstraint: NSLayoutConstraint!
    public var upperbubbleBackgroundViewHeightConstraint: NSLayoutConstraint!
    public let titleLabel = UILabel()
    public let replyImageView = UIImageView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    open override func prepareForReuse() {
            super.prepareForReuse()
            // Reset the content of the cell
            messageLabel.text = nil
            // Reset other UI elements if necessary
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

        upperbubbleBackgroundView.addSubview(replyImageView)
        replyImageView.layer.cornerRadius = 60 // Half of width/height
        replyImageView.layer.masksToBounds = true // Ensures image is clipped to the bounds

        replyImageView.backgroundColor = .gray // Replace with actual image
        replyImageView.translatesAutoresizingMaskIntoConstraints = false
        replyImageView.widthAnchor.constraint(equalToConstant: ChatConstants.ReplyBubble.mediaImageViewSize.width).isActive = true
        replyImageView.heightAnchor.constraint(equalToConstant: ChatConstants.ReplyBubble.mediaImageViewSize.height).isActive = true

    }

    public func setupConstraints() {
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
        minWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: ChatConstants.ReplyBubble.minBubbleWidth)
        maxWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * ChatConstants.ReplyBubble.maxBubbleWidthRatio)

        upperbubbleBackgroundViewHeightConstraint = upperbubbleBackgroundView.heightAnchor.constraint(equalToConstant: 0)
        
        // Constraints for replyImageView
        let replyImageViewWidthConstraint = replyImageView.widthAnchor.constraint(equalToConstant: ChatConstants.ReplyBubble.mediaImageViewSize.width)
        replyImageViewWidthConstraint.priority = .defaultHigh

        let replyImageViewHeightConstraint = replyImageView.heightAnchor.constraint(equalToConstant: ChatConstants.ReplyBubble.mediaImageViewSize.height)
        replyImageViewHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            minWidthConstraint,
            maxWidthConstraint,

            // Constraints for playButton to fill the bubbleBackgroundView
            playButton.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor),
            playButton.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor),
            playButton.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),

            upperbubbleBackgroundView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
            upperbubbleBackgroundView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: ChatConstants.Bubble.padding),
            upperbubbleBackgroundView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -ChatConstants.Bubble.padding),
            upperbubbleBackgroundViewHeightConstraint,
            
            // Constraints for titleLabel
            titleLabel.topAnchor.constraint(equalTo: upperbubbleBackgroundView.topAnchor,constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: upperbubbleBackgroundView.leadingAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalToConstant: 70), // Fixed width
            titleLabel.heightAnchor.constraint(equalToConstant: 15), // Fixed height

            replyImageViewWidthConstraint,
            replyImageViewHeightConstraint,
            replyImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            replyImageView.centerXAnchor.constraint(equalTo: upperbubbleBackgroundView.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: upperbubbleBackgroundView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: ChatConstants.Bubble.padding),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -ChatConstants.Bubble.padding),

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
        
        let isCurrentUser = message.sender == UserDefaultsHelper.getCurrentUser()
        bubbleBackgroundView.backgroundColor = isCurrentUser ? UIColor.black.withAlphaComponent(0.5) : Colors.Circles.violet
        upperbubbleBackgroundView.backgroundColor = isCurrentUser ? Colors.Circles.violet :UIColor.black.withAlphaComponent(0.5)

        titleLabel.textColor = .white
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
        readIndicatorImageView.image = UIImage(named: ChatConstants.Image.readIndicator, in: Bundle(for: ChatMessageCell.self), compatibleWith: nil)

        configureTextMessage(message.content?.body ?? "", replyText: message.content?.relatesTo?.inReplyTo?.sender ?? "", replyImage: message.content?.relatesTo?.inReplyTo?.content?.S3MediaUrl ?? "", replyDesc: message.content?.relatesTo?.inReplyTo?.content?.body ?? "")

        
        // Handle different message types
        let msgType = /message.content?.relatesTo?.inReplyTo?.content?.msgtype
            
            if (msgType == MessageType.image) {
                guard let videoURL = URL(string: "\(ChatConstants.S3Media.URL)\(message.content?.relatesTo?.inReplyTo?.content?.S3MediaUrl ?? "")") else {
                    print("Error: Invalid video URL")
                    return
                }
                DispatchQueue.main.async {
                    self.replyImageView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: ReplyMedia_TextCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                }
            }else if (msgType == MessageType.audio) || (msgType == MessageType.video) {
                guard let videoURL = URL(string: "\(ChatConstants.S3Media.URL)\(message.content?.relatesTo?.inReplyTo?.content?.S3thumbnailUrl ?? "")") else {
                    print("Error: Invalid video URL")
                    return
                }
                DispatchQueue.main.async {
                    self.replyImageView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: ReplyMedia_TextCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                }
            }
        
    }

    public func configureTextMessage(_ text: String, replyText:String,replyImage:String, replyDesc:String) {
        
        messageLabel.text = text
        titleLabel.text = replyText
        upperbubbleBackgroundViewHeightConstraint.constant = 150
        
//        guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(replyImage)") else {
//            print("Error: Invalid video URL")
//            return
//        }
//        DispatchQueue.main.async {
//            self.replyImageView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: MediaContentCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
//        }
        
        
    }
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        delegate?.didTapPlayButton(in: self)
        print("touch only")
    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("long pressed")
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
