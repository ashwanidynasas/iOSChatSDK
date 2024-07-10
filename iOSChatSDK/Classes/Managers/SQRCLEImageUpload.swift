//
//  SQRCLEImageUpload.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import UIKit
/*
enum uploadImageSubType: String {
    case image = "IMAGE"
    case text = "TEXT"
}

class SQRCLEImageUpload {
    
    static var s3UploadService: S3UploadService?
    
    class func getImageUrlForCircle(endPoint: S3UploadServiceEndPoint, type: String, userId: String, circleId: String, completionHandler: @escaping ((Bool, S3UploadDetailsModel?, [AnyHashable : Any]?) -> Void)) {
        
        s3UploadService = S3UploadService(configuration: .default)
        s3UploadService?.getImageUrlForCircle(endPoint: endPoint,
                                              type: type,
                                              userId: userId,
                                              circleId: circleId,
                                              completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let response = value?.response , let success = response.success, success, let details = response.details {
                    completionHandler(true, details, headers)
                } else {
                    AlertUtiliy.addToast(message: "", style: .danger)
                    completionHandler(false, nil, nil)
                }
            case .failure(let error):
                AlertUtiliy.addToast(message: error.customDescription, style: .danger)
                completionHandler(false, nil, nil)
            }
        })
    }
    
    class func getImageUrlForCoi(endPoint: S3UploadServiceEndPoint, type: String, coiHashAddr: String, circleOfInterestId: String, completionHandler: @escaping ((Bool, S3UploadDetailsModel?, [AnyHashable : Any]?) -> Void)) {
        
        s3UploadService = S3UploadService(configuration: .default)
        s3UploadService?.getImageUrlForCoi(endPoint: endPoint,
                                           type: type,
                                           coiHashAddr: coiHashAddr,
                                           circleOfInterestId: circleOfInterestId,
                                           completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let response = value?.response , let success = response.success, success, let details = response.details{
                    completionHandler(true, details, headers)
                } else {
                    AlertUtiliy.addToast(message: "", style: .danger)
                    completionHandler(false, nil, nil)
                }
            case .failure(let error):
                AlertUtiliy.addToast(message: error.customDescription, style: .danger)
                completionHandler(false, nil, nil)
            }
        })
    }
    
    class func getImageUrlForPost(endPoint: S3UploadServiceEndPoint, subType : String , type: String, coiHashAddr: String, circleOfInterestId: String, completionHandler: @escaping ((Bool, S3UploadDetailsModel?, [AnyHashable : Any]?) -> Void)) {
        
        s3UploadService = S3UploadService(configuration: .default)
        s3UploadService?.getImageUrlForPost(endPoint: endPoint,
                                            subType: subType,
                                            type: type,
                                            coiHashAddr: coiHashAddr,
                                            circleOfInterestId: circleOfInterestId,
                                            completion: { (result, headers) in
            switch result {
            case .success(let value):
                if let response = value?.response , let success = response.success, success, let details = response.details {
                    completionHandler(true, details, headers)
                } else {
                    AlertUtiliy.addToast(message: "", style: .danger)
                    completionHandler(false, nil, nil)
                }
            case .failure(let error):
                AlertUtiliy.addToast(message: error.customDescription, style: .danger)
                completionHandler(false, nil, nil)
            }
        })
    }
    
    class func uploadImageAtUrl(url: String, image: UIImage, headers: [String : Any], completionHandler: @escaping (Bool) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        var parameters = headers
        parameters["Content-Type"] = "image/png"
        
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        guard let mediaImage = MediaUpload(withImage: image, forKey: "file", forfilename: "imagefile.jpg", formimeType: "image/jpeg") else { return }
        request.httpBody = createDataBody(withParameters: parameters,
                       media: [mediaImage],
                       boundary: boundary)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }.resume()
    }
    
    class func uploadVideoAtUrl(url: String, video: Data, headers: [String : Any], completionHandler: @escaping (Bool) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        var parameters = headers
        parameters["Content-Type"] = "video/mp4"
        
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        guard let mediaImage = MediaUpload(withVideoData: video, forKey: "file", forfilename: "upload.mp4", formimeType: "video/mp4") else { return }
        request.httpBody = createDataBody(withParameters: parameters,
                       media: [mediaImage],
                       boundary: boundary)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }.resume()
    }
    
    class func uploadAudioAtUrl(url: String, audioData: Data, fileName: String, completionHandler: @escaping (Bool) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PUT"
        request.setValue("audio/mp3", forHTTPHeaderField: "Content-Type")
        request.httpBody = audioData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }.resume()
    }
    
    class func createDataBody(withParameters params: Parameters?, media: [MediaUpload]?, boundary: String) -> Data {
       let lineBreak = "\r\n"
       var body = Data()
       if let parameters = params {
          for (key, value) in parameters {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
             body.append("\(value as! String + lineBreak)")
          }
       }
       if let media = media {
          for photo in media {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
             body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
             body.append(photo.data)
             body.append(lineBreak)
          }
       }
       body.append("--\(boundary)--\(lineBreak)")
       return body
    }
    
    class func generateBoundary() -> String {
       return "Boundary-\(NSUUID().uuidString)"
    }
    
}

extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
         print("data======>>>",data)
      }
   }
}


struct MediaUpload {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String , forfilename filename: String, formimeType mimeType: String) {
        self.key = key
        self.mimeType = mimeType
        self.filename = filename
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
    
    init?(withVideoData videoData: Data, forKey key: String , forfilename filename: String, formimeType mimeType: String) {
        self.key = key
        self.mimeType = mimeType
        self.filename = filename
        self.data = videoData
    }
}
 */

public typealias Parameters = [String: Any]


enum Media : String{
    case photo = "IMAGE"
    case video = "VIDEO"
    
    var contentType : String{
        switch self{
        case .photo : return "image/png"
        case .video : return "video/mp4"
        }
    }
}

