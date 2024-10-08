//
//  ChatImagePicker.swift
//  iOSChatSDK
//
//  Created by Ashwani on 08/10/24.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

enum MediaPicker {
    case camera
    case gallery
    case video
}

//MARK: - CLASS
class ChatImagePicker: NSObject {
    
    //MARK: - PROPERTIES
    static let sharedHandler = ChatImagePicker()
    
    let PHOTO_LIBRARY_PERMISSION: String = "Require access to Photo library to proceed. Would you like to open settings and grant permission to photo library?"
    let CAMERA_USAGE_PERMISSION: String = "Require access to Camera to proceed. Would you like to open settings and grant permission to camera?"
    let CAMERA_NOT_AVAILABLE: String = "Camera is not available."
    let GALLERY_NOT_AVAILABLE: String = "Gallery is not available."
    
    var vc: UIViewController?
    var mediaClosure: ((_ originalImage: UIImage?, _ videoURL: URL?) -> Void)?
    var originalImage: UIImage?
    var videoURL: URL?
    
    //MARK: - FUNCTIONS
    func getMedia(controller: UIViewController,
                  type: MediaPicker,
                  allowEditing: Bool? = true,
                  completion: ((_ originalImage: UIImage?, _ videoURL: URL?) -> Void)?) {
        
        vc = controller
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = allowEditing ?? true
        mediaPicker.mediaTypes = [(kUTTypeImage as String), (kUTTypeMovie as String)] // Support both images and videos
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch type {
            case .gallery:
                openGallery(picker: mediaPicker)
            case .camera:
                openCamera(picker: mediaPicker)
            case .video:
                openVideo(picker: mediaPicker)
            }
        }
        
        mediaClosure = { (_, _) in
            completion?(self.originalImage, self.videoURL)
        }
    }
}

//MARK: - CHECK STATUS
extension ChatImagePicker {
    private func checkCameraStatus(completionHandler: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .notDetermined, .restricted:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(controller: self.vc,
                                               msg: self.CAMERA_USAGE_PERMISSION,
                                               completionHandler)
                    }
                }
            }
        case .denied:
            DispatchQueue.main.async {
                self.showSettingsAlert(controller: self.vc,
                                       msg: self.CAMERA_USAGE_PERMISSION,
                                       completionHandler)
            }
        case .authorized:
            completionHandler(true)
        @unknown default:
            completionHandler(false)
        }
    }
    
    private func checkGalleryStatus(completionHandler: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .notDetermined, .restricted, .limited:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        completionHandler(true)
                    } else {
                        DispatchQueue.main.async {
                            self.showSettingsAlert(controller: self.vc,
                                                   msg: self.PHOTO_LIBRARY_PERMISSION,
                                                   completionHandler)
                        }
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    self.showSettingsAlert(controller: self.vc,
                                           msg: self.PHOTO_LIBRARY_PERMISSION,
                                           completionHandler)
                }
            case .authorized:
                completionHandler(true)
            @unknown default:
                completionHandler(false)
            }
        }
    }
}

//MARK: - FUNCTIONS
extension ChatImagePicker {
    private func openCamera(picker: UIImagePickerController) {
        checkCameraStatus { isGranted in
            if isGranted {
                Threads.performTaskInMainQueue {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        picker.sourceType = .camera
                        picker.edgesForExtendedLayout = UIRectEdge.all
                        picker.showsCameraControls = true
                        picker.mediaTypes = [(kUTTypeImage as String)] // Only image from camera
                        self.vc?.present(picker, animated: true, completion: nil)
                    } else {
                        print(self.CAMERA_NOT_AVAILABLE)
                    }
                }
            }
        }
    }
    
    func openVideo(picker: UIImagePickerController) {
        checkCameraStatus { isGranted in
            if isGranted {
                Threads.performTaskInMainQueue {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        picker.sourceType = .camera
                        picker.mediaTypes = [(kUTTypeMovie as String)] // Only video from camera
                        picker.videoQuality = .typeHigh
                        self.vc?.present(picker, animated: true, completion: nil)
                    } else {
                        print(self.CAMERA_NOT_AVAILABLE)
                    }
                }
            }
        }
    }
    
    func openGallery(picker: UIImagePickerController) {
        checkGalleryStatus { isGranted in
            if isGranted {
                Threads.performTaskInMainQueue {
                    picker.sourceType = .photoLibrary // Allow both images and videos from gallery
                    self.vc?.present(picker, animated: true, completion: nil)
                }
            } else {
                print(self.GALLERY_NOT_AVAILABLE)
            }
        }
    }
}

// MARK: - UIImagePicker Delegates
extension ChatImagePicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        // Check if the selected media is an image
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
            videoURL = nil // Clear videoURL as we picked an image
        }
        
        // Check if the selected media is a video
        if let videoUrl = info[.mediaURL] as? URL {
            videoURL = videoUrl
            originalImage = nil // Clear originalImage as we picked a video
        }
        
        picker.dismiss(animated: true) {
            if self.originalImage == nil, self.videoURL == nil {
                print("Something went wrong")
            } else {
                self.mediaClosure?(self.originalImage, self.videoURL)
            }
        }
    }
}

// Helper function for showing settings alert
extension ChatImagePicker {
    private func showSettingsAlert(controller: UIViewController?,
                                   msg: String,
                                   _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            completionHandler(false)
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(false)
        })
        
        controller?.present(alert, animated: true)
    }
}
