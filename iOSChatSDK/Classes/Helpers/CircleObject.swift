//
//  CircleObject.swift
//  iOSChatSDK
//
//  Created by Ashwani on 02/07/24.
//

import Foundation
 
extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2
        self.layer.masksToBounds = true
    }
    func addTopShadow(color: UIColor = .black,
                         height: CGFloat = 4,
                         opacity: Float = 0.5,
                         radius: CGFloat = 3) {
           
           // Create gradient layer
           let gradientLayer = CAGradientLayer()
           gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
           gradientLayer.colors = [color.cgColor, UIColor.clear.cgColor]
           gradientLayer.opacity = opacity
           gradientLayer.shadowRadius = radius
           gradientLayer.shadowOffset = CGSize(width: 0, height: radius)
           gradientLayer.shadowColor = color.cgColor
           gradientLayer.shadowOpacity = opacity
           
           // Add gradient layer to view's layer
           layer.addSublayer(gradientLayer)
       }
func addTopGradient(startColor: UIColor, endColor: UIColor, height: CGFloat = 40) {
  let gradientLayer = CAGradientLayer()
  gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
  gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
  gradientLayer.locations = [0.0, 1.0] // Start color at top, end color at bottom
  layer.insertSublayer(gradientLayer, at: 0) // Insert at index 0 for top position
}
}
