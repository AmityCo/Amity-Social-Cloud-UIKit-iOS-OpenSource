//
//  LiveStreamBroadcastVC+CoverImagePicker.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 1/9/2564 BE.
//

import UIKit
import MobileCoreServices

// MARK: -

extension LiveStreamBroadcastViewController {
    
    func presentCoverImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

// MARK: - UIImagePickerController Delegate Requirements

extension LiveStreamBroadcastViewController: UINavigationControllerDelegate {
    
}

extension LiveStreamBroadcastViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let mediaType = info[.mediaType] as? String else {
            return
        }
        
        switch mediaType {
        case String(kUTTypeImage):
            if let imageUrl = info[.imageURL] as? URL {
                coverImageUrl = imageUrl
            }
            updateCoverImageSelection()
        default:
            assertionFailure("Unsupported media type")
            break
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
