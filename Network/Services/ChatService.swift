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
class ChatService: GenericClient {
    
    typealias T = ConnectionResponse
    var showLoader: Bool = true
    internal let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
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
    
}










//MARK: - REQUEST PARAMETERS
struct FetchConnectionsParameter: DictionaryEncodable {
    var circleId: String
    var circleHash : String
    
}
