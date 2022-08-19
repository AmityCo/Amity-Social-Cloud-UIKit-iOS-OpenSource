//
//  LiveStreamBroadcastVC+Permission.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 1/9/2564 BE.
//

import UIKit
import AVFoundation
import Photos
import AmityUIKit

extension LiveStreamBroadcastViewController {
    
    func permissionsGranted() -> Bool {
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        if auth != .authorized {
            return false
        }
        if AVAudioSession.sharedInstance().recordPermission != .granted {
            return false
        }
        return true
        
        
    }
    
    func permissionsNotDetermined() -> Bool {
        let cameraAuth = AVCaptureDevice.authorizationStatus(for: .video)
        let microphoneAuth = AVAudioSession.sharedInstance().recordPermission
        return cameraAuth == .notDetermined && microphoneAuth == .undetermined
    }
    
    func permissionsGoliveNotDetermined() -> Bool {
        let cameraAuth = AVCaptureDevice.authorizationStatus(for: .video)
        let microphoneAuth = AVAudioSession.sharedInstance().recordPermission
        return cameraAuth == .authorized && microphoneAuth == .granted
    }
    
    func requestPermissions(completion: @escaping (Bool) -> Void) {
        let requestCameraPermission: (@escaping (Bool) -> Void) -> Void = { completion in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
        let requestMicrophonePermission: (@escaping (Bool) -> Void) -> Void = { completion in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
        requestCameraPermission { cameraGranted in
            requestMicrophonePermission { microphoneGranted in
                completion(cameraGranted && microphoneGranted)
            }
        }
    }
    
    func presentPermissionRequiredDialogue() {
        let title = AmityLocalizedStringSet.LiveStream.Alert.titleAlertPermission.localizedString
        let message = AmityLocalizedStringSet.LiveStream.Alert.descriptionAlertPermission.localizedString
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .default, handler: { action in
        }))
        alertController.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.settings.localizedString, style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        self.present(alertController, animated: true)
    }
    
    func alertPhotoPermision() {
        let title = AmityLocalizedStringSet.LiveStream.Alert.titleAlerpermissionPhoto.localizedString
        let message = AmityLocalizedStringSet.LiveStream.Alert.descriptionAlertPermissionPhoto.localizedString
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .default, handler: { action in
        }))
        alertController.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.settings.localizedString, style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        self.present(alertController, animated: true)
    }
    
    func checkPhotoLibraryPermission(success: @escaping() -> (), fail: @escaping() -> ()) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
           switch photoAuthorizationStatus {
           case .authorized:
               success()
               break
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization({
                   (newStatus) in
                   if newStatus ==  PHAuthorizationStatus.authorized {
                       success()
                   }
               })
           case .restricted:
               break
           case .denied:
               fail()
               break
           case .limited:
               fail()
               break
           @unknown default:
               fail()
               break
           }
    }
    
}
