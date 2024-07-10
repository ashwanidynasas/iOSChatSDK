//
//  SQRCLEImagePicker.swift
//  Dynasas
//
//  Created by Dynasas on 22/08/23.
//


import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

enum ImagePickerDisplayText: String {
    
    case gallery = "Gallery"
    case camera = "Camera"
    case cancel = "Cancel"
    case okay = "Okay"
    case cameraDisabled = "Camera is disabled"
    case enableCamera = "Enable camera"
    case enablePhoto = "Enable photos"
    case photoLibraryDisabled = "Photo Library is disabled"
    case errorOccured = "Something error occured"
    case text = "Text"
    case photo = "Photo"
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue.localizedString(), comment: "")
    }
}

class SQRCLEImagePicker: NSObject {
    
    static let sharedHandler = SQRCLEImagePicker()
    var guestInstance: UIViewController?
    var imageClosure: ((_ editedImage: UIImage?, _ originalImage: UIImage?) -> Void)?
    var editedImage: UIImage?
    var originalImage: UIImage?
    
    func getImage(instance: UIViewController, rect: CGRect?, optionName: String, allowEditing: Bool? = true, galleryTitle: String = ImagePickerDisplayText.gallery.localizedString, cameraTitle: String = ImagePickerDisplayText.camera.localizedString, completion: ((_ editedImage: UIImage?, _ originalImage: UIImage?) -> Void)?) {
        guestInstance = instance
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = allowEditing ?? true
        imgPicker.mediaTypes = [(kUTTypeImage) as String]
        imgPicker.allowsEditing = false
        if UIDevice.current.userInterfaceIdiom == .phone {
            if optionName == galleryTitle {
                // For gallery Option
                self.openGallery(picker: imgPicker)
            } else {
                // For Camera Option
                self.openCamera(picker: imgPicker)
            }
        }
        
        imageClosure = { (_, _) in
            completion?(self.editedImage, self.originalImage)
        }
    }
    
    // Private Methods
    
    private func openCamera(picker: UIImagePickerController) {
        checkCameraDeniedStatus { (success) in
            if success {
                Threads.performTaskInMainQueue {
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                        picker.sourceType = UIImagePickerController.SourceType.camera
                        picker.edgesForExtendedLayout = UIRectEdge.all
                        picker.showsCameraControls = true
                        self.guestInstance?.present(picker, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Warning", message: "Camera is not available.", preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: ImagePickerDisplayText.okay.localizedString, style: .default, handler: nil)
                        alert.addAction(actionOK)
                        self.guestInstance?.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                self.openPopupCameraServiceOff()
            }
        }
    }
    
    private func checkCameraDeniedStatus(completionClosure: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == .denied {
            completionClosure(false)
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    completionClosure(true)
                } else {
                    completionClosure(false)
                }
            })
        } else {
            completionClosure(true)
        }
    }
    
    private func openPopupCameraServiceOff() {
        DispatchQueue.main.async(execute: {
//            AlertUtiliy.addToast(message: ImagePickerDisplayText.cameraDisabled.localizedString, style: .warning)
        })
    }
    
    private func openCameraSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl) { (_) in
            }
        }
    }
    
    func openGallery(picker: UIImagePickerController) {
        checkGalleryDeniedStatus(completionClosure: { (success) in
            if success {
                Threads.performTaskInMainQueue {
                    picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.guestInstance?.present(picker, animated: true, completion: nil)
                }
            } else {
                self.openPopupGalleryServiceOff()
            }
        })
    }
    
    private func checkGalleryDeniedStatus(completionClosure: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                completionClosure(true)
            case .denied:
                completionClosure(false)
            default:
                completionClosure(true)
            }
        }
    }
    
    private func openPopupGalleryServiceOff() {
        DispatchQueue.main.async(execute: {
            DispatchQueue.main.async(execute: {
//                AlertUtiliy.addToast(message: ImagePickerDisplayText.cameraDisabled.localizedString, style: .warning)
            })
        })
    }
}

// MARK: - UIImagePicker Delegates
extension SQRCLEImagePicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) // Cancel button  of imagePicker
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            editedImage = image
        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true) {
            if self.editedImage == nil, self.originalImage == nil {
//                AlertUtiliy.addToast(message: ImagePickerDisplayText.errorOccured.localizedString, style: .danger)
            } else {
                self.imageClosure?(self.editedImage, self.originalImage)
            }
        }
    }
}
