//
//  MediaPreviewVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 02/09/24.
//

import Foundation
//MARK: - MODULES
import UIKit
import AVKit
import AVFoundation

//MARK: - CLASS
class MediaPreviewVC: UIViewController {

    //MARK: - UI COMPONENTS
    private var topView: ChatTopBarView!
    private var fullImgView: UIImageView!
    private var bottomView: MoreView!
    private var videoPlayerBackView: UIView!
    private var videoPlayerContainerView: CustomVideoPlayerContainerView!

    //MARK: - VIEWMODEL
//    private var viewModel = ChatRoomViewModel(connection: nil, accessToken: "", curreuntUser: "")

    public var viewModel: ChatRoomViewModel?

    //MARK: - PROPERTIES
    var imageFetched: UIImage?
    var videoFetched: URL?
    var selectedMessage: Messages?
    var player: AVPlayer?

    weak var delegate: DelegateMediaFullVC?

    //MARK: - VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVideoPlayerContainerView()
        setupConstraints()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    //MARK: - SETUP METHODS
    private func setupUI() {
        // Initialize and configure topView
        topView = ChatTopBarView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.searchButton.isHidden = true
        topView.delegate = self
        self.view.addSubview(topView)
        
        // Initialize and configure fullImgView
        fullImgView = UIImageView()
        fullImgView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fullImgView)
        
        // Initialize and configure bottomView
        bottomView = MoreView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .clear
        bottomView.setup(.preview)
        bottomView.delegate = self
        self.view.addSubview(bottomView)
        
        // Initialize and configure videoPlayerBackView
        videoPlayerBackView = UIView()
        videoPlayerBackView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerBackView.isHidden = true
        self.view.addSubview(videoPlayerBackView)
    }

    private func setupVideoPlayerContainerView() {
        // Initialize and configure videoPlayerContainerView
        videoPlayerContainerView = CustomVideoPlayerContainerView(frame: .zero)
        videoPlayerContainerView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerBackView.addSubview(videoPlayerContainerView)

        // Constraints for videoPlayerContainerView
        NSLayoutConstraint.activate([
            videoPlayerContainerView.topAnchor.constraint(equalTo: videoPlayerBackView.topAnchor),
            videoPlayerContainerView.bottomAnchor.constraint(equalTo: videoPlayerBackView.bottomAnchor),
            videoPlayerContainerView.leadingAnchor.constraint(equalTo: videoPlayerBackView.leadingAnchor),
            videoPlayerContainerView.trailingAnchor.constraint(equalTo: videoPlayerBackView.trailingAnchor)
        ])
    }

    private func setupConstraints() {
        // Constraints for topView
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // Constraints for fullImgView
        NSLayoutConstraint.activate([
            fullImgView.topAnchor.constraint(equalTo: topView.bottomAnchor), // Place just below topView
            fullImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullImgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fullImgView.bottomAnchor.constraint(equalTo: bottomView.topAnchor) // Ends just above bottomView
        ])
        
        // Constraints for bottomView
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 70) // Adjust height as needed
        ])
        
        // Constraints for videoPlayerBackView
        NSLayoutConstraint.activate([
            videoPlayerBackView.topAnchor.constraint(equalTo: topView.bottomAnchor), // Place just below topView
            videoPlayerBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayerBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoPlayerBackView.bottomAnchor.constraint(equalTo: bottomView.topAnchor) // Ends just above bottomView
        ])
    }

    private func configureUI() {
        topView.titleLabel.text = /UserDefaultsHelper.getCurrentUser()
        self.view.setGradientBackground(startColor: Colors.Circles.black, endColor: Colors.Circles.violet)
        
        if let videoURL = selectedMessage?.content?.url?.modifiedString.mediaURL {
            if /selectedMessage?.content?.msgtype == MessageType.image {
                self.fullImgView.sd_setImage(with: videoURL, placeholderImage: UIImage(named: ChatMessageCellConstant.ImageView.placeholderImageName, in: Bundle(for: MediaPreviewVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
            } else {
                videoPlayerBackView.isHidden = false
                playVideo()
            }
        }
    }

    private func redactMessage() {
        viewModel?.redactMessage(eventID: /selectedMessage?.eventId) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.delegate?.messageDeleted()
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print("Failed to redact message: \(error.localizedDescription)")
            }
        }
    }

    private func playVideo() {
        guard let videoURL = URL(string: "\(ChatConstants.S3Media.URL)\(/(selectedMessage?.content?.S3MediaUrl ?? ""))") else {
            print("Error: Invalid video URL")
            return
        }
        let player = AVPlayer(url: videoURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = player
        avPlayerController.view.frame = self.videoPlayerBackView.bounds
        self.addChild(avPlayerController)
        self.videoPlayerBackView.addSubview(avPlayerController.view)
    }
}

//MARK: - CUSTOM DELEGATES
extension MediaPreviewVC: DelegateTopView {
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MediaPreviewVC: DelegateMore {
    func selectedOption(_ item: Item) {
        switch item {
        case .save: break
        case .delete: redactMessage()
        case .forward: break
        case .pin: break
        default: break
        }
    }
}
