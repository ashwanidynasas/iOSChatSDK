//
//  ChatRoomVC+Delegates.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

//MARK: - CUSTOM DELEGATES

//MARK: - TOP VIEW
extension ChatRoomVC: DelegateTopView {
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}



extension ChatRoomVC : DelegatePublishMedia{
    
    func didReceiveData(data: String) {
        if data == ChatConstants.Common.update{
            viewModel?.getMessages()
        }else{
            print("return from detail screen")
        }
    }
}


extension ChatRoomVC : DelegateMediaFullVC{
    func itemDeleteFromChat(_ didSendData: String) {
        if didSendData == ChatConstants.Common.deleteItem{
            viewModel?.getMessages()
        }
    }
}

//MARK: - PRESS
extension ChatRoomVC: DelegatePlay{
    func didTapPlayButton(in cell: UITableViewCell) {
        if cell is ReplyText_TextCell || cell is ReplyMedia_TextCell || cell is ReplyMediaText_TextCell{
            print("Text only - no preview")
        }else{
            preview(cell: cell)
        }
    }
    
    func didLongPressPlayButton(in cell: UITableViewCell) {
        if cell is ReplyText_MediaTextCell {
            preview(cell: cell)
        }else{
            select(cell: cell)
        }
    }
}

//MARK: - TOP VIEW
extension ChatRoomVC: DelegateMore{
    func selectedOption(_ item: Item) {
        switch item{
           
        //attach
        case .media    : gallery()
        case .camera   : camera()
        case .location : break
        case .document : break
        case .zc       : break
            
            
        //select
        case .copy            : break
        case .deleteSelected  : deleteMessage()
        case .forwardSelected : break
        case .reply:
            isReply = true
            layout([.input , .reply])
            
        case .cancel:
            isReply = false
            DispatchQueue.main.async {
                self.layout([.input])
            }
        default : break
        }
    }
}


//MARK: - DELEGATE INPUT
extension ChatRoomVC : DelegateInput{
    
    func sendTextMessage() {
        if viewInput?.textfieldMessage?.text == "" {
            return
        }
        if isReply {
            viewModel?.sendReply(body: /viewInput?.textfieldMessage?.text, eventID: eventID, completion: { result in
                switch result {
                case .success(let response):
                    self.messageSent()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }else{
            viewModel?.sendMessage(body: /viewInput?.textfieldMessage?.text,
                                   msgType: MessageType.text) { [weak self] response in
                DispatchQueue.main.async {
                    if let response = response {
                        self?.messageSent()
                    } else {
                        print("No response received")
                    }
                }
            }
        }
    }
    
    func micButtonTapped() {
        print("Mic button tapped")
    }
    
    func sendAudio(audioFilename : URL){
        viewModel?.sendAudioMedia(audioFilename: audioFilename, completion: { result in
            switch result{
            case .success(let msg) :
                self.messageSent()
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    func attach() {
        viewMore?.backgroundColor = .clear
        viewMore?.setup(.attach)
        layout(isReply ? [.reply, .input, .more] : [.input, .more])
    }
}

extension ChatRoomVC : DelegateReply{
    func cancelReply() {
        isReply = false
        layout([.input])
    }
}

