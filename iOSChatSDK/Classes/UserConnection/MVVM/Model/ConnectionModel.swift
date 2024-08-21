//
//  ConnectionModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

import Foundation

struct ConnectionResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: ConnectionDetails
}

struct ConnectionDetails: Codable {
    let connections: [Connection]
}

struct Connection: Codable {
    let circleHashAddr: String
    let coiHashAddr: String
    let chatUserId: String
    let imageInfo: ImageInfo
    let userInfo: UserInfo
    let defaultParam: DefaultParam
}

struct ImageInfo: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "Url"
    }
}

struct UserInfo: Codable {}

struct DefaultParam: Codable {
    let color: String
}


