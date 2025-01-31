//
//  ChatRoomVC+Delegates.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

//MARK: - CUSTOM DELEGATES
enum SendChild{
    case input
    case more
    case reply
}

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
            isReply = false
        }else{
        }
    }
}


extension ChatRoomVC : DelegateMediaFullVC{
    func messageDeleted() {
        viewModel?.getMessages()
    }
}

//MARK: - PRESS
extension ChatRoomVC: DelegatePlay{
    func didStartPlayingAudio(in cell: MediaContentCell) {
        stopFetchTimer()
    }
    
    func didStopPlayingAudio(in cell: MediaContentCell) {
        startFetchTimer()
    }
    
    func didTapPlayButton(in cell: UITableViewCell) {
        if cell is ReplyText_TextCell || cell is ReplyMedia_TextCell || cell is ReplyMediaText_TextCell{
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
        case .document : presentDocumentPicker()
        case .zc       : break
            
            
        //select
        case .copy            : break
        case .deleteSelected  : deleteMessage()
        case .forwardSelected : break
        case .reply:
            isReply = true
            viewSend.viewReply.configure(with: selectedMessage)
            viewSend.layout([.input , .reply])
            
        case .cancel:
            isReply = false
            DispatchQueue.main.async {
                self.viewSend.layout([.input])
            }
        default : break
        }
    }
}


//MARK: - DELEGATE INPUT
extension ChatRoomVC : DelegateInput,DelegateAudio{
    
    func sendTextMessage() {
        if viewSend.viewInput.textfieldMessage.text == "" {
            return
        }
        if isReply {
            viewModel?.sendReply(body: /viewSend.viewInput.textfieldMessage.text, eventID: /selectedMessage?.eventId, completion: { result in
                switch result {
                case .success(_):
                    self.messageSent()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }else{
            viewModel?.sendMessage(body: /viewSend.viewInput.textfieldMessage.text,
                                   msgType: MessageType.text) { [weak self] response in
                DispatchQueue.main.async {
                    if response != nil {
                        self?.messageSent()
                    } else {
                    }
                }
            }
        }
    }

    
    func sendAudio(audioFilename : URL){
        viewModel?.sendAudioMedia(audioFilename: audioFilename, completion: { result in
            switch result{
            case .success(_) :
                self.messageSent()
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    func attach() {
        viewSend.viewMore.setup(.attach)
        viewSend.layout(isReply ? [.reply, .input, .more] : [.input, .more])
    }
    func hideAttach(){
        viewSend.resetViews()
    }
}

extension ChatRoomVC : DelegateReply{
    func cancelReply() {
        isReply = false
//        viewSend.layout([.input])
        viewSend.resetViews()
    }
}

