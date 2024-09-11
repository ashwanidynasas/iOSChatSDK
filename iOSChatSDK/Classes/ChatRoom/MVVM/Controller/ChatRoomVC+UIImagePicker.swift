//
//  ChatRoomVC+UIImagePicker.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation


//MARK: - IMAGE PICKER DELEGATES
extension ChatRoomVC : UIImagePickerControllerDelegate{
    
    func camera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func gallery() {
        // Check if the photo library is available
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            imagePickerController.mediaTypes = ["public.image", "public.movie"] // Support both images and videos
            DispatchQueue.main.async {
                self.present(imagePickerController, animated: true, completion: nil)
            }
        } else {
            // Handle the case where the photo library is not available
            let alert = UIAlertController(title: "Error", message: "Photo Library not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
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
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


