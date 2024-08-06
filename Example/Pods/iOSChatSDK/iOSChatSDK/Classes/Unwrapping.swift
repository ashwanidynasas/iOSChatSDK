//
//  Unwrapping.swift
//  MyWayy
//
//  Created by Shefali Goel on 09/05/19.
//  Copyright © 2019 MyWayy. All rights reserved.
//

import Foundation
import UIKit

//MARK:- PROTOCOL
protocol OptionalType { init() }

//MARK:- EXTENSIONS
extension String: OptionalType {}
extension Int: OptionalType {}
extension Double: OptionalType {}
extension Bool: OptionalType {}
extension Float: OptionalType {}
extension CGFloat: OptionalType {}
extension CGRect: OptionalType {}
extension UIImage: OptionalType {}
extension IndexPath: OptionalType {}
extension Int32: OptionalType {}
extension Int64: OptionalType {}
extension Set: OptionalType {}
extension NSData: OptionalType {}
extension Date: OptionalType {}
prefix operator /


//unwrapping values
prefix func /<T: OptionalType>( value: T?) -> T {
    guard let validValue = value else { return T() }
    return validValue
}


extension Int32{
    func intValue() -> Int{
        return Int(self)
    }
}

extension Int64{
    func intValue() -> Int{
        return Int(self)
    }
}

extension Int{
    func int32Value() -> Int32{
        return Int32(self)
    }
}
