//
//  CustomTopView.swift
//  iOSChatSDK
//
//  Created by Ashwani on 05/07/24.
//

import UIKit

protocol CustomTopViewDelegate: AnyObject {
    func backButtonTapped()
}
class CustomTopView: UIView {

    @IBOutlet weak var backButton: UIButton!
     @IBOutlet weak var imageView: UIImageView!
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var searchButton: UIButton!
    weak var delegate: CustomTopViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    @IBAction func backActionBtn(_ sender: UIButton) {
        delegate?.backButtonTapped()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .clear
        if let viewFromXib = Bundle(for: type(of: self)).loadNibNamed("CustomTopView", owner: self, options: nil)?.first as? UIView {
            viewFromXib.frame = self.bounds
            addSubview(viewFromXib)
        } else {
            // Handle the case where the XIB file cannot be loaded
            print("Failed to load XIB file 'CustomTopView'")
        }
    }
    
    
}
