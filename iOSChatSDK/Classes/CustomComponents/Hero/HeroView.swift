//
//  HeroView.swift
//  SQRCLE
//
//  Created by Dynasas on 05/12/23.
//

import UIKit


class HeroView: UIView {
    
    @IBOutlet weak var viewHeroRound: HeroRoundView!
    @IBOutlet private weak var loadView: UIView!
    
    @IBOutlet weak var viewGrid: HeroGridView!
    
    
    var heroGridtype : DataCollection = .six
    var state : HeroState = .slideshowVideo {
        didSet{
            viewHeroRound.state = state
        }
    }
    
    
    weak var delegate : DelegateDataComponent?
    var dcs = [DataComponent](){
        didSet{
            setupHeroGrid()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commitView()
    }
    
    override func awakeFromNib() {
        
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("HeroView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }
    
    func setupHeroGrid(){
        viewHeroRound.state = state
        viewGrid.heroGridtype = heroGridtype
        viewGrid.dcs = dcs
        viewGrid.delegate = self
        
    }
}


extension HeroView : DelegateDataComponent{
    func selectDataComponent(type: DataCollection, index: Int) {
        delegate?.selectDataComponent(type: type, index: index)
    }
}
