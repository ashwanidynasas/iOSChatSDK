//
//  PostsView.swift
//  SQRCLE
//
//  Created by Dynasas on 15/01/24.
//

import UIKit
import AVFoundation
import AVKit



class PostsView: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
//    var post : PostDetailPostModel?{
//        didSet{
//            switch Media(rawValue: /post?.type){
//            case .photo:
//                if let dict = post?.objectKeyUrl,
//                   let url = dict[/post?.objectKey?.last]{
//                    img?.setImage(placeholder : Placeholders.postImage.rawValue, url: url)
//                }
//            case .video:
//                if let dict = post?.objectKeyUrl,
//                   let url = dict[/post?.objectKey?.last]{
//                    //img?.playVideoAtURL(URL(string: url))
//                }
//            default:
//                break
//            }
//        }
//    }
}


extension UIImageView{
    
    func setImage(placeholder : String, url : String){
        let placeholderImage = UIImage(named: placeholder)
        self.image = placeholderImage
        SQRCLEImageDownload.downloadImage(imageView: self, imageURL: url, placeholderImage: placeholderImage) { image in
            if image != nil {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}


extension UIButton{
    
    func setImage(placeholder : String, url : String){
        let placeholderImage = UIImage(named: placeholder)
        self.contentMode = .scaleAspectFill
        self.setImage(placeholderImage, for: .normal)
        SQRCLEImageDownload.downloadImage(imageView: self.imageView!, imageURL: url, placeholderImage: placeholderImage) { image in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageView?.contentMode = .scaleToFill
                    self.setImage(image, for: .normal)
                }
            }
        }
    }
}
