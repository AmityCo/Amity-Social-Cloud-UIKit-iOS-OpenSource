//
//  EkoFeedUISettings.swift
//  UpstraUIKit
//
//  Created by Hamlet on 27.01.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

/**
 * Eko Feed UI Settings
 */
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
    
    /// The object that acts as the delegate of the feed view.
    public weak var delegate: EkoFeedDelegate?
    
    /// The object that acts as the data source of the feed view.
    public weak var dataSource: EkoFeedDataSource?
    
    
    /// Registers a nib object containing a cell with the table view under a specified identifier.
    /// - Parameters:
    ///   - nib: A nib object that specifies the nib file to use to create the cell.
    ///   - identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    public func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        customNib.append(EkoFeedCustomCellModel(nib: nib, identifier: identifier))
    }
    
    /// Registers a class for use in creating new table cells.
    /// - Parameters:
    ///   - cellClass: The class of a cell that you want to use in the table (must be a ```UITableViewCell``` subclass).
    ///   - identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    public func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        customCellClass.append(EkoFeedCustomCellModel(cellClass: cellClass, identifier: identifier))
    }
    
    internal var customNib: [EkoFeedCustomCellModel] = []
    internal var customCellClass: [EkoFeedCustomCellModel] = []
}

// MARK: Helper model
internal struct EkoFeedCustomCellModel {
    var nib: UINib?
    let identifier: String
    var cellClass: AnyClass?
    
    init(nib: UINib?, identifier: String) {
        self.nib = nib
        self.identifier = identifier
    }
    
    init(cellClass: AnyClass?, identifier: String) {
        self.cellClass = cellClass
        self.identifier = identifier
        
    }
}

