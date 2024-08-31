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
    @IBOutlet weak var viewReply: ChatReplyView!
    @IBOutlet weak var viewInput: InputView!
    @IBOutlet weak var viewMore: MoreView!
    
    //MARK: - PROPERTIES
    //MARK: - VIEWMODEL
    var viewModel : ChatRoomViewModel?
    
    //scroll
    var isScrolling = false
    var imageFetched: UIImage? = nil
    var videoFetched: URL?
    var isReply = false
    var selectedMessage : Messages?
    
    //MARK: - VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOtherUser?.delegate = self
        viewOtherUser?.connection = viewModel?.connection
        
        viewSend?.backgroundColor = .clear
        
        viewReply?.delegate = self
        
        viewInput?.setupUI()
        viewInput?.layer.cornerRadius = 24
        viewInput?.clipsToBounds = true
        viewInput?.setupTextfield()
        viewInput?.setupAudio()
        
        if let viewMore = viewMore {
            viewMore.setup(.attach)
        } else {
            print("viewMore is nil")
        }
        setupUI()
        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
                
                //self?.scrollToBottom()
            }
        }
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isReply = false
        viewModel?.getMessages()
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
            guard let vc = UIStoryboard(name: "MainChat", bundle: Bundle(for: ChatRoomVC.self)).instantiateViewController(withIdentifier: "MediaFullVC") as? MediaFullVC else { return }
            vc.videoFetched = videoFetched
            vc.imageFetched = imageFetched
            vc.selectedMessage = message
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - SETUP UI
extension ChatRoomVC{
    
    func setupUI() {
        layout([.input])
        let startColor = UIColor(hex: "000000")
        let endColor = UIColor(hex: "520093")
        self.view.setGradientBackground(startColor: startColor, endColor: endColor)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView?.backgroundColor = .clear
        
    }
    
    func layout( _ children : [SendChild]){
        DispatchQueue.main.async {
            self.viewReply.isHidden = !children.contains(.reply)
            self.viewInput.isHidden = !children.contains(.input)
            self.viewMore.isHidden = !children.contains(.more)
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
        viewMore?.setup(.select)
        DispatchQueue.main.async {
            self.layout([.more])
        }
    }
    
    func deleteMessage() {
        viewModel?.redactMessage(eventID: /selectedMessage?.eventId) { result in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.viewModel?.getMessages()
                    DispatchQueue.main.async {
                        self.layout([.input])
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
            self.layout([.input])
            self.viewInput?.textfieldMessage?.text = ""
            self.viewInput?.buttonSend?.setImage(UIImage(named: "mic", in: Bundle(for: ChatRoomVC.self), compatibleWith: nil), for: .normal)
        }
        viewModel?.getMessages()
        scrollToBottom()
    }

}
