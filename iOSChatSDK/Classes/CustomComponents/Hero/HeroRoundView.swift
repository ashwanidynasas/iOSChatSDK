//
//  HeroRoundView.swift
//  SQRCLE
//
//  Created by Dynasas on 05/12/23.
//

import UIKit

class HeroRoundView: UIView {

    @IBOutlet private weak var loadView: UIView!
    @IBOutlet weak var viewSlideshow: SlideshowView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewDataGrid: DataGridCompactView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    //@IBOutlet weak var viewRound: UIView!
    
    var curve : CGFloat = 0.9{
        didSet{
            setupUI()
        }
    }
    var dcs : [DataComponent]?{
        didSet{
            if state == .dataGrid{
                viewDataGrid.reaction = isViral ? .viral : DCReaction.none
                viewDataGrid.items = dcs
                viewDataGrid.cv?.reloadData()
            }
        }
    }
    
    var isViral = false
    
    var slideShowItems = [String](){
        didSet{
            if state == .slideshowVideo || state == .slideshowPhoto || state == .hybrid{
//                viewSlideshow.state = state
//                viewSlideshow?.items = slideShowItems
                viewDataGrid.setupCollection()
            }
        }
    }
    var state : HeroState = .slideshowVideo{
        didSet{
            viewSlideshow?.isHidden = state != .slideshowVideo && state != .slideshowPhoto && state != .hybrid
            img?.isHidden = state != .banner
            imageViewIcon?.isHidden = state != .icon
            viewDataGrid?.isHidden = state != .dataGrid
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
        
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("HeroRoundView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }
    
    func setupUI(){
        self.addBottomRoundedEdge(desiredCurve: curve)
    }
}
