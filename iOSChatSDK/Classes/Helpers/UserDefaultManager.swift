//
//  UserDefaultManager.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/08/24.
//

import Foundation

public struct UserDefaultsManager {
    
    
    static func clearUserCredentials() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.roomId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.accessToken.rawValue)
    }
    
}


open class UserDefaultsHelper {
    
    //MARK: - GENERIC
    class func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    class func set(_ value : Any?, forkey key: UserDefaultsKeys) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        } else {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    class func get(_ key : UserDefaultsKeys) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
}

extension UserDefaultsHelper{
    class func setAccessToken(_ value: String) {
        self.set(value, forkey: .accessToken)
    }
    
    class func getAccessToken() -> String? {
        return UserDefaultsHelper.get(.accessToken) as? String
    }
    
    class func setRoomId(_ value: String) {
        self.set(value, forkey: .roomId)
    }
    
    class func getRoomId() -> String? {
        return UserDefaultsHelper.get(.roomId) as? String
    }
    
    class func setCurrentUser(_ value: String) {
        self.set(value, forkey: .currentUser)
    }
    
    class func getCurrentUser() -> String? {
        return UserDefaultsHelper.get(.currentUser) as? String
    }
    
    class func setOtherUser(_ value: String) {
        self.set(value, forkey: .otherUser)
    }
    
    class func getOtherUser() -> String? {
        return UserDefaultsHelper.get(.otherUser) as? String
    }
}
enum UserDefaultsKeys: String {
    case accessToken = "access_token"
    case roomId      = "room_id"
    case currentUser = "currentUser"
    case otherUser = "otherUser"
}
