//
//  ChatReplyViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 29/07/24.
//

import Foundation

//class ChatReplyViewModel {
 
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
    
//}
