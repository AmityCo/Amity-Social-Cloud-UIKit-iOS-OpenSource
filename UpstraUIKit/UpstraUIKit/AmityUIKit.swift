//
//  AmityUIKit.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 2/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

/// AmityUIKit
public final class AmityUIKitManager {
    
    private init() { }
    
    // MARK: - Setup Authentication
    
    public static func setup(_ apiKey: String) {
        AmityUIKitManagerInternal.shared.setup(apiKey)
    }
    
    public static func registerDevice(withUserId userId: String, displayName: String?, authToken: String? = nil) {
        AmityUIKitManagerInternal.shared.registerDevice(userId, displayName: displayName, authToken: authToken)
    }
    public static func unregisterDevice() {
        AmityUIKitManagerInternal.shared.unregisterDevice()
    }
    
    public static func registerDeviceForPushNotification(_ deviceToken: String) {
        AmityUIKitManagerInternal.shared.registerDeviceForPushNotification(deviceToken)
    }
    
    public static func unregisterDevicePushNotification() {
        AmityUIKitManagerInternal.shared.unregisterDevicePushNotification()
    }
    
    public static func setEnvironment(_ env: [String: Any]) {
        AmityUIKitManagerInternal.shared.env = env
    }
    
    // MARK: - Variable
    
    public static var client: AmityClient {
        return AmityUIKitManagerInternal.shared.client
    }
    
    public static var feedUISettings: AmityFeedUISettings {
        return AmityFeedUISettings.shared
    }
    
    static var bundle: Bundle {
        return Bundle(for: self)
    }
    
    // MARK: - Helper methods
    
    public static func set(theme: AmityTheme) {
        AmityThemeManager.set(theme: theme)
    }
    
    public static func set(typography: AmityTypography) {
        AmityFontSet.set(typography: typography)
    }
    
    public static func set(eventHandler: AmityEventHandler) {
        AmityEventHandler.shared = eventHandler
    }
}

final class AmityUIKitManagerInternal: NSObject {
    
    // MARK: - Properties
    
    private var apiKey: String = ""
    public static let shared = AmityUIKitManagerInternal()
    private var _client: AmityClient?
    
    var currentUserId: String { return client.currentUserId ?? "" }
    
    var client: AmityClient {
        guard let client = _client else {
            fatalError("Something went wrong. Please call `AmityUIKitManager.setup(:_)` for setting an apiKey.")
        }
        return client
    }
    
    var env: [String: Any] = [:]
    
    // MARK: - Initializer
    
    private override init() { }
    
    // MARK: - Setup functions

    func setup(_ apiKey: String) {
        self.apiKey = apiKey
    }

    func registerDevice(_ userId: String, displayName: String?, authToken: String?) {
        
        // clear current client before setting up a new one
        unregisterDevice()
        self._client = nil
        
        guard let _client = AmityClient(apiKey: apiKey) else {
            assertionFailure("Something went wrong. API key is invalid.")
            return
        }
        
        _client.clientErrorDelegate = self
        _client.registerDevice(withUserId: userId, displayName: displayName, authToken: authToken)
        self._client = _client
    }
    
    func unregisterDevice() {
        AmityFileCache.shared.clearCache()
        self._client?.unregisterDevice()
    }
    
    func registerDeviceForPushNotification(_ deviceToken: String, completion: AmityRequestCompletion? = nil) {
        self._client?.registerDeviceForPushNotification(withDeviceToken: deviceToken, completion: completion)
    }
    
    func unregisterDevicePushNotification() {
        guard let currentUserId = self._client?.currentUserId else { return }
        client.unregisterDeviceForPushNotification(forUserId: currentUserId, completion: nil)
    }
    
}

extension AmityUIKitManagerInternal: AmityClientErrorDelegate {
    
    func didReceiveAsyncError(_ error: Error) {
        AmityHUD.show(.error(message: error.localizedDescription))
    }
    
}
