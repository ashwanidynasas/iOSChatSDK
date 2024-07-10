//
//  String.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import UIKit

enum DateFormatType {
    
    case isoYear, isoYearMonth, isoDate, isoDateTime, isoDateTimeSec, isoDateTimeMilliSec, dotNet, rss, altRSS, httpHeader, standard, localDateTimeSec, localDate, localTimeWithNoon, localPhotoSave, birthDateFormatOne, birthDateFormatTwo, messageRTetriveFormat, emailTimePreview, ddMMMYYYY, birthDateFormatThree, isoHourMinSec, hourMin
    case custom(String)
    
    var stringFormat:String {
        switch self {
        case .birthDateFormatOne: return "dd/MM/YYYY"
        case .birthDateFormatTwo: return "dd-MM-YYYY"
        case .birthDateFormatThree: return "dd MMM YYYY"
        case .ddMMMYYYY: return "ddM MMY YYYY"
        case .isoYear: return "yyyy"
        case .isoYearMonth: return "yyyy-MM"
        case .isoDate: return "yyyy-MM-dd"
        case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
        case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .dotNet: return "/Date(%d%f)/"
        case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
        case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
        case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
        case .custom(let customFormat): return customFormat
        case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
        case .localTimeWithNoon: return "hh:mm a"
        case .localDate: return "yyyy-MM-dd"
        case .localPhotoSave: return "yyyyMMddHHmmss"
        case .messageRTetriveFormat: return "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case .emailTimePreview: return "dd MMM yyyy, h:mm a"
        case .isoHourMinSec: return "yyyy-MM-dd'T'HH:mm:ss"
        case .hourMin: return "hh:mm"
        }
    }
}

extension String {
    var modifiedString: String {
        return self.replacingOccurrences(of: "mxc://", with: "http://chat.sqrcle.co/_matrix/media/v3/download/")
    }

    var mediaURL: URL? {
        return URL(string: self.modifiedString)
    }
    
    func localizedString() -> String {
        return NSLocalizedString(self, comment: self)
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined().removingBackslash()
    }
    
    func removingBackslash() -> String {
        return stringByReplacingFirstOccurrenceOfString(target: "\\", withString: "")
    }
    
    func stringByReplacingFirstOccurrenceOfString(target: String, withString replaceString: String) -> String {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func toDate(_ format: DateFormatType = .isoDate) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Int {
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension Double {
    
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension NSMutableAttributedString {
    
    var fontSize: CGFloat { return 14 }
    var boldFont: UIFont { return UIFont(.roboto, 12, .bold) }
    var normalFont: UIFont { return UIFont(.roboto, 12, .regular)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func boldWithColor(_ value:String, _ color: UIColor = Colors.Circles.violet) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,
            .foregroundColor : color,
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlinedBold(_ value:String) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .foregroundColor : Colors.Circles.violet,
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func color(_ value:String, _ color: UIColor = UIColor.white.withAlphaComponent(0.7)) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .foregroundColor : color,
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

extension Date {
    
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    func inString(_ format: DateFormatType = .emailTimePreview) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        return dateFormatter.string(from: self)
    }
    
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    func toLocalTime() -> Date {
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = self.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
}

