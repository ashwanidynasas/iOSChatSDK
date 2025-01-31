//
//  ChatRoomVC+ImageDownload.swift
//  iOSChatSDK
//
//  Created by Ashwani on 31/01/25.
//

import Foundation
import UIKit

class ChatImageView: UIImageView {
    
    var imageURL : String?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
}

let imageCache = NSCache<AnyObject, UIImage>()

class ChatImageDownload {
    
    class func downloadImage(imageView: UIImageView, imageURL: String?, placeholderImage: UIImage? = nil, completionHandler: ((UIImage?) -> Void)? = nil) {
        
        let placeHolder = placeholderImage ?? UIImage(named: ChatConstants.Image.placeholder)
        
        guard let _imageURL = imageURL else {
            completionHandler?(placeHolder)
            return
        }
        
        // **Check if image is already cached**
        if let cachedImage = imageCache.object(forKey: _imageURL as AnyObject) {
            completionHandler?(cachedImage)
            return
        }
        
        // **Download image if not cached**
        DispatchQueue.global().async {
            if let url = URL(string: _imageURL) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil, let image = UIImage(data: data) else {
                        DispatchQueue.main.async {
                            completionHandler?(placeHolder)
                        }
                        return
                    }
                    
                    // **Store image in cache**
                    imageCache.setObject(image, forKey: _imageURL as AnyObject)
                    
                    DispatchQueue.main.async {
                        completionHandler?(image)
                    }
                }.resume()
            }
        }
    }
}


extension UIImageView {
    
    func setImage(placeholder: String, url: String) {
        let placeholderImage = UIImage(named: placeholder)
        
        // Set placeholder initially
        self.image = placeholderImage
        self.contentMode = .scaleAspectFill
        
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: url as AnyObject) {
            self.image = cachedImage
            self.contentMode = .scaleAspectFit
            return
        }
        
        // Download the image if not in cache
        ChatImageDownload.downloadImage(imageView: self, imageURL: url, placeholderImage: placeholderImage) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // Ensure the image still corresponds to the current cell’s image URL
                if self.tag == url.hashValue {
                    self.image = image
                    self.contentMode = .scaleAspectFit
                }
            }
        }
    }
}
