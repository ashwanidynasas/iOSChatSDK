//
//  UserViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

import Foundation

public class UserViewModel {
    
    private var userService: UserService
    public var users: [User] = []
    public var errorMessage: String?
    
    public var usersDidChange: (() -> Void)?
    public var errorDidChange: (() -> Void)?
    
    public init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    public func fetchUsers() {
        userService.fetchUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.usersDidChange?()
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.errorDidChange?()
            }
        }
    }
}
