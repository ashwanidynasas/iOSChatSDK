//
//  ChatRoomVC+UITableView.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

//MARK: - UITABLEVIEW DELEGATES
extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable(){
        chatRoomTableView.rowHeight = UITableView.automaticDimension
        chatRoomTableView.estimatedRowHeight = 100
        chatRoomTableView.separatorStyle = .none
        let medianib = UINib(nibName: Cell.mediaText, bundle: Bundle(for: MediaTextTVCell.self))
        chatRoomTableView.register(medianib, forCellReuseIdentifier: Cell.mediaText)
        chatRoomTableView.registerCells([ChatMessageCell.self,
                                         MediaContentCell.self,
                                         ReplyText_TextCell.self,
                                         ReplyText_MediaCell.self ,
                                         ReplyText_MediaTextCell.self , 
                                         ReplyMedia_TextCell.self,
                                         ReplyMedia_MediaCell.self,
                                         ReplyMedia_MediaTextCell.self,
                                         ReplyMediaText_TextCell.self,
                                         ReplyMediaText_MediaCell.self,
                                         ReplyMediaText_MediaTextCell.self])
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
            if mainMsgType == MessageType.text {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.message, for: indexPath) as! ChatMessageCell
                cell.configure(with: message, currentUser: currentUser)
                cell.overlayButton.tag = indexPath.row
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            } else if (mainMsgType == MessageType.image || mainMsgType == MessageType.video || mainMsgType == MessageType.audio) && ((mainBody?.isEmpty) == false) {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.mediaText, for: indexPath) as! MediaTextTVCell
                // Configure the cell
                cell.mediaConfigure(with: message, currentUser: currentUser)
                cell.playButton.tag = indexPath.row
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            } else if (mainMsgType == MessageType.image || mainMsgType == MessageType.video || mainMsgType == MessageType.audio) && ((mainBody?.isEmpty) == true) {
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
        if replyMsgType == MessageType.text && mainMsgType == MessageType.text {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyText_TextCell, for: indexPath) as! ReplyText_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if replyMsgType == MessageType.text && mainMsgType == MessageType.image && (mainBody?.isEmpty ?? false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyText_MediaCell, for: indexPath) as! ReplyText_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if replyMsgType == MessageType.text && mainMsgType == MessageType.image && ((mainBody?.isEmpty) == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyText_MediaTextCell, for: indexPath) as! ReplyText_MediaTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if (replyMsgType == MessageType.image || replyMsgType == MessageType.video || replyMsgType == MessageType.audio) && (replyBody?.isEmpty ?? false) && mainMsgType == MessageType.text && ((mainBody?.isEmpty) == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMedia_TextCell, for: indexPath) as! ReplyMedia_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == MessageType.image || replyMsgType == MessageType.video || replyMsgType == MessageType.audio) && (replyBody?.isEmpty ?? false) && mainMsgType == MessageType.image && (mainBody?.isEmpty ?? false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMedia_MediaCell, for: indexPath) as! ReplyMedia_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == MessageType.image || replyMsgType == MessageType.video || replyMsgType == MessageType.audio) && (replyBody?.isEmpty ?? false) && mainMsgType == MessageType.image && ((mainBody?.isEmpty) == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMedia_MediaTextCell, for: indexPath) as! ReplyMedia_MediaTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == MessageType.image || replyMsgType == MessageType.video || replyMsgType == MessageType.audio) && ((replyBody?.isEmpty) == false) && mainMsgType == MessageType.text && ((mainBody?.isEmpty) == false) {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMediaText_TextCell, for: indexPath) as! ReplyMediaText_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == MessageType.image || replyMsgType == MessageType.video || replyMsgType == MessageType.audio) && ((replyBody?.isEmpty) == false) && mainMsgType == MessageType.image && (mainBody?.isEmpty ?? false) {
            // ReplyMediaText_MediaCell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ReplyMediaText_MediaCell, for: indexPath) as! ReplyMediaText_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if (replyMsgType == MessageType.image || replyMsgType == MessageType.video || replyMsgType == MessageType.audio) && ((replyBody?.isEmpty) == false) && mainMsgType == MessageType.image && ((mainBody?.isEmpty) == false) {
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
        let msgType = /message.content?.msgtype
        if (msgType == MessageType.image) || (msgType == MessageType.audio) || (msgType == MessageType.video) {
            if message.content?.body == "" {
                return 200
            }
            return UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
}

