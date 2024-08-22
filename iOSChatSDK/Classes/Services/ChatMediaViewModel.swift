//
//  ChatMediaViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 05/07/24.
//

import Foundation

class ChatMediaViewModel {
    
    
    func uploadFile(accessToken: String, roomID: String, body: String, msgType: String, mimetype: String, fileName: String, imageFilePath: UIImage? = nil,videoFilePath: URL? = nil,mediaType:String, completion: @escaping (Result<UploadResponse, Error>) -> Void) {
        
        let url = URL(string: "\(API.sendMedia)\(mediaType)")!
        //        print("url \(url)")
        //        print("msgType \(msgType)")
        //        print("mimetype \(mimetype)")
        //        print("fileName \(fileName)")
        //        print("imageFilePath \(String(describing: imageFilePath))")
        //        print("videoFilePath \(String(describing: videoFilePath))")
        //        print("mediaType \(mediaType)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var bodyData = Data()
        
        // Access Token
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"accessToken\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("\(accessToken)\r\n".data(using: .utf8)!)
        
        // Room ID
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"roomID\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("\(roomID)\r\n".data(using: .utf8)!)
        
        // Body
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"body\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("\(body)\r\n".data(using: .utf8)!)
        
        // Message Type
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"msgType\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("\(msgType)\r\n".data(using: .utf8)!)
        
        // MIME Type
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"mimetype\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("\(mimetype)\r\n".data(using: .utf8)!)
        
        // File Name
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"fileName\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("\(fileName)\r\n".data(using: .utf8)!)
        
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        
        if(imageFilePath==nil)  {
            var movieData: Data?
            do {
                movieData = try Data(contentsOf: videoFilePath!, options: Data.ReadingOptions.alwaysMapped)
            } catch _ {
                movieData = nil
                return
            }
            bodyData.append(movieData!)
        }else{
            let imageData = imageFilePath?.jpegData(compressionQuality: 0.5)
            bodyData.append(imageData!)
        }
        
        bodyData.append("\r\n".data(using: .utf8)!)
        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = bodyData
        DispatchQueue.global(qos: .background).async {
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
                    completion(.failure(error))
                    return
                }
                
                do {
                    let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: data)
                    completion(.success(uploadResponse))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}

struct UploadResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: Details
    
    struct Details: Codable {
        let response: String
        let chatEventId: String
        
        enum CodingKeys: String, CodingKey {
            case response
            case chatEventId = "chat_event_id"
        }
    }
}
