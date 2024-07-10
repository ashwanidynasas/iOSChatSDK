//
//  Transitions.swift
//  SQRCLE
//
//  Created by Dynasas on 05/12/23.
//

import Foundation
import UIKit

extension UIViewController{
    func pop(_ type : CATransitionSubtype){
        let transition = CATransition()
        transition.duration = 1.0
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    func push(_ type : CATransitionSubtype, vc : UIViewController){
        let transition = CATransition()
        transition.duration = 1.0
        transition.type = CATransitionType.moveIn
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func push(_ type : CATransitionType, vc : UIViewController){
        let transition = CATransition()
        transition.duration = 1.0
        transition.type = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func pop(_ type : CATransitionType){
        let transition = CATransition()
        transition.duration = 1.0
        transition.type = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.popToRootViewController(animated: true)
    }
}


extension UIView {
    
    func addBottomRoundedEdge(desiredCurve: CGFloat?) {
        let offset: CGFloat = self.frame.width / desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, 
                                        y: bounds.origin.y - 8,
                                        width: bounds.size.width,
                                        height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2,
                                        y: bounds.origin.y - 8,
                                        width: bounds.size.width + offset,
                                        height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        maskLayer.shadowOpacity = 0.4
        maskLayer.shadowOffset = CGSize(width: -0.1, height: 4)
        maskLayer.shadowRadius = 3
        maskLayer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 0.5
//        self.layer.borderColor = UIColor.darkGray.cgColor
        maskLayer.fillColor = UIColor.red.cgColor
        self.layer.mask = maskLayer
    }
    
    func addTopRoundedEdge(desiredCurve:CGFloat?) {
        let offset:CGFloat = self.frame.width/desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, 
                                        y: bounds.origin.y+bounds.size.height / 2,
                                        width: bounds.size.width,
                                        height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, 
                                        y: bounds.origin.y, 
                                        width: bounds.size.width + offset,
                                        height: bounds.size.height)
        
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        
        rectPath.append(ovalPath)
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func addBottomReversedRoundedEdge(desiredCurve:CGFloat?) {
        let offset:CGFloat = self.frame.width/desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x,
                                        y: bounds.origin.y-bounds.size.height / 2,
                                        width: bounds.size.width,
                                        height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2,
                                        y: bounds.origin.y,
                                        width: bounds.size.width + offset,
                                        height: bounds.size.height)
        
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        
        rectPath.append(ovalPath)
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
    
}




extension UIView {
    func addShadow(to edges: [UIRectEdge], radius: CGFloat = 4.0, opacity: Float = 0.8, color: CGColor = UIColor.black.cgColor) {

        let fromColor = color
        let toColor = UIColor.clear.cgColor
        let viewFrame = self.frame
        for edge in edges {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [fromColor, toColor]
            gradientLayer.opacity = opacity

            switch edge {
            case .top:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: radius)
            case .bottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - radius, width: viewFrame.width, height: radius)
            case .left:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: viewFrame.height)
            case .right:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.frame = CGRect(x: viewFrame.width - radius, y: 0.0, width: radius, height: viewFrame.height)
            default:
                break
            }
            self.layer.addSublayer(gradientLayer)
        }
    }

//    func removeAllShadows() {
//        if let sublayers = self.layer.sublayers, !sublayers.isEmpty {
//            for sublayer in sublayers {
//                sublayer.removeFromSuperlayer()
//            }
//        }
//    }
}


