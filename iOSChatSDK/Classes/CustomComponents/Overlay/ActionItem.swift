//
//  ActionItem.swift
//  SQRCLE
//
//  Created by Dynasas on 10/05/24.
//

import UIKit

class ActionItem: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var action : ActionSheetItem?{
        didSet{
            img?.image = /action?.icon != "" ? UIImage(named: /action?.icon) : nil
            lblName?.text = /action?.title
        }
    }
}
