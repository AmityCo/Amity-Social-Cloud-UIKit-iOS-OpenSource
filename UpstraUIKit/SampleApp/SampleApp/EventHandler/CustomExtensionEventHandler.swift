//
//  CustomExtensionEventHandler.swift
//  SampleApp
//
//  Created by Mono TheForestcat on 3/11/2565 BE.
//  Copyright © 2565 BE Eko. All rights reserved.
//

import Foundation
import AmityUIKit

class AmityCustomExtensionEventHandler: AmityExtensionEventHandler {
    override func dismissTargetPickerEvent() {
        print("Dismiss picker.")
    }
    
    override func finishPostEvent(_ callbackModel: CommunityPostEventModel) {
        print("Dismiss with share Extension")
    }
}
