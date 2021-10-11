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
    
    /// Setup AmityClient
    ///
    /// - Parameters:
    ///   - apiKey: API key provided by Amity.
    ///   - httpUrl: Custom url to be used as base url.
    ///   - socketUrl: Custom url to be used as base url.
    public static func setup(apiKey: String, httpUrl: String? = nil, socketUrl: String? = nil) {
        if let httpUrl = httpUrl, let socketUrl = socketUrl {
            AmityUIKitManagerInternal.shared.setup(apiKey, httpUrl: httpUrl, socketUrl: socketUrl)
        } else if let httpUrl = httpUrl {
            AmityUIKitManagerInternal.shared.setup(apiKey, httpUrl: httpUrl)
        } else if let socketUrl = socketUrl {
            AmityUIKitManagerInternal.shared.setup(apiKey, socketUrl: socketUrl)
        } else {
            AmityUIKitManagerInternal.shared.setup(apiKey)
        }
    }
    
    public static func registerDevice(
        withUserId userId: String,
        displayName: String?,
        authToken: String? = nil,
        completion: AmityRequestCompletion? = nil) {
        AmityUIKitManagerInternal.shared.registerDevice(userId, displayName: displayName, authToken: authToken, completion: completion)
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
    
    public static func set(channelEventHandler: AmityChannelEventHandler) {
        AmityChannelEventHandler.shared = channelEventHandler
    }
    
    public static func setLanguage(language: AmityLanguageType) {
        AmityUIKitManagerInternal.shared.setLanguage(language: language)
    }
}

final class AmityUIKitManagerInternal: NSObject {
    
    // MARK: - Properties
    
    public static let shared = AmityUIKitManagerInternal()
    private var _client: AmityClient?
    private var apiKey: String = ""
    private var httpUrl: String = ""
    private var socketUrl: String = ""
    private var language: AmityLanguageType = .en
    
    private(set) var fileService = AmityFileService()
    private(set) var messageMediaService = AmityMessageMediaService()
    
    var currentUserId: String { return client.currentUserId ?? "" }
    
    var client: AmityClient {
        guard let client = _client else {
            fatalError("Something went wrong. Please ensure `AmityUIKitManager.setup(:_)` get called before accessing client.")
        }
        return client
    }
    
    var amityLanguage: AmityLanguageType { return language }
    
    var env: [String: Any] = [:]
    
    // MARK: - Initializer
    
    private override init() { }
    
    // MARK: - Setup functions

    func setup(_ apiKey: String, httpUrl: String = "", socketUrl: String = "") {
        self.apiKey = apiKey
        self.httpUrl = httpUrl
        self.socketUrl = socketUrl
        
        // Passing empty string over `httpUrl` and `socketUrl` is acceptable.
        // `AmityClient` will be using the default endpoint instead.
        guard let client = AmityClient(apiKey: apiKey, httpUrl: httpUrl, socketUrl: socketUrl) else {
            assertionFailure("Something went wrong. API key is invalid.")
            return
        }
        _client = client
        _client?.clientErrorDelegate = self
    }

    func registerDevice(_ userId: String,
                        displayName: String?,
                        authToken: String?,
                        completion: AmityRequestCompletion?) {
        
        // clear current client before setting up a new one
        unregisterDevice()
        
        client.registerDevice(withUserId: userId, displayName: displayName, authToken: authToken, completion: completion)
        didUpdateClient()
    }
    
    func unregisterDevice() {
        AmityFileCache.shared.clearCache()
        self._client?.unregisterDevice()
    }
    
    func didUpdateClient() {
        // Update file repository to use in file service.
        fileService.fileRepository = AmityFileRepository(client: client)
        messageMediaService.fileRepository = AmityFileRepository(client: client)
    }
    
    func registerDeviceForPushNotification(_ deviceToken: String, completion: AmityRequestCompletion? = nil) {
        self._client?.registerDeviceForPushNotification(withDeviceToken: deviceToken, completion: completion)
    }
    
    func unregisterDevicePushNotification() {
        guard let currentUserId = self._client?.currentUserId else { return }
        client.unregisterDeviceForPushNotification(forUserId: currentUserId, completion: nil)
    }
    
    func setLanguage(language: AmityLanguageType) {
        self.language = language
    }
    
}

extension AmityUIKitManagerInternal: AmityClientErrorDelegate {
    
    func didReceiveAsyncError(_ error: Error) {
        AmityHUD.show(.error(message: error.localizedDescription))
    }
    
}
