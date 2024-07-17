//
//  ChatRoomVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

import UIKit
import AVFAudio

class ChatRoomVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,PublishMediaDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    

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

    @IBOutlet weak var morebottomView: UIView!
    @IBOutlet weak var audioTimeLbl: UILabel!
    
    let tableCell = "CustomTableViewCell"
    
    let apiClient = RoomAPIClient()
    var chatUserID: String!
    var currentUser: String!
    var isToggled = false
    var imageFetched:UIImage! = nil
    var videoFetched:URL!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recordingSession: AVAudioSession!
    var audioFilename: URL!
    var timer: Timer?
    var recordingDuration: TimeInterval = 0



    private let sendMsgModel = SenderViewModel()
    private let viewModel = MessageViewModel()
    private let mediaViewModel = ChatMediaViewModel()

    func setButtonTintColor(button: UIButton, color: UIColor) {
        button.tintColor = color
    }
    
    private enum MessageType: String {
        case audio = "m.audio"
        case video = "m.video"
        case image = "m.image"

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
        moreViewHide()
        customTopView.titleLabel.text = currentUser
        customTopView.delegate = self
        backBottomView.backgroundColor = .clear
        setupUI()
        registerNib()
        createRoomCall()
        fetchMessages()
        setupCustomBottomView()
        
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        chatRoomTableView.register(MediaContentCell.self, forCellReuseIdentifier: "MediaContentCell")

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

        backTFView.layer.cornerRadius = 18
        backTFView.clipsToBounds = true
        sendBtn.makeCircular()
        chatRoomTableView.backgroundColor = .clear
        
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
            playRecording()
        } else {
            print("Recording failed")
        }
        // Stop the timer
        timer?.invalidate()
        timer = nil

    }
    
    func playRecording() {
        do {
            print("audioFilename ---->>> \(String(describing: audioFilename))")
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
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
    
    @objc func sendButtonTapped() {
        print("Send button tapped")
        moreViewHide()
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
        let body = self.sendMsgTF.text
        let msgType = "m.text"
        sendMsgModel.sendMessage(roomID: /room_id, body: /body, msgType: msgType, accessToken: /accessToken) { [weak self] response in
            DispatchQueue.main.async {
                if let response = response {
                    print("Response: \(response.details.response)\nEvent ID: \(response.details.chat_event_id)")
                    self?.fetchMessages()
                } else {
                    print("No response received")
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
        morebottomView.backgroundColor = .clear
        let buttonImages = [
            UIImage(named: "Media", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
            UIImage(named: "MoreCamera", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
            UIImage(named: "Location", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
            UIImage(named: "Document", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!,
            UIImage(named: "ZC", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil)!
        ]
        let buttonTitles = ["Media", "Camera", "Location","Document","Send ZC"]
        let customTabBar = CustomTabBar(buttonTitles: buttonTitles, buttonImages: buttonImages)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        morebottomView.addSubview(customTabBar)
        customTabBar.didSelectTab = { tabIndex in
            self.bottomMediaActionPerform(tabIndex)
        }
    }
    
    func bottomMediaActionPerform(_ tapIndex:Int){
        
        switch tapIndex {
        case 0:
            print("Media")
            self.openGallery()
            self.moreViewHide()
        case 1:
            print("Camera")
            self.openCamera()
            self.moreViewHide()
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
        print("token \(/token)")

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
    
    @IBAction func moreActoinBtn(_ sender: Any) {
        isToggled = !isToggled
        if isToggled {
           moreViewShow()
        } else {
           moreViewHide()
        }
    }
    
    func moreViewShow(){
        morebottomView.isHidden = false
        moreViewHeight.constant = 56.0
        backBottomViewHeight.constant = 114.0
        scrollToBottom()
    }
    func moreViewHide(){
        morebottomView.isHidden = true
        moreViewHeight.constant = 0.0
        backBottomViewHeight.constant = 56.0
        scrollToBottom()
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
    
    func gotoPublishView(){
        let storyboard = UIStoryboard(name: "MainChat", bundle: Bundle(for: ChatRoomVC.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PublishMediaVC") as? PublishMediaVC else {
            fatalError("ViewController Not Found")
        }
        viewController.currentUser = currentUser
        viewController.videoFetched = videoFetched
        viewController.imageFetched = imageFetched
        viewController.publishDelegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == "public.image" {
                if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    print("Selected image: \(selectedImage)")
                    imageFetched = selectedImage
                    gotoPublishView()
                }
            } else if mediaType == "public.movie" {
                if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    print("Selected video URL: \(videoURL)")
                    videoFetched = videoURL
                    gotoPublishView()
                }
            }
        }
        
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func didReceiveData(data: String) {
        if data == "video"{
            sendImageFromGalleryAPICall(video:videoFetched, msgType: "m.video")
        }else if data == "image"{
            sendImageFromGalleryAPICall(image:imageFetched, msgType: "m.image")
        }else{
            print("return from detail screen")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func sendImageFromGalleryAPICall(image: UIImage? = nil, video: URL? = nil, audio: URL? = nil, document: String? = nil, msgType:String) {
        let roomID = UserDefaults.standard.string(forKey: "room_id")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        let body = self.sendMsgTF.text
        print("msg type ---> \(msgType)")
        
        var mimetype:String!
        var mediaType:String!
        var fileName:String!
        
        switch msgType {
        case "m.image":
            mimetype = "image/jpeg"
            mediaType = "image"
            fileName = "a1.jpg"
        case "m.video":
            mimetype = "video/mp4"
            mediaType = "video"
            fileName = "upload.mp4"
        case "m.file" :
            mimetype = "application/x-python-code"
            mediaType = "file"
        case "m.audio":
            mimetype = "audio/mp3"
            mediaType = "audio"
            fileName = "Audio File"
        default:
            print(msgType)
        }
        
        if mediaType == "image"{
            mediaViewModel.uploadFile(accessToken: /accessToken, roomID: /roomID, body: /body, msgType: msgType, mimetype: mimetype, fileName: /fileName, imageFilePath: image,  mediaType: mediaType) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        print("Success: \(response.message)")
                        self.fetchMessages()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        else if (mediaType == "audio"){
            mediaViewModel.uploadFile(accessToken: /accessToken, roomID: /roomID, body: /body, msgType: msgType, mimetype: mimetype, fileName: /fileName, videoFilePath: audio,  mediaType: mediaType) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        print("Success: \(response.message)")
                        self.fetchMessages()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }else{
            mediaViewModel.uploadFile(accessToken: /accessToken, roomID: /roomID, body: /body, msgType: msgType, mimetype: mimetype, fileName: /fileName, videoFilePath: video,  mediaType: mediaType) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        print("Success: \(response.message)")
                        self.fetchMessages()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    
}
extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = viewModel.messages[indexPath.row]
        // Media Only
        if let msgType = MessageType(rawValue: message.content?.msgtype ?? "") {
            if (msgType == .image) || (msgType == .audio) || (msgType == .video) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MediaContentCell", for: indexPath) as! MediaContentCell
                // Configure the cell
                cell.mediaConfigure(with: message, currentUser: currentUser)
                cell.playButton.tag = indexPath.row
                cell.playButton.addTarget(self, action: #selector(tapButtonTapped(_:)), for: .touchUpInside)
                cell.selectionStyle = .none // Disable cell selection
                
                return cell
            }
        }
        // Text Only
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        cell.configure(with: message, currentUser: currentUser)
        cell.selectionStyle = .none
        return cell

    }

    @objc func tapButtonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        print("Tap button was tapped on row \(rowIndex)!")
        
        let storyboard = UIStoryboard(name: "MainChat", bundle: Bundle(for: ChatRoomVC.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MediaFullVC") as? MediaFullVC else {
            fatalError("ViewController Not Found")
        }

        let message = viewModel.messages[rowIndex]

        if message.content?.url == nil  {
            print("media nil...")
            return
        }
        viewController.currentUser = currentUser
        viewController.videoFetched = videoFetched
        viewController.imageFetched = imageFetched
        viewController.imageSelectURL = message.content?.url
        viewController.s3MediaURL = message.content?.awsUrl
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
         let message = viewModel.messages[indexPath.row]
         // Media Only
         if let msgType = MessageType(rawValue: message.content?.msgtype ?? "") {
             if (msgType == .image) || (msgType == .audio) || (msgType == .video) {
                 return 200
             }
         }
             
        return UITableView.automaticDimension
    }
     
}

extension UIView {
    func setGradientBackground(startColor: UIColor, endColor: UIColor) {
      let gradientLayer = CAGradientLayer()
      gradientLayer.frame = self.bounds
      gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
      gradientLayer.locations = [0.0, 1.0] // Start color at top, end color at bottom
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Centered at top
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // Centered at bottom
      self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension ChatRoomVC: TopViewDelegate {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
