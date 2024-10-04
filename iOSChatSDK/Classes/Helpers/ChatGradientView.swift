//
//  ChatGradientView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 04/10/24.
//

import Foundation
import UIKit

@IBDesignable
class ChatGradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.red {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.green {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateView()
        }
    }

    @IBInspectable var vertical: Bool = true

    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyGradient()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    func updateView() {
        self.gradientLayer.colors = [firstColor, secondColor, secondColor, firstColor].map {$0.cgColor}
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        self.gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.gradientLayer.cornerRadius = cornerRadius
    }

    func applyGradient() {
        layer.sublayers = [gradientLayer]
    }

    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
}

@IBDesignable
class MultipleColorGradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0.75 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
//        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor, topColor.cgColor]
//        self.gradientLayer.locations = [0.0, 0.5, 1.0]
        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientLayer.locations = [0.0, 1.0]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
    }
    
    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
        let fromColors = self.gradientLayer?.colors
        let toColors: [AnyObject] = [newTopColor.cgColor, newBottomColor.cgColor, newTopColor.cgColor]
        self.gradientLayer?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey:"animateGradient")
    }
}

@IBDesignable
class ThreeColorGradientView: UIView {
    
    private var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var middleColor: UIColor = .red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0.75 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        self.gradientLayer = self.layer as? CAGradientLayer
//        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor, topColor.cgColor]
//        self.gradientLayer.locations = [0.0, 0.5, 1.0]
        self.gradientLayer.colors = [topColor.cgColor, middleColor.cgColor ,bottomColor.cgColor]
        self.gradientLayer.locations = [0.0, 0.5, 1.0]
        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = 1
    }
}

@IBDesignable
class RadialGradientView: UIView {
    
    @IBInspectable var InsideColor: UIColor = UIColor.clear
    @IBInspectable var OutsideColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        let colors = [InsideColor.cgColor, OutsideColor.cgColor] as CFArray
        let endRadius = min(frame.width, frame.height)
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
}

struct GradientImage{
    static let v = "gradient_violet"
    static let i = "gradient_indigo"
    static let b = "gradient_blue"
    static let g = "gradient_green"
    static let y = "gradient_yellow"
    static let o = "gradient_orange"
    static let r = "gradient_red"
}

@IBDesignable
class GradientImageView: UIImageView {
    
    @IBInspectable var gradientImage: UIImage? =  UIImage(named: GradientImage.v) {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        //self.imageView = UIImageView
        self.image = image
        self.frame = self.bounds
    }
}
