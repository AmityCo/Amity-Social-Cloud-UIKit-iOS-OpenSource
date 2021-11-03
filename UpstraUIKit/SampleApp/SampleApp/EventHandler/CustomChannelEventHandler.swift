//
//  CustomChannelEventHandler.swift
//  SampleApp
//
//  Created by min khant on 20/07/2021.
//  Copyright © 2021 Eko. All rights reserved.
//

import Foundation
import AmityUIKit

class CustomChannelEventHandler: AmityChannelEventHandler {
    
    override func channelDidTap(from source: AmityViewController,
                                channelId: String) {
        var settings = AmityMessageListViewController.Settings()
        settings.shouldShowChatSettingBarButton = true
        let viewController = AmityMessageListViewController.make(channelId: channelId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
