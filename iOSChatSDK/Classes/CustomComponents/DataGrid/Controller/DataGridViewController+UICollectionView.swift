//
//  DataGridViewController+UICollectionView.swift
//  SQRCLE
//
//  Created by Dynasas on 06/12/23.
//

import Foundation
import UIKit
import CollectionViewPagingLayout

extension DataGridViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func setupCollection(cv : UICollectionView){
        self.collection = cv
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
        cell.parentVC = self
        cell.delegateDC = delegateDC
        cell.isHero = gridCount == .six
        cell.dataGridType = dataGridType
        cell.configureCell(data: getItemsAtPage(indexPath.row*gridCount.rawValue))
        return cell
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offSet = scrollView.contentOffset.x
//        let width = scrollView.frame.width
//        let horizontalCenter = width / 2
//        currentPage = Int(offSet + horizontalCenter) / Int(width)
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataGridType == .interest{
            if indexPath.item != 0 && !isReload{
                cell.isHidden = true
            }
        }else{
            if indexPath.item != 0 && !isReload{
                cell.isHidden = true
            }else{
                cell.isHidden = false
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        for cell in self.collection?.visibleCells ?? []{
            cell.isHidden = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.collection {
            guard let cv = collection else { return }
            var currentCellOffset = cv.contentOffset
            currentCellOffset.x += cv.frame.width / 2
            if let indexPath = cv.indexPathForItem(at: currentCellOffset) {
                cv.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
               // self.currentPage = indexPath.item
            }
        }
    }
}

