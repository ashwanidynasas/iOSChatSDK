//
//  CustomTopView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 05/07/24.
//

import UIKit


class CustomTopView: UIView {

    @IBOutlet weak var backButton: UIButton!
     @IBOutlet weak var imageView: UIImageView!
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var searchButton: UIButton!
    
    weak var delegate : DelegateTopView?
    var connection : Connection? {
        didSet{
            titleLabel?.text = UserDefaultsHelper.getCurrentUser()
            //titleLabel?.text = connection?.userInfo
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @IBAction func backActionBtn(_ sender: UIButton) {
        delegate?.back()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() {
        self.backgroundColor = .clear
        if let viewFromXib = Bundle(for: type(of: self)).loadNibNamed(Cell_Chat.CustomTopView, owner: self, options: nil)?.first as? UIView {
            viewFromXib.frame = self.bounds
            addSubview(viewFromXib)
        } else {
            print("Failed to load XIB file 'CustomTopView'")
        }
    }
}
