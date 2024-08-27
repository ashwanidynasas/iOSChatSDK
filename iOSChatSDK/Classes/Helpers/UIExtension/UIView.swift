//
//  UIView.swift
//  iOSChatSDK
//
//  Created by Dynasas on 20/08/24.
//

import Foundation


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


extension UITableView{
    
    func registerCells(_ cells : [AnyClass]){
        for cell in cells{
            self.register(cell, forCellReuseIdentifier: String(describing: cell.self))
        }
    }
}
