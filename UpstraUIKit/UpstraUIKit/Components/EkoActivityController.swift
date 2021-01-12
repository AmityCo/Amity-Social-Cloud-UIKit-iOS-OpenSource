//
//  EkoActivityController.swift
//  UpstraUIKit
//
//  Created by Hamlet on 06.01.21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

public class EkoActivityController: UIActivityViewController {

    // This is a wrapper class to help fill in parameters.
    public static func make(activityItems: [Any],  applicationActivities: [UIActivity]? = nil) -> EkoActivityController {
        return EkoActivityController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
}
