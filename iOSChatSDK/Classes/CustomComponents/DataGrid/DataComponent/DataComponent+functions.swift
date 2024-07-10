//
//  DataComponent+functions.swift
//  SQRCLE
//
//  Created by Dynasas on 06/12/23.
//

import Foundation
import UIKit

extension DataComponent{
    
    enum Page{
        case first
        case previous
        case next
        case last
    }
    
    enum State{
        case normal
        case Page
    }
    
    enum Sector{
        case leftDown
        case leftUp
        case centerDown
        case centerUp
        case rightDown
        case rightUp
    }
    
    
    
    class func sector(index : Int) -> Sector{
        let indexOnPage = index%9
        switch indexOnPage{
        case 0,3:
            return .leftDown
        case 6:
            return .leftUp
        case 1,4:
            return .centerDown
        case 7:
            return .centerUp
        case 2,5:
            return .rightDown
        case 8:
            return .rightUp
        default:
            return .centerDown
        }
    }
    
    
    
    class func sectorAngles(index : Int) -> (Float,Float){
        let sector = sector(index: index)
        switch sector{
        case .leftDown :
            return (90.0,180.0)
        case .leftUp :
            return (0.0,90.0)
        case .centerUp:
            return (-45.0,45.0)
        case .centerDown:
            return (135.0,225.0)
        case .rightDown:
            return (270.0,180.0)
        case .rightUp:
            return (270.0,360.0)
        }
    
    }
    
    class func endAngleForCount(count : Int) -> Float{
        switch count{
        case 0 : return 45.0
        case 1 : return 90.0
        case 2 : return 135.0
        case 3 : return 180.0
        case 4 : return 225.0
        case 5 : return 270.0
        case 6 : return 315.0
        case 7 : return 360.0
        default: return 360.0
        }
    
    }
    
    class func neighbours(index : Int) -> [Int]{
        let indexOnPage = index%9
        switch indexOnPage{
        case 0:
            return [1,3,4]
        case 1:
            return [0,2,4]
        case 2:
            return [1,4,5]
        case 3:
            return [4,6,7]
        case 4:
            return [3,5,7]
        case 5:
            return [4,7,8]
        case 6:
            return [3,4,7]
        case 7:
            return [4,6,8]
        case 8:
            return [4,5,7]
        default:
            return []
        }
    }
    
}

extension UIView{
    //.shadow(color: .black.opacity(0.65), radius: 2.5, x: 2, y: 2)
    //.shadow(color: .white.opacity(0.15), radius: 2.5, x: -2, y: -2)
    
    public func outerShadowBottom(){
        
        self.layer.cornerRadius = self.bounds.width/2
        layer.name = "outerShadowBottom"
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.65).cgColor
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 1.0
        backgroundColor = UIColor.black.withAlphaComponent(0.01)
        
    }
    
    func outerShadowTop(){
        self.layer.cornerRadius = self.bounds.width/2
        layer.name = "outerShadowTop"
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.withAlphaComponent(0.15).cgColor
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        layer.shadowOpacity = 1.0
        backgroundColor = UIColor.black.withAlphaComponent(0.01)
        
    }
    
    func innerShadowBottom(){
        self.layer.cornerRadius = self.bounds.width/2
        layer.name = "innerShadowBottom"
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.65).cgColor
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 1.0
        backgroundColor = Colors.Circles.violet
    }
    func innerShadowTop(){
        self.layer.cornerRadius = self.bounds.width/2
        layer.name = "innerShadowTop"
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.withAlphaComponent(0.15).cgColor
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        layer.shadowOpacity = 1.0
        backgroundColor = Colors.Circles.violet
    }
    
    func addShadowGradient(){
        self.layer.cornerRadius = self.bounds.width/2
        let gradientView: MultipleColorGradientView! = MultipleColorGradientView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height))
        gradientView.topColor = .black.withAlphaComponent(0.65)
        gradientView.bottomColor = .white.withAlphaComponent(0.15)
        gradientView.startPointX = 0.0
        gradientView.endPointX = 1.0
        gradientView.startPointY = 0.0
        gradientView.endPointY = 1.0
        gradientView.layer.cornerRadius = self.bounds.width/2
        gradientView.backgroundColor = .clear
        gradientView.clipsToBounds = true
        self.insertSubview(gradientView, at: 0)
    }
    
    func removeShadowGradient(){
        if let vw = self.subviews.first as? MultipleColorGradientView{
            vw.removeFromSuperview()
        }
     }
}

/* left : (0.0,180.0) center:  (-90.0,90.0) right: (360.0,180.0) */
