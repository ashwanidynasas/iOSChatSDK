//
//  SQRMacros.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import UIKit

let APPLICATION = UIApplication.shared
let KEY_WINDOW = APPLICATION.windows.filter {$0.isKeyWindow}.first
let APP_DELEGATE = APPLICATION.delegate
let USERID_LENGTH = 16
let PASSWORD_FIELD_LENGTH = 16

let EMAIL_ADDRESS_LENGTH = 30
let NAME_FIELD_LENGTH = 22
let DESCRIPTION_FIELD_LENGTH = 140
let USERNAME_FIELD_LENGTH = 25
let CIRCLE_PROFILE_IMAGE = "circle_profile_image"
let COI_PROFILE_IMAGE = "coi_profile_image"
let JPEG = "jpeg"
let PNG = "png"
let EMPTY_STR = ""

let dcWidth = ((UIScreen.main.bounds.width * 0.89) - 80)/3

enum APPNIBNAME: String {
    case buttonWithTextView = "SQRButtonWithTextView"
}

enum Placeholders: String {
    case profile   = "placeholder_profile"
    case postImage = "placeholder_image"
    case postVideo = "placeholder_video"
    case postAudio = "placeholder_audio"
    case postText  = "placeholder_text"
}

struct Videos {
    
    static let coi = [
        "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-banners/Test1.mp4",
        "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Earn/13.mp4"
    
    ]
    
    static let earn =
    
    ["https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Earn/4.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Earn/13.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Earn/14.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Earn/2.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Earn/3.mp4"]
     
    static let spend  =
    ["https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/1.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/10.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/11.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/7.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/9.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/5.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/6.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/23.mp4",
     "https://d24p0kf6wpiidw.cloudfront.net/Sqrcle-Hero/SQRCLES Hero Videos/Spend/25.mp4"]
    
    
}


struct DC{
    static let temp = [DataComponent(img: "localDC", selectedImg: nil ,title: "Poker", index: 0, quickMenuItems: nil, isSelected: false),
                                DataComponent(img: "localDC", selectedImg: nil, title: "Soccer", index: 1, quickMenuItems: nil, isSelected: false),
                                DataComponent(img: "localDC", selectedImg: nil, title: "Bingo", index: 2, quickMenuItems: nil, isSelected: false),
                                DataComponent(img: "localDC", selectedImg: nil,title: "Wordy", index: 3, quickMenuItems: nil, isSelected: false),
                                DataComponent(img: "localDC", selectedImg: nil, title: "Rummy", index: 4, quickMenuItems: nil, isSelected: false)]
    
    static let temp2 = [DataComponent(img: "localDC", selectedImg: nil ,title: "Poker", index: 0, quickMenuItems: nil, isSelected: false),
                                DataComponent(img: "localDC", selectedImg: nil, title: "Soccer", index: 1, quickMenuItems: nil, isSelected: false),
                                DataComponent(img: "localDC", selectedImg: nil, title: "Bingo", index: 2, quickMenuItems: nil, isSelected: false),
                                ]
    
    static let temp3 = [DataComponent(title: "Paid to Saurabh", subtitle: "18:25, 13/02/2022", value: "-10", circle: .Red),
                        DataComponent(title: "Received from Sarah", subtitle: "18:25, 13/02/2022", value: "+19", circle: .Green),
                        DataComponent(title: "Received from Qiwi Exc.", subtitle: "18:25, 13/02/2022", value: "-10", circle: .Yellow),
                        DataComponent(title: "Paid to Saurabh", subtitle: "18:25, 13/02/2022", value: "+40", circle: .Violet),
                        DataComponent(title: "Paid to Saurabh", subtitle: "18:25, 13/02/2022", value: "-10", circle: .Blue),]
    
    static let temp4 = [DataComponent(title: "1ZC = 1.5 FIAT", text: "ALS"),
                        DataComponent(title: "1ZC = 2 FIAT"  , text: "BRS"),
                        DataComponent(title: "1ZC = 3 FIAT"  , text: "Al Ansari"),
                        DataComponent(title: "1ZC = 3 FIAT"  , text: "IQT"),
                        DataComponent(title: "1ZC = 10 FIAT" , text: "Saraf Exchange")]
}
