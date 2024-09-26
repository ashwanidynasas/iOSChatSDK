//
//  PublishMediaVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 11/07/24.
//

//MARK: - MODULES
import UIKit
import AVKit
import AVFoundation
import PDFKit


//MARK: - CLASS
class PublishMediaVC: UIViewController,BottomViewDelegate, DelegateReply, DelegateInput {

    // Reference to bottom view height constraint
    public var viewSendHeightConstraint: NSLayoutConstraint!
    public var viewSend: BottomView!
    var pdfView: PDFView!
    var pdfCustomView: PDFCustomView!

    //MARK: - OUTLETS
    @IBOutlet weak var topView: CustomTopView!
    @IBOutlet weak var fullImgView:UIImageView!
    @IBOutlet weak var sendMsgTF:UITextField!
    @IBOutlet weak var backTFView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var videoPlayerBackView: UIView!
    @IBOutlet weak var borderLine: UIView!
    
    //Reply View Outlet
    @IBOutlet weak var replyUserName:UILabel!
    @IBOutlet weak var replyUserDesc:UILabel!
    @IBOutlet weak var replyUserImgView:UIImageView!
    @IBOutlet weak var replyUserImgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyBottomView:UIView!
    @IBOutlet weak var replyBottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var replyLeading: NSLayoutConstraint!
    
    @IBOutlet weak var bottomViewheight: NSLayoutConstraint!
    
    //MARK: - PROPERTIES
    weak var delegate: DelegatePublishMedia?
    var imageFetched:UIImage! = nil
    var fileFetched:URL! =      nil
    var videoFetched:URL! =     nil
    var isReply:Bool!
    
    var username:String! = ""
    var userDesc:String! = ""
    var userImage:UIImage! = nil
    var eventID: String! = ""
    
    var videoPlayerContainerView: VideoPlayerContainerView!
    var player: AVPlayer?
    
    //MARK: - VIEW CYCLE
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupKeyboardObservers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyBottomView.isHidden = !isReply
        replyUserName.text = (username == /UserDefaultsHelper.getCurrentUser() ? "You" : /UserDefaultsHelper.getOtherUser())
        replyUserDesc.text = userDesc

        setupUI()
        setupVideoPlayerContainerView()
        topView.searchButton.isHidden = true
        topView.imageView.isHidden = true
        sendBtn.tintColor = Colors.Circles.violet
        fullImgView.image = imageFetched
        sendMsgTF.inputAccessoryView = UIView()
        videoPlayerBackView.isHidden = true
        
        pdfCustomView = PDFCustomView(frame: videoPlayerBackView.bounds)
        videoPlayerBackView.addSubview(pdfCustomView)
        if videoFetched != nil {
            videoPlayerBackView.isHidden = false
            playVideo()
            pdfCustomView.removeFromSuperview()
        }else if fileFetched != nil {
            videoPlayerBackView.isHidden = false
            pdfCustomView.loadPDF(from: fileFetched)
        }else{
            pdfCustomView.removeFromSuperview()
        }
    }
    //MARK: - ACTIONS
    @IBAction func replyCancelView(_ sender: UIButton) {
        isReply = false
        replyBottomView.isHidden = true
//        bottomViewheight.constant = -replyBottomView.frame.height
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        let room_id = UserDefaultsHelper.getRoomId()
        let accessToken = UserDefaultsHelper.getAccessToken()
        let body = self.sendMsgTF.text

        var msgType: String?
        var mediaURL: URL?
        var isImage: Bool = false
        
        if let image = imageFetched {
           msgType = MessageType.image
           isImage = true
        } else if let video = videoFetched {
           msgType = MessageType.video
           mediaURL = video
           isImage = false
        } else if let file = fileFetched {
           msgType = MessageType.file
           mediaURL = file
           isImage = false
        }
        
         guard let messageType = msgType else {
             print("No media to send.")
             return
         }

         let mimeTypeAndFileName = ChatMediaUpload.shared.getMimeTypeAndFileName(for: /messageType)

        if isReply {
            // Handle reply
            let replyRequest = SendMediaRequest(
                accessToken: /accessToken,
                roomID: /room_id,
                body: /body,
                msgType: messageType,
                mimetype: mimeTypeAndFileName.mimeType, fileName: mimeTypeAndFileName.fileName, mediaType: mimeTypeAndFileName.mediaType,
                eventID: eventID,
                imageFilePath: imageFetched,
                videoFilePath: mediaURL
            )
            print(replyRequest)
            // If it's an image
            ChatMediaUpload.shared.uploadFileChatReply(replyRequest: replyRequest, isImage: isImage) { result in
                switch result {
                case .success(let response):
                    print("Success: \(response.message)")
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveData(data: ChatConstants.Common.update)
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            // Handle non-reply
            ChatMediaUpload.shared.sendImageFromGalleryAPICall(image: imageFetched, video: mediaURL, msgType: messageType, body: body) { result in
                switch result {
                case .success(let message):
                    print("Success: \(message)")
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveData(data: ChatConstants.Common.update)
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
//
//        let room_id = UserDefaultsHelper.getRoomId()
//        let accessToken = UserDefaultsHelper.getAccessToken()
//
//        if imageFetched == nil {
//
//            if isReply {
//                let body = self.sendMsgTF.text
//                let msgType = MessageType.video
//                let mimeTypeAndFileName = ChatMediaUpload.shared.getMimeTypeAndFileName(for: /msgType)
//
//                let replyRequests = SendMediaRequest(accessToken: /accessToken,
//                                                     roomID: /room_id,
//                                                     body: /body,
//                                                     msgType: /msgType,
//                                                     mediaType: mimeTypeAndFileName.mediaType,
//                                                     eventID: eventID,
//                                                     imageFilePath: imageFetched)
//
//                ChatMediaUpload.shared.uploadFileChatReply(replyRequest: replyRequests,
//                                                           isImage: false ){ result in
//                    switch result {
//                    case .success(let response):
//                        print("Success: \(response.message)")
//                        DispatchQueue.global().async {
//                            DispatchQueue.main.async {
//                                self.delegate?.didReceiveData(data: ChatConstants.Common.update)//"update")
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        }
//                    case .failure(let error):
//                        DispatchQueue.main.async {
//                            print("Error: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//            else{
//                ChatMediaUpload.shared.sendImageFromGalleryAPICall(video: videoFetched, msgType: MessageType.video, body:self.sendMsgTF.text) { result in
//                    switch result {
//                    case .success(let message):
//                        print("Success: \(message)")
//                        DispatchQueue.global().async {
//                            DispatchQueue.main.async {
//                                self.delegate?.didReceiveData(data: ChatConstants.Common.update)//"update")
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        }
//                    case .failure(let error):
//                        print("Error: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }else{
//            if isReply {
//                let body = self.sendMsgTF.text
//                let msgType = MessageType.image
//                let mimeTypeAndFileName = ChatMediaUpload.shared.getMimeTypeAndFileName(for: /msgType)
//
//                let replyRequests = SendMediaRequest(accessToken: /accessToken,
//                                                     roomID: /room_id,
//                                                     body: /body,
//                                                     msgType: /msgType,
//                                                     mediaType: mimeTypeAndFileName.mediaType,
//                                                     eventID: eventID,
//                                                     imageFilePath: imageFetched)
//
//                ChatMediaUpload.shared.uploadFileChatReply(replyRequest:replyRequests,isImage: true){ result in
//                    switch result {
//                    case .success(let response):
//                        print("Success: \(response.message)")
//                        DispatchQueue.global().async {
//                            DispatchQueue.main.async {
//                                self.delegate?.didReceiveData(data: ChatConstants.Common.update)//"update")
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        }
//                    case .failure(let error):
//                        DispatchQueue.main.async {
//                            print("Error: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }else{
//                ChatMediaUpload.shared.sendImageFromGalleryAPICall(image: imageFetched, msgType: MessageType.image, body:self.sendMsgTF.text) { result in
//                    switch result {
//                    case .success(let message):
//                        print("Success: \(message)")
//                        DispatchQueue.global().async {
//                            DispatchQueue.main.async {
//                                self.delegate?.didReceiveData(data: ChatConstants.Common.update)
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        }
//                    case .failure(let error):
//                        print("Error: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
    }
    func updateBottomViewHeight(to height: CGFloat) {
        print("")
    }
    
    func hideAttach() {
        print("")

    }
    
    func sendTextMessage() {
        print("")
    }
    
    func sendAudio(audioFilename: URL) {
        print("")

    }
    
    func camera() {
        print("")

    }
    
    func attach() {
        print("")

    }
    
    func cancelReply() {
        print("")

    }
}

//MARK: - SETUP UI
extension PublishMediaVC{
    func setupUI(){
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = Colors.Circles.violet
        borderLine.layer.shadowColor = UIColor.black.cgColor
        borderLine.layer.shadowOffset = CGSize(width: 0, height: -2)
        borderLine.layer.shadowRadius = 4
        borderLine.layer.shadowOpacity = 1.0

        topView.titleLabel.isHidden = true
        topView.delegate = self
        sendMsgTF.delegate = self
        backTFView.layer.cornerRadius = 18
        backTFView.clipsToBounds = true
        sendBtn.makeCircular()
        self.view.setGradientBackground(startColor: Colors.Circles.black, endColor: Colors.Circles.violet)
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
        
        DispatchQueue.main.async {
            if self.userImage == nil {
                self.replyUserImgView.isHidden = true
                self.replyLeading.constant = -self.replyUserImgView.frame.width
            }else{
                self.replyUserImgView.isHidden = false
                self.replyUserImgView.image = self.userImage
                self.replyUserImgView.layer.cornerRadius = 21
                self.replyUserImgView.clipsToBounds = true
                self.replyLeading.constant = 8
            }
        }
    }
    
    func playVideo() {
        if  let videoURL = videoFetched{
            let player = AVPlayer(url: videoURL)
            let avPlayerController = AVPlayerViewController()
            avPlayerController.player = player
            avPlayerController.view.frame = self.videoPlayerBackView.bounds
            self.addChild(avPlayerController)
            self.videoPlayerBackView.addSubview(avPlayerController.view)
            
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

extension PublishMediaVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - VIEW
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

class PDFCustomView: UIView {

    var pdfView: PDFView!

    // Padding constants
    let topPadding: CGFloat = 0.0
    let bottomPadding: CGFloat = 0.0
    let sidePadding: CGFloat = 0.0

    // Initialize the custom view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPDFView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPDFView()
    }

    private func setupPDFView() {
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        pdfView.backgroundColor = .white
        
        self.addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: self.topAnchor, constant: topPadding),
            pdfView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomPadding),
            pdfView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    // Load the PDF document from a file URL
    func loadPDF(from url: URL) {
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
    }
}
