//
//  UserDefaultsHelper.swift
//  Dynasas
//
//  Created by Dynasas on 28/04/23.
//

import Foundation
import UIKit

enum APPSTORAGE: String {
    case userDetails
    case userId
    case userName //login
    case profilePhoto
    case userLogin
    
    case deepLinkCircle
    case deepLinkCoi
    case deepLinkPost
}

class UserDefaultsHelper {
    
    //MARK: - GENERIC
    class func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    class func set(_ value : Any?, forkey key: APPSTORAGE) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        } else {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    class func get(_ key : APPSTORAGE) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    class func removeTempCircle() {
        guard let url = getDirectoryURL("/tempCircle/") else { return }
        do{
            try FileManager.default.removeItem(at: url)
        }
        catch{
            
        }
    }
    
    class func getDirectoryURL(_ name: String) -> URL? {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "\(name)"
        return URL(fileURLWithPath: directory)
    }
}
    
//MARK: - DEFAULTS
extension UserDefaultsHelper{
    
    class func setUserId(_ value: String) {
        self.set(value, forkey: .userId)
    }
    
    class func getUserId() -> String? {
        return UserDefaultsHelper.get(.userId) as? String
    }
    
    class func setUserName(_ value: String) {
        self.set(value, forkey: .userName)
    }
    
    class func getUserName() -> String? {
        return UserDefaultsHelper.get(.userName) as? String
    }
    
    class func setUserLogin(_ value: Bool) {
        self.set(value, forkey: .userLogin)
    }
    
    class func getUserLogin() -> Bool {
        return UserDefaultsHelper.get(.userLogin) as? Bool ?? false
    }
    
    class func getProfileImage() -> String? {
        return UserDefaultsHelper.get(.profilePhoto) as? String
    }
    
    class func setProfileImage(profilePhoto : String?) {
        self.set(profilePhoto, forkey: .profilePhoto)
    }
    
//    class func setTempCircle(details : CircleDetailCircleModel) {
//        guard let url = getDirectoryURL("/tempCircle/") else { return }
//        let encoded = try? JSONEncoder().encode(details)
//        try? encoded?.write(to: url)
//    }
//    
//    class func getTempCircle() -> CircleDetailCircleModel? {
//        guard let url = getDirectoryURL("/tempCircle/"),
//              let data = try? Data(contentsOf: url) else { return nil }
//        return try? JSONDecoder().decode(CircleDetailCircleModel.self, from: data)
//    }
    
    
}

//MARK: - LOGGED IN USER
extension UserDefaultsHelper{
    
    
//    class func getUserDetail() -> UserModel? {
//        return KeychainHelper.getUserModel(userId: /UserDefaultsHelper.getUserId())
//    }
//    
//    class func setUserDetail(userModel: UserModel , userId : String){
//        return KeychainHelper.setUserModel(userModel: userModel, userId: userId)
//    }
}
    

    //MARK: - CIRCLES
extension UserDefaultsHelper{
    
//    class func setCircles(details : [CircleDetailCircleModel]) {
//        guard let url = getDirectoryURL("/circles/") else { return }
//        let encoded = try? JSONEncoder().encode(details)
//        try? encoded?.write(to: url)
//    }
//    
//    class func getCircles() -> [CircleDetailCircleModel]? {
//        guard let url = getDirectoryURL("/circles/"),
//              let data = try? Data(contentsOf: url) else { return nil }
//        return try? JSONDecoder().decode([CircleDetailCircleModel].self, from: data)
//    }
//    
//    class func getCurrentDetailedCircle() -> CircleDetailCircleModel? {
//        if let currentCircle = UserDefaultsHelper.getCurrentCircle(),
//           let detailedCircles = UserDefaultsHelper.getCircles() {
//            
//            let currentDetailedCircle = detailedCircles.filter{ $0.circleHashAddr == currentCircle.circleHash}.first
//            return currentDetailedCircle
//        }
//        return nil
//    }
    
//    class func getOtherDetailedCircles() -> [CircleDetailCircleModel]? {
//        guard let currentCircle = UserDefaultsHelper.getCurrentCircle(),
//              let detailedCircles = UserDefaultsHelper.getCircles() else { return nil }
//        let otherDetailedCircles = detailedCircles.filter{ $0.circleHashAddr != currentCircle.circleHash}
//        return otherDetailedCircles
//    }
}

//MARK: - COMMON FUNCTIONS
extension UserDefaultsHelper{
    
//    class func getCurrentColor() -> UIColor {
//        guard let userDetail = UserDefaultsHelper.getUserDetail(),
//              let circles = userDetail.circles,
//              let newIndex = circles.firstIndex(where: { $0.circleId == UserDefaultsHelper.getCurrentCircleId() }) else { return Colors.Circles.violet }
//        return circles[newIndex].circleColor?.getColor() ?? Colors.Circles.violet
//    }
//    
//    class func getCurrentBorderColor() -> UIColor {
//        guard let userDetail = UserDefaultsHelper.getUserDetail(),
//              let circles = userDetail.circles,
//              let newIndex = circles.firstIndex(where: { $0.circleId == UserDefaultsHelper.getCurrentCircleId() }) else { return Colors.Circles.violet }
//        return circles[newIndex].circleColor?.getBorderUIColor() ?? Colors.borders.violet
//    }
//    
//    class func getCurrentCircle() -> CirclesModel? {
//        if let data = getUserDetail(),
//            let circleHashAddr = data.circleHashAddr,
//           let circle = data.circles?.first(where: { $0.circleHash == circleHashAddr }) {
//            return circle
//        }
//        return nil
//    }
    
//    class func getCurrentCircleId() -> String? {
//        guard let circle = getCurrentCircle() else { return nil }
//        return circle.circleId
//    }
//    
//    class func getCircleCOIModel() -> COIModel? {
//        guard let circle = getCurrentCircle() else { return nil }
//        return circle.coi
//    }
//    
//    class func getQubitId() -> String{
//        return /getUserDetail()?.qubitId
//    }
}

//MARK: - FOR DEEP LINKING
extension UserDefaultsHelper{
    
    class func setDeepLinkCoi(_ value: String) {
        self.set(value, forkey: .deepLinkCoi)
    }
    
    class func getDeepLinkCoi() -> String? {
        return UserDefaultsHelper.get(.deepLinkCoi) as? String
    }
    
    class func setDeepLinkCircle(_ value: String) {
        self.set(value, forkey: .deepLinkCircle)
    }
    
    class func getDeepLinkCircle() -> String? {
        return UserDefaultsHelper.get(.deepLinkCircle) as? String
    }
    
    class func setDeepLinkPost(_ value: String) {
        self.set(value, forkey: .deepLinkPost)
    }
    
    class func getDeepLinkPost() -> String? {
        return UserDefaultsHelper.get(.deepLinkPost) as? String
    }
}
