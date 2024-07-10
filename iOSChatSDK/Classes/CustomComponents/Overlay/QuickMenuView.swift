//
//  QuickMenuView.swift
//  SQRCLE
//
//  Created by Dynasas on 28/05/24.
//

//MARK: - MODULES
import Foundation
import UIKit
import CircleMenu

let QUICK_MENU_COUNT = 8


//MARK: - CLASS
class QuickMenuView: UIView {

    @IBOutlet var loadView: UIView!
    @IBOutlet weak var btnMenu: CircleMenu!
    @IBOutlet weak var viewMenu: CirclePieView!
    @IBOutlet weak var imgView: SQRCLEImageView!
    
    weak var delegateQuick : DelegateDataComponent?
    var dataComponent : DataComponent?{
        didSet{
            setup()
        }
    }
    
    //MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commitView()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.contentMode = .scaleAspectFill
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("QuickMenuView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view?.tag == 123{
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.removeFromSuperview()
            }
        }
    }

}


//MARK: - SETUP
extension QuickMenuView{
    func setup(){
        
        imgView?.clipsToBounds = true
        imgView?.layer.cornerRadius = imgView.frame.size.width/2
        viewMenu?.layer.cornerRadius = (/viewMenu?.frame.size.width)/2
        setupImage()
        btnMenu.tag = /dataComponent?.index
        setupQuickMenu()
        
        Threads.performTaskAfterDelay(0.5) {
//            self.btnMenu.longpressed()
        }
    }
    
    func setupImage(){
        let isUrl = /dataComponent?.img?.contains("http")
        if isUrl{
            imgView?.image = UIImage(named: Placeholders.profile.rawValue)
            imgView?.imageURL = /dataComponent?.img
            guard let _ = imgView else { return }
            SQRCLEImageDownload.downloadImage(imageView: imgView, imageURL: /dataComponent?.img, placeholderImage: nil) { image in
                if image != nil {
                    DispatchQueue.main.async {
                        self.imgView.image = image
                        self.imgView.clipsToBounds = true
                        self.imgView.layer.cornerRadius = self.imgView.frame.size.width/2
                    }
                }
            }
            
        }else{
            imgView.image = UIImage(named: /dataComponent?.img)
        }
    }
}


// MARK: - CUSTOM DELEGATES
extension QuickMenuView : CircleMenuDelegate{
    func setupQuickMenu(){
        if self.dataComponent?.quickMenuItems == nil || (self.dataComponent?.quickMenuItems ?? [] == []){
            btnMenu?.gestureRecognizers?.removeAll()
        }else{
            guard (self.dataComponent?.quickMenuItems ?? []) != [] else { return }
            btnMenu?.buttonsCount = 8
            btnMenu?.duration = 2
            btnMenu?.distance = Float(btnMenu.frame.width/2 + 48.0 + 4.0)
            btnMenu?.delegate = self
            btnMenu?.subButtonsRadius = 24
            btnMenu?.startAngle = 22.5
            btnMenu?.endAngle = DataComponent.endAngleForCount(count: 8) + 22.5
            //btnMenu?.startAngle = DataComponent.sectorAngles(index: btnMenu.tag).0
            //btnMenu?.endAngle = DataComponent.sectorAngles(index: btnMenu.tag).1
//            btnMenu?.commonInit()
        }
        setPies(selectedIndex: nil)
        
    }
    
    func menuOpened(_ circleMenu: CircleMenu) {
        
    }
    
    func menuCollapsed(_ circleMenu: CircleMenu) {
        
    }
    
    func openClose(_ circleMenu: CircleMenu, isOpened: Bool) {
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        guard let dc = dataComponent ,
              let items = dc.quickMenuItems else { return }
        let image  = atIndex < items.count ? UIImage(named: items[atIndex].rawValue) : UIImage()
        button.backgroundColor = .clear
        button.setImage(image, for: .normal)
        
        // set highlited image
        let highlightedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        if atIndex >= /dataComponent?.quickMenuItems?.count { return }
//        setPies(selectedIndex: atIndex + 1)
//        viewMenu.draw(viewMenu.frame)
        if let selectedItem = dataComponent?.quickMenuItems?[atIndex]{
            self.removeFromSuperview()
            delegateQuick?.quickMenuItem(dcIndex: circleMenu.tag, menuItem: selectedItem)
        }
    }
}

extension QuickMenuView{
    func setPies(selectedIndex : Int?){
    
        let itemCount = /dataComponent?.quickMenuItems?.count
        let fullValue  = 500
        let emptyValue = 0
        var values     = [Int]()
        var maxSizes   = [Int]()
        var colors     = [UIColor]()
        
        for i in 1...QUICK_MENU_COUNT{
            values.append(i > itemCount ? emptyValue : fullValue)
            maxSizes.append(fullValue)
            let color = i > itemCount ? .clear : (/selectedIndex == i ? .red : Colors.home)
            print(color.description)
            colors.append(color)
        }
        
        viewMenu.setSegmentValues(
            values: values,
            totals: maxSizes,
            colors: colors)
    }
}
