//
//  ChatConstant.swift
//  iOSChatSDK
//
//  Created by Ashwani on 20/08/24.
//

import Foundation

// MARK: - ChatConstants
struct ChatConstants {

    // API Constants
    struct API {
        static let roomID = "room_id"
        static let accessToken = "access_token"
    }

    // Media Types
    struct MediaType {
        static let image = "image"
        static let video = "video"
        static let file = "file"
        static let audio = "audio"
    }
    
    // MIME Types
    struct MimeType {
        static let imageJPEG = "image/jpeg"
        static let videoMP4 = "video/mp4"
        static let filePython = "application/x-python-code"
        static let audioMP3 = "audio/mp3"
    }

    // File Names
    struct FileName {
        static let image = "a1.jpg"
        static let video = "upload.mp4"
        static let audio = "Audio File"
    }

    // Localization Keys
    struct Localization {
        static let successMessage = NSLocalizedString("Data sent successfully", comment: "Message displayed when data is sent successfully")
        static let errorMessage = NSLocalizedString("Error: %@", comment: "Error message format")
        static let msgTypeNotSupported = NSLocalizedString("Message type not supported: %@", comment: "Message displayed when an unsupported message type is used")
    }

    // Default delay for async operations (in seconds)
    static let asyncDelay: TimeInterval = 2.0
}

struct BottomViewConstants {
    // MARK: - View Heights
    struct Heights {
        static let zeroHeight: CGFloat = 0.0
        static let replyBottomViewHeight: CGFloat = 46.0
        static let textFieldViewHeight: CGFloat = 46.0
        static let moreViewHeight: CGFloat = 46.0
        static let backBottomViewHeightWithReplyMore: CGFloat = 170.0
        static let backBottomViewHeightWithReply: CGFloat = 114.0
        static let backBottomViewHeightWithMore: CGFloat = 114.0
        static let backBottomViewHeightOnlyTF: CGFloat = 74.0
    }
}
struct ChatMediaConstants {
    
    struct API {
        static let baseURL = "http://157.241.58.41/chat_api/message/send/"
        static let httpMethodPost = "POST"
        static let contentType = "Content-Type"
        static let multipartFormData = "multipart/form-data; boundary="
        static let accessToken = "accessToken"
        static let roomID = "roomID"
        static let body = "body"
        static let msgType = "msgType"
        static let mimetype = "mimetype"
        static let fileName = "fileName"
        static let file = "file"
    }
    
    struct MIMEType {
        static let imageJPEG = "image/jpeg"
        static let videoMP4 = "video/mp4"
        static let audioMP3 = "audio/mp3"
        static let filePython = "application/x-python-code"
    }
    
    struct FileName {
        static let imageFile = "a1.jpg"
        static let videoFile = "upload.mp4"
        static let audioFile = "Audio File"
    }
    
    struct UploadResponseKeys {
        static let success = "success"
        static let message = "message"
        static let redirectUrl = "redirectUrl"
        static let details = "details"
        static let response = "response"
        static let chatEventId = "chat_event_id"
    }
}
struct ChatMessageCellConstants {
    
    struct Bubble {
        static let cornerRadius: CGFloat = 20
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 0.3
        static let shadowRadius: CGFloat = 4
        static let backgroundColorCurrentUser = UIColor.black.withAlphaComponent(0.5)
        static let backgroundColorOtherUser = Colors.Circles.violet
    }
    
    struct MessageLabel {
        static let font: UIFont = .systemFont(ofSize: 12)
        static let textColor: UIColor = .white
    }
    
    struct TimestampLabel {
        static let font: UIFont = .systemFont(ofSize: 8)
        static let textColor: UIColor = .lightGray
        static let padding: CGFloat = 4
        static let dateFormat: String = "hh:mm a"
    }
    
    struct ReadIndicator {
        static let size: CGFloat = 7
        static let imageName: String = "read_indicator"
        static let trailingPadding: CGFloat = -2
        static let bottomPadding: CGFloat = -10
    }
    
    struct Padding {
        static let general: CGFloat = 12
        static let bubbleTopBottom: CGFloat = 16
        static let messageImageTop: CGFloat = 8
        static let minBubbleWidth: CGFloat = 100
        static let maxBubbleWidthRatio: CGFloat = 0.75
    }
    
    struct ImageView {
        static let contentMode: UIView.ContentMode = .scaleAspectFit
        static let height: CGFloat = 150
        static let placeholderImageName: String = "userPlaceholder"
    }
    
    struct Gesture {
        static let longPressMinimumPressDuration: CFTimeInterval = 0.5
    }

}


struct MessageType {
    static let text = "m.text"
    static let audio = "m.audio"
    static let video = "m.video"
    static let image = "m.image"

}

struct Cell {
    static let custom    = "CustomTableViewCell"
    static let mediaText = "MediaTextTVCell"
    
    static let message = "ChatMessageCell"
    static let media = "MediaContentCell"
    
    
    static let ReplyText_TextCell = "ReplyText_TextCell"
    static let ReplyText_MediaCell = "ReplyText_MediaCell"
    static let ReplyText_MediaTextCell = "ReplyText_MediaTextCell"
    
    static let ReplyMedia_TextCell = "ReplyMedia_TextCell"
    static let ReplyMedia_MediaCell = "ReplyMedia_MediaCell"
    static let ReplyMedia_MediaTextCell = "ReplyMedia_MediaTextCell"
    
    static let ReplyMediaText_TextCell = "ReplyMediaText_TextCell"
    static let ReplyMediaText_MediaCell = "ReplyMediaText_MediaCell"
    static let ReplyMediaText_MediaTextCell = "ReplyMediaText_MediaTextCell"
    
}

struct SB {
    static let main = "MainChat"
}
