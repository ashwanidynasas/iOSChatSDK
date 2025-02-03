//
//  UIView.swift
//  iOSChatSDK
//
//  Created by Dynasas on 20/08/24.
//

import Foundation


extension UIView {
    func setGradientBackground(startColor: UIColor?, endColor: UIColor?) {
        guard let startColor = startColor , let endColor = endColor else { return }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0] // Start color at top, end color at bottom
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Centered at top
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // Centered at bottom
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func showToast(message: String, duration: TimeInterval = 3.0) {
            let toastLabel = UILabel(frame: CGRect(x: self.center.x - 75,
                                                   y: self.frame.size.height - 50,
                                                   width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center
            toastLabel.font = UIFont.systemFont(ofSize: 14.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            toastLabel.center.x = self.center.x  // Ensures proper centering
            self.addSubview(toastLabel)
            
            UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
}


extension UITableView{
    
    func registerCells(_ cells : [AnyClass]){
        for cell in cells{
            self.register(cell, forCellReuseIdentifier: String(describing: cell.self))
        }
    }
}
