//
//  ChatService.swift
//  iOSChatSDK
//
//  Created by Dynasas on 22/08/24.
//

//MARK: - MODULES
import Foundation
import UIKit

//MARK: - CLASS
open class ChatService: GenericClient {
    
    typealias T = ConnectionResponse
    var showLoader: Bool = true
    internal let session: URLSession
    
    public init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    public convenience init() {
        self.init(configuration: .default)
    }
    
    //MARK: - list connections
    func login(showloader: Bool = false,
               parameters : ChatLoginParameter,
               completion: @escaping (Result<LoginResponse?, APIError>, [AnyHashable : Any]?) -> ()) {
        self.showLoader = showloader
        guard let request = ChatServiceEndPoint.login.postRequest(parameters: parameters, headers: []) else {
            completion(.failure(.invalidRequestURL), nil)
            return
        }
        fetch(with: request, showloader: showloader, decode: { json -> LoginResponse? in
            guard let results = json as? LoginResponse else { return  nil }
            return results
        }, completion: completion)
    }
    
    //MARK: - list connections
    func listConnections(showloader: Bool = false,
                         parameters: FetchConnectionsParameter,
                         completion: @escaping (Result<ConnectionResponse?, APIError>, [AnyHashable : Any]?) -> ()) {
        self.showLoader = showloader
        guard let request = ChatServiceEndPoint.listConnecttions.postRequest(parameters: parameters, headers: []) else {
            completion(.failure(.invalidRequestURL), nil)
            return
        }
        fetch(with: request, showloader: showloader, decode: { json -> ConnectionResponse? in
            guard let results = json as? ConnectionResponse else { return  nil }
            return results
        }, completion: completion)
    }
    
    func getMessages(showloader: Bool = false,
                     roomId: String,
                     accessToken: String,
                     completion: @escaping (Result<MessageResponse?, APIError>, [AnyHashable : Any]?) -> ()) {
        self.showLoader = showloader
        let headers = [HTTPHeader.authorization(accessToken)]
        guard let request = ChatServiceEndPoint.getMessages(roomId: roomId, limit: "1000").getRequest(parameters: nil, headers: headers) else {
            completion(.failure(.invalidRequestURL), nil)
            return
        }
        fetch(with: request, showloader: showloader, decode: { json -> MessageResponse? in
            guard let results = json as? MessageResponse else { return  nil }
            return results
        }, completion: completion)
    }
    
    func sendMessage(showloader: Bool = false,
                     body: String,
                     msgType: String,
                     completion: @escaping (Result<ChatMessageResponse?, APIError>, [AnyHashable : Any]?) -> ()) {
        
        self.showLoader = showloader
        print("room id \(/UserDefaultsHelper.getRoomId())")
        let parameters = ChatMessageRequest(roomID: /UserDefaultsHelper.getRoomId(),
                                            body: body,
                                            msgType: msgType,
                                            accessToken: /UserDefaultsHelper.getAccessToken())
        guard let request = ChatServiceEndPoint.sendText.postRequest(parameters: parameters, headers: []) else {
            completion(.failure(.invalidRequestURL), nil)
            return
        }
        fetch(with: request, showloader: showloader, decode: { json -> ChatMessageResponse? in
            guard let results = json as? ChatMessageResponse else { return  nil }
            return results
        }, completion: completion)
    }
    
    func redactMessage(showloader: Bool = false,
                       request: MessageRedactRequest,
                       completion: @escaping (Result<ChatMessageResponse?, APIError>, [AnyHashable : Any]?) -> ()) {
        
        self.showLoader = showloader
//        let headers = [HTTPHeader.authorization(request.accessToken)]
        guard let request = ChatServiceEndPoint.redactMessage.postRequest(parameters: request, headers: []) else {
            completion(.failure(.invalidRequestURL), nil)
            return
        }
        fetch(with: request, showloader: showloader, decode: { json -> ChatMessageResponse? in
            guard let results = json as? ChatMessageResponse else { return  nil }
            return results
        }, completion: completion)
    }
}



//MARK: - REQUEST PARAMETERS
struct ChatLoginParameter: DictionaryEncodable {
    var username: String
    var loginJWTToken : String
    
}

struct FetchConnectionsParameter: DictionaryEncodable {
    var circleId: String
    var circleHash : String
    
}


struct ChatMessageRequest: Codable {
    let roomID: String
    let body: String
    let msgType: String
    let accessToken: String
}


struct MessageRedactRequest: Codable {
    let accessToken: String
    let roomID: String
    let eventID: String
    let body: String
}


//Media Request
struct SendMediaRequest: Codable {
    let accessToken: String
    let roomID: String
    let body: String
    let msgType: String
    let mimetype: String?
    let fileName: String?
    let mediaType: String?
    let eventID: String?
    var imageFilePath: UIImage? = nil
    var videoFilePath: URL? = nil

    enum CodingKeys: String, CodingKey {
        case accessToken
        case roomID
        case eventID
        case body
        case msgType
        case mimetype
        case fileName
        case mediaType
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(roomID, forKey: .roomID)
        try container.encode(eventID, forKey: .eventID)
        try container.encode(body, forKey: .body)
        try container.encode(msgType, forKey: .msgType)
        try container.encode(mimetype, forKey: .mimetype)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(mediaType, forKey: .mediaType)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        roomID = try container.decode(String.self, forKey: .roomID)
        eventID = try container.decode(String.self, forKey: .eventID)
        body = try container.decode(String.self, forKey: .body)
        msgType = try container.decode(String.self, forKey: .msgType)
        mimetype = try container.decode(String.self, forKey: .mimetype)
        fileName = try container.decode(String.self, forKey: .fileName)
        mediaType = try container.decode(String.self, forKey: .mediaType)
        imageFilePath = nil
        videoFilePath = nil
    }
    
    init(accessToken: String, roomID: String, body: String, msgType: String, mimetype: String? = nil, fileName: String? = nil, mediaType: String? = "",eventID:String? = "", imageFilePath: UIImage? = nil, videoFilePath: URL? = nil) {
        self.accessToken = accessToken
        self.roomID = roomID
        self.body = body
        self.msgType = msgType
        self.mimetype = mimetype
        self.fileName = fileName
        self.mediaType = mediaType
        self.imageFilePath = imageFilePath
        self.videoFilePath = videoFilePath
        self.eventID = eventID
    }
}

struct ReplyMediaRequest {
    let accessToken: String
    let roomID: String
    let eventID: String
    let body: String
    let msgType: String
    let mimetype: String?
    let fileName: String?
    let imageFilePath: UIImage?
    let videoFilePath: URL?
    
    init(
        accessToken: String,
        roomID: String,
        eventID: String,
        body: String,
        msgType: String,
        mimetype: String? = nil,
        fileName: String? = nil,
        imageFilePath: UIImage? = nil,
        videoFilePath: URL? = nil
    ) {
        self.accessToken = accessToken
        self.roomID = roomID
        self.eventID = eventID
        self.body = body
        self.msgType = msgType
        self.mimetype = mimetype
        self.fileName = fileName
        self.imageFilePath = imageFilePath
        self.videoFilePath = videoFilePath
    }
}
