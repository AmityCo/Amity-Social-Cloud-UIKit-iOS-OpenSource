//
//  EkoMyCommunityViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

/// A view controller for providing all community list.
public class EkoMyCommunityViewController {

    // This is a wrapper class to help fill in all parameters.
    public static func make() -> EkoViewController {
        return EkoSearchCommunityViewController.make(for: nil, searchType: .inTableView)
    }
    
}
