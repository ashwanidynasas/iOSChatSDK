//
//  DataGridCompactView.swift
//  SQRCLE
//
//  Created by Dynasas on 22/01/24.
//

import UIKit
import CollectionViewPagingLayout

class DataGridCompactView: UIView {

    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet private weak var loadView: UIView!
    
    var reaction : DCReaction?
    var gridCount : DataGrid = .six
    var dataGridType : DataGridType = .temp
    var items : [DataComponent]?
    var delegateDC : DelegateDataComponent?
    var currentPage = 0
    
    override func awakeFromNib() {
        setupCollection()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commitView()
    }
    
    private func commitView() {
        Bundle.main.loadNibNamed("DataGridCompactView", owner: self, options: nil)
        self.addSubview(self.loadView)
        ConstraintHandler.addConstraints(loadView)
    }

}

extension DataGridCompactView : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func setupCollection(){
        let layout = CollectionViewPagingLayout()
        cv.collectionViewLayout = layout
        cv.isPagingEnabled = true
        layout.numberOfVisibleItems = nil
        cv.register([DataGridView.typeName])
        cv.delegate = self
        cv.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let noOfItems = items?.count else { return 0 }
        return noOfItems/gridCount.rawValue + (noOfItems%gridCount.rawValue != 0 ?  1 : 0)
    }
    
    func getItemsAtPage(_ index: Int) -> [DataComponent] {
        
        var dcList = [DataComponent]()
        for i in 0...8{
            if /items?.count > index+i{
                print(index+i)
                if let dc = items?[index+i]{
                    dcList.append(dc)
                }
            }
        }
        
        return dcList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DataGridView.self), for: indexPath) as? DataGridView else { return UICollectionViewCell() }
        cell.addMintObservers()
        cell.delegateDC = delegateDC
        cell.isHero = true
        cell.dataGridType = dataGridType
        cell.reaction = reaction
        cell.configureCell(data: getItemsAtPage(indexPath.row*gridCount.rawValue))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.cv {
            guard let cv = cv else { return }
            var currentCellOffset = cv.contentOffset
            currentCellOffset.x += cv.frame.width / 2
            if let indexPath = cv.indexPathForItem(at: currentCellOffset) {
                cv.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
               // self.currentPage = indexPath.item
            }
        }
    }
}

