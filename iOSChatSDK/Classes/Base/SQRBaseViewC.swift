//
//  SQRBaseViewC.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//
import UIKit

class SQRBaseViewC: UIViewController {
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle =  .light
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addColorObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(colorChanged), name: Notification.Name("colorChanged"), object: nil)
    }
    
    @objc func colorChanged(notification: NSNotification){
        updateColor()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.navigationController?.tabBarController != nil{
                if self.navigationController?.tabBarController?.navigationController?.view.frame.origin.y == 0 {
                    self.navigationController?.tabBarController?.navigationController?.view.frame.origin.y -= keyboardSize.height
                }
            }else{
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.navigationController?.tabBarController != nil{
            if self.navigationController?.tabBarController?.navigationController?.view.frame.origin.y != 0{
                self.navigationController?.tabBarController?.navigationController?.view.frame.origin.y = 0
            }
        }else{
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
}


extension SQRBaseViewC{
    func updateColor() {
//        let color = UserDefaultsHelper.getCurrentColor()
//        if let gradientView = self.view.subviews.first as? MultipleColorGradientView {
//            gradientView.animate(duration: 0.1,
//                                 newTopColor: .black,
//                                 newBottomColor: color)
//            
//        }
//        
//        if let navView = self.view.subviews.filter({ $0 is NavigationView}).first as? NavigationView{
//            navView.setup(vc: nil, type: .others, title: "", hasFilters: false, hasSettings: false)
//        }
    }
    
    func addImageGradientView() {
        let gradientView: GradientImageView! = GradientImageView(frame: CGRect(x: 0.0, y: 0.0,
                                                                               width: UIScreen.main.bounds.width,
                                                                               height: UIScreen.main.bounds.height))
        gradientView.gradientImage = UIImage(named: GradientImage.v)
        gradientView.backgroundColor = UIColor.black
        self.view.insertSubview(gradientView, at: 0)
    }
    
    func addOverlayView(permission : Permissions, delegate : DelegateOverlay) {
        let overlayView: OverlayView! = OverlayView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayView.permission = permission
        overlayView.delegateOverlay = delegate
        self.view.addSubview(overlayView)
    }
    
    
    
    func addQuickMenu(dc : DataComponent?, delegate : DelegateDataComponent) {
        let view: QuickMenuView! = QuickMenuView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.dataComponent = dc
        view.delegateQuick = delegate
        if let window = UIApplication.shared.keyWindow{
            view.alpha = 0.0
            window.addSubview(view)
            UIView.animate(withDuration: 0.25) { () -> Void in
                view.alpha = 1.0
            }
        }
    }
    
    
    
    func addActionSheetView(actions : [ActionSheetItem], delegate : DelegateActionSheet) {
        let view: ActionSheetView! = ActionSheetView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.actions = actions
        view.delegate = delegate
        self.view.window?.addSubview(view)
    }
    
//    func addQRView(qrCode : UIImage, delegate : DelegateQR) {
//        let view: QRView! = QRView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        view.qrImage = qrCode
//        view.delegate = delegate
//        self.view.window?.addSubview(view)
//    }
    
    
    func addGradientView() {
        let gradientView: MultipleColorGradientView! = MultipleColorGradientView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gradientView.topColor = .black
        gradientView.bottomColor = Colors.Circles.violet
        gradientView.backgroundColor = Colors.Circles.violet
        self.view.insertSubview(gradientView, at: 0)
        Threads.performTaskAfterDelay(0.1) {
            gradientView.animate(duration: 0.1,
                                 newTopColor: .black,
                                 newBottomColor: .blue)
        }
    }
    
    func addGradientView(color : String) {
        let gradientView: MultipleColorGradientView! = MultipleColorGradientView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gradientView.topColor = .black
        gradientView.bottomColor = Colors.Circles.violet
        gradientView.backgroundColor = Colors.Circles.violet
        self.view.insertSubview(gradientView, at: 0)
        Threads.performTaskAfterDelay(0.1) {
            gradientView.animate(duration: 0.1,
                                 newTopColor: .black,
                                 newBottomColor: color.getColor() )
        }
    }
    
    func addHomeGradientView() {
        let gradientView: MultipleColorGradientView! = MultipleColorGradientView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gradientView.startPointY = 0
        gradientView.endPointY = 1.0
        gradientView.topColor = .black
        gradientView.bottomColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1.0)
        gradientView.backgroundColor = Colors.home
        self.view.insertSubview(gradientView, at: 0)
        Threads.performTaskAfterDelay(0.1) {
            gradientView.animate(duration: 0.1, newTopColor: .black, newBottomColor: Colors.home)
        }
    }
    
    
    
    func addSearchGradientView() {
        let gradientView: MultipleColorGradientView! = MultipleColorGradientView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gradientView.startPointY = 0.5
        gradientView.endPointY = 1.0
        gradientView.topColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        gradientView.bottomColor = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1.0)
        gradientView.backgroundColor = Colors.search
        self.view.insertSubview(gradientView, at: 0)
        Threads.performTaskAfterDelay(0.1) {
            gradientView.animate(duration: 0.1, newTopColor: UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0), newBottomColor: UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1.0))
        }
    }
    
}



extension UIView{
    
    func addAnimatingGradientView() {
        let vw: AnimatingGradient! = AnimatingGradient(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.addSubview(vw)
    }
    
    
    func addPostGradientView() {
        let gradientView: MultipleColorGradientView! = MultipleColorGradientView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        gradientView.startPointY = 0.5
        gradientView.endPointY = 1.0
        gradientView.topColor = .clear
        gradientView.bottomColor = .black.withAlphaComponent(0.9)
        gradientView.backgroundColor = .black.withAlphaComponent(0.1)
        self.insertSubview(gradientView, at: 0)
        Threads.performTaskAfterDelay(0.1) {
            gradientView.animate(duration: 0.1, newTopColor: .clear, newBottomColor: .black.withAlphaComponent(0.9))
        }
    }
    
    func emptyCOIGradient(){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            UIColor.systemPink.cgColor,
            UIColor.blue.cgColor
        ]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        self.layer.addSublayer(gradient)
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = [
            UIColor.green.cgColor,
            UIColor.orange.cgColor
        ]
        gradientChangeAnimation.repeatCount = 1000
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
}

@IBDesignable
class AnimatingGradient : UIView , CAAnimationDelegate{
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor.init(hex: "E86FD1").cgColor
    let gradientTwo = UIColor.init(hex: "DA73CD").cgColor
    let gradientThree = UIColor.init(hex: "555AD2").cgColor
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        continuousGradientAnimation()
    }
    
    //When creating the view in IB
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        continuousGradientAnimation()
    }
    
    
    func continuousGradientAnimation(){
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        self.layer.addSublayer(gradient)
        
        animateGradient()
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            if flag {
                gradient.colors = gradientSet[currentGradient]
                animateGradient()
            }
        }
}
