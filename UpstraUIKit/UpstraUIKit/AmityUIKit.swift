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
    
    
    /// Setup AmityUIKit instance. Internally it creates AmityClient instance
    /// from AmitySDK.
    ///
    /// If you are using `AmitySDK` & `AmityUIKit` within same project, you can setup `AmityClient` instance using this method and access it using static property `client`.
    ///
    /// ~~~
    /// AmityUIKitManager.setup(...)
    /// ...
    /// let client: AmityClient = AmityUIKitManager.client
    /// ~~~
    ///
    /// - Parameters:
    ///   - apiKey: ApiKey provided by Amity
    ///   - region: The region to which this UIKit connects to. By default, region is .global
    public static func setup(apiKey: String, region: AmityRegion = .global) {
        AmityUIKitManagerInternal.shared.setup(apiKey, region: region)
    }
    
    
    /// Setup AmityUIKit instance. Internally it creates AmityClient instance from AmitySDK.
    ///
    /// If you do not need extra configuration, please use setup(apiKey:_, region:_) method instead.
    ///
    /// Also if you are using `AmitySDK` & `AmityUIKit` within same project, you can setup `AmityClient` instance using this method and access it using static property `client`.
    ///
    /// ~~~
    /// AmityUIKitManager.setup(...)
    /// ...
    /// let client: AmityClient = AmityUIKitManager.client
    /// ~~~
    ///
    /// - Parameters:
    ///   - apiKey: ApiKey provided by Amity
    ///   - endpoint: Custom Endpoint to which this UIKit connects to.
    public static func setup(apiKey: String, endpoint: AmityEndpoint) {
        AmityUIKitManagerInternal.shared.setup(apiKey, endpoint: endpoint)
    }
    
    // MARK: - Setup Authentication
    
    /// Setup AmityUIKit instance. Internally it creates AmityClient instance from AmitySDK.
    ///
    /// - Parameters:
    ///   - apiKey: API key provided by Amity.
    ///   - httpUrl: Custom url to be used as base url.
    ///   - socketUrl: Custom url to be used as base url.
    ///
    @available(swift, deprecated: 2.8.0, message: "This method will be removed in future version. Please use `setup(apiKey:_, region:_)` method instead")
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
    @available(iOS 13.0.0, *)
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
    
    public static func setUrlAdvertisement(_ url: String) {
        AmityUIKitManagerInternal.shared.urlAdvertisement = url
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
    
    public static var AmityLanguage: String {
        AmityUIKitManagerInternal.shared.amityLanguage
    }
    
    public static var currentUserId: String {
        AmityUIKitManagerInternal.shared.currentUserId
    }
   
}

final class AmityUIKitManagerInternal: NSObject {
    
    // MARK: - Properties
    
    enum Env {
        case production
        case staging
        case indonesia
        case cambodia
        case philippin
        case vietnam
        case myanmar
    }
    
    public static let shared = AmityUIKitManagerInternal()
    private var _client: AmityClient?
    private var apiKey: String = ""
    private var httpUrl: String = ""
    private var socketUrl: String = ""
    private var language: String = ""
    private var userToken: String = ""
    
    var stagingLiveRoleID: [String] {
        return ["251a6a45-13f3-4c45-8bb5-bebd5d2a8819",
                "84ef8e1e-c26a-4e7c-bff9-9105dcacb8dd",
                "f60a11c7-8832-42b3-9f27-bba09d7c7bd8",
                "13daf123-326d-441f-a7ad-eab376f2ed47",
                "5fc45a0d-220b-43bf-bd37-cd40d1fb3798",
                "4d1269fd-3411-4f71-9e3d-b32828dbf601"]
    }
    
    var productionLiveRoleID: [String] {
        return ["df29018e-49fb-4197-b53b-0267464b4301",
                "3010519a-f08a-4d21-8075-1be9414f8f47",
                "955a4648-319b-420a-b97a-b44f6e69dad5",
                "0e5f90c6-754a-465f-b62e-41df0f95c402",
                "884895d3-ec5d-445b-bbe2-5f4f300162ea",
                "364ef67b-7780-47a6-bbcb-0b1cc8c8c6dd"]
    }
    
    private(set) var fileService = AmityFileService()
    private(set) var messageMediaService = AmityMessageMediaService()
    
    var currentUserId: String { return client.currentUserId ?? "" }
    var currentUserToken: String { return self.userToken }
    
    var client: AmityClient {
        guard let client = _client else {
            fatalError("Something went wrong. Please ensure `AmityUIKitManager.setup(:_)` get called before accessing client.")
        }
        return client
    }
        
    var envByApiKey:Env {
        switch apiKey {
        case "b0eceb5e68ddf36545308f4e000b12dcd90985e2bf3d6a2e": return .staging
        case "b3bde15c3989f86045658e4a530a1688d1088be0be3d6f25": return .production
        case "b0ece908338da6314c61df1a5701408e865d8be7bf366f79": return .indonesia
        case "b0ece9086bdbf1334c61df1a570114d9860b8be7bf366e78": return .indonesia
        case "b0ecbd0e3a8df46c48308b48515e128bd65a8ee3e8333b2b": return .cambodia
        case "b0ecbd0e3a8df36c4c66dc4852091481820d84b7e9643b78": return .cambodia
        case "b0ece9086bdbf5654c61df1a5701148ad7088be7bf366d7f": return .philippin
        case "b0ece9086bdbf7644c61df1a57011fdad50d8be7bf366c24": return .philippin
        case "b0ece9086bdbf9604c61df1a5701458ad40e8be7bf366b25": return .vietnam
        case "b0ece9086bdba2604c61df1a570114dcd15f8be7bf366a2a": return .vietnam
        case "b0edb9523cd3f26644368b1c51011f8ad0008be1b3336e7a": return .myanmar
        case "b0edb9523cdcf7344c328d1a570912dcd10d8fe5bb3d6b2a": return .myanmar
        default: return .staging
        }
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
    
    var urlAdvertisement: String = ""
    
    // MARK: - Initializer
    
    private override init() { }
    
    // MARK: - Setup functions

    func setup(_ apiKey: String, region: AmityRegion) {
        guard let client = try? AmityClient(apiKey: apiKey, region: region) else { return }
        self.apiKey = apiKey

        // Passing empty string over `httpUrl` and `socketUrl` is acceptable.
        // `AmityClient` will be using the default endpoint instead.
        guard let client = try? AmityClient(apiKey: apiKey, httpUrl: httpUrl, socketUrl: socketUrl) else {
            assertionFailure("Something went wrong. API key is invalid.")
            return
        }
        _client = client
        _client?.clientErrorDelegate = self
    }
    
    func setup(_ apiKey: String, endpoint: AmityEndpoint) {
        guard let client = try? AmityClient(apiKey: apiKey, endpoint: endpoint) else { return }
        self.apiKey = apiKey

        // Passing empty string over `httpUrl` and `socketUrl` is acceptable.
        // `AmityClient` will be using the default endpoint instead.
        guard let client = try? AmityClient(apiKey: apiKey, httpUrl: httpUrl, socketUrl: socketUrl) else {
            assertionFailure("Something went wrong. API key is invalid.")
            return
        }
        _client = client
        _client?.clientErrorDelegate = self
    }
    
    func setup(_ apiKey: String, httpUrl: String = "", socketUrl: String = "") {
        self.apiKey = apiKey

        // Passing empty string over `httpUrl` and `socketUrl` is acceptable.
        // `AmityClient` will be using the default endpoint instead.
        guard let client = try? AmityClient(apiKey: apiKey, httpUrl: httpUrl, socketUrl: socketUrl) else {
            assertionFailure("Something went wrong. API key is invalid.")
            return
        }
        _client = client
        _client?.clientErrorDelegate = self
    }

    @available(iOS 13.0.0, *)
    func registerDevice(_ userId: String,
                        displayName: String?,
                        authToken: String?,
                        completion: AmityRequestCompletion?) {
    
        client.login(userId: userId, displayName: displayName, authToken: authToken) { [weak self] status, error in
            self?.didUpdateClient()
            self?.registerUserToken(userId: userId)
            completion?(status, error)
        }
    }
    
    func unregisterDevice() {
        AmityFileCache.shared.clearCache()
        self._client?.logout()
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

    @available(iOS 13.0.0, *)
    func registerUserToken(userId: String) {
        Task {
            let userTokenManager = AmityUserTokenManager(apiKey: apiKey, region: .SG)
            let result = await userTokenManager.createUserToken(
                userId: userId
            )
            switch result {
            case .success(let auth):
//                print("auth.accessToken: \(auth.accessToken)")
                userToken = auth.accessToken
            case .failure(let error):
                print("unable to create a new user token: \(error.localizedDescription)")
            }
        }
    }
    
}

extension AmityUIKitManagerInternal: AmityClientErrorDelegate {
    
    func didReceiveAsyncError(_ error: Error) {
//        AmityHUD.show(.error(message: error.localizedDescription))
        print("Error: \(error.localizedDescription)")
    }
}
