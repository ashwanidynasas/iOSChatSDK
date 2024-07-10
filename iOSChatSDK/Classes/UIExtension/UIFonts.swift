//
//  UIFonts.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import UIKit

public enum FontName: String {
    case poppins = "Poppins",
         roboto = "Roboto"
}

public enum FontStyle: String {
    case regular = "Regular",
         extraLight = "Thin",
         bold = "Bold",
         light = "Light",
         medium = "Medium",
         black = "Black",
         extrabold = "ExtraBold",
         semibold = "SemiBold",
         ultraBold = "UltraBold"
}

public extension UIFont {
    
    convenience init(_ name: FontName, _ size: CGFloat, _ style: FontStyle) {
        let fontName = name.rawValue + "-" + style.rawValue
        self.init(name: fontName, size: size)!
    }
}
