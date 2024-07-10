//
//  DataComponentView.swift
//  SQRCLE
//
//  Created by Dynasas on 30/11/23.
//

//MARK: - MODULES
import Foundation
import UIKit

//MARK: - CLASS
class DataComponentView : UIView{
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewshadow: UIView!
    @IBOutlet weak var imgView: SQRCLEImageView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet var loadView: UIView!
    @IBOutlet weak var constraintDCWidth: NSLayoutConstraint!
    @IBOutlet weak var imageReaction: UIImageView!
    @IBOutlet weak var viewWallet: UIView!
    @IBOutlet weak var viewText: UIView!
    
    @IBOutlet weak var btnMenu: UIButton!
    
    
    //MARK: - PROPERTIES
    weak var delegate: DelegateDataComponent?
    var parentVC : SQRBaseViewC?
    var reaction : DCReaction? = DCReaction.none
    var dataGridType : DataGridType = .temp
    var dataComponent : DataComponent?{
        didSet{
            addGesture()
            setup()
        }
    }
    var type : DataCollection = .dataGrid{
        didSet{
            constraintDCWidth?.constant = type == .dataGrid ? dcWidth : type.size
        }
    }
    
    var isHighlight : Bool?{
        didSet{
            if type == .dataGrid{
                imgView.layer.borderColor = /isHighlight ? UIColor.white.cgColor : Colors.border.cgColor
            }
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
        indicator?.isHidden = true
        imgView.contentMode = .scaleAspectFill
        
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("DataComponentView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }
    
    // MARK: - ACTIONS
    @IBAction func btnActionSelect(_ sender: UIButton) {
        dataComponent?.isSelected?.toggle()
        setup()
        delegate?.selectDataComponent(type: type, index: sender.tag)
    }
    
    // MARK: - FUNCTIONS
    func hideAll(){
        self.loadView.isHidden = true
    }
    
    func unhideAll(){
        self.loadView.isHidden = false
    }
    
    func addGesture(){
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(gesture:)))
        self.addGestureRecognizer(longGesture)
    }
    
    @objc func longPressed(gesture:UIGestureRecognizer) {
        if gesture.state == .ended{
            self.parentVC?.addQuickMenu(dc: dataComponent, delegate: self)
        }
    }
}


//MARK: - SETUP
extension DataComponentView{
    func setup(){
        btnMenu?.tag = /dataComponent?.index
        imageReaction?.isHidden = reaction != .viral
        
        imgView?.clipsToBounds = true
        constraintDCWidth?.constant = type == .dataGrid ? dcWidth : type.size
        imgView?.layer.cornerRadius = type == .dataGrid ? dcWidth/2 : type.size/2
        viewshadow?.layer.cornerRadius = type.size/2
        indicator.isHidden = true
        label.text = /dataComponent?.title
        
        
        
        let isWallet = /dataComponent?.subtitle != ""
        let isText = /dataComponent?.text != ""
        
        lblText?.isHidden = !isText
        lblValue?.isHidden = !isWallet
        lblSubTitle?.isHidden = !isWallet
        imgView?.isHidden = isWallet || isText
        viewWallet?.isHidden = !isWallet
        
        if isWallet{
            label?.numberOfLines = 1
            lblSubTitle?.numberOfLines = 1
            lblSubTitle?.text = /dataComponent?.subtitle
            lblValue?.text = /dataComponent?.value
            viewWallet?.layer.cornerRadius = type == .dataGrid ? dcWidth/2 : type.size/2
            viewWallet?.layer.borderColor = dataComponent?.circle?.color.cgColor
            viewWallet?.layer.borderWidth = 4.0
        }else if isText{
            lblText?.text = /dataComponent?.text
            viewText?.layer.cornerRadius = type == .dataGrid ? dcWidth/2 : type.size/2
            viewText?.layer.borderColor = /dataComponent?.isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
            viewText?.layer.borderWidth = 4.0
            //viewText?.backgroundColor = 4.0
            
        }else{
            
            label.textColor = type != .dataGrid ? (/dataComponent?.isSelected ? .white : .white.withAlphaComponent(0.4)) : UIColor.white
            
            setupImageBorder()
            setupImage()
            setupImageBackground()
        }
    }
}


extension DataComponentView{
    func setupImage(){
        switch dataGridType{
        case .local , .temp:
            if type == .dataGrid{
                imgView.image = UIImage(named: /dataComponent?.img)
            }else{
                imgView.image = /dataComponent?.isSelected ? UIImage(named: /dataComponent?.selectedImg) : UIImage(named: /dataComponent?.img)
            }
            
        case .hybrid:
            
            let isUrl = /dataComponent?.img?.contains("http")
            if isUrl{
                indicator?.isHidden = false
                indicator?.startAnimating()
                imgView?.image = UIImage(named: Placeholders.profile.rawValue)
                imgView?.imageURL = /dataComponent?.img
                guard let _ = imgView else { return }
                SQRCLEImageDownload.downloadImage(imageView: imgView, imageURL: /dataComponent?.img, placeholderImage: nil) { image in
                    if image != nil {
                        DispatchQueue.main.async {
                            self.indicator.isHidden = true
                            self.indicator.stopAnimating()
                            self.imgView.image = image
                            self.imgView.clipsToBounds = true
                            self.imgView.layer.cornerRadius = self.imgView.frame.size.width/2
                            self.label.text = ""
                        }
                    }
                }
                
            }else{
                imgView.image = UIImage(named: /dataComponent?.img)
            }
            
            
        default:
            indicator?.isHidden = false
            indicator?.startAnimating()
            imgView?.image = UIImage(named: Placeholders.profile.rawValue)
            
            imgView?.imageURL = /dataComponent?.img
            if /dataComponent?.img == "" {
                self.indicator?.isHidden = true
                self.indicator?.stopAnimating()
                return
            }
            guard let _ = imgView else { return }
            SQRCLEImageDownload.downloadImage(imageView: imgView, imageURL: /dataComponent?.img, placeholderImage: nil) { image in
                if image != nil {
                    DispatchQueue.main.async {
                        self.indicator.isHidden = true
                        self.indicator.stopAnimating()
                        self.imgView.image = image
                        
                    }
                }
            }
        }
    }
    
    func setupImageBorder(){
        
        switch dataGridType{
            
        case .local , .interest:
            imgView.layer.borderColor = UIColor.clear.cgColor
            
        case .temp:
            if type == .dataGrid{
                imgView.layer.borderColor = /isHighlight ? UIColor.white.cgColor : Colors.border.cgColor
            }
            
        case .hybrid:
            let notCreated = /self.dataComponent?.img?.contains("create")
            if !notCreated{
                self.imgView.layer.borderColor = self.dataComponent?.title?.getBorderColor()
            }else{
                imgView.layer.borderColor = UIColor.clear.cgColor
            }
            
        default:
            imgView.layer.borderColor = /isHighlight ? UIColor.white.cgColor : Colors.border.cgColor
        }
        
    }
    
    func setupImageBackground(){
        
        switch dataGridType{
            
        case .local , .temp:
            if type == .dataGrid{
                imgView.backgroundColor = /dataComponent?.isSelected ? UIColor.white.withAlphaComponent(0.2) : UIColor.black.withAlphaComponent(0.1)
            }
            
        case .interest:
            imgView.backgroundColor = /dataComponent?.isSelected ? UIColor.white.withAlphaComponent(0.2) : UIColor.black.withAlphaComponent(0.3)
            
        default:
            break
        }
        
    }
    
    func setupShadow(){
        
        switch dataGridType{
            
        case .local , .interest:
            if /dataComponent?.isSelected{
                viewshadow.layer.shadowOpacity = 0.0
                imgView.layer.shadowOpacity = 0.0
            }else{
                viewshadow.outerShadowBottom()
                imgView.outerShadowTop()
            }
            
        case .hybrid:
            viewshadow.layer.shadowOpacity = 0.0
            imgView.layer.shadowOpacity = 0.0
            
        default:
            break
        }
    }
}




extension DataComponentView : DelegateDataComponent{
    func quickMenuItem(dcIndex: Int, menuItem: QuickMenu) {
        delegate?.quickMenuItem(dcIndex: dcIndex, menuItem: menuItem)
    }
}
