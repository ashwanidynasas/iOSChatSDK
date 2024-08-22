//
//  ConnectionViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

//MARK: - MODULES
import Foundation

//MARK: - CLASS
class ConnectionViewModel {
    
    //MARK: - PROPERTIES
    private var service : ChatService?
    var connections: [Connection] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    var bindViewModelToController: (() -> ()) = {}
    
    
    //MARK: - FUNCTIONS
    func fetchConnections(circleId: String, circleHash: String) {
        service = ChatService(configuration: .default)
        let parameter = FetchConnectionsParameter(circleId: circleId, circleHash: circleHash)
        
        service?.listConnections(parameters: parameter, completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let success = value?.success, success {
                    self.connections = value?.details.connections ?? []
                } else {
                    print(/value?.message)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

//MARK: - CLASS
class LoginViewModel {
    
    //MARK: - PROPERTIES
    private var service : ChatService?
    var loginResponse: LoginResponse? {
        didSet {
            if let token = loginResponse?.details.accessToken {
                UserDefaults.standard.set(token, forKey: "access_token")
            }
            self.bindViewModelToController()
        }
    }

    var bindViewModelToController: (() -> ()) = {}
    
    //MARK: - FUNCTIONS
    func login(username: String, loginJWTToken: String, completion: @escaping (String?) -> Void) {
        
        service = ChatService(configuration: .default)
        let parameter = LoginParameter(username: username, loginJWTToken: loginJWTToken)
        
        service?.login(parameters: parameter, completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let success = value?.success, success {
                    self.loginResponse = value
                    completion(value?.details.accessToken)
                } else {
                    print(/value?.message)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func fetchAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
}

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: Details
}

struct Details: Codable {
    let accessToken: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case response
    }
}



struct API{
    
    static let createRoom = "http://157.241.58.41/chat_api/room/create"
    static let fetchUserlist = "http://157.241.58.41/chat_api/list-user-apple"
    static let sendMedia = "http://157.241.58.41/chat_api/message/send/"
    static let reply = "http://157.241.58.41/chat_api/message/reply"
}
