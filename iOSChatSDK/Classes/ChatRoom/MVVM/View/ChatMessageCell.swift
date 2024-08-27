import UIKit
import SDWebImage
import AVFoundation

class ChatMessageCell: UITableViewCell {
    private let bubbleBackgroundView = UIView()
    private let messageLabel = UILabel()
    private let timestampLabel = UILabel()
    private let readIndicatorImageView = UIImageView()
    private let messageImageView = UIImageView()
    let overlayButton = UIButton()
    weak var delegate: DelegatePlay?

    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var minWidthConstraint: NSLayoutConstraint!
    private var maxWidthConstraint: NSLayoutConstraint!
    private var messageImageViewHeightConstraint: NSLayoutConstraint!

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

        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = Constants.bubbleCornerRadius
        bubbleBackgroundView.layer.shadowColor = Constants.bubbleShadowColor
        bubbleBackgroundView.layer.shadowOffset = Constants.bubbleShadowOffset
        bubbleBackgroundView.layer.shadowOpacity = Constants.bubbleShadowOpacity
        bubbleBackgroundView.layer.shadowRadius = Constants.bubbleShadowRadius
        contentView.addSubview(bubbleBackgroundView)

        messageImageView.contentMode = .scaleAspectFit
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(messageImageView)

        messageLabel.numberOfLines = 0
        messageLabel.font = Constants.messageFont
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(messageLabel)

        timestampLabel.font = Constants.timestampFont
        timestampLabel.textColor = Constants.timestampColor
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(timestampLabel)

        readIndicatorImageView.contentMode = .scaleAspectFit
        readIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(readIndicatorImageView)
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(overlayButton)
        
        // Setup long press gesture recognizer
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        overlayButton.addGestureRecognizer(longPressGestureRecognizer)

    }
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.didLongPressPlayButton(in: self)
        }
    }
    private func setupConstraints() {
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        minWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minBubbleWidth)
        maxWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * Constants.maxBubbleWidthRatio)

        messageImageViewHeightConstraint = messageImageView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            minWidthConstraint,
            maxWidthConstraint,

            messageImageView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: 8),
            messageImageView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: Constants.padding),
            messageImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -Constants.padding),
            messageImageViewHeightConstraint,
            
            messageLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: Constants.padding),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -Constants.padding),
            
            timestampLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Constants.timestampPadding),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -Constants.padding),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -8),

            readIndicatorImageView.widthAnchor.constraint(equalToConstant: Constants.readIndicatorSize),
            readIndicatorImageView.heightAnchor.constraint(equalToConstant: Constants.readIndicatorSize),
            readIndicatorImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -2),
            readIndicatorImageView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -10),

            overlayButton.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor),
            overlayButton.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor),
            overlayButton.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor),
            overlayButton.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),

        ])
    }

    func configure(with message: Messages, currentUser: String) {
        let isCurrentUser = message.sender == currentUser
        bubbleBackgroundView.backgroundColor = isCurrentUser ? UIColor.black.withAlphaComponent(0.5) : Colors.Circles.violet
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

    private func configureTextMessage(_ text: String) {
        messageLabel.text = text
        messageLabel.isHidden = false
        messageImageView.isHidden = true
    }

    private func configureAudioMessage(_ text: String) {
        messageLabel.text = "Audio: \(text)"
        messageLabel.isHidden = false
        // Additional setup for audio message
        messageImageView.isHidden = true
    }

    private func configureVideoMessage(_ text: String) {
        messageLabel.isHidden = true
        messageImageView.isHidden = false
        if text.modifiedString.mediaURL != nil {
            self.messageImageViewHeightConstraint.constant = 150
        } else {
            messageImageViewHeightConstraint.constant = 0
        }
    }
    
    private func configureImageMessage(_ text: String,mediaUrl:String) {
            
        messageLabel.text = text
        messageLabel.isHidden = false
        messageImageView.isHidden = false

        if let url = mediaUrl.modifiedString.mediaURL {

            self.messageImageView.sd_setImage(with: url, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: ChatMessageCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
              
            messageImageViewHeightConstraint.constant = 150 // Set desired height for the image view
          } else {
              messageImageViewHeightConstraint.constant = 0
          }
      }
    
    private func updateConstraintsForContent() {
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
                                                  
                                                  
                                                  
                                                  
                                                  
                                                  
    private func applyBubbleShape(isCurrentUser: Bool) {
        bubbleBackgroundView.layer.cornerRadius = 12
        if isCurrentUser {
            bubbleBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            bubbleBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        }
    }
}
