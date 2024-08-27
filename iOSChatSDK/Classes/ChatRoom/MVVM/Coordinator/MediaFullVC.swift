//
//  MediaFullVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 09/07/24.
//

//MARK: - MODULES
import UIKit
import AVKit
import AVFoundation

//MARK: - CLASS
class MediaFullVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var topView: CustomTopView!
    @IBOutlet weak var fullImgView:UIImageView!
    @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var videoPlayerBackView: UIView!
    
    //MARK: - VIEWMODEL
    private var deleteViewModel = MessageViewModel()
    
    //MARK: - PROPERTIES
    var currentUser: String?
    var imageFetched: UIImage?
    var videoFetched: URL?
    var imageSelectURL :String?
    var s3MediaURL :String?
    var mediaType:String! = ""
    var videoPlayerContainerView: CustomVideoPlayerContainerView!
    var player: AVPlayer?
    var eventID: String?
    
    weak var delegate: DelegateMediaFullVC?
    
    //MARK: - VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBottomView()
        setupVideoPlayerContainerView()
        setupUI()
        topView.searchButton.isHidden = true
        videoPlayerBackView.isHidden = true
        if let videoURL = imageSelectURL?.modifiedString.mediaURL {
            if mediaType == MessageType.image {
                self.fullImgView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: MediaFullVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
            }else{
                videoPlayerBackView.isHidden = false
                playVideo()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    func setupUI(){
        topView.titleLabel.text = /currentUser
        topView.delegate = self
        self.view.setGradientBackground(startColor: UIColor.init(hex: "000000"), endColor: UIColor.init(hex: "520093"))
    }
    
    
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let tag = sender.tag
        print("Button with tag \(tag) tapped")
        switch tag {
        default:
            break
            
        }
    }
}

//MARK: - CUSTOM DELEGATES
extension MediaFullVC : DelegateTopView{
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - BOTTOM VIEW
extension MediaFullVC{
    private func setupCustomBottomView() {
        bottomView.backgroundColor = .clear
        let customTabBar = CustomTabBar(items: [.save , .delete , .forward , .pin])
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(customTabBar)
        customTabBar.didSelectTab = { tabIndex in
            switch tabIndex {
            case Item.delete.ordinal():
                self.redactMessage()
            default:
                break
            }
        }
    }
}




//MARK: - VIDEO PLAYER VIEW
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
