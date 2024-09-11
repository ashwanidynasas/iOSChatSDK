//
//  CustomTableViewCell.swift
//  iOSChatSDK
//
//  Created by Ashwani on 26/06/24.
//

import UIKit

open class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderTextLabel:UILabel!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
