//
//  DataComponent.swift
//  SQRCLE
//
//  Created by Dynasas on 04/12/23.
//

import Foundation

//MARK: - PROTOCOLS
protocol DelegateDataComponent: AnyObject {
    func selectDataComponent(type : DataCollection, index: Int)
    func quickMenuItem(dcIndex: Int, menuItem: QuickMenu)
}

extension DelegateDataComponent{
    func selectDataComponent(type : DataCollection, index: Int){}
    func quickMenuItem(dcIndex: Int, menuItem: QuickMenu){}
}

class DataComponent{
    
    var img             : String?
    var selectedImg     : String?
    var title           : String?
    var index           : Int?
    var quickMenuItems  : [QuickMenu]?
    var isSelected      : Bool?
    
    var value           : String?
    var subtitle        : String?
    var circle          : Circle?
    
    var text            : String?
    
    init(img: String?, selectedImg : String?, title : String?, index : Int?, quickMenuItems  : [QuickMenu]?, isSelected : Bool?){
        self.img            = img
        self.selectedImg    = selectedImg
        self.title          = title
        self.index          = index
        self.quickMenuItems = quickMenuItems
        self.isSelected     = isSelected
    }
    
    init(title : String?, subtitle : String?, value : String?, circle : Circle){
        self.value          = value
        self.subtitle       = subtitle
        self.title          = title
        self.circle         = circle
    }
    
    init(title : String?, text : String?){
        self.text           = text
        self.title          = title
    }
    
}

enum DCReaction{
    case viral
    case none
}
