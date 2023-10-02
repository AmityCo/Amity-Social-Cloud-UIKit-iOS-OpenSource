//
//  UIImageView+Extension.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import AmitySDK
import UIKit

extension UIImageView {
    
    // This can be expanded to support error image, placeholder and alldow
    func loadImage(with url: String, size: AmityMediaSize, placeholder: UIImage?, optimisticLoad: Bool = false) {
        if let placeholder = placeholder {
            image = placeholder
        }
        AmityUIKitManagerInternal.shared.fileService.loadImage(imageURL: url, size: size, optimisticLoad: optimisticLoad) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
            case .failure(let error):
                Log.add("Error while downloading image with file id: \(url) error: \(error)")
            }
        }
        
    }
    
    func setImageColor(_ color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
