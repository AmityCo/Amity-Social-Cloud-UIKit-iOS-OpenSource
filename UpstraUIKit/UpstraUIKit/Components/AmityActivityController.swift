//
//  AmityActivityController.swift
//  AmityUIKit
//
//  Created by Hamlet on 13.01.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

public class AmityActivityController: UIActivityViewController {

    // This is a wrapper class to help fill in parameters.
    public static func make(activityItems: [Any],  applicationActivities: [UIActivity]? = nil) -> AmityActivityController {
        return AmityActivityController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
}
