//
//  MessageViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

//MARK: - MODULES
import Foundation

//MARK: - CLASS
class MessageViewModel {
    
    //MARK: - PROPERTIES
    var messages: [Messages] = []
    private var service : ChatService?
    
    var onUpdate: (() -> Void)?

    //MARK: - FUNCTIONS
    func getMessages(accessToken: String) {
        guard let room_id = UserDefaults.standard.string(forKey: "room_id") else { return }
        service = ChatService(configuration: .default)
        service?.getMessages(roomId: room_id, accessToken : accessToken , completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let messages = value?.chunk {
                    let filteredMessages = messages.filter { message in
                            message.type == "m.room.message" && message.content != nil && message.content?.msgtype != nil
                        }
                    self.messages = filteredMessages.sorted { $0.originServerTs ?? 0 < $1.originServerTs ?? 0 }
                } else {
                    print("No messages found in response")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}
