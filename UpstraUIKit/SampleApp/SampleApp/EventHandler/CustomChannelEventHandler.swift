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
                                channelId: String, subChannelId: String) {
        var settings = AmityMessageListViewController.Settings()
        settings.shouldShowChatSettingBarButton = true
        let viewController = AmityMessageListViewController.make(channelId: channelId, subChannelId: subChannelId, settings: settings)
        if ChatFeatureSetting.shared.iscustomMessageEnabled {
            viewController.dataSource = self
        } else {
            viewController.dataSource = nil
        }
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension CustomChannelEventHandler: AmityMessageListDataSource {
    func cellForMessageTypes() -> [AmityMessageTypes : AmityMessageCellProtocol.Type] {
        return [
            .textIncoming: CustomMessageTextIncomingTableViewCell.self
        ]
    }
}

