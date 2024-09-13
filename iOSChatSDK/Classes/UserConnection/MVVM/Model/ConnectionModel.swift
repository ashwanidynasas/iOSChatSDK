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
    public var roomID: String
    public var circleHashAddr: String
    public var coiHashAddr: String
    public var chatUserId: String
    public var imageInfo: ImageInfo
    public var userInfo: UserInfo
    public var defaultParam: DefaultParam
    
    public init(roomID: String, circleHashAddr: String, coiHashAddr: String, chatUserId: String, imageInfo: ImageInfo, userInfo: UserInfo, defaultParam: DefaultParam) {
        self.circleHashAddr = circleHashAddr
        self.coiHashAddr = coiHashAddr
        self.chatUserId = chatUserId
        self.imageInfo = imageInfo
        self.userInfo = userInfo
        self.defaultParam = defaultParam
        self.roomID = roomID
    }
    
    enum CodingKeys: String, CodingKey {
        case roomID
        case circleHashAddr
        case coiHashAddr
        case chatUserId
        case imageInfo
        case userInfo
        case defaultParam
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.roomID = (try? container.decode(String.self, forKey: .circleHashAddr)) ?? ""
        self.circleHashAddr = (try? container.decode(String.self, forKey: .circleHashAddr)) ?? ""
        self.coiHashAddr = (try? container.decode(String.self, forKey: .coiHashAddr)) ?? ""
        self.chatUserId = (try? container.decode(String.self, forKey: .chatUserId)) ?? ""
        self.imageInfo = (try? container.decode(ImageInfo.self, forKey: .imageInfo)) ?? ImageInfo(url: "")
        self.userInfo = (try? container.decode(UserInfo.self, forKey: .userInfo)) ?? UserInfo()
        self.defaultParam = (try? container.decode(DefaultParam.self, forKey: .defaultParam)) ?? DefaultParam(color: "")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(roomID, forKey: .roomID)
        try container.encode(circleHashAddr, forKey: .circleHashAddr)
        try container.encode(coiHashAddr, forKey: .coiHashAddr)
        try container.encode(chatUserId, forKey: .chatUserId)
        try container.encode(imageInfo, forKey: .imageInfo)
        try container.encode(userInfo, forKey: .userInfo)
        try container.encode(defaultParam, forKey: .defaultParam)
    }
}

public struct ImageInfo: Codable {
    public var url: String

    enum CodingKeys: String, CodingKey {
        case url = "Url"
    }

    public init(url: String) {
        self.url = url
    }
}

public struct UserInfo: Codable {
    public init() {}
}

public struct DefaultParam: Codable {
    public var color: String

    public init(color: String) {
        self.color = color
    }
}

public struct ConnectionManager {
    public init() {}
    
    public func createConnection(circleHashAddr:String,
                                 coiHashAddr: String,
                                 chatUserId: String,
                                 imageInfo: String,
                                 userInfo: String,
                                 defaultParam: String,
                                 roomID: String) -> Connection {
        let defaultParam = DefaultParam(color: defaultParam)
        let imageInfo = ImageInfo(url: imageInfo)
        let userInfo = UserInfo()
        
        let connection = Connection(roomID: roomID, circleHashAddr: circleHashAddr,
                                    coiHashAddr: coiHashAddr,
                                    chatUserId: chatUserId,
                                    imageInfo: imageInfo,
                                    userInfo: userInfo,
                                    defaultParam: defaultParam)
        
        return connection
    }
}
