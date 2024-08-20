//
//  APIManager.swift
//  iOSChatSDK
//
//  Created by Ashwani on 23/07/24.
//

import Foundation

//MARK: - CLASS
class APIManager {

    // Shared instance
    static let shared = APIManager()
    private let mediaViewModel = ChatMediaViewModel()
    private init() {}

    // Function to send image, video, audio, or document with completion handler
    func sendImageFromGalleryAPICall(image: UIImage? = nil, 
                                     video: URL? = nil,
                                     audio: URL? = nil,
                                     document: String? = nil,
                                     msgType: String,
                                     body:String? = nil,
                                     eventID:String? = nil, 
                                     completion: @escaping (Result<String, Error>) -> Void) {
        
        // Simulate an API call with a delay
        let roomID = UserDefaults.standard.string(forKey: "room_id")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        let body = body
        print("msg type ---> \(msgType)")
        
        var mimetype:String!
        var mediaType:String!
        var fileName:String!
        
        switch msgType {
        case "m.image":
            mimetype = "image/jpeg"
            mediaType = "image"
            fileName = "a1.jpg"
        case "m.video":
            mimetype = "video/mp4"
            mediaType = "video"
            fileName = "upload.mp4"
        case "m.file" :
            mimetype = "application/x-python-code"
            mediaType = "file"
        case "m.audio":
            mimetype = "audio/mp3"
            mediaType = "audio"
            fileName = "Audio File"
        default:
            print(msgType)
        }
        
        
        if mediaType == "image"{
            mediaViewModel.uploadFile(accessToken: /accessToken, 
                                      roomID: /roomID, 
                                      body: /body,
                                      msgType: msgType, 
                                      mimetype: mimetype,
                                      fileName: /fileName,
                                      imageFilePath: image,
                                      mediaType: mediaType) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                        print("Success: \(response.message)")
                        completion(.success("Data sent successfully"))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        else if (mediaType == "audio"){
            mediaViewModel.uploadFile(accessToken: /accessToken, 
                                      roomID: /roomID,
                                      body: /body, 
                                      msgType: msgType,
                                      mimetype: mimetype,
                                      fileName: /fileName, 
                                      videoFilePath: audio,
                                      mediaType: mediaType) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                        print("Success: \(response.message)")
                        completion(.success("Data sent successfully"))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }else{
            mediaViewModel.uploadFile(accessToken: /accessToken, 
                                      roomID: /roomID, 
                                      body: /body,
                                      msgType: msgType, 
                                      mimetype: mimetype,
                                      fileName: /fileName,
                                      videoFilePath: video,
                                      mediaType: mediaType) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                        print("Success: \(response.message)")
                        completion(.success("Data sent successfully"))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }

    }
}
