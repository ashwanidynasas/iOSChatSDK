//
//  MessageViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

import Foundation

class MessageViewModel {
    var messages: [Messages] = []
    var onUpdate: (() -> Void)?

    func fetchMessages(accessToken: String) {
        let room_id = UserDefaults.standard.string(forKey: "room_id")
        print("room_id ChatRoomAPIClient: \(room_id ?? "")")

        guard let url = URL(string: "http://chat.sqrcle.co/_matrix/client/r0/rooms/\(room_id ?? "")/messages?dir=b") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let messageResponse = try decoder.decode(MessageResponse.self, from: data)

                if let messages = messageResponse.chunk {
                    let filteredMessages = messages.filter { message in
                            message.type == "m.room.message" && message.content != nil && message.content?.msgtype != nil
                        }
                    self?.messages = filteredMessages.sorted { $0.originServerTs ?? 0 < $1.originServerTs ?? 0 }
                } else {
                    print("No messages found in response")
                }
                DispatchQueue.main.async {
                    self?.onUpdate?()
                }
            } catch {
                print("Error decoding messages: \(error)")
            }
        }
        
        task.resume()
    }
}
