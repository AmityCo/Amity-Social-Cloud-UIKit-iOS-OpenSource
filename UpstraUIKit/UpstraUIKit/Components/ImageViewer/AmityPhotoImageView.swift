//
//  AmityPhotoImageView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

class AmityPhotoImageView: UIImageView {    
    override var image: UIImage? {
        didSet {
            imageChangeBlock?(image)
        }
    }
    
    var imageChangeBlock: ((UIImage?) -> Void)?
}
