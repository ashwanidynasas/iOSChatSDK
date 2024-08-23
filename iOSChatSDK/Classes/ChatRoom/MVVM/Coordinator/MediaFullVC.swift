//
//  MediaFullVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 09/07/24.
//

import UIKit
import AVKit
import AVFoundation

class MediaFullVC: UIViewController {
    
    @IBOutlet weak var topView: CustomTopView!
    @IBOutlet weak var fullImgView:UIImageView!
    @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var videoPlayerBackView: UIView!
    private var deleteViewModel = MessageViewModel()
    
    var currentUser: String! = ""
    var imageFetched:UIImage! = nil
    var videoFetched:URL!
    var imageSelectURL:String! = ""
    var s3MediaURL:String! = ""
    var mediaType:String! = ""
    var videoPlayerContainerView: CustomVideoPlayerContainerView!
    var player: AVPlayer?
    var eventID: String! = ""
    weak var delegate: MediaFullVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBottomView()
        setupVideoPlayerContainerView()
        setupUI()
        topView.searchButton.isHidden = true
        videoPlayerBackView.isHidden = true
        if let videoURL = imageSelectURL.modifiedString.mediaURL {
            if mediaType == "m.image" {
                self.fullImgView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: MediaFullVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
            }else{
                videoPlayerBackView.isHidden = false
                playVideo()
            }
        }
    }
    
    func setupVideoPlayerContainerView() {
        videoPlayerContainerView = CustomVideoPlayerContainerView(frame: .zero)
        videoPlayerContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.videoPlayerBackView.addSubview(videoPlayerContainerView)
        
        NSLayoutConstraint.activate([
            videoPlayerContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            videoPlayerContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            videoPlayerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            videoPlayerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
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
        let customTabBar = CustomTabBar(buttonTitles: buttonTitles, buttonImages: buttonImages, buttonColors: Colors.Circles.violet)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(customTabBar)
        customTabBar.didSelectTab = { tabIndex in
            print("Selected tab index: \(tabIndex)")
            let tag = tabIndex
            print("Button with tag \(tag) tapped")
            switch tag {
            case 0:
                print("Action for Button 1")
            case 1:
                print("Action for Button 2")
                self.redactMessage()
            case 2:
                print("Action for Button 3")
            case 3:
                print("Action for Button 4")
            default:
                break
                
            }
        }
    }
    
    private func redactMessage() {
        let roomID = UserDefaults.standard.string(forKey: "room_id")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        
        print("roomID id ----> \(roomID ?? "")")
        print("accessToken id ----> \(accessToken ?? "")")
        print("event id ----> \(eventID ?? "")")

        let request = MessageRedactRequest(
            accessToken: /accessToken,
            roomID: /roomID,
            eventID: /eventID,
            body: "spam"
        )
        
        deleteViewModel.redactMessage(request: request) { [weak self] result in
            
            switch result {
            case .success(let value):
                //print("delete response message ----->>>> \(message)")
                DispatchQueue.main.async {
                    self?.delegate?.itemDeleteFromChat("deleteItem")
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("Failed to redact message: \(error.localizedDescription)")
            }
        }
    }
    
    func playVideo() {
        guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(s3MediaURL ?? "")") else {
            print("Error: Invalid video URL")
            return
        }
        let player = AVPlayer(url: videoURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = player;
        avPlayerController.view.frame = self.videoPlayerBackView.bounds;
        self.addChild(avPlayerController)
        self.videoPlayerBackView.addSubview(avPlayerController.view);
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
}

extension MediaFullVC : DelegateTopView{
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

class CustomVideoPlayerContainerView: UIView {
    var playerViewController: AVPlayerViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerViewController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerViewController()
    }
    
    private func setupPlayerViewController() {
        playerViewController = AVPlayerViewController()
        guard let playerVC = playerViewController else {
            print("Error: PlayerViewController could not be initialized")
            return
        }
        playerVC.view.frame = self.bounds
        playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(playerVC.view)
    }
    
    var player: AVPlayer? {
        get {
            return playerViewController?.player
        }
        set {
            playerViewController?.player = newValue
        }
    }
}
