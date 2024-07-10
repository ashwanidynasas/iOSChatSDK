//
//  Slideshow+UICollectionView.swift
//  SQRCLE
//
//  Created by Dynasas on 05/12/23.
//

import Foundation
import UIKit

extension SlideshowView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func setupCollection(){
        collectionView.register(UINib(nibName: "CoinView", bundle: nil), forCellWithReuseIdentifier: "CoinView")
        collectionView.register(UINib(nibName: "BannerView", bundle: nil), forCellWithReuseIdentifier: "BannerView")
        collectionView.register(UINib(nibName: "DataGridView", bundle: nil), forCellWithReuseIdentifier: "DataGridView")
        collectionView.register(UINib(nibName: "VideoPlayerView", bundle: nil), forCellWithReuseIdentifier: "VideoPlayerView")
        collectionView.delegate = self
        collectionView.dataSource = self
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return /items?.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if state == .slideshowVideo{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VideoPlayerView.self), for: indexPath) as? VideoPlayerView else { return UICollectionViewCell() }
            cell.videoURL = nil
            cell.videoURL = items?[indexPath.item]
            cell.loadVideo()
            return cell
        }else if state == .slideshowPhoto{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerView.self), for: indexPath) as? BannerView else { return UICollectionViewCell() }
            cell.isCOI = isCOI
            cell.img = items?[indexPath.item]
            return cell
        }else{
            if indexPath.item == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerView.self), for: indexPath) as? BannerView else { return UICollectionViewCell() }
                cell.img = items?[indexPath.item]
                return cell
            }else{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VideoPlayerView.self), for: indexPath) as? VideoPlayerView else { return UICollectionViewCell() }
                cell.videoURL = nil
                cell.videoURL = items?[indexPath.item]
                cell.loadVideo()
                return cell
            }
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offSet = scrollView.contentOffset.x
//        let width = scrollView.frame.width
//        let horizontalCenter = width / 2
//
//        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? VideoPlayerView else{ return }
        //cell.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? VideoPlayerView else{ return }
        
//        cell.loadVideo()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
    
}
