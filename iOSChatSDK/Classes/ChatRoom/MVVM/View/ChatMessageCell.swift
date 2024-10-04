//MARK: - MODULES
import UIKit
import SDWebImage
import AVFoundation

//MARK: - CLASS
open class ChatMessageCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    public let bubbleBackgroundView = UIView()
    public let messageLabel = UILabel()
    public let timestampLabel = UILabel()
    public let readIndicatorImageView = UIImageView()
    public let messageImageView = UIImageView()
    let overlayButton = UIButton()
    
    weak var delegate: DelegatePlay?
    
    //MARK: - CONSTRAINTS
    public var leadingConstraint: NSLayoutConstraint!
    public var trailingConstraint: NSLayoutConstraint!
    public var minWidthConstraint: NSLayoutConstraint!
    public var maxWidthConstraint: NSLayoutConstraint!
    public var messageImageViewHeightConstraint: NSLayoutConstraint!
    
    public struct Constants {
        static let minBubbleWidth: CGFloat = 100
    }
    
    //MARK: - INITIALIZERS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addGestures()
        setupConstraints()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGestures(){
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        overlayButton.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc public func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
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



//MARK: - UI SETUP
extension ChatMessageCell{
    
    public func setupViews() {
        backgroundColor = .clear
        
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = ReplyCell_Chat.bubbleCornerRadius
        bubbleBackgroundView.layer.shadowColor = ReplyCell_Chat.bubbleShadowColor
        bubbleBackgroundView.layer.shadowOffset = ReplyCell_Chat.bubbleShadowOffset
        bubbleBackgroundView.layer.shadowOpacity = ReplyCell_Chat.bubbleShadowOpacity
        bubbleBackgroundView.layer.shadowRadius = ReplyCell_Chat.bubbleShadowRadius
        contentView.addSubview(bubbleBackgroundView)
        
        messageImageView.contentMode = .scaleAspectFit
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(messageImageView)
        
        messageLabel.numberOfLines = 0
        messageLabel.font = ReplyCell_Chat.messageFont
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(messageLabel)
        
        timestampLabel.font = ReplyCell_Chat.timestampFont
        timestampLabel.textColor = ReplyCell_Chat.timestampColor
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(timestampLabel)
        
        readIndicatorImageView.contentMode = .scaleAspectFit
        readIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(readIndicatorImageView)
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(overlayButton)
    }
    
    public func updateConstraintsForContent() {
        
        if messageLabel.isHidden {
            messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 0).isActive = false
        } else {
            messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 8).isActive = true
        }
        
        if messageImageView.isHidden {
            messageImageViewHeightConstraint.constant = 0
        } else {
            messageImageViewHeightConstraint.constant = 150 // Set desired height for the image view
        }
    }
    
    public func setupConstraints() {
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        minWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minBubbleWidth)
        maxWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * ReplyCell_Chat.maxBubbleWidthRatio)
        
        messageImageViewHeightConstraint = messageImageView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            minWidthConstraint,
            maxWidthConstraint,
            
            messageImageView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
            messageImageView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: ReplyCell_Chat.padding),
            messageImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -ReplyCell_Chat.padding),
            messageImageViewHeightConstraint,
            
            messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: ReplyCell_Chat.padding),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -ReplyCell_Chat.padding),
            
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: ReplyCell_Chat.timestampPadding),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -ReplyCell_Chat.padding),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),
            
            readIndicatorImageView.widthAnchor.constraint(equalToConstant: ReplyCell_Chat.readIndicatorSize),
            readIndicatorImageView.heightAnchor.constraint(equalToConstant: ReplyCell_Chat.readIndicatorSize),
            readIndicatorImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -2),
            readIndicatorImageView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -10),
            
            overlayButton.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor),
            overlayButton.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor),
            overlayButton.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor),
            overlayButton.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),
        ])
    }
}




//MARK: - CONFIGURATION
extension ChatMessageCell{
    func configure(with message: Messages) {
        
        let isCurrentUser = message.sender == UserDefaultsHelper.getCurrentUser()
        
        bubbleBackgroundView.backgroundColor = isCurrentUser ? ChatConstants.Bubble.backgroundColor : UIColor(hex:ChatConstants.CircleColor.borderHexString)
        messageLabel.textColor = .white
        timestampLabel.textColor = .white
        applyBubbleShape(isCurrentUser: isCurrentUser)
        
        leadingConstraint.isActive = !isCurrentUser
        trailingConstraint.isActive = isCurrentUser
        readIndicatorImageView.isHidden = !isCurrentUser
        
        let timestamp = Date(timeIntervalSince1970: Double(message.originServerTs ?? 0) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ReplyCell_Chat.dateFormat
        timestampLabel.text = dateFormatter.string(from: timestamp)
        
        // Adjust bubble width based on timestampLabel size
        let timestampSize = timestampLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: timestampLabel.frame.height))
        let minWidth = timestampSize.width + 2 * ReplyCell_Chat.padding
        
        minWidthConstraint.constant = max(minWidth, Constants.minBubbleWidth)
        
        // Configure read indicator
        readIndicatorImageView.image = UIImage(named: ChatConstants.Image.readIndicator, in: Bundle(for: ChatMessageCell.self), compatibleWith: nil)
        
        // Handle different message types
        let msgType = /message.content?.msgtype
        switch msgType {
        case MessageType.text:
            configureTextMessage(message.content?.body ?? "")
        case MessageType.audio:
            configureAudioMessage(message.content?.body ?? "")
        case MessageType.video:
            configureVideoMessage(message.content?.url ?? "")
        case MessageType.image:
            configureImageMessage(message.content?.body ?? "", mediaUrl: message.content?.url ?? "")
        default:
            break
        }
        
        // Adjust constraints based on content
        updateConstraintsForContent()
        
    }
    
    public func configureTextMessage(_ text: String) {
        messageLabel.text = text
        messageLabel.isHidden = false
        messageImageView.isHidden = true
    }
    
    public func configureAudioMessage(_ text: String) {
        messageLabel.text = "Audio: \(text)"
        messageLabel.isHidden = false
        messageImageView.isHidden = true
    }
    
    public func configureVideoMessage(_ text: String) {
        messageLabel.isHidden = true
        messageImageView.isHidden = false
        if text.modifiedString.mediaURL != nil {
            self.messageImageViewHeightConstraint.constant = 150
        } else {
            messageImageViewHeightConstraint.constant = 0
        }
    }
    
    public func configureImageMessage(_ text: String,mediaUrl:String) {
        
        messageLabel.text = text
        messageLabel.isHidden = false
        messageImageView.isHidden = false
        
        if let url = mediaUrl.modifiedString.mediaURL {
            
            self.messageImageView.sd_setImage(with: url, placeholderImage:  UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: ChatMessageCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
            
            messageImageViewHeightConstraint.constant = 150 // Set desired height for the image view
        } else {
            messageImageViewHeightConstraint.constant = 0
        }
    }
}
