//
//  SlideshowView.swift
//  SQRCLE
//
//  Created by Dynasas on 05/12/23.
//

import UIKit

enum Slide : String{
    case featuredBanner
    case noImageCoi
}


class SlideshowView: UIView {

    @IBOutlet private weak var loadView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isCOI = false
    var items : [String]?{
        didSet{
            collectionView?.reloadData()
            pageControl.numberOfPages = /items?.count
    
        }
    }
    
    var state : HeroState = .slideshowVideo
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commitView()
        setupCollection()
        
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("SlideshowView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }
}


