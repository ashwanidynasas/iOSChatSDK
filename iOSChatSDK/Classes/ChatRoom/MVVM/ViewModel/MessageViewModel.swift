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
        guard let room_id = UserDefaultsManager.roomID else { return }
        service = ChatService(configuration: .default)
        service?.getMessages(roomId: room_id, accessToken : accessToken , completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let messages = value?.chunk {
                    let filteredMessages = messages.filter { message in
                        message.type == MessageType.roomMsg && message.content != nil && message.content?.msgtype != nil
                        }
                    self.messages = filteredMessages.sorted { $0.originServerTs ?? 0 < $1.originServerTs ?? 0 }
                    self.onUpdate?()
                } else {
                    print("No messages found in response")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func sendMessage(roomID: String,
                     body: String,
                     msgType: String,
                     accessToken: String,
                     completion: @escaping (ChatMessageResponse?) -> Void) {
        service = ChatService(configuration: .default)
        service?.sendMessage(roomID: roomID,
                             body: body,
                             msgType: msgType,
                             accessToken: accessToken,
                             completion: { (result, headers) in
            
            switch result {
            case .success(let value):
                if let success = value?.success, success {
                    completion(value)
                } else {
                    print(/value?.message)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func redactMessage(request: MessageRedactRequest, completion: @escaping (Result<String?, Error>) -> Void) {
        service = ChatService(configuration: .default)
        service?.redactMessage(request: request, completion: { (result, headers) in
            
            switch result {
            case .success(let value):
                if let success = value?.success, success {
                    completion(.success("Message deleted successfully"))
                } else {
                    print(/value?.message)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    
}
