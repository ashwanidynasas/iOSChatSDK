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
}

extension ChatServiceEndPoint: Endpoint {

    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .listConnecttions: return "/list-connections"
        case .createRoom: return "/room/create"
        case .sendText: return "/message/send/text"
        case .redactMessage: return "/message/redact"
        case .fetchUserlist : return "/list-user-apple"
        case .sendMedia : return "/message/send/"
        case .reply : return "/message/reply"
        }
    }
}


