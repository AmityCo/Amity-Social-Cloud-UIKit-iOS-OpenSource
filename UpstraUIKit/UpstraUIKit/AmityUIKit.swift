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
    
    /// Setup AmityUIKit instance. Internally it creates AmityClient instance from AmitySDK.
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
    
    /// Registers current user with server. This is analogous to "login" process. If the user is already registered, local
    /// information is used. It is okay to call this method multiple times.
    ///
    /// Note:
    /// You do not need to call `unregisterDevice` before calling this method. If new user is being registered, then sdk handles unregistering process automatically.
    /// So simply call `registerDevice` with new user information.
    ///
    /// - Parameters:
    ///   - userId: Id of the user
    ///   - displayName: Display name of the user. If display name is not provided, user id would be set as display name.
    ///   - authToken: Auth token for this user if you are using secure mode.
    ///   - completion: Completion handler.
    public static func registerDevice(
        withUserId userId: String,
        displayName: String?,
        authToken: String? = nil,
        completion: AmityRequestCompletion? = nil) {
        AmityUIKitManagerInternal.shared.registerDevice(userId, displayName: displayName, authToken: authToken, completion: completion)
    }
    
    /// Unregisters current user. This removes all data related to current user & terminates conenction with server. This is analogous to "logout" process.
    /// Once this method is called, the only way to re-establish connection would be to call `registerDevice` method again.
    ///
    /// Note:
    /// You do not need to call this method before calling `registerDevice`.
    public static func unregisterDevice() {
        AmityUIKitManagerInternal.shared.unregisterDevice()
    }
    
    
    /// Registers this device for receiving apple push notification
    /// - Parameter deviceToken: Correct apple push notificatoin token received from the app.
    public static func registerDeviceForPushNotification(_ deviceToken: String, completion: AmityRequestCompletion? = nil) {
        AmityUIKitManagerInternal.shared.registerDeviceForPushNotification(deviceToken, completion: completion)
    }
    
    /// Unregisters this device for receiving push notification related to AmitySDK.
    public static func unregisterDevicePushNotification() {
        AmityUIKitManagerInternal.shared.unregisterDevicePushNotification()
    }
    
    public static func setEnvironment(_ env: [String: Any]) {
        AmityUIKitManagerInternal.shared.env = env
    }
    
    // MARK: - Variable
    
    /// Public instance of `AmityClient` from `AmitySDK`. If you are using both`AmitySDK` & `AmityUIKit` in a same project, we recommend to have only one instance of `AmityClient`. You can use this instance instead.
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
    
    public static func setLanguage(language: String) {
        AmityUIKitManagerInternal.shared.setLanguage(language: language)
    }
    
    public static var isClient: Bool {
        AmityUIKitManagerInternal.shared.isClientRegister
    }
   
}

final class AmityUIKitManagerInternal: NSObject {
    
    // MARK: - Properties
    
    public static let shared = AmityUIKitManagerInternal()
    private var _client: AmityClient?
    private var apiKey: String = ""
    private var httpUrl: String = ""
    private var socketUrl: String = ""
    private var language: String = ""
    
    private(set) var fileService = AmityFileService()
    private(set) var messageMediaService = AmityMessageMediaService()
    
    var currentUserId: String { return client.currentUserId ?? "" }
    
    var client: AmityClient {
        guard let client = _client else {
            fatalError("Something went wrong. Please ensure `AmityUIKitManager.setup(:_)` get called before accessing client.")
        }
        return client
    }
    
    var isClientRegister: Bool {
        if _client == nil {
            return false
        } else {
            return true
        }
    }
    
    var amityLanguage: String { return language }
    
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
        
        client.registerDevice(withUserId: userId, displayName: displayName, authToken: authToken) { [weak self] status, error in
            self?.didUpdateClient()
            completion?(status, error)
        }
        
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
    
    func unregisterDevicePushNotification(completion: AmityRequestCompletion? = nil) {
        guard let currentUserId = self._client?.currentUserId else { return }
        client.unregisterDeviceForPushNotification(forUserId: currentUserId, completion: completion)
    }
    
    func setLanguage(language: String) {
        self.language = language.lowercased()
    }
    
}

extension AmityUIKitManagerInternal: AmityClientErrorDelegate {
    
    func didReceiveAsyncError(_ error: Error) {
        AmityHUD.show(.error(message: error.localizedDescription))
    }
    
}
