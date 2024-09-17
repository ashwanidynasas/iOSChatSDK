//
//  ConnectionViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

//MARK: - MODULES
import Foundation

//MARK: - CLASS
public class ConnectionViewModel : NSObject{
    
    //MARK: - PROPERTIES
    private var service : ChatService?
    
    var circleId : String?
    var circleHash : String?
    var connections: [Connection] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    var bindViewModelToController: (() -> ()) = {}
    
    required init(circleId: String, circleHash : String) {
        super.init()
        self.service = ChatService()
        self.circleId = circleId
        self.circleHash = circleHash
//        UserDefaultsHelper.setCurrentUser("@\(/circleHash):chat.sqrcle.co")
        fetchConnections()
    }
    
    //MARK: - FUNCTIONS
    func fetchConnections() {
        let parameter = FetchConnectionsParameter(circleId: /circleId,
                                                  circleHash: /circleHash)
        
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
open class ChatViewModel {
    
    //MARK: - PROPERTIES
    open var service : ChatService?
    
    open var loginResponse: LoginResponse? {
        didSet {
            if let token = loginResponse?.details.accessToken {
                UserDefaultsHelper.setAccessToken(token)
            }
            self.bindViewModelToController()
        }
    }
    
    open var createResponse: CreateRoomResponse? {
        didSet {
            if let room = createResponse?.details.room_id {
                UserDefaultsHelper.setRoomId(room)
            }
        }
    }
    
    var bindViewModelToController: (() -> ()) = {}

    //MARK: - INITIALIZER
    public init() {}
    
    //MARK: - FUNCTIONS
    open func login(username: String, loginJWTToken: String, completion: @escaping (String?) -> Void) {
        
        service = ChatService(configuration: .default)
        let parameter = ChatLoginParameter(username: username, loginJWTToken: loginJWTToken)
        
        service?.login(parameters: parameter, completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let success = value?.success, success {
                    self.loginResponse = value
                    completion(value?.details.accessToken)
                } else {
                    print(/value?.message)
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    open func createRoom(accessToken: String,
                         invitees: [String],
                         defaultChat: Bool,
                         completion: @escaping (Bool, String) -> Void) {
        
        guard let url = URL(string: API.createRoom) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = CreateRoomRequest(accessToken: accessToken, invitees: invitees, default_chat: defaultChat)
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(false , error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "ResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(false , error.localizedDescription)
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(CreateRoomResponse.self, from: data)
                    if response.success {
                        self.createResponse = response
                        completion(true, response.details.room_id)
                    } else {
                        let error = NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                        completion(false , error.localizedDescription)
                    }
                } catch {
                    completion(false , error.localizedDescription)
                }
            }
            
            task.resume()
        } catch {
            completion(false , error.localizedDescription)
        }
    }
    
}


//MARK: - MODELS

public struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: Details
}

public struct Details: Codable {
    let accessToken: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case response
    }
}

public struct CreateRoomRequest: Codable {
    let accessToken: String
    let invitees: [String]
    let default_chat: Bool
}

// Response model
public struct CreateRoomResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: RoomDetails
}

public struct RoomDetails: Codable {
    let room_id: String
    let response: String
}

