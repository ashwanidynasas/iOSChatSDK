//
//  LoginService.swift
//  iOSChatSDK
//
//  Created by Ashwani on 27/06/24.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let redirectUrl: String
    let details: Details
}

struct Details: Codable {
    let accessToken: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case response
    }
}

class LoginViewModel {
    var loginResponse: LoginResponse? {
        didSet {
            if let token = loginResponse?.details.accessToken {
                // Store the access token in UserDefaults
                UserDefaults.standard.set(token, forKey: "access_token")
            }
            self.bindViewModelToController()
        }
    }
    
    var bindViewModelToController: (() -> ()) = {}
    
    func login(username: String, loginJWTToken: String, completion: @escaping (String?) -> Void) {
          let url = URL(string: "http://157.241.58.41/chat_api/auth/login")!
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          
          let json: [String: Any] = [
              "username": username,
              "loginJWTToken": loginJWTToken
          ]
          
          let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
          request.httpBody = jsonData
          
          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data, error == nil else {
                  print("Error: \(error?.localizedDescription ?? "Unknown error")")
                  completion(nil)
                  return
              }
              
              do {
                  let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                  self.loginResponse = loginResponse
                  completion(loginResponse.details.accessToken)
              } catch let parsingError {
                  print("Error parsing JSON: \(parsingError)")
                  completion(nil)
              }
          }
          
          task.resume()
      }
    func fetchAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
}
