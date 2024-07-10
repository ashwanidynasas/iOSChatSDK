//
//  ConnectionListService.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

import Foundation

struct ConnectionResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: ConnectionDetails
}

struct ConnectionDetails: Codable {
    let connections: [Connection]
}

struct Connection: Codable {
    let circleHashAddr: String
    let coiHashAddr: String
    let chatUserId: String
    let imageInfo: ImageInfo
    let userInfo: UserInfo
    let defaultParam: DefaultParam
}

struct ImageInfo: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "Url"
    }
}

struct UserInfo: Codable {}

struct DefaultParam: Codable {
    let color: String
}


class ConnectionViewModel {
    var connections: [Connection] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }

    var bindViewModelToController: (() -> ()) = {}
    
    func fetchConnections(circleId: String, circleHash: String) {
        let url = URL(string: "http://157.241.58.41/chat_api/list-connections")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: Any] = [
            "circleId": circleId,
            "circleHash": circleHash
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let connectionResponse = try JSONDecoder().decode(ConnectionResponse.self, from: data)
                self.connections = connectionResponse.details.connections
            } catch let parsingError {
                print("Error parsing JSON: \(parsingError)")
            }
        }
        
        task.resume()
    }
}
