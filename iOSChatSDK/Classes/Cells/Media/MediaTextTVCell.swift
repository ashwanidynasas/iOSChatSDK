//
//  MediaTextTVCell.swift
//  iOSChatSDK
//
//  Created by Ashwani on 25/07/24.
//

import UIKit


class MediaTextTVCell: UITableViewCell {
    
    @IBOutlet weak var bubbleBackgroundView:UIView!
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var messageImageView:UIImageView!
    @IBOutlet weak var imageBackView:UIView!

    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    @IBOutlet weak var maxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var readIndicatorImageView: UIImageView!

    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!

    @IBOutlet weak var playButton:UIButton!
    weak var delegate: DelegatePlay?

    func mediaConfigure(with message: Messages) {

        let isCurrentUser = message.sender == UserDefaultsHelper.getCurrentUser()
        bubbleBackgroundView.backgroundColor = isCurrentUser ? ChatConstants.Bubble.backgroundColor : UIColor(hex:ChatConstants.CircleColor.borderHexString)
        timestampLabel.textColor = .white
        messageLabel.text = message.content?.body

        let timestamp = Date(timeIntervalSince1970: Double(message.originServerTs ?? 0) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ChatConstants.Bubble.dateFormat
        timestampLabel.text = dateFormatter.string(from: timestamp)
        applyBubbleShape(isCurrentUser: isCurrentUser)

        if isCurrentUser {
            leading.constant = 160
            trailing.constant = 32
            readIndicatorImageView.isHidden = false
        } else {
            leading.constant = 32
            trailing.constant = 160
            readIndicatorImageView.isHidden = true
        }
        if message.content?.msgtype == MessageType.image {
            playButton.setImage(nil, for: .normal)
            if let imageUrlString = message.content?.url, let imageUrl = imageUrlString.modifiedString.mediaURL {
                // Load the image from the URL
                self.messageImageView.sd_setImage(with: imageUrl, placeholderImage:  UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: MediaTextTVCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                
            }
        }else if message.content?.msgtype == MessageType.video {
            if let videoURL = message.content?.S3thumbnailUrl {
                fetchThumbnail(videoURL)
            }else{
                let imageView = UIImageView(image: UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: MediaTextTVCell.self), compatibleWith: nil)) // Replace with your image names

                self.messageImageView = imageView
            }
            self.playButton.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaTextTVCell.self), compatibleWith: nil), for: .normal)

        }else if message.content?.msgtype == MessageType.audio {
            let imageView = UIImageView(image: UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: MediaTextTVCell.self), compatibleWith: nil)) // Replace with your image names
            self.messageImageView = imageView
            self.playButton.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaTextTVCell.self), compatibleWith: nil), for: .normal)
            
        }
        
        
    }
    
    func fetchThumbnail(_ s3MediaUrl:String) {
        guard let videoURL = URL(string: "\(ChatConstants.S3Media.URL)\(s3MediaUrl)") else {
            print("Error: Invalid video URL")
            return
        }
        DispatchQueue.main.async {
            self.messageImageView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: ChatConstants.Image.userPlaceholder, in: Bundle(for: MediaTextTVCell.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)

        }

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = ChatConstants.ReplyBubble.cornerRadius
        bubbleBackgroundView.layer.shadowColor = ChatConstants.Bubble.shadowColor
        bubbleBackgroundView.layer.shadowOffset = ChatConstants.Bubble.shadowOffset
        bubbleBackgroundView.layer.shadowOpacity = ChatConstants.Bubble.shadowOpacity
        bubbleBackgroundView.layer.shadowRadius = ChatConstants.Bubble.shadowRadius
        bubbleBackgroundView.backgroundColor =  Colors.Circles.violet

        messageImageView.layer.cornerRadius = messageImageView.frame.size.width/2
        messageImageView.clipsToBounds = true
        
        imageBackView.layer.cornerRadius = imageBackView.frame.size.width/2
        imageBackView.clipsToBounds = true

        playButton.setImage(UIImage(named: ChatConstants.Image.playIcon, in: Bundle(for: MediaTextTVCell.self), compatibleWith: nil), for: .normal)

        // Setup tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        playButton.addGestureRecognizer(tapGestureRecognizer)
        
        // Setup long press gesture recognizer
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        playButton.addGestureRecognizer(longPressGestureRecognizer)

    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        delegate?.didTapPlayButton(in: self)
    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.didLongPressPlayButton(in: self)
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
