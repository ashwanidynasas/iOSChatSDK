//
//  ConnectionModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

import Foundation

public struct ConnectionResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: ConnectionDetails
}

public struct ConnectionDetails: Codable {
    let connections: [Connection]
}

public struct Connection: Codable {
    var circleHashAddr: String
    var coiHashAddr: String
    var chatUserId: String
    var imageInfo: ImageInfo
    var userInfo: UserInfo
    var defaultParam: DefaultParam
    
    init(circleHashAddr: String, coiHashAddr: String, chatUserId: String, imageInfo: ImageInfo, userInfo: UserInfo, defaultParam: DefaultParam) {
        self.circleHashAddr = circleHashAddr
        self.coiHashAddr = coiHashAddr
        self.chatUserId = chatUserId
        self.imageInfo = imageInfo
        self.userInfo = userInfo
        self.defaultParam = defaultParam
    }
//    //default values
//    init() {
//        self.circleHashAddr = ""
//        self.coiHashAddr = ""
//        self.chatUserId = ""
//        self.imageInfo = ImageInfo(url: "")
//        self.userInfo = UserInfo()
//        self.defaultParam = DefaultParam(color: "#FFFFFF")
//    }
}

public struct ImageInfo: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "Url"
    }
}

public struct UserInfo: Codable {}

public struct DefaultParam: Codable {
    let color: String
//    init(color: String) {
//        self.color = color
//    }
}


