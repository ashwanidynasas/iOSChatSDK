//
//  ChatRoomVC.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

import UIKit

class ChatRoomVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var emojiBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!

    @IBOutlet weak var backTFView: UIView!
    @IBOutlet weak var backBottomView: UIView!
    @IBOutlet weak var chatRoomTableView:UITableView!
    @IBOutlet weak var sendMsgTF:UITextField!
    
    @IBOutlet weak var customTopView: CustomTopView!

    @IBOutlet weak var moreViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backBottomViewHeight: NSLayoutConstraint!

    @IBOutlet weak var morebottomView: UIView!
    
    let tableCell = "CustomTableViewCell"
    
    let apiClient = RoomAPIClient()
    var chatUserID: String!
    var currentUser: String!
    var isToggled = false
    var imageFetched:UIImage!
    var videoFetched:URL!

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
            print("Selected tab index: \(tabIndex)")
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
        backTFView.layer.cornerRadius = 18
        backTFView.clipsToBounds = true
        sendBtn.makeCircular()
        chatRoomTableView.backgroundColor = .clear
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

    @IBAction func sendMsgAction(_ sender: UIButton) {
        
        moreViewHide()
        let room_id = UserDefaults.standard.string(forKey: "room_id")
        print("room_id sender: \(/room_id)")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        print("accessToken sender: \(/accessToken)")
        
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
    
    private func fetchMessages() {
        
        viewModel.onUpdate = { [weak self] in
            self?.chatRoomTableView.reloadData()
            self?.scrollToBottom()
            self?.sendMsgTF.text = ""
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
//          self.openCamera()   //  activate after bottom view worked
            self.openGallery()  //  remove after bottom view worked
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

    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == "public.image" {
                if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    print("Selected image: \(selectedImage)")
                    imageFetched = selectedImage
                    sendImageFromGalleryAPICall(image:selectedImage, msgType: "m.image")
                }
            } else if mediaType == "public.movie" {
                if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    print("Selected video URL: \(videoURL)")
                    videoFetched = videoURL
                    sendImageFromGalleryAPICall(video:videoURL, msgType: "m.video")

                }
            }
        }
        
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
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
                        // Handle error
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
        let msgType = message.content?.msgtype
        
        if let msgType = MessageType(rawValue: message.content?.msgtype ?? "") {
            if (msgType == .image) || (msgType == .audio) || (msgType == .video) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MediaContentCell", for: indexPath) as! MediaContentCell
                
                cell.mediaConfigure(with: message, currentUser: currentUser)
                cell.selectionStyle = .none
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        cell.configure(with: message, currentUser: currentUser)
        cell.selectionStyle = .none
        return cell

    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainChat", bundle: Bundle(for: ChatRoomVC.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MediaFullVC") as? MediaFullVC else {
            fatalError("ViewController Not Found")
        }
        
        let message = viewModel.messages[indexPath.row]

        if message.content?.url == nil  {
            print("media nil...")
            return
        }
        viewController.currentUser = currentUser
        viewController.videoFetched = videoFetched
        viewController.imageFetched = imageFetched
        viewController.imageSelectURL = message.content?.url
        self.navigationController?.pushViewController(viewController, animated: true)
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
extension ChatRoomVC: CustomTopViewDelegate {
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
