//
//  MediaContentCell.swift
//  iOSChatSDK
//
//  Created by Ashwani on 09/07/24.
//

import UIKit
import AVFoundation



open class MediaContentCell: UITableViewCell {
    public let bubbleBackgroundView = UIView()
    public let timestampLabel = UILabel()
    public var messageImageView = UIImageView()
    public let readIndicatorImageView = UIImageView() // Added read indicator
    let playButton = UIButton()
    weak var delegate: DelegatePlay?

    public var leadingConstraint: NSLayoutConstraint!
    public var trailingConstraint: NSLayoutConstraint!
    public var maxWidthConstraint: NSLayoutConstraint!

    public var bubbleHeightConstraint: NSLayoutConstraint!
    public var bubbleWidthConstraint: NSLayoutConstraint!
    public var messageImageViewHeightConstraint: NSLayoutConstraint!
    public var messageImageViewWidthConstraint: NSLayoutConstraint!
    public let gradientLayer = CAGradientLayer()

    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var audioURL:URL?
    var mediaType:String?
    

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setupViews() {
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
        
        // Add gradient layer to the image view
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.3).cgColor]
        gradientLayer.locations = [0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        messageImageView.layer.addSublayer(gradientLayer)

        timestampLabel.font = ChatConstants.Bubble.timeStampFont
        timestampLabel.textColor = ChatConstants.Bubble.timeStampColor
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
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
//        playButton.addGestureRecognizer(tapGestureRecognizer)
        
        // Setup long press gesture recognizer
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        playButton.addGestureRecognizer(longPressGestureRecognizer)

    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        // Make sure the gradient layer's frame matches the image view
        gradientLayer.frame = messageImageView.bounds
    }
    @objc private func buttonTapped(_ sender: UIButton) {
        if self.mediaType == MessageType.audio{
            if let player = player {
                if player.timeControlStatus == .playing {
                    player.pause()
                    sender.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), for: .normal)
                    delegate?.didStopPlayingAudio(in: self)
                } else {
                    player.play()
                    sender.setImage(UIImage(named: ChatConstants.Image.pauseIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), for: .normal)
                    delegate?.didStartPlayingAudio(in: self)
                }
            } else {
                //                if let url = self.audioURL {
                //                    print("Selected Audio ---> \(url)")
                //                    configureWith(url: url)
                //                }
                //                sender.setImage(UIImage(named: ChatConstants.Image.pauseIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), for: .normal)
                //                delegate?.didStartPlayingAudio(in: self)
                
                if let url = self.audioURL {
                    print("Selected Audio ---> \(url)")
                    configureWith(url: url)
                } else {
                    resetPlayPauseButton()
                    showToast(message: "Audio URL is invalid.")
                }
                sender.setImage(
                    UIImage(named: ChatConstants.Image.pauseIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil),
                    for: .normal
                )
                delegate?.didStartPlayingAudio(in: self)
            }
        }else{
            delegate?.didTapPlayButton(in: self)
        }
    }
    
    func configureAudioSessionss() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
        }
    }

    func playAudio(from urlString: URL) {
        configureAudioSessionss()
        player = AVPlayer(url: urlString)
        player?.play()
    }

    func configureWith(url: URL) {
        configureAudioSessionss()
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Observe when the player finishes playing
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        // Observe errors during playback
        playerItem.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
        
        player?.play()
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let playerItem = object as? AVPlayerItem {
            switch playerItem.status {
            case .readyToPlay:
                print("Audio is ready to play.")
            case .failed:
                print("Failed to play audio: \(playerItem.error?.localizedDescription ?? "Unknown error")")
                resetPlayPauseButton() // Reset the button state
                showToast(message: "Audio failed to play.")
            default:
                break
            }
        }
    }
    private func resetPlayPauseButton() {
        playButton.setImage(
            UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil),
            for: .normal
        )
        player = nil
    }
    private func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.contentView.center.x - 75, y: self.contentView.frame.size.height - 50, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.contentView.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
//    func configureWith(url: URL) {
//        configureAudioSessionss()
//
//        let playerItem = AVPlayerItem(url: url)
//        player = AVPlayer(playerItem: playerItem)
//
//        // Observe when the player finishes playing
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(playerDidFinishPlaying),
//            name: .AVPlayerItemDidPlayToEndTime,
//            object: playerItem
//        )
//
//        player?.play()
//    }
    @objc private func playerDidFinishPlaying() {
        // Reset the play button icon to play
        playButton.setImage(
            UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil),
            for: .normal
        )
        player = nil
    }// if audio url is not working or not play or incruptted, so play pause toggle will reset. afte click on play button. and toast will show.

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.didLongPressPlayButton(in: self)
        }
    }

    public func setupConstraints() {
        
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
            playButton.widthAnchor.constraint(equalTo: messageImageView.widthAnchor),
            playButton.heightAnchor.constraint(equalTo: messageImageView.heightAnchor),

            timestampLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: ChatConstants.Bubble.timeStampLblBAnchor),
            timestampLabel.centerXAnchor.constraint(equalTo: messageImageView.centerXAnchor),
            
            readIndicatorImageView.trailingAnchor.constraint(equalTo: timestampLabel.trailingAnchor, constant: (timestampLabel.frame.width/2+10)),
            readIndicatorImageView.centerYAnchor.constraint(equalTo: timestampLabel.centerYAnchor),
            readIndicatorImageView.widthAnchor.constraint(equalToConstant: ChatConstants.Bubble.readIndicatorSize),
            readIndicatorImageView.heightAnchor.constraint(equalToConstant: ChatConstants.Bubble.readIndicatorSize),
        ])
    
    }
    open override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        player?.pause() // Stop any ongoing playback
        delegate?.didStopPlayingAudio(in: self)
        player = nil
        
        messageImageView.image = nil
        playButton.tag = 0
        
        
        // Remove notification observer
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        // Reset the play button icon
        playButton.setImage(
            UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil),
            for: .normal
        )
        
    }
    func mediaConfigure(with message: Messages) {
        
        let isCurrentUser = message.sender == UserDefaultsHelper.getCurrentUser()
        self.mediaType = ""
        bubbleBackgroundView.backgroundColor = isCurrentUser ? ChatConstants.Bubble.backgroundColor : UIColor(hex:ChatConstants.CircleColor.borderHexString)
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
            self.messageImageView.image = UIImage(named: ChatConstants.Image.playIcon)
            self.mediaType = message.content?.msgtype
            guard let audiourl = URL(string: "\(ChatConstants.S3Media.URL)\(/message.content?.S3MediaUrl)") else {
                print("Error: Invalid video URL")
                return
            }
            self.audioURL = audiourl
            self.playButton.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), for: .normal)
            
        }
        else if message.content?.msgtype == MessageType.file {
            self.messageImageView.image = UIImage(named: ChatConstants.Image.placeholder)

            self.playButton.setImage(UIImage(named: ChatConstants.Image.documentPlaceholder, in: Bundle(for: MediaContentCell.self), compatibleWith: nil), for: .normal)
        }
        else{
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
