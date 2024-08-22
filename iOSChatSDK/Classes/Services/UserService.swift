//
//  UserService.swift
//  iOSChatSDK
//
//  Created by Ashwani on 26/06/24.
//

import Foundation


public class UserService {
    public init() {}
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: API.fetchUserlist)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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

