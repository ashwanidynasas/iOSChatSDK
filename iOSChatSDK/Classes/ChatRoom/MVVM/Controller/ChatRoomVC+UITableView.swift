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
        chatRoomTableView.estimatedRowHeight = ChatConstants.BubbleHeight.estimationRowHeight
        chatRoomTableView.separatorStyle = .none
        let medianib = UINib(nibName: Cell_Chat.mediaText, bundle: Bundle(for: MediaTextTVCell.self))
        chatRoomTableView.register(medianib, forCellReuseIdentifier: Cell_Chat.mediaText)
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
        switch message.chatType{
            
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.message, for: indexPath) as! ChatMessageCell
            cell.configure(with: message, currentUser: currentUser)
            cell.overlayButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .media:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.media, for: indexPath) as! MediaContentCell
            // Configure the cell
            cell.mediaConfigure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.mediaText, for: indexPath) as! MediaTextTVCell
            // Configure the cell
            cell.mediaConfigure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .textToText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyText_TextCell, for: indexPath) as! ReplyText_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .textToMedia:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyText_MediaCell, for: indexPath) as! ReplyText_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .textToMediaText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyText_MediaTextCell, for: indexPath) as! ReplyText_MediaTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaToText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMedia_TextCell, for: indexPath) as! ReplyMedia_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaToMedia:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMedia_MediaCell, for: indexPath) as! ReplyMedia_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaToMediaText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMedia_MediaTextCell, for: indexPath) as! ReplyMedia_MediaTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        
        case .mediaTextToText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMediaText_TextCell, for: indexPath) as! ReplyMediaText_TextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaTextToMedia:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMediaText_MediaCell, for: indexPath) as! ReplyMediaText_MediaCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaTextToMediaText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMediaText_MediaTextCell, for: indexPath) as! ReplyMediaText_MediaTextCell
            cell.configure(with: message, currentUser: currentUser)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = viewModel.messages[indexPath.row]
        if let inReplyTo = message.content?.relatesTo?.inReplyTo {
            return UITableView.automaticDimension
        }
        
        let msgType = /message.content?.msgtype
        if (msgType == MessageType.image) || (msgType == MessageType.audio) || (msgType == MessageType.video) {
            if message.content?.body == "" {
                return ChatConstants.BubbleHeight.cellHeight
            }
            return UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
    
}

//MARK: - SCROLL VIEW
extension ChatRoomVC{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
    }
}
