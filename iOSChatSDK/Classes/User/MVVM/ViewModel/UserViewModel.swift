//
//  UserViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

//MARK: - MODULES
import Foundation

//MARK: - CLASS
public class UserViewModel {
    
    //MARK: - PROPERTIES
    private var userService: UserService
    public var users: [User] = []
    public var errorMessage: String?
    
    public var usersDidChange: (() -> Void)?
    public var errorDidChange: (() -> Void)?
    
    public init(userService: UserService = UserService()) {
        self.userService = userService
    }
   
    //MARK: - FUNCTIONS
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
