//
//  ChatMessageModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

import Foundation

struct ChatMessageResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: ChatMessageDetails
}

struct ChatMessageDetails: Codable {
    let response: String
    let chat_event_id: String
}

struct MessageResponse: Codable {
    let chunk: [Messages]?
    let start: String?
    let end: String?
}

struct Messages: Codable {
    let type: String?
    let roomId: String?
    let sender: String?
    let content: MessageContent?
    let originServerTs: Int?
    let unsigned: Unsigned?
    let eventId: String?
    let userId: String?
    let age: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case roomId = "room_id"
        case sender
        case content
        case originServerTs = "origin_server_ts"
        case unsigned
        case eventId = "event_id"
        case userId = "user_id"
        case age
    }
}

struct MessageContent: Codable {
    let msgtype: String?
    let body: String?
    let url: String?
    let S3MediaUrl: String?
    let S3thumbnailUrl: String?
    let format: String?
    let formattedBody: String?
    let relatesTo: RelatesTo?
    let info: Info?

    enum CodingKeys: String, CodingKey {
        case msgtype
        case body
        case url
        case S3MediaUrl
        case S3thumbnailUrl
        case format
        case formattedBody = "formatted_body"
        case relatesTo = "m.relates_to"
        case info
    }
}

struct RelatesTo: Codable {
    let inReplyTo: InReplyTo?

    enum CodingKeys: String, CodingKey {
        case inReplyTo = "m.in_reply_to"
    }
}

struct InReplyTo: Codable {
    let eventId: String
    let sender: String
    let content: ReplyContent?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id", sender, content
    }
}
struct ReplyContent: Codable {
    let msgtype: String?
    let body: String?
    let url: String?
    let S3MediaUrl: String?
    let S3thumbnailUrl: String?
    let info: Info?
    
    enum CodingKeys: String, CodingKey {
        case msgtype, body, url, S3MediaUrl, S3thumbnailUrl, info = "info"
    }
}

struct Info: Codable {
    let mimetype: String?
}
struct Unsigned: Codable {
    let age: Int?
}

