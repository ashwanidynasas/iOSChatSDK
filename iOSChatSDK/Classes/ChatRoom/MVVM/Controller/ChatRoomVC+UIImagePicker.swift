//
//  ChatRoomVC+UIImagePicker.swift
//  iOSChatSDK
//
//  Created by Dynasas on 23/08/24.
//

import Foundation
import MobileCoreServices


//MARK: - IMAGE PICKER DELEGATES
extension ChatRoomVC : UIImagePickerControllerDelegate, UIDocumentPickerDelegate{
    
    func camera() {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            return
//        }
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .camera
//        imagePicker.delegate = self
//        self.present(imagePicker, animated: true)
        
        self.imageFetched = nil
        self.videoFetched = nil
        self.fileFetched = nil
        ChatImagePicker.sharedHandler.getMedia(controller: self, type: .camera, allowEditing: false) { (originalImage, videoURL) in
                    if let originalImage = originalImage {
                        print("Original Image Captured: \(originalImage)")
                        self.imageFetched = originalImage
                        self.publish()
                    } else if let videoURL = videoURL {
                        print("Video Captured at URL: \(videoURL)")
                        self.videoFetched = videoURL
                        self.publish()
                    }
                }
    }
    
    func gallery() {
        self.imageFetched = nil
        self.videoFetched = nil
        self.fileFetched = nil
        ChatImagePicker.sharedHandler.getMedia(controller: self, type: .gallery, allowEditing: false) { (originalImage, videoURL) in
            if let originalImage = originalImage {
                print("Image Selected: \(originalImage)")
                self.imageFetched = originalImage
                self.publish()
            } else if let videoURL = videoURL {
                print("Video Selected: \(videoURL)")
                self.videoFetched = videoURL
                self.publish()
            }
        }

        // Check if the photo library is available
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            let imagePickerController = UIImagePickerController()
//            imagePickerController.delegate = self
//            imagePickerController.sourceType = .photoLibrary
//            imagePickerController.allowsEditing = false
//            imagePickerController.mediaTypes = ["public.image", "public.movie"] // Support both images and videos
//            DispatchQueue.main.async {
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//        } else {
//            // Handle the case where the photo library is not available
//            let alert = UIAlertController(title: "Error", message: "Photo Library not available.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            DispatchQueue.main.async {
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageFetched = nil
        videoFetched = nil
        fileFetched = nil
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
    
    
    public func presentDocumentPicker() {
        
        if #available(iOS 14.0, *) {
               let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
               documentPicker.delegate = self
               documentPicker.allowsMultipleSelection = false
               self.present(documentPicker, animated: true, completion: nil)
           } else {
               // Fallback for iOS versions earlier than 14.0
               let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
               documentPicker.delegate = self
               documentPicker.allowsMultipleSelection = false
               self.present(documentPicker, animated: true, completion: nil)
           }
    }
    
    // Delegate method when a document is picked
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        fileFetched = nil
        imageFetched = nil
        videoFetched = nil
        guard let pickedURL = urls.first else { return }
        fileFetched = pickedURL
        publish()
    }
    
    // Delegate method when the user cancels the picker
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
}


