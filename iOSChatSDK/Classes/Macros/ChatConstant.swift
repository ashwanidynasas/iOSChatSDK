//
//  ChatConstant.swift
//  iOSChatSDK
//
//  Created by Ashwani on 20/08/24.
//

import Foundation

// MARK: - ChatConstants
struct ChatConstants {
    
    struct Common {
        static let update       = "update"
        static let back         = "back"
        static let deleteItem   = "deleteItem"
        static let spam         = "spam"
    }
    
    //API Constant
    struct API {
        static let failedAccessToken = "Failed to retrieve access token"
        static let AccessToken      = "Access Token"
        
        static let baseURL      = "http://157.241.58.41/chat_api/"
        static let createRoom   = "\(baseURL)room/create"
        static let fetchUserlist = "\(baseURL)list-user-apple"
        static let sendMedia    = "\(baseURL)message/send/"
        static let reply        = "\(baseURL)message/reply"
    }
    
    struct Storyboard {
        static let mainChat                   = "MainChat"
        static let mainChatVCIdentifier       = "MainChatVC"
        static let connectionListVCIdentifier = "ConnectionListVC"
        static let chatRoomVCIdentifier       = "ChatRoomVC"
    }
    // Media Types
    struct MediaType {
        static let image = "image"
        static let video = "video"
        static let file  = "file"
        static let audio = "audio"
    }
    
    // MIME Types
    struct MimeType {
        static let imageJPEG  = "image/jpeg"
        static let videoMP4   = "video/mp4"
        static let filePython = "application/x-python-code"
        static let audioMP3   = "audio/mp3"
    }
    
    // File Names
    struct FileName {
        static let image    = "a1.jpg"
        static let video    = "upload.mp4"
        static let document = "upload.pdf"
        static let audio    = "Audio File"
    }
    
    // Localization Keys
    struct Localization {
        static let successMessage = NSLocalizedString("Data sent successfully", comment: "Message displayed when data is sent successfully")
        static let errorMessage = NSLocalizedString("Error: %@", comment: "Error message format")
        static let msgTypeNotSupported = NSLocalizedString("Message type not supported: %@", comment: "Message displayed when an unsupported message type is used")
    }
    
    // Default delay for async operations (in seconds)
    static let asyncDelay: TimeInterval = 2.0
    
    struct Image {
        static let readIndicator:String    = "read_indicator"
        static let playIcon:String         = "PlayIcon"
        static let placeholder:String      = "placeholder"
        static let userPlaceholder:String  = "placeholder"
        static let sendIcon:String         = "sendIcon"
        static let cancel:String           = "cancel"
        static let replyCancel:String      = "replyCancel"
        static let emoji:String            = "emoji"
        static let moreCamera:String       = "MoreCamera"
        static let cameraIcon:String       = "cameraIcon"
        static let plusIcon:String         = "plusIcon"
        static let backButton:String       = "BackButton"
        static let searchImg:String        = "Search"
        static let wave:String             = "wave"
        
        static let locationPlaceholder:String   = "chat_location_placeholder"
        static let documentPlaceholder:String   = "chat_document_placeholder"
        static let videoPlaceholder:String      = "chat_video_placeholder"
        static let audioPlaceholder:String      = "chat_audio_placeholder"

    }
    
    struct Bubble {
        static let diameter: CGFloat            = 170
        static let timeStampFont: UIFont        = .systemFont(ofSize: 10)
        static let messageFont: UIFont          = .systemFont(ofSize: 12)
        static let timeStampColor: UIColor      = .lightGray
        static let readIndicatorSize: CGFloat   = 7
        static let padding: CGFloat             = 12
        static let timeStampPadding: CGFloat    = 4
        static let dateFormat: String           = "hh:mm a"
        static let playButtonSize: CGFloat      = 30
        static let leadAnchor:CGFloat           = 32
        static let trailAnchor:CGFloat          = -32
        static let topAnchor: CGFloat           = 16
        static let bottomAncher: CGFloat        = -16
        static let borderWidth:CGFloat          = 3.0
        static let timeStampLblBAnchor:CGFloat  = -20
        static let cornerRadius                 = diameter / 2
        static let defaultBGColor: UIColor      = .clear
        
        static let shadowColor: CGColor         = UIColor.black.cgColor
        static let shadowOffset                 = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float         = 0.3
        static let shadowRadius: CGFloat        = 4
        static let backgroundColor = UIColor.black.withAlphaComponent(0.4)

    }
    struct ReplyBubble {
        static let cornerRadius: CGFloat = 20
        static let minBubbleWidth: CGFloat = 180
        static let maxBubbleWidthRatio: CGFloat = 0.75
        static let imageViewSize: CGSize = CGSize(width: 30, height: 30)
        static let imageViewSizeZero: CGSize = CGSize(width: 0, height: 0)
        static let mediaImageViewSize: CGSize = CGSize(width: 120, height: 120)
    }
    
    struct BubbleHeight {
        static let cellHeight:CGFloat           = 200.0
        static let estimationRowHeight:CGFloat  = 100.0
    }
    
    struct S3Media {
        static let URL: String = "https://d3qie74tq3tm9f.cloudfront.net/"
    }
    struct CircleColor {
        static var hexString: String = "#520093"
        static var borderHexString: String = "#8D30D6"
    }
}

struct ChatMediaConstant_Chat {
    
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
    
    struct UploadResponseKeys_Chat {
        static let success      = "success"
        static let message      = "message"
        static let redirectUrl  = "redirectUrl"
        static let details      = "details"
        static let response     = "response"
        static let chatEventId  = "chat_event_id"
    }
}
struct ChatMessageCellConstant {
    
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
//        static let imageName: String = "read_indicator"
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
        static let placeholderImageName: String = "placeholder"
    }
    
    struct Gesture {
        static let longPressMinimumPressDuration: CFTimeInterval = 0.5
    }

}


struct MessageType {
    static let text    = "m.text"
    static let audio   = "m.audio"
    static let video   = "m.video"
    static let image   = "m.image"
    static let file    = "m.file"
    static let roomMsg = "m.room.message"
}

struct Cell_Chat {
    
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
    
    static let CustomTopView = "CustomTopView"
    static let InputView = "InputView"
    static let ReplyView = "ReplyView"
}

struct SB {
    static let main = "MainChat"
}

struct Alerts_Chat {
    static let errorTitle = "Error"
    static let okButtonTitle = "OK"
    static let sdkNotFoundMessage = "SDK not found in CustomPods"
    static let accessTokenTitle = "Access Token"
    static let accessTokenErrorMessage = "Failed to retrieve access token"
}

struct Titles_Chat {
    static let chatSDK = "Chat SDK"
    static let connectionList = "Connection List"
}
  
struct URLs_Chat {
    static let placeholderImageName = "placeholder"
    static let defaultCircleId = "591cd8b1-2288-4e6c-ad7d-c2bdc7d786fe"
}


//MediaContentCell
//struct MsgView {
//    static let bubbleDiameter: CGFloat = 170
//    static let timestampFont: UIFont = .systemFont(ofSize: 8)
//    static let timestampColor: UIColor = .lightGray
//    static let readIndicatorSize: CGFloat = 7
//    static let padding: CGFloat = 12
//    static let timestampPadding: CGFloat = 4
//    static let dateFormat: String = "hh:mm a"
//    static let playButtonSize: CGFloat = 30
//    static let defaultBackgroundColor: UIColor = .clear
//}
    
struct ReplyCell_Chat {
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
    static let minBubbleWidth: CGFloat = 180
    static let maxBubbleWidthRatio: CGFloat = 0.75
    static let dateFormat: String = "hh:mm a"
    static let imageViewSize: CGSize = CGSize(width: 120, height: 120)
}

struct ImagePickerMedia{
    static let image = "public.image"
    static let video = "public.movie"
}
