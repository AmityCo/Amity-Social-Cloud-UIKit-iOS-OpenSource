//
//  EkoFeedUISettings.swift
//  UpstraUIKit
//
//  Created by Hamlet on 27.01.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import Foundation

public class EkoFeedUISettings {
    
    // MARK: - Properties
    
    public static let shared = EkoFeedUISettings()
    
    public var eventHandler = EkoFeedEventHandler() {
        didSet {
            EkoFeedEventHandler.shared = eventHandler
        }
    }
    
    public var myFeedSharingTargets: Set<EkoPostSharingTarget> {
        return sharingSettings.myFeedPostSharingTarget()
    }
    
    public var userFeedSharingTargets: Set<EkoPostSharingTarget> {
        return sharingSettings.userFeedPostSharingTarget()
    }
    
    public var privateCommunitySharingTargets: Set<EkoPostSharingTarget> {
        return sharingSettings.privateCommunityPostSharingTarget()
    }
    
    public var publicCommunitySharingTargets: Set<EkoPostSharingTarget> {
        return sharingSettings.publicCommunityPostSharingTarget()
    }
    
    private var sharingSettings = EkoPostSharingSettings()
    
    // MARK: - Initializer
    
    private init() { }
    
    // MARK: - Methods
    
    public func setPostSharingSettings(settings: EkoPostSharingSettings) {
        self.sharingSettings = settings
    }
    
    public func getPostSharingSettings() -> EkoPostSharingSettings {
        return self.sharingSettings
    }
}
