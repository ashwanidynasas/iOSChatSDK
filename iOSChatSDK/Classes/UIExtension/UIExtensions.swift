//
//  UIExtensions.swift
//  SQRCLE
//
//  Created by Dynasas on 30/11/23.
//

import Foundation
import UIKit


@IBDesignable extension UIView {
    
    @IBInspectable var isCircular: Bool {
        get { return layer.cornerRadius == frame.width/2 }
        set {
            if newValue{
                layer.cornerRadius = frame.width/2
            }

              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = newValue
        }
    }
    
//    @IBInspectable var cornerRad: CGFloat {
//        get { return layer.cornerRadius }
//        set {
//              layer.cornerRadius = newValue
//
//              // If masksToBounds is true, subviews will be
//              // clipped to the rounded corners.
//              layer.masksToBounds = (newValue > 0)
//        }
//    }
//    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
              layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            if let color = layer.borderColor{
                return UIColor(cgColor: color)
            }else{
                return .black
            }
            
        }
        set {
              layer.borderColor = newValue.cgColor
        }
    }
}




extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}


extension UIView{
    
    func show(){
        self.isHidden = false
    }
    
    func hideView(){
        self.isHidden = true
    }
}


extension UIButton{
    func underlined(title : String, fontSize : CGFloat , fontstyle : FontStyle  ){
        let attr : [NSAttributedString.Key: Any] = [
              .font: UIFont(.roboto, fontSize, fontstyle),
              .foregroundColor: UIColor.white,
              .underlineStyle: NSUnderlineStyle.single.rawValue ]
          
        let attributeString = NSMutableAttributedString(
                string: title,
                attributes: attr
             )
        self.setAttributedTitle(attributeString, for: .normal)
        
    }
}


extension UIViewController {

    var hasSafeArea: Bool {
        guard
            #available(iOS 11.0, tvOS 11.0, *)
            else {
                return false
            }
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }

}

class ButtonWithShadow: UIButton {

    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }

    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1.0
        self.layer.cornerRadius = 8.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
    }

}


extension UIView {
  func animateBorderWidth(toValue: CGFloat, duration: Double = 0.8) {
    let animation = CABasicAnimation(keyPath: "borderWidth")
    animation.fromValue = layer.borderWidth
    animation.toValue = toValue
    animation.duration = duration
    layer.add(animation, forKey: "Width")
    layer.borderWidth = toValue
  }
    
  func animateBackgroundColor(color : UIColor?){
      UIView.animate(withDuration: 0.5, delay: 0.0, options:[], animations: {
          self.backgroundColor = color ?? Colors.Circles.violet
          }, completion:nil)
  }
}



extension UIView{
    func bottomShadow(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.65).cgColor
        layer.shadowRadius = 13.5
        layer.shadowOffset = CGSize(width: 3.0, height: 9.0)
        layer.shadowOpacity = 1.0
        backgroundColor = UIColor.black.withAlphaComponent(0.01)
    }
    
    func topShadow(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.65).cgColor
        layer.shadowRadius = 13.5
        layer.shadowOffset = CGSize(width: -3.0, height: -6.0)
        layer.shadowOpacity = 1.0
        backgroundColor = UIColor.black.withAlphaComponent(0.01)
    }
}


extension UIView{
    func show(_ btns : [UIButton]){
        for btn in btns{
            btn.isHidden = false
        }
    }
    
    func hide(_ btns : [UIButton]){
        for btn in btns{
            btn.isHidden = true
        }
    }
}

/*
extension UIViewController{
    func customHeaders(fields : Fields?) -> [String : String]{
        var updatedHeaders = [String : String]()
        updatedHeaders["key"] = /fields?.key
        updatedHeaders["bucket"] = /fields?.bucket
        updatedHeaders["X-Amz-Algorithm"] = /fields?.algorithm
        updatedHeaders["X-Amz-Credential"] = /fields?.credential
        updatedHeaders["X-Amz-Date"] = /fields?.date
        updatedHeaders["X-Amz-Security-Token"] = /fields?.securityToken
        updatedHeaders["Policy"] = /fields?.policy
        updatedHeaders["X-Amz-Signature"] = /fields?.signature
        return updatedHeaders
    }
}
*/
