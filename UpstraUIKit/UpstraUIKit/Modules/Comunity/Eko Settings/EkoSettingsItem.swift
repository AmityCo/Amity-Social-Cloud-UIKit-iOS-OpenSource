//
//  EkoSettingsItem.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 6/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//

import UIKit
protocol EkoSettingsItemContentIdentifier {
    var identifier: String { get }
}
enum EkoSettingsItem {
    case header(content: HeaderContent)
    case separator
    case textContent(content: TextContent)
    case navigationContent(content: NavigationContent)
    case toggleContent(content: ToggleContent)
    case radioButtonContent(content: RadionButtonContent)
    
    struct HeaderContent {
        let title: String
    }
    
    struct TextContent: EkoSettingsItemContentIdentifier {
        let identifier: String
        let icon: UIImage?
        let title: String
        let description: String?
        let titleTextColor: UIColor?
        
        init(identifier: String, icon: UIImage?, title: String, description: String?, titleTextColor: UIColor? = EkoColorSet.base) {
            self.identifier = identifier
            self.icon = icon
            self.title = title
            self.description = description
            self.titleTextColor = titleTextColor
        }
    }
    
    struct NavigationContent: EkoSettingsItemContentIdentifier {
        let identifier: String
        let icon: UIImage?
        let title: String
        let description: String?
    }
    
    class ToggleContent: EkoSettingsItemContentIdentifier {
        let identifier: String
        let iconContent: EkoSettingContentIcon?
        let title: String
        let description: String?
        var isToggled: Bool {
            didSet {
                callback?(isToggled)
            }
        }
        var callback: ((Bool) -> Void)?
        
        init(identifier: String, iconContent: EkoSettingContentIcon?, title: String, description: String?, isToggled: Bool) {
            self.identifier = identifier
            self.iconContent = iconContent
            self.title = title
            self.description = description
            self.isToggled = isToggled
        }
    }
    
    class RadionButtonContent: EkoSettingsItemContentIdentifier {
        let identifier: String
        let title: String
        var isSelected: Bool
        
        init(identifier: String, title: String, isSelected: Bool) {
            self.identifier = identifier
            self.title = title
            self.isSelected = isSelected
        }
    }
}
