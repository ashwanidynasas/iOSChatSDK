
import Foundation
import UIKit


enum Storyboard : String {
    case common = "Common"
    case auth = "Auth"
    case home = "Home"
    case coi = "COI"
    case register = "Registration"
    case circles = "Circles"
    case wallet = "Wallet"
}

struct VC{
    static let circles = "CirclesViewController"
    static let coi = "CoiHomeViewController"
    static let home = "HomeViewController"
    static let games = "SQRGamesViewController"
    static let feed = "SQRHomeFeedViewC"
    
    static let signup     = "SignupViewController"
    static let login      = "LoginViewController"
    static let otp        = "OtpViewController"
    static let username   = "UsernameViewController"
    static let circleName = "CircleNameViewController"
    static let interests  = "InterestsViewController"
    static let language   = "LanguageViewController"
    static let comingSoon = "ComingSoonViewController"
    
    static let wallet = "WalletViewController"
    static let captcha = "CaptchaViewController"
}

class StoryBoardHelper : NSObject {
    
    class func controller<T>(_ storyBoardType: Storyboard, type : T.Type ) -> T? {
        let storyboard = UIStoryboard(name: storyBoardType.rawValue , bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
    
    class func controller(_ storyBoardType : Storyboard, identifier : String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyBoardType.rawValue , bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
