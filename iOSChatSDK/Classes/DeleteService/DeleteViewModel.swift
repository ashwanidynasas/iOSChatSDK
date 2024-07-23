//
//  DeleteViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 22/07/24.
//

import Foundation
struct MessageRedactRequest: Codable {
    let accessToken: String
    let roomID: String
    let eventID: String
    let body: String
}
//class DeleteViewModel {
//    var onRedactSuccess: ((UploadResponse) -> Void)?
//    var onRedactFailure: ((Error) -> Void)?
//    
//    func redactMessage(accessToken: String, roomID: String, eventID: String, body: String) {
//        guard let url = URL(string: "http://157.241.58.41/chat_api/message/redact") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        
//        let parameters: [String: Any] = [
//            "accessToken": accessToken,
//            "roomID": roomID,
//            "eventID": eventID,
//            "body": body
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
//        } catch {
//            self.onRedactFailure?(error)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                self.onRedactFailure?(error)
//                return
//            }
//            
//            guard let data = data else {
//                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
//                self.onRedactFailure?(error)
//                return
//            }
//            
//            do {
//                let redactResponse = try JSONDecoder().decode(UploadResponse.self, from: data)
//                self.onRedactSuccess?(redactResponse)
//            } catch {
//                self.onRedactFailure?(error)
//            }
//        }
//        
//        task.resume()
//    }
//}

class DeleteMessageViewModel {
    func redactMessage(request: MessageRedactRequest, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://157.241.58.41/chat_api/message/redact") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(request.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success("Message redacted successfully"))
            } else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }
        
        task.resume()
    }
}
