//
//  UITableView.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import UIKit

extension UITableView {
    
    func register(_ nibs: [String]?, inBundle bundle: Bundle? = nil) {
        if let nibArray = nibs {
            for nibName in nibArray {
                self.register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: nibName)
            }
        }
    }
    
    func getIndexPathFor(view: UIView) -> IndexPath? {
        let point = self.convert(view.bounds.origin, from: view)
        let indexPath = self.indexPathForRow(at: point)
        return indexPath
    }
    
    func layoutTableHeaderView() {

        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let headerWidth = headerView.bounds.size.width
        let temporaryWidthConstraint = headerView.widthAnchor.constraint(equalToConstant: headerWidth)

        headerView.addConstraint(temporaryWidthConstraint)

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame

        frame.size.height = height
        headerView.frame = frame

        self.tableHeaderView = headerView

        headerView.removeConstraint(temporaryWidthConstraint)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}

extension UICollectionView {
    
    func register(_ nibs: [String]?, inBundle bundle: Bundle? = nil) {
        if let nibArray = nibs {
            for nibName in nibArray {
                self.register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: nibName)
            }
        }
    }
    
    func getIndexPathFor(view: UIView) -> IndexPath? {
        
        let point = self.convert(view.bounds.origin, from: view)
        let indexPath = self.indexPathForItem(at: point)
        return indexPath
    }
    
    func hasPreviousItem() -> Bool {
        CGFloat(floor(self.contentOffset.x - self.bounds.size.width)) >= 0
    }
    
    func hasNextItem() -> Bool {
        CGFloat(floor(self.contentOffset.x + self.bounds.size.width)) <= self.contentSize.width - self.bounds.size.width
    }
    
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}

extension UICollectionView {
    var visibleCurrentCellIndexPath: IndexPath? {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            return indexPath
        }
        return nil
    }
}
