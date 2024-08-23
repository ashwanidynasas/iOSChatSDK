//
//  ChatRoomVC+UIImagePicker.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation

extension ChatRoomVC : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageFetched = nil
        videoFetched = nil
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == "public.image" {
                if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    imageFetched = selectedImage
                    gotoPublishView()
                }
            } else if mediaType == "public.movie" {
                if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    videoFetched = videoURL
                    gotoPublishView()
                }
            }
        }
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }
}
