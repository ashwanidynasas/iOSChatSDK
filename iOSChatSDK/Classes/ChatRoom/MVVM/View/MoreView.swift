//
//  MoreView.swift
//  iOSChatSDK
//
//  Created by Dynasas on 30/08/24.
//

import UIKit
import Foundation

enum MoreType{
    case attach
    case select
    case preview
    
    var items : [Item]{
        switch self{
        case .attach  : return [.media , .camera, .location , .document , .zc]
        case .select  : return [.copy , .delete , .forward , .reply , .cancel]
        case .preview : return [.save , .delete , .forward , .pin]
        }
    }
}

protocol DelegateMore : AnyObject{
    func selectedOption(_ item : Item)
}

class MoreView: UIView {
    
    private var customTabBar: CustomTabBar?
    weak var delegate : DelegateMore?
    
    init(frame: CGRect, type: MoreType) {
        super.init(frame: frame)
        setup(type)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func setup(_ type : MoreType) {
        removeCustomTabBar()
        customTabBar = CustomTabBar(items: [.media , .camera, .location , .document , .zc])
        if let customTabBar = customTabBar {
            customTabBar.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(customTabBar)
            customTabBar.didSelectTab = { item in
                self.delegate?.selectedOption(item)
            }
        }
    }
    
    func removeCustomTabBar() {
        customTabBar?.removeFromSuperview()
        customTabBar = nil
    }
}
