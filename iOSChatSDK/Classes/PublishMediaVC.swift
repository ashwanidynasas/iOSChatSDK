//
//  PublishMediaVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 11/07/24.
//

import UIKit
import IQKeyboardManager
import AVKit
import AVFoundation

protocol PublishMediaDelegate: AnyObject {
    func didReceiveData(data: String)
}

class PublishMediaVC: UIViewController,UITextFieldDelegate,TopViewDelegate {
    
    @IBOutlet weak var topView: CustomTopView!
    @IBOutlet weak var fullImgView:UIImageView!
    @IBOutlet weak var sendMsgTF:UITextField!
    @IBOutlet weak var backTFView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var videoPlayerBackView: UIView!

    weak var publishDelegate: PublishMediaDelegate?
    
    var currentUser: String!
    var imageFetched:UIImage!
    var videoFetched:URL!
    
//    var videoPlayerView: VideoPlayerCustomView!
    var videoPlayerContainerView: VideoPlayerContainerView!
    var player: AVPlayer?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVideoPlayerContainerView()
        topView.searchButton.isHidden = true
        sendBtn.tintColor = Colors.Circles.violet
        print("currentUser \(String(describing: currentUser))")
        print("imageFetched \(String(describing: imageFetched))")
        print("videoFetched \(String(describing: videoFetched))")
        self.fullImgView.image = imageFetched
        self.sendMsgTF.inputAccessoryView = UIView()
//        IQKeyboardManager.shared().isEnabled = false
        
        // Register for keyboard notifications
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        sendMsgTF.autocorrectionType = .no
        videoPlayerBackView.isHidden = true

        if imageFetched == nil {
            videoPlayerBackView.isHidden = false
            playVideo()
        }
    }
    func setupVideoPlayerContainerView() {
        videoPlayerContainerView = VideoPlayerContainerView(frame: self.videoPlayerBackView.bounds)
        videoPlayerContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.videoPlayerBackView.addSubview(videoPlayerContainerView)
        
        NSLayoutConstraint.activate([
            videoPlayerContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            videoPlayerContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            videoPlayerContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            videoPlayerContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

       func playVideo() {
           if  let videoURL = videoFetched{
//               player = AVPlayer(url: videoURL)
//               videoPlayerContainerView.player = player
               let player = AVPlayer(url: videoURL)
               let avPlayerController = AVPlayerViewController()
               avPlayerController.player = player;
               avPlayerController.view.frame = self.videoPlayerBackView.bounds;
               self.addChild(avPlayerController)
               self.videoPlayerBackView.addSubview(avPlayerController.view);

           }
       }
    
//    deinit {
//        // Remove observer
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        
//    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//         if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//             if self.backTFView.frame.origin.y == 0 {
//                 self.backTFView.frame.origin.y -= keyboardSize.height
//             }
//         }
//     }
//     
//     @objc func keyboardWillHide(notification: NSNotification) {
//         if self.backTFView.frame.origin.y != 0 {
//             self.backTFView.frame.origin.y = 0
//         }
//     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
     
//     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//         self.view.endEditing(true)
//     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUI(){
        topView.titleLabel.text = currentUser
        topView.delegate = self
        sendMsgTF.delegate = self
        backTFView.layer.cornerRadius = 18
        backTFView.clipsToBounds = true
        sendBtn.makeCircular()
        self.view.setGradientBackground(startColor: UIColor.init(hex: "000000"), endColor: UIColor.init(hex: "520093"))
    }
    
    func backButtonTapped() {
        publishDelegate?.didReceiveData(data: "back")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        if imageFetched == nil {
            APIManager.shared.sendImageFromGalleryAPICall(video: videoFetched, msgType: "m.video", body:self.sendMsgTF.text) { result in
                switch result {
                case .success(let message):
                    print("Success: \(message)")
                    // Update UI or perform other actions on success
                    DispatchQueue.global().async {
                        DispatchQueue.main.async {
                            self.publishDelegate?.didReceiveData(data: "update")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    // Handle error or show an alert
                }
            }
        }else{
            APIManager.shared.sendImageFromGalleryAPICall(image: imageFetched, msgType: "m.image", body:self.sendMsgTF.text) { result in
                switch result {
                case .success(let message):
                    print("Success: \(message)")
                    // Update UI or perform other actions on success
                    DispatchQueue.global().async {
                        DispatchQueue.main.async {
                            self.publishDelegate?.didReceiveData(data: "update")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    // Handle error or show an alert
                }
            }
        }
    }
    
}
class VideoPlayerContainerView: UIView {
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
        if let playerVC = playerViewController {
            playerVC.view.frame = self.bounds
            playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(playerVC.view)
        }
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
