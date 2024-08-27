//
//  ChatRoomVC+UIImagePicker.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

struct ImagePickerMedia{
    static let image = "public.image"
    static let video = "public.movie"
}

//MARK: - IMAGE PICKER DELEGATES
extension ChatRoomVC : UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageFetched = nil
        videoFetched = nil
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
            if mediaType == ImagePickerMedia.image {
                if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    imageFetched = selectedImage
                    publish()
                }
            } else if mediaType == ImagePickerMedia.video {
                if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    videoFetched = videoURL
                    publish()
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
