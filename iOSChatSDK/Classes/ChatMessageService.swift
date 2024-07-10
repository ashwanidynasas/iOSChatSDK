//
//  ChatMessageService.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

import Foundation

struct MessageResponse: Codable {
    let chunk: [Messages]?
    let start: String?
    let end: String?
}

struct Messages: Codable {
    let type: String?
    let roomId: String?
    let sender: String?
    let content: MessageContent?
    let originServerTs: Int?
    let unsigned: Unsigned?
    let eventId: String?
    let userId: String?
    let age: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case roomId = "room_id"
        case sender
        case content
        case originServerTs = "origin_server_ts"
        case unsigned
        case eventId = "event_id"
        case userId = "user_id"
        case age
    }
}

struct MessageContent: Codable {
    let msgtype: String?
    let body: String?
    let url: String?
    let format: String?
    let formattedBody: String?
    let relatesTo: RelatesTo?
    let info: Info?

    enum CodingKeys: String, CodingKey {
        case msgtype
        case body
        case url
        case format
        case formattedBody = "formatted_body"
        case relatesTo = "m.relates_to"
        case info
    }
}

struct RelatesTo: Codable {
    let inReplyTo: InReplyTo?

    enum CodingKeys: String, CodingKey {
        case inReplyTo = "m.in_reply_to"
    }
}

struct InReplyTo: Codable {
    let eventId: String?

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
    }
}
struct Info: Codable {
    let mimetype: String?
}
struct Unsigned: Codable {
    let age: Int?
}

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
                    self?.messages = messages.sorted { $0.originServerTs ?? 0 < $1.originServerTs ?? 0 }
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
