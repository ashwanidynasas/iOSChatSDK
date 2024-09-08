//
//  ChatRoom.swift
//  iOSChatSDK
//
//  Created by Ashwani on 03/09/24.
//

import Foundation

//MARK: - CLASS
class ChatRoomVC: UIViewController, UINavigationControllerDelegate,BottomViewDelegate {

    // MARK: - Properties
    public var tableView: UITableView!
    public var topView: ChatTopBarView!
    public var viewSend: BottomView!

    var viewModel: ChatRoomViewModel?
    var selectedMessage: Messages?
    var isScrolling             = false
    var isReply                 = false
    var imageFetched: UIImage?  = nil
    var videoFetched: URL?

    // Reference to bottom view height constraint
    private var viewSendHeightConstraint: NSLayoutConstraint!

    // MARK: - VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIVC()
        setupTable()
        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.scrollToBottom()
                self?.viewSend.resetViews()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isReply = false
        viewModel?.getMessages()
    }

    // MARK: - Setup UI
    private func setupUIVC() {
        // Initialize and configure topView
        topView = ChatTopBarView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.searchButton.isHidden = true
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

        viewSend.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewSend)

        // Setup view properties
        viewSend.layout([.input])
        view.setGradientBackground(startColor: Colors.Circles.black, endColor: Colors.Circles.violet)
        navigationController?.setNavigationBarHidden(true, animated: true)

        // Add constraints
        setupConstraints()
    }

    private func setupConstraints() {
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
        viewSendHeightConstraint = viewSend.heightAnchor.constraint(equalToConstant: 65)
        NSLayoutConstraint.activate([
            viewSend.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewSend.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewSend.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
}
//MARK: - NAVIGATION
extension ChatRoomVC{
    
    func publish(){
        guard let vc = UIStoryboard(name: SB.main, bundle: Bundle(for: ChatRoomVC.self)).instantiateViewController(withIdentifier: String(describing: PublishMediaVC.self)) as? PublishMediaVC else { return  }
        vc.videoFetched = videoFetched
        vc.imageFetched = imageFetched
        vc.delegate     = self
        vc.isReply      = isReply
        vc.username     = /selectedMessage?.sender
        vc.userDesc     = /selectedMessage?.content?.body
//        vc.userImage    = /viewReply?.imageView?.image
        vc.eventID      =  /selectedMessage?.eventId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func preview(cell:UITableViewCell){
        
        guard let indexPath = tableView?.indexPath(for: cell),
              let message = viewModel?.messages[indexPath.row] else { return }
        if let msgType = viewModel?.messages[indexPath.row].content?.msgtype {
            if message.content?.url == nil  {
                print("media nil...")
                return
            }
//            guard let vc = UIStoryboard(name: "MainChat", bundle: Bundle(for: ChatRoomVC.self)).instantiateViewController(withIdentifier: "MediaFullVC") as? MediaFullVC else { return }
            let mediaPreviewVC = MediaPreviewVC()
            mediaPreviewVC.videoFetched = videoFetched
            mediaPreviewVC.imageFetched = imageFetched
            mediaPreviewVC.selectedMessage = message
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
        
//        viewReply?.configureReply(message: viewModel?.messages[indexPath.row])
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
//            self.viewSend.layout([.input])
            self.viewSend.resetViews()
            self.viewSend.viewInput.mode = .audio
        }
        viewModel?.getMessages()
        scrollToBottom()
    }

}
//MARK: - SETUP UI
extension ChatRoomVC{
    
    func setupUI() {
        
        viewSend.layout([.input])
        
        self.view.setGradientBackground(startColor: Colors.Circles.black, endColor: Colors.Circles.violet)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView?.backgroundColor = .clear
        
    }
}
