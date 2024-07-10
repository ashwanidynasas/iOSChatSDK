//
//  QuickMenuItem.swift
//  SQRCLE
//
//  Created by Dynasas on 06/12/23.
//

import Foundation
import UIKit

enum QuickMenu : String , CaseIterable{
    case accept   = "quickAccept"
    case reject   = "quickReject"
    
    case pin      = "quickPin"
    case profile  = "quickProfile"
    case mute     = "quickMute"
    case fans     = "quickFans"
    case posts    = "quickPosts"
    
    case unfollow = "quickUnfollow"
    case block , unblock  = "quickBlock"
    
    case follow     = "quickFollow"
    case remove    = "quickRemove"

}
