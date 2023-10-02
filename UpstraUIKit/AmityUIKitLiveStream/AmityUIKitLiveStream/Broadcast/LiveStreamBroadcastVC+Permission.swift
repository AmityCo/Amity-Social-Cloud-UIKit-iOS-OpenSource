//
//  LiveStreamBroadcastVC+Permission.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 1/9/2564 BE.
//

import UIKit
import AVFoundation

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
        let title = "Permission Required!!"
        let message = "Please grant permission in iOS settings."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
    
}
