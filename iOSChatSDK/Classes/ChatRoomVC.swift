//
//  ChatRoomVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

import UIKit
import AVFAudio

class ChatRoomVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,PublishMediaDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate, MediaFullVCDelegate, MediaContentCellDelegate {
    func itemDeleteFromChat(_ didSendData: String) {
        if didSendData == "deleteItem"{
            fetchMessages()
        }
    }
    
    

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

    var bottomViewHandler: BottomViewHandler?
    
    //Reply View Outlet
    @IBOutlet weak var replyUserName:UILabel!
    @IBOutlet weak var replyUserDesc:UILabel!
    @IBOutlet weak var replyUserImgView:UIImageView!
    @IBOutlet weak var replyViewWidthConstraint: NSLayoutConstraint!//replyUserImgView width

    
    let tableCell = "CustomTableViewCell"
    let mediaTableCell = "MediaTextTVCell"
    let replyTextTVCell = "ReplyTextTVCell"

    let apiClient = RoomAPIClient()
    var chatUserID: String!
    var currentUser: String!
    var isToggled = false
    var isReply = false
    var imageFetched:UIImage! = nil
    var videoFetched:URL!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    var audioFilename: URL!
    var timer: Timer?
    var recordingDuration: TimeInterval = 0

    private var customTabBar: CustomTabBar?
    private var deleteViewModel = DeleteMessageViewModel()
    var eventID: String! = ""

    private let sendMsgModel = SenderViewModel()
    private let viewModel = MessageViewModel()
    private let mediaViewModel = ChatMediaViewModel()
    private let replyViewModel = ChatReplyViewModel()

    func setButtonTintColor(button: UIButton, color: UIColor) {
        button.tintColor = color
    }
    
    private enum MessageType: String {
        case audio = "m.audio"
        case video = "m.video"
        case image = "m.image"
        case text = "m.text"

    }

    func setupAudio(){
        audioTimeLbl.text = "00:00"

        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Microphone access granted")
                    } else {
                        print("Failed to gain microphone access")
                    }
                }
            }
        } catch {
            print("Failed to set up audio session")
        }
    }
    
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
        fetchMessages()
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        chatRoomTableView.register(MediaContentCell.self, forCellReuseIdentifier: "MediaContentCell")
        chatRoomTableView.register(ReplyTextCell.self, forCellReuseIdentifier: "ReplyTextCell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isToggled = false
        isReply = false
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
        sendMsgTF.inputAccessoryView = UIView()
        sendMsgTF.delegate = self
        sendMsgTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sendMsgTF.addTarget(self, action: #selector(textFieldTapped(_:)), for: .touchDown)

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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func registerNib() {
        let nib = UINib(nibName: tableCell, bundle: Bundle(for: CustomTableViewCell.self))
        chatRoomTableView.register(nib, forCellReuseIdentifier: "customTableViewCell")
        chatRoomTableView.rowHeight = UITableView.automaticDimension
        chatRoomTableView.estimatedRowHeight = 100
        let medianib = UINib(nibName: mediaTableCell, bundle: Bundle(for: MediaTextTVCell.self))
        chatRoomTableView.register(medianib, forCellReuseIdentifier: "mediaTextTVCell")
        
    }
    @objc func textFieldTapped(_ textField:UITextField) {
//        moreViewHide()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.bottomAudioView.isHidden  = true

        if textField.text?.isEmpty == false {
        DispatchQueue.main.async {
            self.sendBtn.setImage(UIImage(named: "sendIcon", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
        }
            sendBtn.removeTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
            sendBtn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        } else {
            DispatchQueue.main.async {
                self.sendBtn.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
            }
            sendBtn.removeTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
            sendBtn.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
        }
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
    func startRecording() {
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
//            sendBtn.setTitle("Stop", for: .normal)
//            sendBtn.removeTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
//            sendBtn.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
            
            // Start the timer
            recordingDuration = 0
            audioTimeLbl.text = "00:00"
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

        } catch {
            // Failed to start recording
            finishRecording(success: false)
        }
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
        APIManager.shared.sendImageFromGalleryAPICall(audio: audioFilename, msgType: "m.audio", body:"") { result in
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
    // AVAudioRecorderDelegate method
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
      finishRecording(success: flag)
  }
  
  // AVAudioPlayerDelegate methods (optional)
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
      // Handle playback finished
  }

  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
      // Handle playback error
      print("Audio playback error: \(String(describing: error?.localizedDescription))")
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
            let msgType = "m.text"

            replyViewModel.uploadFileChatReply(accessToken: /accessToken, roomID: /room_id, eventID: eventID, body: /body, msgType: msgType){ result in
                switch result {
                case .success(let response):
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                        print("Success: \(response.message)")
                        self.bottomViewHandler?.BV_TF_Appear()
                        self.isReply = false
                        self.fetchMessages()

                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }else{
            let body = self.sendMsgTF.text
            let msgType = "m.text"
            sendMsgModel.sendMessage(roomID: /room_id, body: /body, msgType: msgType, accessToken: /accessToken) { [weak self] response in
                DispatchQueue.main.async {
                    if let response = response {
    //                    print("Response: \(response.details.response)\nEvent ID: \(response.details.chat_event_id)")
                        self?.fetchMessages()
                    } else {
                        print("No response received")
                    }
                }
            }
        }
        
    }
    
    private func scrollToBottom() {
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
        let buttonImages = [
            UIImage(named: "Media", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
            UIImage(named: "MoreCamera", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
            UIImage(named: "Location", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
            UIImage(named: "Document", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
            UIImage(named: "ZC", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!
        ]
        let buttonTitles = ["Media", "Camera", "Location","Document","Send ZC"]
        customTabBar = CustomTabBar(buttonTitles: buttonTitles, buttonImages: buttonImages, buttonColors: UIColor.white)
        
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
        case 0:
            print("Media")
            DispatchQueue.main.async {
                self.openGallery()
                self.bottomViewHandler?.BV_TF_Appear_More_Disappear()
            }
        case 1:
            print("Camera")
            DispatchQueue.main.async {
                self.openCamera()
                self.bottomViewHandler?.BV_TF_Appear_More_Disappear()
            }
        case 2:
            print("Location")
        case 3:
            print("Document")
        case 4:
            print("Send ZC")
        default:
            print("perform action")
        }
    }
    private func fetchMessages() {
        
        viewModel.onUpdate = { [weak self] in
            self?.chatRoomTableView.reloadData()
            self?.scrollToBottom()
            self?.sendMsgTF.text = ""
            DispatchQueue.main.async {
                self?.sendBtn.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
            }
            self?.sendBtn.removeTarget(self, action: #selector(self?.sendButtonTapped), for: .touchUpInside)
            self?.sendBtn.addTarget(self, action: #selector(self?.micButtonTapped), for: .touchUpInside)

        }
        let token = UserDefaults.standard.string(forKey: "access_token")
        print("access_token \(/token)")

        viewModel.fetchMessages(accessToken: "\(token ?? "")")
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
        viewController.publishDelegate = self
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
           self.present(imagePickerController, animated: true, completion: nil)
       } else {
           // Handle the case where the photo library is not available
           let alert = UIAlertController(title: "Error", message: "Photo Library not available.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    }

    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == "public.image" {
                if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                    print("Selected image: \(selectedImage)")
                    imageFetched = selectedImage
                    gotoPublishView()
                }
            } else if mediaType == "public.movie" {
                if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//                    print("Selected video URL: \(videoURL)")
                    videoFetched = videoURL
                    gotoPublishView()
                }
            }
        }
        
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func didReceiveData(data: String) {
        if data == "update"{
            fetchMessages()
        }else{
            print("return from detail screen")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }

    
}

extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource,MediaTextCellDelegate,ChatMessageCellDelegate {
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        //Reply Template
        if let inReplyTo = message.content?.relatesTo?.inReplyTo {
            //            if let msgType = MessageType(rawValue: inReplyTo.content?.msgtype ?? "") {
            //                if (msgType == .image) || (msgType == .audio) || (msgType == .video) {
            //
            //                }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTextCell", for: indexPath) as! ReplyTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.selectionStyle = .none // Disable cell selection
            return cell
        }

        
        // Media Only
        if let msgType = MessageType(rawValue: message.content?.msgtype ?? "") {
            if (msgType == .image) || (msgType == .audio) || (msgType == .video) {
                if message.content?.body == "" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MediaContentCell", for: indexPath) as! MediaContentCell
                    // Configure the cell
                    cell.mediaConfigure(with: message, currentUser: currentUser)
                    cell.playButton.tag = indexPath.row
                    cell.delegate = self  // Set the delegate
                    cell.selectionStyle = .none // Disable cell selection
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "mediaTextTVCell", for: indexPath) as! MediaTextTVCell
                    // Configure the cell
                    cell.mediaConfigure(with: message, currentUser: currentUser)
                    cell.playButton.tag = indexPath.row
                    cell.delegate = self  // Set the delegate
                    cell.selectionStyle = .none // Disable cell selection
                    return cell
                }
                

            } else if (msgType == .text) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
                cell.configure(with: message, currentUser: currentUser)
                cell.overlayButton.tag = indexPath.row
                cell.delegate = self  // Set the delegate
                cell.selectionStyle = .none // Disable cell selection
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let message = viewModel.messages[indexPath.row]
        if let msgType = MessageType(rawValue: message.content?.msgtype ?? "") {
            if (msgType == .image) || (msgType == .audio) || (msgType == .video) {
                if message.content?.body == "" {
                    return 200
                }
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
    
    // MARK: - ChatMessageCellDelegate Methods
    func didLongPressPlayButton(in cell: ChatMessageCell) {
        print("long pressed")
        
            if let indexPath = chatRoomTableView.indexPath(for: cell) {
                let message = viewModel.messages[indexPath.row]
                // Handle long press here
                print("ChatMessageCell pressed")
                self.eventID = ""
                self.eventID = message.eventId
                removeCustomTabBar()
                
                bottomViewHandler?.BV_More_Appear()
                
                guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(message.content?.S3thumbnailUrl ?? "")") else {
                    print("Error: Invalid video URL")
                    return
                }
                DispatchQueue.main.async {
                    self.replyViewWidthConstraint.constant = 0.0
                    self.replyUserDesc.text = message.content?.body
                    self.replyUserName.text = message.sender
                }

                let buttonImages = [
                    UIImage(named: "copy", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                    UIImage(named: "deleteB", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                    UIImage(named: "forwardB", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                    UIImage(named: "reply", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                    UIImage(named: "cancel", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!
                ]
                let buttonTitles = ["Copy", "Delete", "Forward","Reply","Cancel"]
                customTabBar = CustomTabBar(buttonTitles: buttonTitles, buttonImages: buttonImages, buttonColors: UIColor.white)
                if let customTabBar = customTabBar {
                    customTabBar.translatesAutoresizingMaskIntoConstraints = false
                    morebottomView.addSubview(customTabBar)
                    customTabBar.didSelectTab = { tabIndex in
                        self.bottomSelectMediaActionPerform(tabIndex)
                        
                    }
                }
            }
    }
    
    
    // MARK: - MediaTextTVCellDelegate Methods
    func didTapPlayButton(in cell: MediaTextTVCell) {
        
            if let indexPath = chatRoomTableView.indexPath(for: cell) {
    //            let message = viewModel.messages[indexPath.row]
                // Handle button tap here
                print("Play button tapped for message:")
                let rowIndex = indexPath.row
                let message = viewModel.messages[rowIndex]

                print("Tap button was tapped on row \(rowIndex)!")
                if let msgType = viewModel.messages[rowIndex].content?.msgtype {
        //            if msgType == "m.audio" {
        ////                audioFilename = audioURL
        ////                playRecording()
        //            }else{
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
        //            }
                }
            }
    }
    
    func didLongPressPlayButton(in cell: MediaTextTVCell) {
        
            if let indexPath = chatRoomTableView.indexPath(for: cell) {
                let message = viewModel.messages[indexPath.row]
                // Handle long press here
                print("Play button long pressed for message: MediaTextTVCell")
                self.eventID = ""
                self.eventID = message.eventId
                removeCustomTabBar()
                
                bottomViewHandler?.BV_More_Appear()
                
                guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(message.content?.S3thumbnailUrl ?? "")") else {
                    print("Error: Invalid video URL")
                    return
                }
                DispatchQueue.main.async {
                    self.replyUserImgView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "audioholder", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                    self.replyViewWidthConstraint.constant = 24.0
                    self.replyUserDesc.text = message.content?.body
                    self.replyUserName.text = message.sender
                }
                let buttonImages = [
                    UIImage(named: "copy", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                    UIImage(named: "deleteB", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                    UIImage(named: "forwardB", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                    UIImage(named: "reply", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                    UIImage(named: "cancel", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!
                ]
                let buttonTitles = ["Copy", "Delete", "Forward","Reply","Cancel"]
                customTabBar = CustomTabBar(buttonTitles: buttonTitles, buttonImages: buttonImages, buttonColors: UIColor.white)
                if let customTabBar = customTabBar {
                    customTabBar.translatesAutoresizingMaskIntoConstraints = false
                    morebottomView.addSubview(customTabBar)
                    customTabBar.didSelectTab = { tabIndex in
                        self.bottomSelectMediaActionPerform(tabIndex)
                        
                    }
                }
            }
    }
       
    // MARK: - MediaContentCellDelegate Methods
    func didTapPlayButton(in cell: MediaContentCell) {
        if let indexPath = chatRoomTableView.indexPath(for: cell) {
//            let message = viewModel.messages[indexPath.row]
            // Handle button tap here
            print("Play button tapped for message:")
            let rowIndex = indexPath.row
            let message = viewModel.messages[rowIndex]

            print("Tap button was tapped on row \(rowIndex)!")
            if let msgType = viewModel.messages[rowIndex].content?.msgtype {
    //            if msgType == "m.audio" {
    ////                audioFilename = audioURL
    ////                playRecording()
    //            }else{
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
    //            }
            }
        }
    }

    func didLongPressPlayButton(in cell: MediaContentCell) {
        if let indexPath = chatRoomTableView.indexPath(for: cell) {
            let message = viewModel.messages[indexPath.row]
            // Handle long press here
            print("Play button long pressed for message: MediaContentCell")
            self.eventID = ""
            self.eventID = message.eventId
            removeCustomTabBar()
            
            bottomViewHandler?.BV_More_Appear()
            guard let videoURL = URL(string: "https://d3qie74tq3tm9f.cloudfront.net/\(message.content?.S3thumbnailUrl ?? "")") else {
                print("Error: Invalid video URL")
                return
            }
            DispatchQueue.main.async {
                self.replyUserImgView.sd_setImage(with: videoURL, placeholderImage:  UIImage(named: "audioholder", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), options: .transformAnimatedImage, progress: nil, completed: nil)
                self.replyViewWidthConstraint.constant = 24.0
                self.replyUserDesc.text = message.content?.body
                self.replyUserName.text = message.sender
            }
            let buttonImages = [
                UIImage(named: "copy", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                UIImage(named: "Delete", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                UIImage(named: "Forward", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                UIImage(named: "reply", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
                UIImage(named: "cancel", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!
            ]
            let buttonTitles = ["Copy", "Delete", "Forward","Reply","Cancel"]
            customTabBar = CustomTabBar(buttonTitles: buttonTitles, buttonImages: buttonImages, buttonColors: UIColor.white)
            if let customTabBar = customTabBar {
                customTabBar.translatesAutoresizingMaskIntoConstraints = false
                morebottomView.addSubview(customTabBar)
                customTabBar.didSelectTab = { tabIndex in
                    self.bottomSelectMediaActionPerform(tabIndex)
                    
                }
            }
        }
    }
    
    // MARK: - Bottom Media Button Methods
    func bottomSelectMediaActionPerform(_ tapIndex:Int){
        
        switch tapIndex {
        case 0:
            print("copy")
        case 1:
            print("delete")
            DispatchQueue.main.async {
                self.redactMessage()
                self.moreViewHide()
                self.removeCustomTabBar()
                self.setupCustomBottomView()
            }
        case 2:
            print("forward")
        case 3:
            print("click on reply")
            print(eventID!)
            isToggled = false
            isReply = true
            bottomViewHandler?.BV_Reply_TF_Appear()

        case 4:
            print("cancel")
            DispatchQueue.main.async {
                self.isReply = false
                self.bottomViewHandler?.BV_TF_Appear()
            }
        default:
            print("perform action")
        }
    }
    
    // MARK: - Delete Chat API
    private func redactMessage() {
        let roomID = UserDefaults.standard.string(forKey: "room_id")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        let request = MessageRedactRequest(
                    accessToken: /accessToken,
                    roomID: /roomID,
                    eventID: /eventID,
                    body: "spam"
                )
                
        deleteViewModel.redactMessage(request: request) { result in
            switch result {
            case .success(let message):
                print("delete response message ----->>>> \(message)")
                DispatchQueue.main.async {
                    self.fetchMessages()
                }
            case .failure(let error):
                print("Failed to redact message: \(error.localizedDescription)")
            }
        }
    }
     
}
extension ChatRoomVC: TopViewDelegate {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
