//
//  AmityFeedUISettings.swift
//  AmityUIKit
//
//  Created by Hamlet on 27.01.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

/**
 * Amity Feed UI Settings
 */
public class AmityFeedUISettings {
    
    // MARK: - Properties
    
    public static let shared = AmityFeedUISettings()
    
    public var eventHandler = AmityFeedEventHandler() {
        didSet {
            AmityFeedEventHandler.shared = eventHandler
        }
    }
    
    public var myFeedSharingTargets: Set<AmityPostSharingTarget> {
        return sharingSettings.myFeedPostSharingTarget()
    }
    
    public var userFeedSharingTargets: Set<AmityPostSharingTarget> {
        return sharingSettings.userFeedPostSharingTarget()
    }
    
    public var privateCommunitySharingTargets: Set<AmityPostSharingTarget> {
        return sharingSettings.privateCommunityPostSharingTarget()
    }
    
    public var publicCommunitySharingTargets: Set<AmityPostSharingTarget> {
        return sharingSettings.publicCommunityPostSharingTarget()
    }
    
    private var sharingSettings = AmityPostSharingSettings()
    
    // MARK: - Initializer
    
    private init() { }
    
    // MARK: - Methods
    
    public func setPostSharingSettings(settings: AmityPostSharingSettings) {
        self.sharingSettings = settings
    }
    
    public func getPostSharingSettings() -> AmityPostSharingSettings {
        return self.sharingSettings
    }
    
    /// The object that acts as the delegate of the feed view.
    public weak var delegate: AmityFeedDelegate?
    
    /// The object that acts as the data source of the feed view.
    public weak var dataSource: AmityFeedDataSource?
    
    
    /// Registers a nib object containing a cell with the table view under a specified identifier.
    /// - Parameters:
    ///   - nib: A nib object that specifies the nib file to use to create the cell.
    ///   - identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    public func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        customNib.append(AmityFeedCustomCellModel(nib: nib, identifier: identifier))
    }
    
    /// Registers a class for use in creating new table cells.
    /// - Parameters:
    ///   - cellClass: The class of a cell that you want to use in the table (must be a ```UITableViewCell``` subclass).
    ///   - identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    public func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        customCellClass.append(AmityFeedCustomCellModel(cellClass: cellClass, identifier: identifier))
    }
    
    internal var customNib: [AmityFeedCustomCellModel] = []
    internal var customCellClass: [AmityFeedCustomCellModel] = []
}

// MARK: Helper model
internal struct AmityFeedCustomCellModel {
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

