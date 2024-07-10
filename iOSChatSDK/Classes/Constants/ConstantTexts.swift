//
//  ConstantTexts.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation

enum AlertDisplayText: String {
    case api_error = "API Error"
    case copyToClipboard = "Copied to clipboard"
}

enum AuthDisplayText: String {
    
    case appName = "SQRCLE"
    case welcome = "WELCOME TO SQRCLE"
    case enterMobile = "Enter mobile/Email for OTP"
    case agreeWithMe = "By signing up you agree to our\n"
    case privacyPolicy = "Privacy Policy"
    case terms = "Terms of Use."
    case sendOtp = "Send OTP"
    case alreadyMember = "Already a member?"
    case enterYourMobile = "000 000 0000"
    case enterYourMobileOrEmail = "MOBILE NUMBER or EMAIL"
    case enterUserId = "Enter userID"
    case enterPassword = "Enter password"
    case userName = "Username"
    case confirmPassword = "Confirm password"
    case login = "Login"
    case sendTo = "Sent to +91"
    case resendOtp = "Resend OTP"
    case inText = "in"
    case seconds = "seconds"
    case confirm = "Confirm"
    case next = "Next"
    case english = "English  "
    case codeSentTo = "Enter SMS code sent to \n"
    case copyId = "Save the login ID for next logins. If you lose, you won't have access to your account."
    case passwordInstruction = "Password must have atleast 8 letters include one capital letter, one  special character and one numeral"
    case createPassword = "Create Password"
    case reEnterPassword = "Re enter Password"
    case userId = "User ID"
    case add = "Add"
    case edit = "Edit"
    case enterDetails = "Enter your details"
    case name = "Name*"
    case status = "Status"
    case chooseInterest = "Choose your interest"
    case selected = "Selected"
    case typeOfCOI = "What type of COI are you?"
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue.localizedString(), comment: "")
    }
}

enum HomeDisplayText: String {
    
    case noFriendsToDisplay = "No friends to display"
    case inviteFriends = "Invite friends and start sqrcling"
    case connectFriends = "Add friends to start connecting them"
    case createNewGroup = "Create new group"
    case noGroup = "No groups to display create new groups and start chatting with your friends"
    case nothingToDisplay = "Nothing to display"
    case addPeopleToCircle = "Please add people to your circle and start exploring"
    case addPeople = "Add People"
    case noCOIToDisplay = "No COI to display"
    case addCOIToCircle = "Click the “+” button below to create COI"
    case privateGroups = "Private groups"
    case privatee = "Private"
    case invite = "Invite"
    case sharePost = "Share Post"
    case newPost = "New Post"
    case editCOI = "Edit COI"
    case fans = "fans"
    case comments = "Comments"
    case reactions = "Reactions"
    case viewMore = "View More"
    case importVioletProfile = "Import violet profile"
    case finish = "Finish"
    case typeName = "Type name here"
    case typeDescription = "type description..."
    case post = "Post"
    case location = "Location"
    case caption = "Caption"
    case add = "Add"
    case edit = "Edit"
    case publicCOI = "Public COI"
    case enterCaption = "Enter caption here"
    case enterHere = "Enter here"
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue.localizedString(), comment: "")
    }
}



extension String{
    var localized: String {
        return NSLocalizedString(self.localizedString(), comment: "")
    }
}
