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
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = ChatConstants.BubbleHeight.estimationRowHeight
        tableView?.separatorStyle = .none
        let medianib = UINib(nibName: Cell_Chat.mediaText, bundle: Bundle(for: MediaTextTVCell.self))
        tableView?.register(medianib, forCellReuseIdentifier: Cell_Chat.mediaText)
        tableView?.registerCells([ChatMessageCell.self,
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /viewModel?.messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = viewModel?.messages[indexPath.row] else { return UITableViewCell() }
        switch message.chatType{
            
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.message, for: indexPath) as! ChatMessageCell
            cell.configure(with: message)
            cell.overlayButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .media:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.media, for: indexPath) as! MediaContentCell
            // Configure the cell
            cell.mediaConfigure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.mediaText, for: indexPath) as! MediaTextTVCell
            // Configure the cell
            cell.mediaConfigure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .textToText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyText_TextCell, for: indexPath) as! ReplyText_TextCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .textToMedia:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyText_MediaCell, for: indexPath) as! ReplyText_MediaCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .textToMediaText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyText_MediaTextCell, for: indexPath) as! ReplyText_MediaTextCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaToText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMedia_TextCell, for: indexPath) as! ReplyMedia_TextCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaToMedia:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMedia_MediaCell, for: indexPath) as! ReplyMedia_MediaCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaToMediaText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMedia_MediaTextCell, for: indexPath) as! ReplyMedia_MediaTextCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        
        case .mediaTextToText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMediaText_TextCell, for: indexPath) as! ReplyMediaText_TextCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaTextToMedia:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMediaText_MediaCell, for: indexPath) as! ReplyMediaText_MediaCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .mediaTextToMediaText:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell_Chat.ReplyMediaText_MediaTextCell, for: indexPath) as! ReplyMediaText_MediaTextCell
            cell.configure(with: message)
            cell.playButton.tag = indexPath.row
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = viewModel?.messages[indexPath.row]
        if message?.content?.relatesTo?.inReplyTo != nil {
            return UITableView.automaticDimension
        }
        
        let msgType = /message?.content?.msgtype
        if (msgType == MessageType.image) || (msgType == MessageType.audio) || (msgType == MessageType.video) || (msgType == MessageType.file){
            if /message?.content?.body == "" {
                return ChatConstants.BubbleHeight.cellHeight
            }
            return UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
    
}

//MARK: - SCROLL VIEW
extension ChatRoomVC{
    func scrollToBottom() {
        //        guard !isScrolling else { return }
        guard isAtBottom else { return } // Only scroll if the user is at the bottom
        
        DispatchQueue.main.async {
            if /self.viewModel?.messages.isEmpty {
                return
            }
            let indexPath = IndexPath(row: /self.viewModel?.messages.count - 1, section: 0)
            self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
        isAtBottom = false // User has started scrolling, assume they’re not at the bottom
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
            updateIsAtBottom(for: scrollView)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
        updateIsAtBottom(for: scrollView)

    }
    private func updateIsAtBottom(for scrollView: UIScrollView) {
        // Check if the user is at the bottom of the chat
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.height
        
        // Allow a small threshold to account for minor scrolling
        isAtBottom = contentOffset >= (contentHeight - scrollViewHeight - 20)
    }
    
}
