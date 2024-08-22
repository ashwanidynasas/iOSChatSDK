//
//  API + Extensions.swift
//  Dynasas
//
//  Created by Dynasas on 29/04/23.
//

import Foundation

extension URLRequest {
    
    public func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"

        var cURL = "curl "
        var header = ""
        var data: String = ""

        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }

        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }

        cURL += method + url + header + data

        return cURL
    }
}

enum HTTPMethods: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}


protocol Response: Codable {
    associatedtype T: Codable
    var data: [T]? { get set }
    var error: Bool? { get set }
    var message: String? { get set }
}

struct ErrorResponse: Response {
    
    typealias T = String
    var data: [T]?
    var error: Bool?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case data
        case error
        case message
    }
}

enum HTTPHeader {
    
    case contentType(String)
    case accept(String)
    case authorization(String)
    case machineId(String)
    case circleHash(String)
    case privateKey(String)
    case forwardedFor(String)
    case userId(String)
    
    var header: (field: String, value: String) {
        
        switch self {
        case .contentType(let value): return (field: "content-type", value: value)
        case .accept(let value): return (field: "Accept", value: value)
        case .authorization(let value): return (field: "authorization", value: "Bearer \(value)")
        case .machineId(let value): return (field: "x-machineId", value: value)
        case .circleHash(let value): return (field: "Circle-Hash", value: value)
        case .privateKey(let value): return (field: "PrivateKey", value: value)
        case .forwardedFor(let value): return (field: "X-Forwarded-For", value: value)
        case .userId(let value): return (field: "userId", value: value)
        }
    }
}

extension HTTPHeader: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.header.field == rhs.header.field
    }
}
