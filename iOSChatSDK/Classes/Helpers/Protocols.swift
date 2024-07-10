//
//  Protocols.swift
//  SQRCLE
//
//  Created by Dynasas on 20/05/24.
//

import Foundation
import UIKit

//MARK: - PROTOCOLS

protocol DelegateEdit : AnyObject{
    func reload()
}

protocol DelegateCOI : AnyObject{
    func created()
}

protocol DelegateNavigation : AnyObject{
    func showFilters(show : Bool)
    func back()
    func showFans()
}

extension DelegateNavigation{
    func showFilters(show : Bool){}
    func back(){}
    func showFans(){}
}


protocol DelegateActionSheet : AnyObject{
    func selectItem(action: ActionSheetItem)
    func close()
}


extension DelegateActionSheet{
    func close(){}
}


protocol DelegateQR : AnyObject{
    func shareQR(img : UIImage)
    func scanQR()
}

protocol DelegateFans : AnyObject{
    func coiDeleted()
}
