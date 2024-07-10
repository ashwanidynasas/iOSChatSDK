//
//  File.swift
//  SQRCLE
//
//  Created by Dynasas on 10/05/24.
//

import Foundation


enum ActionSheetItem : String , CaseIterable{
    case startOver     = "Start over"
    case saveDraft     = "Save draft"
    case discard       = "Discard"
    case camera        = "Camera"
    case gallery       = "Gallery"
    case cancel        = "Cancel"
    case removePicture = "Remove picture"
    case copy          = "Copy Link"
    case external      = "External"
    case qr            = "QR code"
    case report        = "Report"
    case mute          = "Mute"
    case removeUser    = "Remove"
    case edit          = "Edit"
    case share         = "Share"
    case connect       = "Connect"
    
    
    var title : String{
        switch self{
        default: return rawValue
        }
    }
    
    var icon : String{
        switch self{
        case .startOver     : return "startOver"
        case .saveDraft     : return "saveDraft"
        case .removePicture : return "removePicture"
        case .qr            : return "viewqr"
        case .external      : return "external"
        case .copy          : return "copylink"
        case .connect       : return "circledetail"
        default:  return rawValue.lowercased()
        }
    }
}

enum Button : String , CaseIterable{
    case edit           = "Edit"
    case shareQr, share = "Share"
    case more           = ""
    case media          = "Media"
    case chat           = "Chat"
    case chats          = "Chats"
    case groups         = "Groups"
    case invite         = "Invite"
    case requests       = "Requests"
    
    case calendar       = "Calendar"
    case myCois         = "My COIs"
    case following      = "Following"
    case directs        = "Directs"
    case viral          = "Viral"
    case discover       = "Discover"
    
    case oneOnOne       = "1 on 1"
    case subscribe      = "Subscribe"
    case subscription   = "Subscription"
    case new            = "New"
    case empty          = "dropup"
    
    
    var title : String{
        switch self{
        case .invite : return "Share"
        default: return rawValue
        }
    }
    
    var icon : String{
        switch self{
        case .share     : return "share"
        case .shareQr   : return "viewqr"
        case .media     : return "gallery"
        case .more      : return "moreHorizontal"
        case .requests  : return "connectRequests"
        case .directs   : return "chats"
        case .discover, .myCois  : return "cois"
        case .subscription : return "subscribe"
        default         : return rawValue.lowercased()
        }
    }
    
    var tag : Int{
        return self.ordinal()
    }
}

public extension CaseIterable where Self: Equatable {

    func ordinal() -> Self.AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
    
    
    

}
