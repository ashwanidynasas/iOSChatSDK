//
//  PublishMediaVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 11/07/24.
//

import UIKit
//import IQKeyboardManager
import AVKit
import AVFoundation

class PublishMediaVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var topView: CustomTopView!
    @IBOutlet weak var fullImgView:UIImageView!
    @IBOutlet weak var sendMsgTF:UITextField!
    @IBOutlet weak var backTFView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var videoPlayerBackView: UIView!
    
    //Reply View Outlet
    @IBOutlet weak var replyUserName:UILabel!
    @IBOutlet weak var replyUserDesc:UILabel!
    @IBOutlet weak var replyUserImgView:UIImageView!
    @IBOutlet weak var replyUserImgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyBottomView:UIView!
    @IBOutlet weak var replyBottomViewHeight: NSLayoutConstraint!
    
    weak var delegate: DelegatePublishMedia?
    
    var currentUser: String!
    var imageFetched:UIImage! = nil
    var videoFetched:URL! =  nil
    var isReply:Bool!
    var username:String! = ""
    var userDesc:String! = ""
    var userImage:UIImage! = nil
    var eventID: String! = ""
    
    //    var videoPlayerView: VideoPlayerCustomView!
    var videoPlayerContainerView: VideoPlayerContainerView!
    var player: AVPlayer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isReply {
            self.replyBottomView.isHidden = false
        }else{
            self.replyBottomView.isHidden = true
        }
        self.replyUserName.text = username
        self.replyUserDesc.text = userDesc
        self.replyUserImgView.image = userImage
        
        setupUI()
        setupVideoPlayerContainerView()
        topView.searchButton.isHidden = true
        sendBtn.tintColor = Colors.Circles.violet
        self.fullImgView.image = imageFetched
        self.sendMsgTF.inputAccessoryView = UIView()
        //        IQKeyboardManager.shared().isEnabled = false
        videoPlayerBackView.isHidden = true
        
        if imageFetched == nil {
            videoPlayerBackView.isHidden = false
            playVideo()
        }
    }
    
    @IBAction func replyCancelView(_ sender: UIButton) {
        isReply = false
        self.replyBottomView.isHidden = true
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
            let player = AVPlayer(url: videoURL)
            let avPlayerController = AVPlayerViewController()
            avPlayerController.player = player;
            avPlayerController.view.frame = self.videoPlayerBackView.bounds;
            self.addChild(avPlayerController)
            self.videoPlayerBackView.addSubview(avPlayerController.view);
            
        }
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
        self.view.setGradientBackground(startColor: Colors.Circles.black, endColor: Colors.Circles.violet)
    }
    
    
    
    @IBAction func sendAction(_ sender: UIButton) {
//        let room_id = UserDefaults.standard.string(forKey: "room_id")
//        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        let room_id = UserDefaultsManager.roomID
        let accessToken = UserDefaultsManager.accessToken
        
        if imageFetched == nil {
            
            if isReply {
                let body = self.sendMsgTF.text
                let msgType = MessageType.video
                let mimeType = ChatConstants.MimeType.videoMP4
                let fileName = ChatConstants.FileName.video//"upload.mp4"
                
                let replyRequest = ReplyMediaRequest(accessToken: /accessToken, roomID: /room_id, eventID: eventID, body: /body, msgType: /msgType,mimetype: mimeType,fileName: fileName,imageFilePath: imageFetched)
                
                let mimeTypeAndFileName = ChatMediaUpload.shared.getMimeTypeAndFileName(for: /msgType)
                
                let replyRequests = SendMediaRequest(accessToken: /accessToken, roomID: /room_id, body: /body, msgType: /msgType, mediaType: mimeTypeAndFileName.mediaType,eventID: eventID,imageFilePath: imageFetched)
                
                ChatMediaUpload.shared.uploadFileChatReply(replyRequest:replyRequests,isImage: false){ result in
                    switch result {
                    case .success(let response):
                        print("Success: \(response.message)")
                        DispatchQueue.global().async {
                            DispatchQueue.main.async {
                                self.delegate?.didReceiveData(data: ChatConstants.Common.update)//"update")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
            else{
                ChatMediaUpload.shared.sendImageFromGalleryAPICall(video: videoFetched, msgType: MessageType.video, body:self.sendMsgTF.text) { result in
                    switch result {
                    case .success(let message):
                        print("Success: \(message)")
                        DispatchQueue.global().async {
                            DispatchQueue.main.async {
                                self.delegate?.didReceiveData(data: ChatConstants.Common.update)//"update")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }else{
            if isReply {
                let body = self.sendMsgTF.text
                let msgType = MessageType.image
                let mimeType = ChatConstants.MimeType.imageJPEG//"image/jpeg"
                let fileName = ChatConstants.FileName.image//"a1.jpg"
                
                let replyRequest = ReplyMediaRequest(accessToken: /accessToken, roomID: /room_id, eventID: eventID, body: /body, msgType: /msgType,mimetype: mimeType,fileName: fileName,imageFilePath: imageFetched)
                
                let mimeTypeAndFileName = ChatMediaUpload.shared.getMimeTypeAndFileName(for: /msgType)
                
                let replyRequests = SendMediaRequest(accessToken: /accessToken, roomID: /room_id, body: /body, msgType: /msgType, mediaType: mimeTypeAndFileName.mediaType,eventID: eventID,imageFilePath: imageFetched)
                
                ChatMediaUpload.shared.uploadFileChatReply(replyRequest:replyRequests,isImage: true){ result in
                    switch result {
                    case .success(let response):
                        print("Success: \(response.message)")
                        DispatchQueue.global().async {
                            DispatchQueue.main.async {
                                self.delegate?.didReceiveData(data: ChatConstants.Common.update)//"update")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }else{
                ChatMediaUpload.shared.sendImageFromGalleryAPICall(image: imageFetched, msgType: MessageType.image, body:self.sendMsgTF.text) { result in
                    switch result {
                    case .success(let message):
                        print("Success: \(message)")
                        DispatchQueue.global().async {
                            DispatchQueue.main.async {
                                self.delegate?.didReceiveData(data: ChatConstants.Common.update)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

//MARK: - CUSTOM DELEGATES
extension PublishMediaVC : DelegateTopView{
    func back() {
        delegate?.didReceiveData(data: ChatConstants.Common.back)
        self.navigationController?.popViewController(animated: true)
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
