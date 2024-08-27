//
//  APIManager.swift
//  iOSChatSDK
//
//  Created by Ashwani on 23/07/24.
//

import Foundation

//MARK: - CLASS
class ChatMediaUpload {

    // Shared instance
    static let shared = ChatMediaUpload()
    private init() {}

    // Common function to upload media or file
    private func uploadMediaRequest(urlString: String, mediaRequest: SendMediaRequest, isImage: Bool, includeEventID: Bool, completion: @escaping (Result<SendMediaResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let bodyData = createBodyData(for: mediaRequest, boundary: boundary, isImage: isImage, includeEventID: includeEventID)
        request.httpBody = bodyData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            do {
                let uploadResponse = try JSONDecoder().decode(SendMediaResponse.self, from: data)
                completion(.success(uploadResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func sendImageFromGalleryAPICall(image: UIImage? = nil,
                                     video: URL? = nil,
                                     audio: URL? = nil,
                                     document: String? = nil,
                                     msgType: String,
                                     body: String? = nil,
                                     eventID: String? = nil,
                                     completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let roomID = UserDefaults.standard.string(forKey: "room_id"),
              let accessToken = UserDefaults.standard.string(forKey: "access_token") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing roomID or accessToken"])))
            return
        }

        let mimeTypeAndFileName = getMimeTypeAndFileName(for: msgType)
        let sendMediaRequest = SendMediaRequest(
            accessToken: accessToken,
            roomID: roomID,
            body: body ?? "",
            msgType: msgType,
            mimetype: mimeTypeAndFileName.mimeType,
            fileName: mimeTypeAndFileName.fileName,
            mediaType: mimeTypeAndFileName.mediaType,
            imageFilePath: image,
            videoFilePath: video ?? audio
        )

        uploadMediaRequest(urlString: "\(API.sendMedia)\(/sendMediaRequest.mediaType)", mediaRequest: sendMediaRequest, isImage: image != nil, includeEventID: false) { result in
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                    print("Success: \(response.message)")
                    completion(.success("Data sent successfully"))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }

    func uploadFileChatReply(replyRequest: SendMediaRequest, isImage: Bool = false, completion: @escaping (Result<SendMediaResponse, Error>) -> Void) {
        uploadMediaRequest(urlString: API.reply, mediaRequest: replyRequest, isImage: isImage, includeEventID: true, completion: completion)
    }

    public func getMimeTypeAndFileName(for msgType: String) -> (mimeType: String, fileName: String, mediaType: String) {
        switch msgType {
        case "m.image":
            return ("image/jpeg", "a1.jpg", "image")
        case "m.video":
            return ("video/mp4", "upload.mp4", "video")
        case "m.file":
            return ("application/x-python-code", "upload.py", "file")
        case "m.audio":
            return ("audio/mp3", "Audio File", "audio")
        default:
            return ("", "", "")
        }
    }

    private func createBodyData(for mediaRequest: SendMediaRequest, boundary: String, isImage: Bool, includeEventID: Bool) -> Data {
        var bodyData = Data()

        let parameters: [(String, String)] = [
            ("accessToken", mediaRequest.accessToken),
            ("roomID", mediaRequest.roomID),
            ("body", mediaRequest.body),
            ("msgType", mediaRequest.msgType),
            ("mimetype", mediaRequest.mimetype ?? ""),
            ("fileName", mediaRequest.fileName ?? "")
        ]

        for param in parameters {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"\(param.0)\"\r\n\r\n".data(using: .utf8)!)
            bodyData.append("\(param.1)\r\n".data(using: .utf8)!)
        }

        if includeEventID, let eventID = mediaRequest.eventID {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"eventID\"\r\n\r\n".data(using: .utf8)!)
            bodyData.append("\(eventID)\r\n".data(using: .utf8)!)
        }

        if isImage, let imageFilePath = mediaRequest.imageFilePath, let imageData = imageFilePath.jpegData(compressionQuality: 0.5) {
            bodyData.append(createFileData(boundary: boundary, fileName: mediaRequest.fileName, mimeType: mediaRequest.mimetype, fileData: imageData))
        } else if let videoFilePath = mediaRequest.videoFilePath, let videoData = try? Data(contentsOf: videoFilePath) {
            bodyData.append(createFileData(boundary: boundary, fileName: mediaRequest.fileName, mimeType: mediaRequest.mimetype, fileData: videoData))
        }

        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return bodyData
    }

    private func createFileData(boundary: String, fileName: String?, mimeType: String?, fileData: Data) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName ?? "")\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType ?? "")\r\n\r\n".data(using: .utf8)!)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        return data
    }
}

//class ChatMediaUpload {
//
//    // Shared instance
//    static let shared = ChatMediaUpload()
//    private init() {}
//    func sendImageFromGalleryAPICall(image: UIImage? = nil,
//                                     video: URL? = nil,
//                                     audio: URL? = nil,
//                                     document: String? = nil,
//                                     msgType: String,
//                                     body: String? = nil,
//                                     eventID: String? = nil,
//                                     completion: @escaping (Result<String, Error>) -> Void) {
//        
//        guard let roomID = UserDefaults.standard.string(forKey: "room_id"),
//              let accessToken = UserDefaults.standard.string(forKey: "access_token") else {
//            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing roomID or accessToken"])))
//            return
//        }
//        
//        let mimeTypeAndFileName = getMimeTypeAndFileName(for: msgType)
//        let sendMediaRequest = SendMediaRequest(
//            accessToken: accessToken,
//            roomID: roomID,
//            body: body ?? "",
//            msgType: msgType,
//            mimetype: mimeTypeAndFileName.mimeType,
//            fileName: mimeTypeAndFileName.fileName,
//            mediaType: mimeTypeAndFileName.mediaType,
//            imageFilePath: image,
//            videoFilePath: video ?? audio
//        )
//        
//        uploadFile(mediaRequest: sendMediaRequest) { result in
//            switch result {
//            case .success(let response):
//                DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
//                    print("Success: \(response.message)")
//                    completion(.success("Data sent successfully"))
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    print("Error: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    private func getMimeTypeAndFileName(for msgType: String) -> (mimeType: String, fileName: String, mediaType: String) {
//        switch msgType {
//        case "m.image":
//            return ("image/jpeg", "a1.jpg", "image")
//        case "m.video":
//            return ("video/mp4", "upload.mp4", "video")
//        case "m.file":
//            return ("application/x-python-code", "upload.py", "file")
//        case "m.audio":
//            return ("audio/mp3", "Audio File", "audio")
//        default:
//            return ("", "", "")
//        }
//    }
//    
//    func uploadFile(mediaRequest: SendMediaRequest, completion: @escaping (Result<SendMediaResponse, Error>) -> Void) {
//        guard let url = URL(string: "\(API.sendMedia)\(mediaRequest.mediaType)") else {
//            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        var bodyData = Data()
//        
//        let parameters: [(String, String)] = [
//            ("accessToken", mediaRequest.accessToken),
//            ("roomID", mediaRequest.roomID),
//            ("body", mediaRequest.body),
//            ("msgType", mediaRequest.msgType),
//            ("mimetype", mediaRequest.mimetype),
//            ("fileName", mediaRequest.fileName)
//        ]
//        
//        
//        for param in parameters {
//            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//            bodyData.append("Content-Disposition: form-data; name=\"\(param.0)\"\r\n\r\n".data(using: .utf8)!)
//            bodyData.append("\(param.1)\r\n".data(using: .utf8)!)
//        }
//        
//        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(mediaRequest.fileName)\"\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Type: \(mediaRequest.mimetype)\r\n\r\n".data(using: .utf8)!)
//        
//        if let imageFilePath = mediaRequest.imageFilePath {
//            if let imageData = imageFilePath.jpegData(compressionQuality: 0.5) {
//                bodyData.append(imageData)
//            } else {
//                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to process image"])))
//                return
//            }
//        } else if let videoFilePath = mediaRequest.videoFilePath {
//            do {
//                let videoData = try Data(contentsOf: videoFilePath, options: .alwaysMapped)
//                bodyData.append(videoData)
//            } catch {
//                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to process video"])))
//                return
//            }
//        }
//        
//        bodyData.append("\r\n".data(using: .utf8)!)
//        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        request.httpBody = bodyData
//        
//        DispatchQueue.global(qos: .background).async {
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                
//                guard let data = data else {
//                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                    return
//                }
//                
//                do {
//                    let uploadResponse = try JSONDecoder().decode(SendMediaResponse.self, from: data)
//                    completion(.success(uploadResponse))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        }
//    }
//    func uploadFileChatReply(replyRequest: ReplyMediaRequest, isImage: Bool = false, completion: @escaping (Result<SendMediaResponse, Error>) -> Void) {
//        
//        guard let url = URL(string: API.reply) else {
//            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        let bodyData = createBodyData(for: replyRequest, boundary: boundary, isImage: isImage)
//        request.httpBody = bodyData
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
//                return
//            }
//            
//            do {
//                let uploadResponse = try JSONDecoder().decode(SendMediaResponse.self, from: data)
//                completion(.success(uploadResponse))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//
//    private func createBodyData(for replyRequest: ReplyMediaRequest, boundary: String, isImage: Bool) -> Data {
//        var bodyData = Data()
//        
//        let parameters: [(String, String)] = [
//            ("accessToken", replyRequest.accessToken),
//            ("roomID", replyRequest.roomID),
//            ("eventID", replyRequest.eventID),
//            ("body", replyRequest.body),
//            ("msgType", replyRequest.msgType),
//            ("mimetype", replyRequest.mimetype ?? ""),
//            ("fileName", replyRequest.fileName ?? "")
//        ]
//        
//        for param in parameters {
//            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//            bodyData.append("Content-Disposition: form-data; name=\"\(param.0)\"\r\n\r\n".data(using: .utf8)!)
//            bodyData.append("\(param.1)\r\n".data(using: .utf8)!)
//        }
//        
//        if isImage, let imageFilePath = replyRequest.imageFilePath, let imageData = imageFilePath.jpegData(compressionQuality: 0.5) {
//            bodyData.append(createFileData(boundary: boundary, fileName: replyRequest.fileName, mimeType: replyRequest.mimetype, fileData: imageData))
//        } else if let videoFilePath = replyRequest.videoFilePath, let videoData = try? Data(contentsOf: videoFilePath) {
//            bodyData.append(createFileData(boundary: boundary, fileName: replyRequest.fileName, mimeType: replyRequest.mimetype, fileData: videoData))
//        }
//        
//        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        return bodyData
//    }
//
//    private func createFileData(boundary: String, fileName: String?, mimeType: String?, fileData: Data) -> Data {
//        var data = Data()
//        data.append("--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName ?? "")\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: \(mimeType ?? "")\r\n\r\n".data(using: .utf8)!)
//        data.append(fileData)
//        data.append("\r\n".data(using: .utf8)!)
//        return data
//    }
//}

//
//    func uploadFileChatReply(replyRequest: ReplyMediaRequest, isImage: Bool = false, completion: @escaping (Result<SendMediaResponse, Error>) -> Void) {
//
//        let url = URL(string: API.reply)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        var bodyData = Data()
//
//        // Access Token
//        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"accessToken\"\r\n\r\n".data(using: .utf8)!)
//        bodyData.append("\(replyRequest.accessToken)\r\n".data(using: .utf8)!)
//
//        // Room ID
//        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"roomID\"\r\n\r\n".data(using: .utf8)!)
//        bodyData.append("\(replyRequest.roomID)\r\n".data(using: .utf8)!)
//
//        // Event ID
//        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"eventID\"\r\n\r\n".data(using: .utf8)!)
//        bodyData.append("\(replyRequest.eventID)\r\n".data(using: .utf8)!)
//
//        // Body
//        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"body\"\r\n\r\n".data(using: .utf8)!)
//        bodyData.append("\(replyRequest.body)\r\n".data(using: .utf8)!)
//
//        // Message Type
//        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"msgType\"\r\n\r\n".data(using: .utf8)!)
//        bodyData.append("\(replyRequest.msgType)\r\n".data(using: .utf8)!)
//
//        // MIME Type
//        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"mimetype\"\r\n\r\n".data(using: .utf8)!)
//        bodyData.append("\(replyRequest.mimetype ?? "")\r\n".data(using: .utf8)!)
//
//        // File Name
//        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//        bodyData.append("Content-Disposition: form-data; name=\"fileName\"\r\n\r\n".data(using: .utf8)!)
//        bodyData.append("\(replyRequest.fileName ?? "")\r\n".data(using: .utf8)!)
//
//        // File Data
//        if isImage, let imageFilePath = replyRequest.imageFilePath, let imageData = imageFilePath.jpegData(compressionQuality: 0.5) {
//            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//            bodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(replyRequest.fileName ?? "")\"\r\n".data(using: .utf8)!)
//            bodyData.append("Content-Type: \(replyRequest.mimetype ?? "")\r\n\r\n".data(using: .utf8)!)
//            bodyData.append(imageData)
//        } else {
//            // For other media types, such as video
//            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
//            bodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(replyRequest.fileName ?? "")\"\r\n".data(using: .utf8)!)
//            bodyData.append("Content-Type: \(replyRequest.mimetype ?? "")\r\n\r\n".data(using: .utf8)!)
//            // Append the video data here
//            // bodyData.append(videoData)
//        }
//
//        bodyData.append("\r\n".data(using: .utf8)!)
//        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        request.httpBody = bodyData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
//                completion(.failure(error))
//                return
//            }
//
//            do {
//                let uploadResponse = try JSONDecoder().decode(SendMediaResponse.self, from: data)
//                completion(.success(uploadResponse))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
