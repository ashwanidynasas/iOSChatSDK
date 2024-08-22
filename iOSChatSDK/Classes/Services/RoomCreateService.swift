//
//  RoomCreateService.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

import Foundation

// Request model
struct CreateRoomRequest: Codable {
    let accessToken: String
    let invitees: [String]
    let default_chat: Bool
}

// Response model
struct CreateRoomResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: RoomDetails
}

struct RoomDetails: Codable {
    let room_id: String
    let response: String
}

class RoomAPIClient {
    
    var createResponse: CreateRoomResponse? {
        didSet {
            if let token = createResponse?.details.room_id {
                UserDefaults.standard.set(token, forKey: "room_id")
            }
        }
    }
    
    func createRoom(accessToken: String, invitees: [String], defaultChat: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: API.createRoom)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = CreateRoomRequest(accessToken: accessToken, invitees: invitees, default_chat: defaultChat)
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "ResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(.failure(error))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(CreateRoomResponse.self, from: data)
                    if response.success {
                        self.createResponse = response
                        completion(.success(response.details.room_id))
                    } else {
                        let error = NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
