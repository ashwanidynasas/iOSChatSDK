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
