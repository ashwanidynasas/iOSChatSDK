//
//  UserModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

import Foundation

public struct User: Codable {
    public let username: String
    public let password: String
    public let loginJWTtoken: String
}

public struct UserResponse: Codable {
    public let success: Bool
    public let message: String
    public let redirectUrl: String
    public let details: Details
    
    public struct Details: Codable {
        public let users: [User]
    }
}
