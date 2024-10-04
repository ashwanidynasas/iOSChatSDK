//
//  ChatRoom.swift
//  iOSChatSDK
//
//  Created by Ashwani on 03/09/24.
//

import Foundation

//MARK: - CLASS
open class ChatRoomVC: UIViewController, UINavigationControllerDelegate, BottomViewDelegate {

    // MARK: - Properties
    public var tableView: UITableView!
    public var topView: ChatTopBarView!
    public var viewSend: BottomView!

    public var viewModel: ChatRoomViewModel?
    public var selectedMessage: Messages?
    public var isScrolling             = false
    public var isReply                 = false
    public var imageFetched: UIImage?  = nil
    public var videoFetched: URL?
    public var fileFetched: URL?

    // Reference to bottom view height constraint
    public var viewSendHeightConstraint: NSLayoutConstraint!

    // MARK: - VIEW CYCLE
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupUIVC()
        setupTable()
        viewModel?.getMessages()
        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.scrollToBottom()
                self?.viewSend.resetViews()
            }
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        isReply = false
//        viewModel?.getMessages()
        setupKeyboardObservers()
        self.hidesBottomBarWhenPushed = true
    }

    // MARK: - Setup UI
    public func setupUIVC() {
        // Initialize and configure topView
        if let colorHex = viewModel?.connection?.defaultParam.color.toHex() {
            ChatConstants.CircleColor.hexString = colorHex
        }
        if let borderColorHex = viewModel?.connection?.defaultParam.borderColor.toHex() {
            ChatConstants.CircleColor.borderHexString = borderColorHex
        }
        topView = ChatTopBarView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.searchButton.isHidden = false
        topView.configure(with: viewModel?.connection)
        topView.delegate = self
        self.view.addSubview(topView)

        // Setup UITableView
        tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        // Setup BottomView
        viewSend = BottomView()
        viewSend.backgroundColor = .clear
        viewSend.delegate = self
        viewSend.viewReply.delegate = self
        viewSend.viewInput.delegateInput = self
        viewSend.viewMore.delegate = self
        viewSend.viewInput.viewAudio.delegate = self
        viewSend.viewInput.buttonColor = viewModel?.connection?.defaultParam.color ?? Colors.Circles.violet
        

        viewSend.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewSend)

        // Setup view properties
        viewSend.layout([.input])
        addGradientView(color: viewModel?.connection?.defaultParam.color ?? Colors.Circles.violet)
        navigationController?.setNavigationBarHidden(true, animated: true)

        // Add constraints
        setupConstraints()
    }

    public func setupConstraints() {
        // Constraints for viewOtherUser (CustomTopView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 60) // Set an appropriate height
        ])

        // Constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: viewSend.topAnchor)
        ])

        // Constraints for viewSend (BottomView)
        viewSendHeightConstraint = viewSend.heightAnchor.constraint(equalToConstant: inputHeight)
        NSLayoutConstraint.activate([
            viewSend.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewSend.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewSend.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewSendHeightConstraint
        ])
    }
    // MARK: - Update BottomView Height
       func updateBottomViewHeight(to height: CGFloat) {
           viewSendHeightConstraint.constant = height
           UIView.animate(withDuration: 0.3) {
               self.view.layoutIfNeeded()
           }
       }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        removeKeyboardObservers()
    }
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
//MARK: - NAVIGATION
extension ChatRoomVC{
    
    func publish(){
        guard let vc = UIStoryboard(name: SB.main, bundle: Bundle(for: ChatRoomVC.self)).instantiateViewController(withIdentifier: String(describing: PublishMediaVC.self)) as? PublishMediaVC else { return  }
        vc.videoFetched = videoFetched
        vc.imageFetched = imageFetched
        vc.fileFetched = fileFetched
        vc.delegate     = self
        vc.isReply      = isReply
        vc.username     = /selectedMessage?.sender
        vc.userDesc     = /selectedMessage?.content?.body
        if viewSend.viewReply.imageView.isHidden == true {
            vc.userImage    = nil
        }else{
            vc.userImage    = viewSend.viewReply.imageView.image
        }
        vc.eventID      =  /selectedMessage?.eventId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func preview(cell:UITableViewCell){
        
        guard let indexPath = tableView?.indexPath(for: cell),
              let message = viewModel?.messages[indexPath.row] else { return }
        if let msgType = viewModel?.messages[indexPath.row].content?.msgtype {
            print("msgType ---> \(msgType)")
            if message.content?.url == nil  {
                print("media nil...")
                return
            }
            let mediaPreviewVC = MediaPreviewVC()
            mediaPreviewVC.videoFetched = videoFetched
            mediaPreviewVC.imageFetched = imageFetched
            mediaPreviewVC.fileFetched = fileFetched
            mediaPreviewVC.selectedMessage = message
            mediaPreviewVC.viewModel = viewModel
            mediaPreviewVC.delegate = self
            self.navigationController?.pushViewController(mediaPreviewVC, animated: true)
        }
    }
}

//MARK: - FUNCTIONS
extension ChatRoomVC{
    
    func select(cell:UITableViewCell){
        guard let indexPath = tableView?.indexPath(for: cell),
              let message = viewModel?.messages[indexPath.row] else { return }
        selectedMessage = message
        viewSend.viewMore.setup(.select)
        DispatchQueue.main.async {
            self.viewSend.layout([.more])
        }
    }
    
    func deleteMessage() {
        viewModel?.redactMessage(eventID: /selectedMessage?.eventId) { result in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.viewModel?.getMessages()
                    DispatchQueue.main.async {
                        self.viewSend.layout([.input])
                    }
                }
            case .failure(let error):
                print("Failed to redact message: \(error.localizedDescription)")
            }
        }
    }
    
    func messageSent(){
        self.isReply = false
        DispatchQueue.main.async {
            self.viewSend.resetViews()
            self.viewSend.viewInput.mode = .audio
        }
        viewModel?.getMessages()
        scrollToBottom()
    }

}
//MARK: - SETUP UI
extension ChatRoomVC{
    
//    func setupUI() {
//
//        viewSend.layout([.input])
//
//        self.view.setGradientBackground(startColor: Colors.Circles.black, endColor: Colors.Circles.violet)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        tableView?.backgroundColor = .clear
//
//    }

}
