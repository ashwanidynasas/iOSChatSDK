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
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var viewOtherUser: CustomTopView!
    @IBOutlet weak var viewSend: UIView!
    @IBOutlet weak var viewReply: ReplyView!
    @IBOutlet weak var viewInput: InputView!
    @IBOutlet weak var viewMore: UIView!
    
    //MARK: - PROPERTIES
    var connection : Connection?
    var currentUser: String! //this is current circle
    
    //MARK: - VIEWMODEL
    let apiClient = RoomAPIClient()
    let viewModel = MessageViewModel()
    
    //scroll
    var isScrolling = false
    
    //audio
    var imageFetched: UIImage? = nil
    var videoFetched: URL?
    var showMore = false
    var isReply = false
    
    
    private var customTabBar: CustomTabBar?
    var eventID: String! = ""
    
    //MARK: - VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOtherUser?.delegate = self
        viewOtherUser?.connection = connection
        viewSend?.backgroundColor = .clear
        viewInput?.setupUI()
        viewInput?.layer.cornerRadius = 24
        viewInput?.clipsToBounds = true
        viewInput?.setupTextfield()
        viewInput?.setupAudio()
        viewReply?.setupUI()
        
        more(show: false)
        setupUI()
        createRoomCall()
        setupCustomBottomView()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showMore = false
        isReply = false
        startFetchingMessages()
        
    }
    
    private func startFetchingMessages() {
        fetchMessages()
    }
    
    private func scrollToBottom() {
        guard !isScrolling else { return }
        DispatchQueue.main.async {
            if self.viewModel.messages.isEmpty {
                return
            }
            let indexPath = IndexPath(row: self.viewModel.messages.count - 1, section: 0)
            self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func setupCustomBottomView() {
        layout([.input])
        viewMore?.backgroundColor = .clear
        customTabBar = CustomTabBar(items: [.media , .camera, .location , .document , .zc])
        
        if let customTabBar = customTabBar {
            customTabBar.translatesAutoresizingMaskIntoConstraints = false
            viewMore?.addSubview(customTabBar)
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
                self.layout([.input])
            }
        case Item.camera.ordinal():
            DispatchQueue.main.async {
                self.openCamera()
                self.layout([.input])
            }
        default:
            break
        }
    }
    @objc func fetchMessages() {

        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
                //                self?.scrollToBottom()
            }
        }
        let token = UserDefaults.standard.string(forKey: "access_token")
        viewModel.getMessages(accessToken: /token)
    }
    
    public func createRoomCall(){
        
        let token = UserDefaults.standard.string(forKey: "access_token")
        apiClient.createRoom(accessToken: token ?? "",
                             invitees: [/connection?.chatUserId],
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
            self.tableView?.reloadData()
        }
    }
    
    
    
   
    
    
    func more(show : Bool){
        self.view.endEditing(true)
        showMore = show
        viewMore.isHidden = !show
        scrollToBottom()
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
        
        if let indexPath = tableView?.indexPath(for: cell) {
            let message = viewModel.messages[indexPath.row]
            self.eventID = ""
            self.eventID = message.eventId
            removeCustomTabBar()
            layout([.more])
            viewReply?.configureReply(message: viewModel.messages[indexPath.row])
            
            
            customTabBar = CustomTabBar(items: [.copy , .delete , .forward , .reply , .cancel])
            if let customTabBar = customTabBar {
                customTabBar.translatesAutoresizingMaskIntoConstraints = false
                viewMore?.addSubview(customTabBar)
                customTabBar.didSelectTab = { tabIndex in
                    self.bottomSelectMediaActionPerform(tabIndex)
                    
                }
            }
        }
    }
    
    func previewcallfunc(cell:UITableViewCell){
        
        if let indexPath = tableView?.indexPath(for: cell) {
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
            DispatchQueue.main.async {
                self.redactMessage()
                self.layout([.input])
                self.removeCustomTabBar()
                self.setupCustomBottomView()
            }
        case Item.forwardB.ordinal():
            print("forward")
        case Item.reply.ordinal():
            showMore = false
            isReply = true
            layout([.input , .reply])
            
        case Item.cancel.ordinal():
            DispatchQueue.main.async {
                self.isReply = false
                self.layout([.input])
            }
        default:
            break
        }
    }
}



//MARK: - SETUP UI
extension ChatRoomVC{
    
    func setupUI() {
        let startColor = UIColor(hex: "000000")
        let endColor = UIColor(hex: "520093")
        self.view.setGradientBackground(startColor: startColor, endColor: endColor)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView?.backgroundColor = .clear
        
    }
}

//MARK: - NAVIGATION
extension ChatRoomVC{
    
    func publish(){
        guard let vc = UIStoryboard(name: SB.main, bundle: Bundle(for: ChatRoomVC.self)).instantiateViewController(withIdentifier: String(describing: PublishMediaVC.self)) as? PublishMediaVC else { return  }
        vc.currentUser = currentUser
        vc.videoFetched = videoFetched
        vc.imageFetched = imageFetched
        vc.delegate     = self
        vc.isReply      = isReply
        vc.username     = /viewReply?.labelName?.text
        vc.userDesc     = /viewReply?.labelDesc?.text
        vc.userImage    = /viewReply?.imageView?.image
        vc.eventID      =  eventID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - DELEGATE INPUT
extension ChatRoomVC : DelegateInput{
    
    func hideMore() {
        more(show: false)
    }
    
    func sendAudioMedia(audioFilename : URL){
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
    
    func micButtonTapped() {
        print("Mic button tapped")
    }
    
    func sendMessage() {
        let room_id = UserDefaults.standard.string(forKey: "room_id")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        if self.viewInput?.textfieldMessage?.text == "" {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "SQRCLE", message: "Please enter the text", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        if isReply {
            
            let body = self.viewInput?.textfieldMessage?.text
            let msgType = MessageType.text
            
            let replyRequest = ReplyMediaRequest(accessToken: /accessToken, roomID: /room_id, eventID: eventID, body: /body, msgType: "m.text")
            
            //            let mimeTypeAndFileName = ChatMediaUpload.shared.getMimeTypeAndFileName(for: /msgType)
            
            let replyRequests = SendMediaRequest(accessToken: /accessToken, roomID: /room_id, body: /body, msgType: /msgType,eventID: eventID)
            
            ChatMediaUpload.shared.uploadFileChatReply(replyRequest:replyRequests,isImage: false){ result in
                switch result {
                case .success(let response):
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                        print("Success: \(response.message)")
                        self.layout([.input])
                        self.isReply = false
                        DispatchQueue.main.async {
                            self.viewInput?.textfieldMessage?.text = ""
                            self.viewInput?.buttonSend?.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
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
            let body = self.viewInput?.textfieldMessage?.text
            let msgType = MessageType.text
            viewModel.sendMessage(roomID: /room_id, body: /body, msgType: msgType, accessToken: /accessToken) { [weak self] response in
                DispatchQueue.main.async {
                    if let response = response {
                        print("Response: \(response.details.response)\nEvent ID: \(response.details.chat_event_id)")
                        DispatchQueue.main.async {
                            self?.viewInput?.textfieldMessage?.text = ""
                            self?.viewInput?.buttonSend?.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
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
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera is not available on this device")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)

    }
    
    func more() {
        removeCustomTabBar()
        setupCustomBottomView()
        showMore.toggle()
        if showMore {
            layout(isReply ? [.reply, .input, .more] : [.input, .more])
        } else {
           layout(isReply ? [.input , .reply] : [.input])
        }
    }
    
    func cancelReply() {
        isReply = false
        layout([.input])
    }
}


extension ChatRoomVC{
    
    func layout( _ children : [SendChild]){
    
        let reply = children.contains(.reply)
        let input = children.contains(.input)
        let more  = children.contains(.more)
        
        DispatchQueue.main.async {
            self.viewReply.isHidden = !reply
            self.viewInput.isHidden = !input
            self.viewMore.isHidden = !more
            /*self.replyHeight.constant = reply ? ViewHeight.child : 0.0
            self.inputHeight.constant = input ? ViewHeight.child : 0.0
            self.moreHeight.constant  = more  ? ViewHeight.child : 0.0
            if (reply && input && more){
                self.sendHeight.constant = ViewHeight.three
            }else if (reply && input) || (reply && more) || (input && more){
                self.sendHeight.constant = ViewHeight.two
            }else if reply || more || input {
                self.sendHeight.constant = ViewHeight.one
            }else{
                self.sendHeight.constant = 0.0
            }*/
            
        }
    }
}
