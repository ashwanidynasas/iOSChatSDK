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
    func didStartPlayingAudio(in cell: MediaContentCell)
    func didStopPlayingAudio(in cell: MediaContentCell)

}

protocol DelegateReply : AnyObject{
    func cancelReply()
}
extension DelegateReply {
    func cancelReply(){}
}

protocol DelegateMore : AnyObject{
    func selectedOption(_ item : Item)
}
extension DelegateMore {
    func selectedOption(_ item : Item){}
}

protocol DelegateInput : AnyObject{
    func sendTextMessage()
    func sendAudio(audioFilename : URL)
    func camera()
    func attach()
    func hideAttach()
}
extension DelegateInput {
    func sendTextMessage() {}
    func sendAudio(audioFilename: URL) {}
    func camera() {}
    func attach() {}
    func hideAttach() {}
}
protocol DelegateAudio : AnyObject{
    func sendAudio(audioFilename : URL)
}
extension DelegateAudio {
    func sendAudio(audioFilename : URL){}
}

