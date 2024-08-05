//
//  String.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import UIKit


extension String {
    var modifiedString: String {
        return self.replacingOccurrences(of: "mxc://", with: "http://chat.sqrcle.co/_matrix/media/v3/download/")
    }
    
    var mediaURL: URL? {
        return URL(string: self.modifiedString)
    }
    
}

extension UIView {
    func setGradientBackground(startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0] // Start color at top, end color at bottom
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Centered at top
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // Centered at bottom
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
