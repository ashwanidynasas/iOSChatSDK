//
//  Endpoint.swift
//  Dynasas
//
//  Created by Dynasas on 29/04/23.
//

extension URL {
    init?(_ string: String) {
        guard string.isEmpty == false else {
            return nil
        }
        if let url = URL(string: string) {
            self = url
        } else if let urlEscapedString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                  let escapedURL = URL(string: urlEscapedString) {
            self = escapedURL
        } else {
            return nil
        }
    }
}

import Foundation

/// Protocol for easy construction of URls, ideally an enum will be the one conforming to this protocol.
protocol Endpoint {
    var base:  String { get }
    var path: String { get }
}

extension Endpoint {
    
    var base: String {
        return "https://devchat.sqrcle.co"
    }
    var sdkURL: String {
        return base + path
    }
    var urlComponents: URLComponents? {
        guard var components = URLComponents(string: base.removingWhitespaces()) else { return nil }
        components.path = path.removingWhitespaces()
        return components
    }
    
    var request: URLRequest? {
        guard var url = urlComponents?.url ?? URL("\(self.base)\(self.path)") else {
            return nil
        }
        if url.path.contains("chat.sqrcle.co"){
            if let chaturl = URL(/self.path){
                url = chaturl
            }
        }
        let request = URLRequest(url: url)
        return request
    }
    
    var imageRequest: URLRequest? {
        guard let url = urlComponents?.url ?? URL("\(self.path)") else {
            return nil
        }
        let request = URLRequest(url: url)
        return request
    }
    
    //Default Header
    func getHTTPHeader(alreadyAppanded: [HTTPHeader]) -> [HTTPHeader] {
        var headers = [HTTPHeader]()
        let contentTypeHeader = HTTPHeader.contentType("application/json")
        headers.append(contentTypeHeader)
        let acceptHeader = HTTPHeader.accept("application/json")
        headers.append(acceptHeader)
        let machineIdHeader = HTTPHeader.machineId("123456")
        headers.append(machineIdHeader)
        return headers
    }
    
    //POST
    func postRequest(urlParameters: DictionaryEncodable? = nil, parameters: Encodable? = nil, headers: [HTTPHeader] = [], isImage : Bool? = false) -> URLRequest? {
        let header = headers
        return makeRequest(type: .post, urlparameters: urlParameters,parameters: parameters, headers: header, isImage: isImage)
    }
    
    //GET
    func getRequest(parameters: DictionaryEncodable? = nil, headers: [HTTPHeader] = []) -> URLRequest? {
        let header = headers
        return makeRequest(type: .get,urlparameters: parameters, headers: header)
    }
    
    //PUT
    func putRequest(urlParameters: DictionaryEncodable? = nil, parameters: Encodable? = nil, headers: [HTTPHeader] = []) -> URLRequest? {
        let header = headers
        return makeRequest(type: .put, urlparameters: urlParameters,parameters: parameters, headers: header)
    }
    
    //DELETE
    func deleteRequest(urlParameters: DictionaryEncodable? = nil, parameters: Encodable? = nil, headers: [HTTPHeader] = []) -> URLRequest? {
        return makeRequest(type: .delete, urlparameters: urlParameters,parameters: parameters, headers: headers)
    }
    
    func makeRequest(type:HTTPMethods, urlparameters: DictionaryEncodable? = nil, parameters: Encodable? = nil, headers: [HTTPHeader], isImage : Bool? = false) -> URLRequest? {
        let allHeader = headers + getHTTPHeader(alreadyAppanded: headers)
        
        guard var request = self.request else { return nil }
        //Request Type
        if /isImage{
            if let imgRequest = self.imageRequest{
                request = imgRequest
            }
        }
        request.httpMethod = type.rawValue
        
        //URL Param
        if let dic = urlparameters?.dictionary() {
            var urlComponent = URLComponents(string: request.url?.absoluteString ?? "")
            var queryItems: [URLQueryItem] = []
            for (key, value) in  dic {
                let item = URLQueryItem(name: key, value: value as? String)
                queryItems.append(item)
            }
            urlComponent?.queryItems = queryItems
            request.url = urlComponent?.url
        }
        
        //Body Param
        if let param = parameters {
            do {
                request.httpBody = try JSONEncoder().encode(param)
            } catch let error {
                Log.d(APIError.postParametersEncodingFailure(description: "\(error)").customDescription)
                return nil
            }
        }
        
        allHeader.forEach { request.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
        return request
    }
    
}

protocol DictionaryEncodable: Encodable {}

extension DictionaryEncodable {
    func dictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
              let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return nil
        }
        return dict
    }
}


extension String {
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined().removingBackslash()
    }
    
    func removingBackslash() -> String {
        return stringByReplacingFirstOccurrenceOfString(target: "\\", withString: "")
    }
    
    func stringByReplacingFirstOccurrenceOfString(target: String, withString replaceString: String) -> String {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}
