//
//  ChatRoomVC+Delegates.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

//MARK: - CUSTOM DELEGATES

extension ChatRoomVC: DelegateTopView {
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}



extension ChatRoomVC : DelegatePublishMedia{
    
    func didReceiveData(data: String) {
        if data == "update"{
            fetchMessages()
        }else{
            print("return from detail screen")
        }
    }
}


extension ChatRoomVC : DelegateMediaFullVC{
    func itemDeleteFromChat(_ didSendData: String) {
        if didSendData == "deleteItem"{
            fetchMessages()
        }
    }
}

extension ChatRoomVC: DelegatePlay{
    func didTapPlayButton(in cell: UITableViewCell) {
        if cell is ReplyText_TextCell || cell is ReplyMedia_TextCell || cell is ReplyMediaText_TextCell{
            print("Text only - no preview")
        }else{
            previewcallfunc(cell: cell)
        }
    }
    
    func didLongPressPlayButton(in cell: UITableViewCell) {
        if cell is ReplyText_MediaTextCell {
            previewcallfunc(cell: cell)
        }else{
            longPressedFunc(cell: cell)
        }
    }
}
