//
//  ChatRoomVC+UITableView.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

//MARK: - UITABLEVIEW DELEGATES
extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func registerNib() {
        let nib = UINib(nibName: Cell.custom, bundle: Bundle(for: CustomTableViewCell.self))
        chatRoomTableView.register(nib, forCellReuseIdentifier: Cell.custom)
        chatRoomTableView.rowHeight = UITableView.automaticDimension
        chatRoomTableView.estimatedRowHeight = 100
        let medianib = UINib(nibName: Cell.mediaText, bundle: Bundle(for: MediaTextTVCell.self))
        chatRoomTableView.register(medianib, forCellReuseIdentifier: Cell.mediaText)
        
    }
    
    func setupTable(){
        chatRoomTableView.separatorStyle = .none
        chatRoomTableView.register(ChatMessageCell.self, forCellReuseIdentifier: Cell.message)
        chatRoomTableView.register(MediaContentCell.self, forCellReuseIdentifier: Cell.media)
        chatRoomTableView.register(ReplyText_TextCell.self, forCellReuseIdentifier: String(describing: ReplyText_TextCell.self))
        chatRoomTableView.register(ReplyText_MediaCell.self, forCellReuseIdentifier: String(describing: ReplyText_MediaCell.self))
        chatRoomTableView.register(ReplyText_MediaTextCell.self, forCellReuseIdentifier: String(describing: ReplyText_MediaTextCell.self))
        chatRoomTableView.register(ReplyMedia_TextCell.self, forCellReuseIdentifier: String(describing: ReplyMedia_TextCell.self))
        chatRoomTableView.register(ReplyMedia_MediaCell.self, forCellReuseIdentifier: String(describing: ReplyMedia_MediaCell.self))
        chatRoomTableView.register(ReplyMedia_MediaTextCell.self, forCellReuseIdentifier: String(describing: ReplyMedia_MediaTextCell.self))
        chatRoomTableView.register(ReplyMediaText_TextCell.self, forCellReuseIdentifier: String(describing: ReplyMediaText_TextCell.self))
        chatRoomTableView.register(ReplyMediaText_MediaCell.self, forCellReuseIdentifier: String(describing: ReplyMediaText_MediaCell.self))
        chatRoomTableView.register(ReplyMediaText_MediaTextCell.self, forCellReuseIdentifier: String(describing: ReplyMediaText_MediaTextCell.self))
    }
    
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        
        let mainContent = message.content
        let relatesTo = mainContent?.relatesTo
        let inReplyTo = relatesTo?.inReplyTo
        let replyContent = inReplyTo?.content
        let mainMsgType = mainContent?.msgtype
        let mainBody = mainContent?.body
        let replyMsgType = replyContent?.msgtype
        let replyBody = replyContent?.body
        
        // Check for absence of m.relates_to and m.in_reply_to
        if relatesTo == nil && inReplyTo == nil {
            if mainMsgType == "m.text" {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.message, for: indexPath) as! ChatMessageCell
                cell.configure(with: message, currentUser: currentUser)
                cell.overlayButton.tag = indexPath.row
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            } else if (mainMsgType == "m.image" || mainMsgType == "m.video" || mainMsgType == "m.audio") && ((mainBody?.isEmpty) == false) {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.mediaText, for: indexPath) as! MediaTextTVCell
                // Configure the cell
                cell.mediaConfigure(with: message, currentUser: currentUser)
                cell.playButton.tag = indexPath.row
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            } else if (mainMsgType == "m.image" || mainMsgType == "m.video" || mainMsgType == "m.audio") && ((mainBody?.isEmpty) == true) {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.media, for: indexPath) as! MediaContentCell
                // Configure the cell
                cell.mediaConfigure(with: message, currentUser: currentUser)
                cell.playButton.tag = indexPath.row
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            }
        }
        // Determine the cell type
        if replyMsgType == "m.text" && mainMsgType == "m.text" {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyText_TextCell, for: indexPath) as! ReplyText_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if replyMsgType == "m.text" && mainMsgType == "m.image" && (mainBody?.isEmpty ?? false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyText_MediaCell, for: indexPath) as! ReplyText_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if replyMsgType == "m.text" && mainMsgType == "m.image" && ((mainBody?.isEmpty) == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyText_MediaTextCell, for: indexPath) as! ReplyText_MediaTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if (replyMsgType == "m.image" || replyMsgType == "m.video" || replyMsgType == "m.audio") && (replyBody?.isEmpty ?? false) && mainMsgType == "m.text" && ((mainBody?.isEmpty) == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMedia_TextCell, for: indexPath) as! ReplyMedia_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == "m.image" || replyMsgType == "m.video" || replyMsgType == "m.audio") && (replyBody?.isEmpty ?? false) && mainMsgType == "m.image" && (mainBody?.isEmpty ?? false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMedia_MediaCell, for: indexPath) as! ReplyMedia_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == "m.image" || replyMsgType == "m.video" || replyMsgType == "m.audio") && (replyBody?.isEmpty ?? false) && mainMsgType == "m.image" && ((mainBody?.isEmpty) == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMedia_MediaTextCell, for: indexPath) as! ReplyMedia_MediaTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == "m.image" || replyMsgType == "m.video" || replyMsgType == "m.audio") && ((replyBody?.isEmpty) == false) && mainMsgType == "m.text" && ((mainBody?.isEmpty) == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMediaText_TextCell, for: indexPath) as! ReplyMediaText_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == "m.image" || replyMsgType == "m.video" || replyMsgType == "m.audio") && ((replyBody?.isEmpty) == false) && mainMsgType == "m.image" && (mainBody?.isEmpty ?? false) {
            // ReplyMediaText_MediaCell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMediaText_MediaCell, for: indexPath) as! ReplyMediaText_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == "m.image" || replyMsgType == "m.video" || replyMsgType == "m.audio") && ((replyBody?.isEmpty) == false) && mainMsgType == "m.image" && ((mainBody?.isEmpty) == false) {
            // ReplyMediaText_MediaTextCell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMediaText_MediaTextCell, for: indexPath) as! ReplyMediaText_MediaTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = viewModel.messages[indexPath.row]
        if let inReplyTo = message.content?.relatesTo?.inReplyTo {
            return UITableView.automaticDimension
        }
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
}
