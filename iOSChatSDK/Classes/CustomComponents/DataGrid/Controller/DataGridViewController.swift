//
//  DataGridViewController.swift
//  SQRCLE
//
//  Created by Dynasas on 06/12/23.
//

import UIKit
import CollectionViewPagingLayout

class DataGridViewController: SQRBaseViewC {
    
    var gridCount : DataGrid = .nine
    var dataGridType : DataGridType = .temp
    var items : [DataComponent]?
    var collection : UICollectionView?
    var delegateDC : DelegateDataComponent?
    var currentPage = 0
    
    var isReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.changePage(notification:)),
//                                               name: Notification.Name(MintNotification.changePage.rawValue),
//                                               object: nil)
    }
    
    
    
//    @objc func changePage(notification: Notification) {
//        if let speed  = notification.userInfo?["speed"] as? MintSpeed ,
//           let page = notification.userInfo?["page"] as? DataComponent.Page{
//            
//            let noOfItems = /items?.count
//            let pages = noOfItems/gridCount.rawValue + (noOfItems%gridCount.rawValue != 0 ?  1 : 0)
//            
//            if speed == .fast{
//                if page == .previous && currentPage != 0{
//                    currentPage -= 1
//                    scrollToPage(currentPage)
//                }else if page == .next && currentPage != pages - 1{
//                    currentPage += 1
//                    scrollToPage(currentPage)
//                }
//            }else if speed == .boosted{
//                if page == .first {
//                    currentPage = 0
//                    scrollToPage(currentPage)
//                }else if page == .last{
//                    currentPage = pages
//                    scrollToPage(currentPage)
//                }
//            }
//            
//        }
//    }
    
//    func scrollToPage(_ currentPage : Int){
//        let indexPath = IndexPath(row: 1, section: 0)
//        DispatchQueue.main.async { [self] in
//            collection?.isPagingEnabled = false
//            collection?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            collection?.setNeedsLayout()
//            collection?.isPagingEnabled = true
//        }        
//    }
}


