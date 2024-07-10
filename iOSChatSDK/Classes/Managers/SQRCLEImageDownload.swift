//
//  SQRCLEImageDownload.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//

import Foundation
import SDWebImage
import UIKit

class SQRCLEImageView: UIImageView {
    
    var imageURL : String?

    override public func layoutSubviews() {
        super.layoutSubviews()
    }
}

let imageCache = NSCache<AnyObject, UIImage>()

class SQRCLEImageDownload {
    
    class func downloadImage(imageView: UIImageView, imageURL: String?, placeholderImage : UIImage? = nil, completionHandler: ((UIImage?) -> Void)? = nil) {
        
//        SDWebImageDownloader.shared.config.downloadTimeout = 300

        let placeHolder = placeholderImage ?? UIImage(named: Placeholders.profile.rawValue)
        
        if let _imageURL = imageURL {
//            if let cachedImage = imageCache.object(forKey: _imageURL as AnyObject) {
//                completionHandler?(cachedImage)
//                return
//            }
            DispatchQueue.global().async {
                if let url = URL(string: _imageURL) {
                    imageView.sd_setImage(with: url, completed: { (image, _, _, _) in
                        if image == nil {
                            completionHandler?(placeHolder)
                        } else {
                            imageCache.setObject(image!, forKey: _imageURL as AnyObject)
                            completionHandler?(image)
                        }
                    })
                }
            }
        }
    }
}
