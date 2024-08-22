//
//  SenderViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 01/07/24.
//

import Foundation



struct ChatMessageResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: ChatMessageDetails
}

struct ChatMessageDetails: Codable {
    let response: String
    let chat_event_id: String
}

class SenderViewModel {
    
    //var chatMessageResponse: ChatMessageResponse?
    
    func sendMessage(roomID: String, 
                     body: String,
                     msgType: String,
                     accessToken: String,
                     completion: @escaping (ChatMessageResponse?) -> Void) {
        
        guard let url = URL(string: API.sendText) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let chatMessageRequest = ChatMessageRequest(roomID: roomID, body: body, msgType: msgType, accessToken: accessToken)
        
        do {
            let jsonData = try JSONEncoder().encode(chatMessageRequest)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode request: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making API call: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let chatMessageResponse = try JSONDecoder().decode(ChatMessageResponse.self, from: data)
                completion(chatMessageResponse)
            } catch {
                print("Failed to decode response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
