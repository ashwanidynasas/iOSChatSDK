//
//  MediaContentCell.swift
//  iOSChatSDK
//
//  Created by Ashwani on 09/07/24.
//

import UIKit



class MediaContentCell: UITableViewCell {
    private let bubbleBackgroundView = UIView()
    private let timestampLabel = UILabel()
    private var messageImageView = UIImageView()
    private let readIndicatorImageView = UIImageView() // Added read indicator
    let playButton = UIButton() // Added play button
    weak var delegate: DelegatePlay?

    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    private var maxWidthConstraint: NSLayoutConstraint!

    private var bubbleHeightConstraint: NSLayoutConstraint!
    private var bubbleWidthConstraint: NSLayoutConstraint!
    private var messageImageViewHeightConstraint: NSLayoutConstraint!
    private var messageImageViewWidthConstraint: NSLayoutConstraint!


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        backgroundColor = .clear

        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = ChatConstants.Bubble.cornerRadius//Constants.bubbleDiameter / 2
        bubbleBackgroundView.clipsToBounds = true
        bubbleBackgroundView.layer.borderWidth = ChatConstants.Bubble.borderWidth//3.0
        bubbleBackgroundView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(bubbleBackgroundView)

        messageImageView.contentMode = .scaleAspectFill
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.layer.cornerRadius = ChatConstants.Bubble.cornerRadius//Constants.bubbleDiameter / 2
        messageImageView.clipsToBounds = true
        bubbleBackgroundView.addSubview(messageImageView)
        
        timestampLabel.font = ChatConstants.Bubble.timeStampFont//Constants.timestampFont
        timestampLabel.textColor = ChatConstants.Bubble.timeStampColor//Constants.timestampColor
        timestampLabel.textAlignment = .center
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestampLabel)
        
        readIndicatorImageView.image = UIImage(named: ChatConstants.Image.readIndicator, in: Bundle(for: MediaContentCell.self), compatibleWith: nil)
        readIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(readIndicatorImageView)

        playButton.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.addSubview(playButton)
        
        // Add target for button tap
        playButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // Setup tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        playButton.addGestureRecognizer(tapGestureRecognizer)
        
        // Setup long press gesture recognizer
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        playButton.addGestureRecognizer(longPressGestureRecognizer)

    }
    @objc private func buttonTapped(_ sender: UIButton) {
        delegate?.didTapPlayButton(in: self)
        
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        delegate?.didTapPlayButton(in: self)
        
    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.didLongPressPlayButton(in: self)
        }
    }
//    private struct Constants {
//        static let bubbleDiameter: CGFloat = 170
//        static let timestampFont: UIFont = .systemFont(ofSize: 8)
//        static let timestampColor: UIColor = .lightGray
//        static let readIndicatorSize: CGFloat = 7
//        static let padding: CGFloat = 12
//        static let timestampPadding: CGFloat = 4
//        static let dateFormat: String = "hh:mm a"
//        static let playButtonSize: CGFloat = 30
//
//    }
    private func setupConstraints() {
        
        leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ChatConstants.Bubble.leadAnchor)
        trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ChatConstants.Bubble.trailAnchor)
        bubbleHeightConstraint = bubbleBackgroundView.heightAnchor.constraint(equalToConstant: ChatConstants.Bubble.diameter)
        bubbleWidthConstraint = bubbleBackgroundView.widthAnchor.constraint(equalToConstant: ChatConstants.Bubble.diameter)
        
        messageImageViewHeightConstraint = messageImageView.heightAnchor.constraint(equalTo: bubbleBackgroundView.heightAnchor)
        messageImageViewWidthConstraint = messageImageView.widthAnchor.constraint(equalTo: bubbleBackgroundView.widthAnchor)
        
        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: ChatConstants.Bubble.topAnchor),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ChatConstants.Bubble.bottomAncher),
            bubbleHeightConstraint,
            bubbleWidthConstraint,

            messageImageView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor),
            messageImageView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor),
            messageImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: messageImageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: messageImageView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: ChatConstants.Bubble.playButtonSize),
            playButton.heightAnchor.constraint(equalToConstant: ChatConstants.Bubble.playButtonSize),

            timestampLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: ChatConstants.Bubble.timeStampLblBAnchor),
            timestampLabel.centerXAnchor.constraint(equalTo: messageImageView.centerXAnchor),
            
            readIndicatorImageView.trailingAnchor.constraint(equalTo: timestampLabel.trailingAnchor, constant: (timestampLabel.frame.width/2+10)),
            readIndicatorImageView.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            readIndicatorImageView.widthAnchor.constraint(equalToConstant: ChatConstants.Bubble.readIndicatorSize),
            readIndicatorImageView.heightAnchor.constraint(equalToConstant: ChatConstants.Bubble.readIndicatorSize),
        ])
    
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        messageImageView.image = nil
        playButton.tag = 0
    }
    
    func mediaConfigure(with message: Messages) {
        
        let isCurrentUser = message.sender == UserDefaultsHelper.getCurrentUser()
        bubbleBackgroundView.backgroundColor = isCurrentUser ? UIColor.black.withAlphaComponent(0.5) : Colors.Circles.violet
        timestampLabel.textColor = .white
        
        let timestamp = Date(timeIntervalSince1970: Double(message.originServerTs ?? 0) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ChatConstants.Bubble.dateFormat
        timestampLabel.text = dateFormatter.string(from: timestamp)
        
        if isCurrentUser {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        } else {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        }
        if message.content?.msgtype == MessageType.image {
            playButton.setImage(nil, for: .normal)
            if let imageUrlString = message.content?.url, let imageUrl = imageUrlString.modifiedString.mediaURL {
                // Load the image from the URL
//                self.messageImageView.sd_setImage(with: imageUrl, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: MediaContentCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                self.messageImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ChatConstants.Image.userPlaceholder), options: [], completed: nil)

            }else{
                let imageView = UIImageView(image: UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: MediaContentCell.self), compatibleWith: nil))
                self.messageImageView = imageView
            }
        }else if message.content?.msgtype == MessageType.video {
            if let videoURL = message.content?.S3thumbnailUrl {
                fetchThumbnail(videoURL)
            }else{
                let imageView = UIImageView(image: UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: MediaContentCell.self), compatibleWith: nil))
                self.messageImageView = imageView
            }
            self.playButton.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), for: .normal)

        }else if message.content?.msgtype == MessageType.audio {
            self.messageImageView.image = UIImage(named: ChatConstants.Image.placeholder)

//            let imageView = UIImageView(image: UIImage(named: "userPlaceholder", in: Bundle(for: MediaContentCell.self), compatibleWith: nil))
//            self.messageImageView = imageView
            self.playButton.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), for: .normal)
            
        }else{
            self.messageImageView.image = UIImage(named: ChatConstants.Image.placeholder)
        }
        
        
    }
    
    func fetchThumbnail(_ s3MediaUrl:String) {
        guard let videoURL = URL(string: "\(ChatConstants.S3Media.URL)\(s3MediaUrl)") else {
            print("Error: Invalid video URL")
            return
        }
        DispatchQueue.main.async {
            self.messageImageView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)

        }

    }
}
