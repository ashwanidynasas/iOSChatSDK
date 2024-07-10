//
//  MediaFullVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 09/07/24.
//

import UIKit

class MediaFullVC: UIViewController, CustomTopViewDelegate {

    @IBOutlet weak var topView: CustomTopView!
    @IBOutlet weak var fullImgView:UIImageView!
    @IBOutlet weak var bottomView:UIView!
    
    var currentUser: String!
    var imageFetched:UIImage!
    var videoFetched:URL!
    var imageSelectURL:String!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBottomView()
        setupUI()
        print("imageFetched \(String(describing: imageFetched))")
        print("videoFetched \(String(describing: videoFetched))")
        print("imageSelectURL \(String(describing: imageSelectURL))")
        
        
        if let videoURL = imageSelectURL.modifiedString.mediaURL {
            self.fullImgView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder"), options: .transformAnimatedImage, progress: nil, completed: nil)
        }

    }
    
    private func setupCustomBottomView() {
        bottomView.backgroundColor = .clear
        let buttonImages = [
            UIImage(named: "Save", in: Bundle(for: MediaFullVC.self), compatibleWith: nil)!,
            UIImage(named: "Delete", in: Bundle(for: MediaFullVC.self), compatibleWith: nil)!,
            UIImage(named: "Forward", in: Bundle(for: MediaFullVC.self), compatibleWith: nil)!,
            UIImage(named: "Pin", in: Bundle(for: MediaFullVC.self), compatibleWith: nil)!
        ]
        let buttonTitles = ["Save", "Delete", "Forward","Pin"]
        let customTabBar = CustomTabBar(buttonTitles: buttonTitles, buttonImages: buttonImages)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(customTabBar)
        customTabBar.didSelectTab = { tabIndex in
            print("Selected tab index: \(tabIndex)")
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let tag = sender.tag
        print("Button with tag \(tag) tapped")
        switch tag {
        case 1:
            print("Action for Button 1")
        case 2:
            print("Action for Button 2")
        case 3:
            print("Action for Button 3")
        case 4:
            print("Action for Button 4")
        default:
            break
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUI(){
        
        topView.titleLabel.text = currentUser
        topView.delegate = self
        self.view.setGradientBackground(startColor: UIColor.init(hex: "000000"), endColor: UIColor.init(hex: "520093"))
    }
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
