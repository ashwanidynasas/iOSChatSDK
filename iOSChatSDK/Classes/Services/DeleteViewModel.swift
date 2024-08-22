//
//  DeleteViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 22/07/24.
//

import Foundation



//class DeleteMessageViewModel {
//    func redactMessage(request: MessageRedactRequest, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let url = URL(string: API.redactMessage) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.setValue("Bearer \(request.accessToken)", forHTTPHeaderField: "Authorization")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            let jsonData = try JSONEncoder().encode(request)
//            urlRequest.httpBody = jsonData
//        } catch {
//            completion(.failure(error))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(.success("Message redacted successfully"))
//            } else {
//                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
//            }
//        }
//        
//        task.resume()
//    }
//}
