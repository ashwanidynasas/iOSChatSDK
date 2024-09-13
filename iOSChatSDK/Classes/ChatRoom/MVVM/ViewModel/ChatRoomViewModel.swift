//
//  MessageViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

//MARK: - MODULES
import Foundation



//MARK: - CLASS
open class ChatRoomViewModel : NSObject{
    
    //MARK: - PROPERTIES
    public var connection : Connection?
    public var accessToken : String?
    public var messages: [Messages] = []
    
    public var service : ChatService?
    public let apiClient = ChatViewModel()
    
    public var onUpdate: (() -> Void)?
    
    required public init(connection: Connection?, accessToken: String?, curreuntUser: String?) {
        super.init()
        self.service = ChatService()
        self.connection = connection
        self.accessToken = accessToken
        
        UserDefaultsHelper.setCurrentUser("@\(/curreuntUser)=circle:chat.sqrcle.co")

        createRoomCall()
    }

    //MARK: - FUNCTIONS
    func createRoomCall(){
        
        apiClient.createRoom(accessToken: /accessToken,
                             invitees: [/connection?.chatUserId],
                             defaultChat: true) { (success, result) in
            if success{
                let roomId = result
                print("Room created successfully with ID: \(roomId)")
                let room_id = UserDefaults.standard.string(forKey: "room_id")
                print("room_id: \(room_id ?? "")")
            }else{
                print("Failed to create room: \(result)")
            }
        }
    }
    
    
    func getMessages() {

//        guard let room_id = UserDefaultsHelper.getRoomId() else { return }
        service = ChatService(configuration: .default)
        service?.getMessages(roomId: /connection?.roomID, accessToken : /accessToken , completion: { (result, headers) in
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
    
    func sendMessage(body: String,
                     msgType: String,
                     completion: @escaping (ChatMessageResponse?) -> Void) {
        service = ChatService(configuration: .default)
        service?.sendMessage(body: body,
                             msgType: msgType,
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
    
    func redactMessage(eventID: String, completion: @escaping (Result<String?, Error>) -> Void) {
        
        let request = MessageRedactRequest(
            accessToken: /accessToken,
            roomID: /UserDefaultsHelper.getRoomId(),
            eventID: /eventID,
            body: "spam"
        )
        
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
    
    func sendAudioMedia(audioFilename : URL, completion: @escaping (Result<String?, Error>) -> Void) {
        ChatMediaUpload.shared.sendImageFromGalleryAPICall(audio: audioFilename, msgType: "m.audio", body:"") { result in
            switch result {
            case .success(let message):
                print("Success: \(message)")
                // Update UI or perform other actions on success
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        completion(.success("Message sent successfully"))
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                // Handle error or show an alert
            }
        }
    }
    
    func sendMedia(replyRequests : SendMediaRequest, completion: @escaping (Result<String?, Error>) -> Void) {
        ChatMediaUpload.shared.uploadFileChatReply(replyRequest:replyRequests,isImage: false){ result in
            switch result {
            case .success(_):
                completion(.success("Message sent successfully"))
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func sendReply(body : String , eventID : String, completion: @escaping (Result<SendMediaResponse, Error>) -> Void) {
        let replyRequests = SendMediaRequest(accessToken: /accessToken,
                                             roomID: /connection?.roomID,
                                             body: body,
                                             msgType: /MessageType.text,
                                             eventID: eventID)
        
        ChatMediaUpload.shared.uploadFileChatReply(replyRequest:replyRequests,isImage: false){ result in
            switch result {
            case .success(_):
                completion(result)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
