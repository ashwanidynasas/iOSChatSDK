//
//  ConnectionViewModel.swift
//  iOSChatSDK
//
//  Created by Ashwani on 21/08/24.
//

//MARK: - MODULES
import Foundation

//MARK: - CLASS
class ConnectionViewModel {
    
    //MARK: - PROPERTIES
    private var service : ChatService?
    var connections: [Connection] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }

    var bindViewModelToController: (() -> ()) = {}
    
    //MARK: - FUNCTIONS
    func fetchConnections(circleId: String, circleHash: String) {
        service = ChatService(configuration: .default)
        let parameter = FetchConnectionsParameter(circleId: circleId, circleHash: circleHash)
        
        service?.listConnections(parameters: parameter, completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let success = value?.success, success {
                    self.connections = value?.details.connections ?? []
                } else {
                    print(/value?.message)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

