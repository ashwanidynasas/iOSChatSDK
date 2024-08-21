//
//  UserService.swift
//  iOSChatSDK
//
//  Created by Ashwani on 26/06/24.
//

import Foundation

public struct User: Codable {
    public let username: String
    public let password: String
    public let loginJWTtoken: String
}

public struct UserResponse: Codable {
    public let success: Bool
    public let message: String
    public let redirectUrl: String
    public let details: Details
    
    public struct Details: Codable {
        public let users: [User]
    }
}

public class UserService {
    public init() {}
    
    public func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: "http://157.241.58.41/chat_api/list-user-apple")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set headers if needed
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add any necessary body data
        // request.httpBody = ... // If there's any body data to include
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(.success(userResponse.details.users))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

