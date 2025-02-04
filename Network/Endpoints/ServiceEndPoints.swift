//
//  ServiceEndPoints.swift
//  Dynasas
//
//  Created by Dynasas on 29/04/23.
//

import Foundation

//MARK: - UserServiceEndPoint

enum ChatServiceEndPoint {
    case login
    case listConnecttions
    case createRoom
    case sendText
    case redactMessage
    case fetchUserlist
    case sendMedia
    case reply
    case getMessages(roomId : String)
}

extension ChatServiceEndPoint: Endpoint {

    var path: String {
        switch self {
        case .login: return "/chat_api/auth/login"
        case .listConnecttions: return "/chat_api/list-connections"
        case .createRoom: return "/chat_api/room/create"
        case .sendText: return "/chat_api/message/send/text"
        case .redactMessage: return "/chat_api/message/redact"
        case .fetchUserlist : return "/chat_api/list-user-apple"
        case .sendMedia : return "/chat_api/message/send/"
        case .reply : return "/chat_api/message/reply"
        case .getMessages(let roomId) : return "http://chat.sqrcle.co/_matrix/client/r0/rooms/\(roomId)/messages?dir=b"
        }
    }
}


