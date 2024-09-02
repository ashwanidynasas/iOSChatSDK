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

protocol DelegateMediaFullVC: AnyObject {
    func messageDeleted()
}

protocol DelegatePlay : AnyObject{
    func didTapPlayButton(in cell: UITableViewCell)
    func didLongPressPlayButton(in cell: UITableViewCell)
}

protocol DelegateReply : AnyObject{
    func cancelReply()
}

protocol DelegateMore : AnyObject{
    func selectedOption(_ item : Item)
}

protocol DelegateInput : AnyObject{
    func sendTextMessage()
    func sendAudio(audioFilename : URL)
    func camera()
    func attach()
}

protocol DelegateAudio : AnyObject{
    func sendAudio(audioFilename : URL)
}

