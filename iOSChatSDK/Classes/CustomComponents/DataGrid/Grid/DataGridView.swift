//
//  DataGridView.swift
//  SQRCLE
//
//  Created by Dynasas on 06/12/23.
//


import UIKit
import CollectionViewPagingLayout

enum DataGrid : Int{
    case six  = 6
    case nine = 9
}

enum DataGridType{
    case local
    case temp
    case dynamic
    case interest
    case hybrid
}

//MARK: - CLASS
class DataGridView: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var targetView: UIStackView!
    @IBOutlet weak var viewThirdRow: UIStackView!
    @IBOutlet var viewDataComponent: [DataComponentView]!
    
    @IBOutlet weak var constraintGridTop: NSLayoutConstraint!
    //MARK: - PROPERTIES
    weak var delegateDC: DelegateDataComponent?
    var highlightedDCIndex = -1
    var parentVC : SQRBaseViewC?
    var dataGridType : DataGridType = .temp
    var reaction : DCReaction?
    var isHero : Bool = false{
        didSet{
            viewThirdRow?.isHidden = isHero
            constraintGridTop?.constant = isHero ? UIScreen.main.bounds.height * 0.04 : 0.0
        }
    }
    
    
    //MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addMintObservers(){
        removeMintObservers()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.highlightDataComponent(notification:)),
//                                               name: Notification.Name(MintNotification.moved.rawValue),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.openDataComponent(notification:)),
//                                               name: Notification.Name(MintNotification.dataComponentSelected.rawValue),
//                                               object: nil)
        
        
    }

    func removeMintObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    //MARK:- ACTIONS
    @objc func highlightDataComponent(notification: Notification) {
        if let selectedDC  = notification.userInfo?["selectedDC"] as? Int{
            print("Highlighted COI at \(selectedDC) index")
            highlightedDCIndex = selectedDC
            for (idx, dc) in viewDataComponent.enumerated() {
                dc.isHighlight = idx == selectedDC
            }
        }
    }
    
    @objc func openDataComponent(notification: Notification) {
        if highlightedDCIndex != -1{
            delegateDC?.selectDataComponent(type: .dataGrid , index: highlightedDCIndex)
        }
    }
    
    
    
    //MARK: - Configure Cell
    func configureCell(data: [DataComponent]) {
        
        for (idx, view) in viewDataComponent.enumerated() {
            if data.count > idx{
                print("\(idx) is selected - \(data[idx].isSelected ?? false)")
                view.delegate = self
                view.dataGridType = dataGridType
                view.reaction = reaction
                view.dataComponent = data[idx]
                view.parentVC = parentVC
                view.unhideAll()
            }else{
                print("\(idx) is hidden")
                view.hideAll()
            }
            
        }
    }
}

//MARK: - CUSTOM DELEGATES
extension DataGridView : DelegateDataComponent{
    
    func selectDataComponent(type: DataCollection, index: Int) {
        delegateDC?.selectDataComponent(type: type, index: index)
    }
    
    func quickMenuItem(dcIndex: Int, menuItem: QuickMenu) {
        delegateDC?.quickMenuItem(dcIndex: dcIndex, menuItem: menuItem)
    }
    
}



extension DataGridView: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.rotary)
    }
}

