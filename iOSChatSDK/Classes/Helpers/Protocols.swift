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
    func itemDeleteFromChat(_ didSendData: String)
}

protocol DelegatePlay : AnyObject{
    func didTapPlayButton(in cell: UITableViewCell)
    func didLongPressPlayButton(in cell: UITableViewCell)
}

