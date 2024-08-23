//
//  Protocols.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

protocol DelegateTopView : AnyObject {
    func back()
}

protocol DelegatePublishMedia: AnyObject {
    func didReceiveData(data: String)
}

protocol DelegateChatMessageCell: AnyObject {
    func longPressPlay(in cell: ChatMessageCell)
}

protocol MediaContentCellDelegate: AnyObject {
    func didTapPlayButton(in cell: MediaContentCell)
    func didLongPressPlayButton(in cell: MediaContentCell)
}

protocol ReplyMediaText_MediaCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyMediaText_MediaCell)
    func didLongPressPlayButton(in cell: ReplyMediaText_MediaCell)
}

protocol ReplyMediaText_MediaTextCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyMediaText_MediaTextCell)
    func didLongPressPlayButton(in cell: ReplyMediaText_MediaTextCell)
}


protocol ReplyText_MediaTextCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyText_MediaTextCell)
    func didLongPressPlayButton(in cell: ReplyText_MediaTextCell)
}

protocol ReplyText_MediaCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyText_MediaCell)
    func didLongPressPlayButton(in cell: ReplyText_MediaCell)
}

protocol ReplyMedia_TextCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyMedia_TextCell)
    func didLongPressPlayButton(in cell: ReplyMedia_TextCell)
}


protocol ReplyMedia_MediaTextCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyMedia_MediaTextCell)
    func didLongPressPlayButton(in cell: ReplyMedia_MediaTextCell)
}

protocol ReplyMedia_MediaCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyMedia_MediaCell)
    func didLongPressPlayButton(in cell: ReplyMedia_MediaCell)
}


protocol ReplyMediaText_TextCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyMediaText_TextCell)
    func didLongPressPlayButton(in cell: ReplyMediaText_TextCell)
}

protocol MediaFullVCDelegate: AnyObject {
    func itemDeleteFromChat(_ didSendData: String)
}

protocol ReplyText_TextCellDelegate: AnyObject {
    func didTapPlayButton(in cell: ReplyText_TextCell)
    func didLongPressPlayButton(in cell: ReplyText_TextCell)
}

protocol MediaTextCellDelegate: AnyObject {
    func didTapPlayButton(in cell: MediaTextTVCell)
    func didLongPressPlayButton(in cell: MediaTextTVCell)
}

