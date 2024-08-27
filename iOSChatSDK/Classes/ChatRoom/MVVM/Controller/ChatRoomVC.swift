//
//  ChatRoomVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

//MARK: - MODULES
import UIKit
import AVFAudio

//MARK: - CLASS
class ChatRoomVC: UIViewController, UINavigationControllerDelegate {

    //MARK: - OUTLETS
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var emojiBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var backTFView: UIView!
    @IBOutlet weak var backBottomView: UIView!
    @IBOutlet weak var bottomAudioView: UIView!

    @IBOutlet weak var chatRoomTableView:UITableView!
    @IBOutlet weak var sendMsgTF:UITextField!
    
    @IBOutlet weak var customTopView: CustomTopView!

    @IBOutlet weak var moreViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backBottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textFieldViewHeight: NSLayoutConstraint!

    @IBOutlet weak var morebottomView: UIView!
    @IBOutlet weak var audioTimeLbl: UILabel!
    
    @IBOutlet weak var replyBottomView:UIView!
    @IBOutlet weak var replyBottomViewHeight: NSLayoutConstraint!
    //Reply View Outlet
    @IBOutlet weak var replyUserName:UILabel!
    @IBOutlet weak var replyUserDesc:UILabel!
    @IBOutlet weak var replyUserImgView:UIImageView!
    @IBOutlet weak var replyViewWidthConstraint: NSLayoutConstraint!//replyUserImgView width

    //MARK: - PROPERTIES
    
    //MARK: - AVFOUNDATION PROPERTIES
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    
    //MARK: - VIEWMODEL
    let apiClient = RoomAPIClient()
    let viewModel = MessageViewModel()
//    private let replyViewModel = ChatReplyViewModel()
    
    // Constants
    let replyTextTVCell = "ReplyTextTVCell"
    var chatUserID: String!
    var currentUser: String!
    var isToggled = false
    var isReply = false
    private var isUserScrolling = false
    var imageFetched: UIImage? = nil
    var videoFetched: URL?
    var audioFilename: URL!
    var timer: Timer?
    private var fetchTimer: Timer?
    var recordingDuration: TimeInterval = 0
    private var customTabBar: CustomTabBar?
    var bottomViewHandler: BottomViewHandler?
    var eventID: String! = ""

    //MARK: - VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("currentUser   <<<----\(currentUser ?? "")")
        bottomViewHandler = BottomViewHandler(
                    replyBottomView: replyBottomView,
                    backTFView: backTFView,
                    morebottomView: morebottomView,
                    replyBottomViewHeight: replyBottomViewHeight,
                    textFieldViewHeight: textFieldViewHeight,
                    moreViewHeight: moreViewHeight,
                    backBottomViewHeight: backBottomViewHeight
                )
        moreViewHide()
        customTopView.titleLabel.text = currentUser
        customTopView.delegate = self
        backBottomView.backgroundColor = .clear
        setupUI()
        registerNib()
        createRoomCall()
        setupCustomBottomView()
//        fetchMessages()
        setupTable()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isToggled = false
        isReply = false
        startFetchingMessages()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchTimer?.invalidate()
        fetchTimer = nil
    }
    
    private func startFetchingMessages() {
        fetchMessages()
        //fetchTimer = Timer.scheduledTimer(timeInterval: 100.0, target: self, selector: #selector(fetchMessages), userInfo: nil, repeats: true)
    }
    
    
    

    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            print("Long press detected")
            self.bottomAudioView.isHidden  = false
            startRecording()
        }else if gestureRecognizer.state == .ended {
            print("Long press ended")
            self.bottomAudioView.isHidden  = true
            stopRecording()
        }
    }

    @objc func micButtonTapped() {
        print("Mic button tapped")

    }
    
    @objc func updateTimer() {
        recordingDuration += 1
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        audioTimeLbl.text = String(format: "%02d:%02d", minutes, seconds)
    }

    @objc func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        // Stop the timer
        timer?.invalidate()
        timer = nil

//        sendBtn.setTitle("Mic", for: .normal)
//        sendBtn.removeTarget(self, action: #selector(stopRecording), for: .touchUpInside)
//        sendBtn.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
    }

    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil

        if success {
            print("Recording succeeded")
//            sendImageFromGalleryAPICall(audio:audioFilename, msgType: "m.audio")
            sendAudioMedia()
        } else {
            print("Recording failed")
        }
        // Stop the timer
        timer?.invalidate()
        timer = nil
    }
    
    func sendAudioMedia(){
        ChatMediaUpload.shared.sendImageFromGalleryAPICall(audio: audioFilename, msgType: "m.audio", body:"") { result in
            switch result {
            case .success(let message):
                print("Success: \(message)")
                // Update UI or perform other actions on success
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        self.fetchMessages()
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                // Handle error or show an alert
            }
        }
    }
    
    func playRecording() {
        do {
            print("audioFilename ---->>> \(String(describing: audioFilename))")
            print(audioFilename!)
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename!)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            // Failed to play recording
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func sendMsgAction(_ sender: UIButton) {
        if sendMsgTF.text?.isEmpty == false {
            sendButtonTapped()
        }else {}
    }
    //MARK: Send_Chat_Button Action
    @objc func sendButtonTapped() {
        print("Send button tapped")
//        moreViewHide()
        let room_id = UserDefaults.standard.string(forKey: "room_id")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        if self.sendMsgTF.text == "" {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "SQRCLE", message: "Please enter the text", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        if isReply {
            
            let body = self.sendMsgTF.text
            let msgType = MessageType.text

            let replyRequest = ReplyMediaRequest(accessToken: /accessToken, roomID: /room_id, eventID: eventID, body: /body, msgType: "m.text")
            
//            let mimeTypeAndFileName = ChatMediaUpload.shared.getMimeTypeAndFileName(for: /msgType)

            let replyRequests = SendMediaRequest(accessToken: /accessToken, roomID: /room_id, body: /body, msgType: /msgType,eventID: eventID)

            ChatMediaUpload.shared.uploadFileChatReply(replyRequest:replyRequests,isImage: false){ result in
                switch result {
                case .success(let response):
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                        print("Success: \(response.message)")
                        self.bottomViewHandler?.BV_TF_Appear()
                        self.isReply = false
                        DispatchQueue.main.async {
                            self.sendMsgTF.text = ""
                            self.sendBtn.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
                            
                            self.sendBtn.removeTarget(self, action: #selector(self.sendButtonTapped), for: .touchUpInside)
                            self.sendBtn.addTarget(self, action: #selector(self.micButtonTapped), for: .touchUpInside)
                        }
                        self.fetchMessages()
                        self.scrollToBottom()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }else{
            let body = self.sendMsgTF.text
            let msgType = MessageType.text
            viewModel.sendMessage(roomID: /room_id, body: /body, msgType: msgType, accessToken: /accessToken) { [weak self] response in
                DispatchQueue.main.async {
                    if let response = response {
                        print("Response: \(response.details.response)\nEvent ID: \(response.details.chat_event_id)")
                        DispatchQueue.main.async {
                            self?.sendMsgTF.text = ""
                            self?.sendBtn.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
                            
                            self?.sendBtn.removeTarget(self, action: #selector(self?.sendButtonTapped), for: .touchUpInside)
                            self?.sendBtn.addTarget(self, action: #selector(self?.micButtonTapped), for: .touchUpInside)
                        }

                        self?.fetchMessages()
                        self?.scrollToBottom()
                    } else {
                        print("No response received")
                    }
                }
            }
        }
    }
    
    private func scrollToBottom() {
        guard !isUserScrolling else { return }
        DispatchQueue.main.async {
            if self.viewModel.messages.isEmpty {
                return
            }
            let indexPath = IndexPath(row: self.viewModel.messages.count - 1, section: 0)
            self.chatRoomTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func setupCustomBottomView() {
        morebottomView.isHidden = true
        replyBottomView.isHidden = true
        replyBottomViewHeight.constant = 0.0
        moreViewHeight.constant = 0.0
        backBottomViewHeight.constant = 74.0
        morebottomView.backgroundColor = .clear
        customTabBar = CustomTabBar(items: [.media , .camera, .location , .document , .zc])
        
        if let customTabBar = customTabBar {
            customTabBar.translatesAutoresizingMaskIntoConstraints = false
            morebottomView.addSubview(customTabBar)
            customTabBar.didSelectTab = { tabIndex in
                self.bottomMediaActionPerform(tabIndex)
            }
        }
    }
    
    func removeCustomTabBar() {
        customTabBar?.removeFromSuperview()
        customTabBar = nil
    }
    
    func bottomMediaActionPerform(_ tapIndex:Int){
        
        switch tapIndex {
        case Item.media.ordinal():
            DispatchQueue.main.async {
                self.openGallery()
                self.bottomViewHandler?.BV_TF_Appear_More_Disappear()
            }
        case Item.camera.ordinal():
            DispatchQueue.main.async {
                self.openCamera()
                self.bottomViewHandler?.BV_TF_Appear_More_Disappear()
            }
        default:
            break
        }
    }
    @objc func fetchMessages() {
//        DispatchQueue.main.async {
//            self.sendMsgTF.text = ""
//            self.sendBtn.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
//            
//            self.sendBtn.removeTarget(self, action: #selector(self.sendButtonTapped), for: .touchUpInside)
//            self.sendBtn.addTarget(self, action: #selector(self.micButtonTapped), for: .touchUpInside)
//        }

        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.chatRoomTableView.reloadData()
//                self?.scrollToBottom()
            }
        }
        let token = UserDefaults.standard.string(forKey: "access_token")
        viewModel.getMessages(accessToken: /token)
    }
    
    public func createRoomCall(){
        
        let token = UserDefaults.standard.string(forKey: "access_token")
        print("token \(token ?? "")")
        print("chatUserID \(chatUserID ?? "")")

        apiClient.createRoom(accessToken: token ?? "",
                             invitees: [chatUserID],
                             defaultChat: true) { result in
            switch result {
            case .success(let roomId):
                print("Room created successfully with ID: \(roomId)")
                let room_id = UserDefaults.standard.string(forKey: "room_id")
                print("room_id: \(room_id ?? "")")
            case .failure(let error):
                print("Failed to create room: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.chatRoomTableView.reloadData()
        }
    }
    
    @IBAction func cameraActionBtn(_ sender: Any) {
        DispatchQueue.main.async {
            self.openCamera()
            self.moreViewHide()
        }
    }
   
    @IBAction func replyCancelView(_ sender: UIButton) {
        isReply = false
        bottomViewHandler?.BV_Reply_Disappear_More_Disappear()
    }
    
    //MARK: Plus Icon Action
    @IBAction func moreActoinBtn(_ sender: Any) {
        removeCustomTabBar()
        setupCustomBottomView()
        isToggled = !isToggled
        if isToggled {
            if isReply {
                bottomViewHandler?.BV_Reply_TF_More_Appear()
            }else{
                bottomViewHandler?.BV_TF_More_Appear()
            }
        } else {
            if isReply{
                bottomViewHandler?.BV_Reply_TF_Appear()
            }else{
                bottomViewHandler?.BV_TF_Appear_More_Disappear()
            }
        }
    }
    
    func moreViewShow(){
        self.view.endEditing(true)
        isToggled = true
        morebottomView.isHidden = false
        moreViewHeight.constant = 56.0
        backBottomViewHeight.constant = 114.0
        scrollToBottom()
    }
    func moreViewHide(){
        isToggled = false
        morebottomView.isHidden = true
        moreViewHeight.constant = 0.0
        backBottomViewHeight.constant = 56.0
        scrollToBottom()
    }

    // MARK: - Publish Screen
    func gotoPublishView(){
        let storyboard = UIStoryboard(name: "MainChat", bundle: Bundle(for: ChatRoomVC.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PublishMediaVC") as? PublishMediaVC else {
            fatalError("ViewController Not Found")
        }
        viewController.currentUser = currentUser
        viewController.videoFetched = videoFetched
        viewController.imageFetched = imageFetched
        viewController.delegate = self
        viewController.isReply = isReply
        viewController.username = self.replyUserName.text
        viewController.userDesc = self.replyUserDesc.text
        viewController.userImage = self.replyUserImgView.image
        viewController.eventID = self.eventID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    // MARK: - Open Camera Function
    private func openCamera() {
      guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
        print("Camera is not available on this device")
        return
      }

      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .camera
      imagePicker.delegate = self
      present(imagePicker, animated: true)
    }

    // MARK: - Open Gallery Function
    private func openGallery() {
        // Check if the photo library is available
       if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
           let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.sourceType = .photoLibrary
           imagePickerController.allowsEditing = false
           imagePickerController.mediaTypes = ["public.image", "public.movie"] // Support both images and videos
           DispatchQueue.main.async {
               self.present(imagePickerController, animated: true, completion: nil)
           }
       } else {
           // Handle the case where the photo library is not available
           let alert = UIAlertController(title: "Error", message: "Photo Library not available.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           DispatchQueue.main.async {
               self.present(alert, animated: true, completion: nil)
           }
       }
    }

    // MARK: - UIImagePickerControllerDelegate Methods
    

    
}


extension ChatRoomVC{
    
    
}

//MARK: - FUNCTIONS
extension ChatRoomVC{
    // MARK: - Delete Message
    private func redactMessage() {
        let roomID = UserDefaults.standard.string(forKey: "room_id")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        let request = MessageRedactRequest(
            accessToken: /accessToken,
            roomID: /roomID,
            eventID: /eventID,
            body: "spam"
        )
        
        viewModel.redactMessage(request: request) { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.fetchMessages()
                }
            case .failure(let error):
                print("Failed to redact message: \(error.localizedDescription)")
            }
        }
    }
    
    func longPressedFunc(cell:UITableViewCell){
        
        if let indexPath = chatRoomTableView.indexPath(for: cell) {
            let message = viewModel.messages[indexPath.row]
            self.eventID = ""
            self.eventID = message.eventId
            removeCustomTabBar()
            bottomViewHandler?.BV_More_Appear()
            if let msgType = MessageType(rawValue: message.content?.msgtype ?? "") {
                if (msgType == .image) {
                    guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(message.content?.S3MediaUrl ?? "")") else {
                        print("Error: Invalid video URL")
                        return
                    }
                    DispatchQueue.main.async {
                        self.replyUserImgView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                        self.replyViewWidthConstraint.constant = 24.0
                        self.replyUserDesc.text = message.content?.body
                        self.replyUserName.text = message.sender
                    }
                }else if (msgType == .audio) || (msgType == .video) {
                    guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(message.content?.S3thumbnailUrl ?? "")") else {
                        print("Error: Invalid video URL")
                        return
                    }
                    DispatchQueue.main.async {
                        self.replyUserImgView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "userPlaceholder", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                        self.replyViewWidthConstraint.constant = 24.0
                        self.replyUserDesc.text = message.content?.body
                        self.replyUserName.text = message.sender
                    }
                }else{
                    DispatchQueue.main.async {
                        self.replyViewWidthConstraint.constant = 0.0
                        self.replyUserDesc.text = message.content?.body
                        self.replyUserName.text = message.sender
                    }
                }
            }
            customTabBar = CustomTabBar(items: [.copy , .delete , .forward , .reply , .cancel])
            if let customTabBar = customTabBar {
                customTabBar.translatesAutoresizingMaskIntoConstraints = false
                morebottomView.addSubview(customTabBar)
                customTabBar.didSelectTab = { tabIndex in
                    self.bottomSelectMediaActionPerform(tabIndex)
                    
                }
            }
        }
    }
    
    func previewcallfunc(cell:UITableViewCell){
        
        if let indexPath = chatRoomTableView.indexPath(for: cell) {
            let rowIndex = indexPath.row
            let message = viewModel.messages[rowIndex]
            if let msgType = viewModel.messages[rowIndex].content?.msgtype {
                print("msgType --->\(msgType)")
                if message.content?.url == nil  {
                    print("media nil...")
                    return
                }
                let storyboard = UIStoryboard(name: "MainChat", bundle: Bundle(for: ChatRoomVC.self))
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "MediaFullVC") as? MediaFullVC else {
                    fatalError("ViewController Not Found")
                }
                viewController.currentUser = currentUser
                viewController.videoFetched = videoFetched
                viewController.imageFetched = imageFetched
                viewController.imageSelectURL = message.content?.url
                viewController.s3MediaURL = message.content?.S3MediaUrl
                viewController.mediaType =  message.content?.msgtype
                viewController.eventID = message.eventId
                viewController.delegate = self
                
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    // MARK: - Bottom Media Button Methods
    func bottomSelectMediaActionPerform(_ tapIndex:Int){
        
        switch tapIndex {
        case Item.copy.ordinal():
            print("copy")
        case Item.deleteB.ordinal():
            print("delete")
            DispatchQueue.main.async {
                self.redactMessage()
                self.bottomViewHandler?.BV_TF_Appear()
                self.removeCustomTabBar()
                self.setupCustomBottomView()
            }
        case Item.forwardB.ordinal():
            print("forward")
        case Item.reply.ordinal():
            isToggled = false
            isReply = true
            bottomViewHandler?.BV_Reply_TF_Appear()
            
        case Item.cancel.ordinal():
            DispatchQueue.main.async {
                self.isReply = false
                self.bottomViewHandler?.BV_TF_Appear()
            }
        default:
            print("perform action")
        }
    }
}

//MARK: - SCROLL VIEW
extension ChatRoomVC{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isUserScrolling = false
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserScrolling = false
    }

}

//MARK: - SETUP UI
extension ChatRoomVC{
    func setButtonTintColor(button: UIButton, color: UIColor) {
        button.tintColor = color
    }
    
    func setupUI() {
        let startColor = UIColor.init(hex: "000000")
        let endColor = UIColor.init(hex: "520093")
        self.view.setGradientBackground(startColor: startColor, endColor: endColor)
        let buttons = [sendBtn, plusBtn,cameraBtn]
        for button in buttons {
            setButtonTintColor(button: button!, color: Colors.Circles.violet)
        }
        setButtonTintColor(button: emojiBtn!, color: UIColor.init(hex: "979797"))
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupTextfield()
        
        backTFView.layer.cornerRadius = 24
        backTFView.clipsToBounds = true
        sendBtn.makeCircular()
        chatRoomTableView.backgroundColor = .clear
        
        replyUserImgView.layer.cornerRadius = replyUserImgView.frame.size.width/2
        replyUserImgView.clipsToBounds = true
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 1.0
        sendBtn.addGestureRecognizer(longPressRecognizer)
        setupAudio()
    }
}
