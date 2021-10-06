//
//  UpstraUIKit.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 2/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import EkoChat

/// UpstraUIKit
public final class UpstraUIKitManager {
    
    private init() { }
    
    // MARK: - Setup Authentication
    
    public static func setup(_ apiKey: String) {
        UpstraUIKitManagerInternal.shared.setup(apiKey)
    }
    
    public static func registerDevice(withUserId userId: String, displayName: String?, authToken: String? = nil, completion: EkoRequestCompletion? = nil) {
        UpstraUIKitManagerInternal.shared.registerDevice(userId, displayName: displayName, authToken: authToken, completion: completion)
    }
    public static func unregisterDevice() {
        UpstraUIKitManagerInternal.shared.unregisterDevice()
    }
    
    public static func registerDeviceForPushNotification(_ deviceToken: String) {
        UpstraUIKitManagerInternal.shared.registerDeviceForPushNotification(deviceToken)
    }
    
    public static func unregisterDevicePushNotification() {
        UpstraUIKitManagerInternal.shared.unregisterDevicePushNotification()
    }
    
    public static func setEnvironment(_ env: [String: Any]) {
        UpstraUIKitManagerInternal.shared.env = env
    }
    
    // MARK: - Variable
    
    public static var client: EkoClient {
        return UpstraUIKitManagerInternal.shared.client
    }
    
    public static var feedUISettings: EkoFeedUISettings {
        return EkoFeedUISettings.shared
    }
    
    static var bundle: Bundle {
        return Bundle(for: self)
    }
    
    // MARK: - Helper methods
    
    public static func set(theme: EkoTheme) {
        EkoThemeManager.set(theme: theme)
    }
    
    public static func set(typography: EkoTypography) {
        EkoFontSet.set(typography: typography)
    }
    
    public static func set(eventHandler: EkoEventHandler) {
        EkoEventHandler.shared = eventHandler
    }
}

final class UpstraUIKitManagerInternal: NSObject {
    
    // MARK: - Properties
    
    private var apiKey: String = ""
    public static let shared = UpstraUIKitManagerInternal()
    private var _client: EkoClient?
    
    private(set) var fileService = EkoFileService()
    private(set) var messageMediaService = EkoMessageMediaService()
    
    var currentUserId: String { return client.currentUserId ?? "" }
    
    var client: EkoClient {
        guard let client = _client else {
            fatalError("Something went wrong. Please call `UpstraUIKitManager.setup(:_)` for setting an apiKey.")
        }
        return client
    }
    
    var env: [String: Any] = [:]
    
    // MARK: - Initializer
    
    private override init() { }
    
    // MARK: - Setup functions
    
    func setup(_ apiKey: String) {
        self.apiKey = apiKey
        
        guard let client = EkoClient(apiKey: apiKey) else {
            assertionFailure("Something went wrong. API key is invalid.")
            return
        }
        _client = client
        _client?.clientErrorDelegate = self
    }

    func registerDevice(_ userId: String,
                        displayName: String?,
                        authToken: String?,
                        completion: EkoRequestCompletion?) {
            
        // clear current client before setting up a new one
        unregisterDevice()
            
        client.registerDevice(withUserId: userId, displayName: displayName, authToken: authToken, completion: completion)
        didUpdateClient()
    }
    
    func unregisterDevice() {
        EkoFileCache.shared.clearCache()
        self._client?.unregisterDevice()
    }
    
    func didUpdateClient() {
        // Update file repository to use in file service.
        fileService.fileRepository = EkoFileRepository(client: client)
        messageMediaService.messageRepository = EkoMessageRepository(client: client)
    }
    
    func registerDeviceForPushNotification(_ deviceToken: String, completion: EkoRequestCompletion? = nil) {
        self._client?.registerDeviceForPushNotification(withDeviceToken: deviceToken, completion: completion)
    }
    
    func unregisterDevicePushNotification() {
        guard let currentUserId = self._client?.currentUserId else { return }
        client.unregisterDevicePushNotification(forUserId: currentUserId, completion: nil)
    }
    
}

extension UpstraUIKitManagerInternal: EkoClientErrorDelegate {
    
    func didReceiveAsyncError(_ error: Error) {
        EkoHUD.show(.error(message: error.localizedDescription))
    }
    
}
