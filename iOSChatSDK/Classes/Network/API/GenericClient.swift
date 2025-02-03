//
//  GenericClient.swift
//  Dynasas
//
//  Created by Dynasas on 29/04/23.
//

import Foundation
import UIKit

/// Generic client to avoid rewrite URL session code
protocol GenericClient {
    associatedtype T:Decodable
    var showLoader: Bool { get set }
    var session: URLSession { get }
    func fetch(with request: URLRequest, refreshHeaders: Bool, showloader: Bool, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>, [AnyHashable : Any]?) -> Void)
    func fetchWithRefreshToken<T: Decodable>(with request: URLRequest, showloader: Bool, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
    func fetchJson(with request: URLRequest, completion: @escaping (Result<[String:Any], APIError>) -> Void)
}

extension GenericClient {
    
    typealias JSONTaskCompletionHandler = (HTTPURLResponse?, Decodable?, APIError?) -> Void
    
    var showLoader: Bool {
        return true
    }
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, showloader: Bool = true, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            Threads.performTaskInMainQueue {
                let requestURL = request.url?.absoluteString ?? ""
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 403 else {
                    logoutUser()
                    completion(nil, nil, .requestFailed(description: error?.localizedDescription ?? "No description"))
                    return
                }
                
#if DEBUG
                //Log.d(":: cURL Request :: \(request.cURL())")
                //Log.d(":: HttpResponse :: \(requestURL) :: \(httpResponse)")
#endif
                guard let data = data else {
                    //Log.e(error)
                    completion(httpResponse, nil, .invalidData)
                    return
                }
                
                do {
#if DEBUG
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    //Log.d(":: cURL JSON :: \(json ?? [:])")
#endif
                } catch _ {
                    
                }
                
                do {
                    _ = try JSONDecoder().decode(decodingType, from: data)
                } catch DecodingError.keyNotFound(let key, let context) {
                    //print("SQRCLEEEEE could not find key \(key) in JSON: \(context.debugDescription) \(request.cURL())")
                } catch DecodingError.valueNotFound(let type, let context) {
                    //print("SQRCLEEEEE could not find type \(type) in JSON: \(context.debugDescription) \(request.cURL())")
                } catch DecodingError.typeMismatch(let type, let context) {
                    //print("SQRCLEEEEE type mismatch for type \(type) in JSON: \(context.debugDescription) \(request.cURL())")
                } catch DecodingError.dataCorrupted(let context) {
                    //print("SQRCLEEEEE data found to be corrupted in JSON: \(context.debugDescription) \(request.cURL())")
                } catch let error as NSError {
                    //print("SQRCLEEEEE Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription) \(request.cURL())")
                }
                
                if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
//                    Log.d(":: Response :: \(requestURL) :: \(JSONString)")
                }
                do {
                    let genericModel = try JSONDecoder().decode(decodingType, from: data)
                    completion(httpResponse, genericModel, nil)
                } catch {
                    //print("_____________got the error")
                }
                
                
//                } else if let errorModel = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
//                    Log.e(":: Error :: \(requestURL) ::  \(String(describing: error))")
//                    Log.e(String(data: data, encoding: String.Encoding.utf8))
//                    completion(httpResponse, nil, .invalidRequest(description: errorModel.message ?? ""))
//                } else {
//                    let genericModel = try? JSONDecoder().decode(ErrorResponse.self, from: data)
//                    Log.e(":: Error :: \(requestURL) ::  \(String(describing: error))")
//                    Log.e(String(data: data, encoding: String.Encoding.utf8))
//                    completion(httpResponse, nil, .jsonConversionFailure(description: genericModel?.message ?? ""))
//                }
            }
        }
        return task
    }
    
    private func logoutUser() {
//        UserDataRepository().clearRecords()
//        UserDefaultsHelper.resetDefaults()
//        let action = Action(redirectionType: .login, actionParams: nil)
//        ActionManager.performAction(action: action, sourceVC: APP_DELEGATE.window?.rootViewController)
    }
    
    /// success respone executed on main thread.
    func fetch<T: Decodable>(with request: URLRequest, refreshHeaders: Bool = false, showloader: Bool = true, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>, [AnyHashable : Any]?) -> Void) {
        
        let newRequest = request
        //Log.i(self)
        let task = decodingTask(with: newRequest, decodingType: T.self, showloader: showloader) { (http, json , error) in
            Threads.performTaskInMainQueue {
                guard let json = json else {
                    error != nil ? completion(.failure(error ?? error!), nil) : completion(.failure(.decodingTaskFailure(description: "\(String(describing: error))")), nil)
                    return
                }
                guard let value = decode(json) else { completion(.failure(.jsonDecodingFailure), nil); return }
                completion(.success(value), http?.allHeaderFields)
            }
        }
        task.resume()
    }
    
    /// success respone executed on main thread.
    /// Always create service property to maintain the scope of refresh token
    func fetchWithRefreshToken<T: Decodable>(with request: URLRequest, showloader: Bool = true, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        
        //Log.i(self)
        let task = decodingTask(with: request, decodingType: T.self, showloader: showloader) { (http, json , error) in
            guard let httpRes = http
            else {
                completion(.failure(.requestFailed(description: error?.localizedDescription ?? "No description")))
                return
            }
            if httpRes.statusCode == 401 {
            } else {
                Threads.performTaskInMainQueue {
                    guard let json = json else {
                        error != nil ? completion(.failure(.decodingTaskFailure(description: "\(String(describing: error))"))) : completion(.failure(.invalidData))
                        return
                    }
                    guard let value = decode(json) else { completion(.failure(.jsonDecodingFailure)); return }
                    completion(.success(value))
                }
            }
        }
        task.resume()
    }
    
    //MARK: JSON Dictionary
    
    func fetchJson(with request: URLRequest, completion: @escaping (Result<[String:Any], APIError>) -> Void) {
        let task = decodingJsonTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    private func decodingJsonTask(with request: URLRequest, completionHandler completion: @escaping (Result<[String:Any], APIError>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else { completion(.failure(.invalidData)); return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    #if DEBUG
                    //Log.d("Response:")
                    //Log.d(object)
                    #endif
                    completion(.success(object))
                } else {
                    #if DEBUG
                    //Log.e(String(data: data, encoding: .utf8))
                    #endif
                    completion(.failure(.invalidData))
                }
            } catch let err {
                #if DEBUG
                //Log.e(err)
                //Log.e(String(data: data, encoding: .utf8))
                #endif
                completion(.failure(.invalidData))
            }
        }
        return task
    }
}
