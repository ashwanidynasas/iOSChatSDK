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
    @IBOutlet weak var bottomView:MoreView!
    @IBOutlet weak var videoPlayerBackView: UIView!
    
    //MARK: - VIEWMODEL
    private var viewModel = ChatRoomViewModel(connection: nil, accessToken: "", curreuntUser: "")
    
    //MARK: - PROPERTIES
    var imageFetched: UIImage?
    var videoFetched: URL?
    
    var selectedMessage : Messages?

    var videoPlayerContainerView: CustomVideoPlayerContainerView!
    var player: AVPlayer?
    
    weak var delegate: DelegateMediaFullVC?
    
    //MARK: - VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.backgroundColor = .clear
        bottomView?.setup(.preview)
        bottomView?.delegate = self
        setupVideoPlayerContainerView()
        setupUI()
        topView.searchButton.isHidden = true
        videoPlayerBackView.isHidden = true
        if (selectedMessage?.content?.url?.modifiedString.mediaURL) != nil {
            if /selectedMessage?.content?.msgtype == MessageType.image {
                
                if let videoURLString = selectedMessage?.content?.url?.modifiedString{
                    self.fullImgView.setImage(placeholder: ChatMessageCellConstant.ImageView.placeholderImageName, url: videoURLString)
                }
                
//                self.fullImgView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: ChatMessageCellConstant.ImageView.placeholderImageName, in: Bundle(for: MediaFullVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
            }
            else{
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
        
        viewModel.redactMessage(eventID: /selectedMessage?.eventId) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.delegate?.messageDeleted()
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                self.view.showToast(message: "Failed to redact message: \(error.localizedDescription)")
            }
        }
    }
    
    func playVideo() {
        guard let videoURL = URL(string: "\(ChatConstants.S3Media.URL)\(/(selectedMessage?.content?.S3MediaUrl ?? ""))") else {
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
        topView.titleLabel.text = /UserDefaultsHelper.getCurrentUser()
        topView.delegate = self
        self.view.setGradientBackground(startColor: Colors.Circles.black, endColor: Colors.Circles.violet)
    }
}

//MARK: - CUSTOM DELEGATES
extension MediaFullVC : DelegateTopView{
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MediaFullVC : DelegateMore{
    func selectedOption(_ item: Item) {
        switch item{
        case .save    : break
        case .delete  : redactMessage()
        case .forward : break
        case .pin     : break
        default       : break
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
