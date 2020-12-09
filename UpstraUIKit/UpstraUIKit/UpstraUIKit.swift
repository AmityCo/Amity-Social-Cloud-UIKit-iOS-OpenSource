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
    
    public static func registerDevice(withUserId userId: String, displayName: String?, authToken: String? = nil) {
        UpstraUIKitManagerInternal.shared.registerDevice(userId, displayName: displayName, authToken: authToken)
    }
    
    public static func unregisterDevice() {
        UpstraUIKitManagerInternal.shared.unregisterDevice()
    }
    
    // MARK: - Variable
    
    public static var client: EkoClient {
        return UpstraUIKitManagerInternal.shared.client
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
    
    static func setModeratorRole(_ roles: Set<String>) {
        EkoUserManager.shared.roles = roles
    }
}

final class UpstraUIKitManagerInternal {
    
    // MARK: - Properties
    
    private var apiKey: String = ""
    public static let shared = UpstraUIKitManagerInternal()
    private var _client: EkoClient?
    
    var client: EkoClient {
        guard let client = _client else {
            fatalError("Something went wrong. Please call `UpstraUIKitManager.setup(:_)` for setting an apiKey.")
        }
        return client
    }
    
    // MARK: - Initializer
    
    private init() { }
    
    // MARK: - Setup functions

    func setup(_ apiKey: String) {
        self.apiKey = apiKey
    }

    func registerDevice(_ userId: String, displayName: String?, authToken: String?) {
        
        // clear current client before setting up a new one
        self._client?.unregisterDevice()
        self._client = nil
        
        guard let _client = EkoClient(apiKey: apiKey) else {
            assertionFailure("Something went wrong. API key is invalid.")
            return
        }
        
        _client.registerDevice(withUserId: userId, displayName: displayName, authToken: authToken)
        self._client = _client
    }
    
    func unregisterDevice() {
        EkoFileCache.shared.clearCache()
        self._client?.unregisterDevice()
    }
    
}

