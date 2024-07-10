//
//  HeroGridView.swift
//  SQRCLE
//
//  Created by Dynasas on 05/12/23.
//

import UIKit

enum DataCollection{
    case dataGrid
    case home
    case six
    case five
    case four
    case three
    case registration
    
    case newfour 
    case newfourChild
    
    var size : CGFloat{
        switch self{
        case .dataGrid : return 80.0
        case .home     : return 78.0
        case .six      : return 48.0
        case .five     : return 40.0
        case .four     : return 44.0
        case .registration      : return 76.0
        case .three    : return 46.0
        case .newfour , .newfourChild  : return UIScreen.main.bounds.width/4 * 0.6
        }
    }
}


class HeroGridView: UIView {

    @IBOutlet private weak var loadView: UIView!
    @IBOutlet var viewGridComponent: [UIView]!
    @IBOutlet var viewDataComponent: [DataComponentView]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var constraintProportionalHeight: NSLayoutConstraint!
    
    weak var delegate : DelegateDataComponent?
    var dataGridType : DataGridType = .temp
    
    var dcs : [DataComponent]?{
        didSet{
            setupUI()
        }
    }
    
    var heroGridtype : DataCollection = .six{
        didSet{
            //stackView.spacing = type.rawValue
            viewGridComponent?[2].isHidden = heroGridtype == .four || heroGridtype == .home || heroGridtype == .newfour || heroGridtype == .newfourChild
            viewGridComponent?[3].isHidden = heroGridtype == .four || heroGridtype == .home || heroGridtype == .newfour || heroGridtype == .newfourChild
            
            viewGridComponent?[1].isHidden = heroGridtype == .three || heroGridtype == .registration
            viewGridComponent?[4].isHidden = heroGridtype == .three || heroGridtype == .registration
            
            viewGridComponent?[3].isHidden = heroGridtype != .six
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commitView()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setupUI()
        }
        
    }
    
    override func awakeFromNib() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.chooseDataComponent(notification:)),
//                                               name: Notification.Name(MintNotification.heroMoved.rawValue),
//                                               object: nil)
    }
    
    //MARK:- ACTIONS
    @objc func chooseDataComponent(notification: Notification) {
        if heroGridtype != .home{
            return
        }
        if let selectedDC  = notification.userInfo?["selectedDC"] as? Int{
            print("Highlighted hero dc at \(selectedDC) index")
            delegate?.selectDataComponent(type: heroGridtype, index: selectedDC)
        }
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("HeroGridView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }
    
    func setupUI(){
        
        var visibleDC = [DataComponentView]()
        for (index, vw) in viewGridComponent.enumerated(){
            if !vw.isHidden{
                visibleDC.append(viewDataComponent[index])
            }
        }
        
        for (index, view) in visibleDC.enumerated(){
            
            if let dc = (dcs?.filter{$0.index == index})?.first{
                view.type = heroGridtype
                view.dataGridType = dataGridType
                view.dataComponent = dc
                view.delegate = self
//                if heroGridtype == .four || heroGridtype == .five || heroGridtype == .three || heroGridtype == .six{
//                    if dc.isSelected ?? false{
//                        view.viewshadow.layer.shadowOpacity = 0.0
//                        view.imgView.layer.shadowOpacity = 0.0
//                    }else{
//                        view.viewshadow.outerShadowBottom()
//                        view.imgView.outerShadowTop()
//                    }
//                }
            }
        }
    }
}

extension HeroGridView : DelegateDataComponent{
    func selectDataComponent(type: DataCollection, index: Int) {
        delegate?.selectDataComponent(type: type, index: index)
    }

}
