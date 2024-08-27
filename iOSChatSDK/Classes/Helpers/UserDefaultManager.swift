//
//  UserDefaultManager.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/08/24.
//

import Foundation

struct UserDefaultsManager {
    
    private enum Keys {
        static let roomID = ChatConstants.API.roomID
        static let accessToken = ChatConstants.API.accessToken
    }
    static var roomID: String? {
        return UserDefaults.standard.string(forKey: Keys.roomID)
    }
    
    static var accessToken: String? {
        return UserDefaults.standard.string(forKey: Keys.accessToken)
    }
    
    static func saveRoomID(_ roomID: String) {
        UserDefaults.standard.set(roomID, forKey: Keys.roomID)
    }
    
    static func saveAccessToken(_ accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: Keys.accessToken)
    }
    static func clearUserCredentials() {
        UserDefaults.standard.removeObject(forKey: Keys.roomID)
        UserDefaults.standard.removeObject(forKey: Keys.accessToken)
    }
    
}
