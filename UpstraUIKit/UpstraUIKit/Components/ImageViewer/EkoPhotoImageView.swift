//
//  EkoPhotoImageView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

class EkoPhotoImageView: UIImageView {    
    override var image: UIImage? {
        didSet {
            imageChangeBlock?(image)
        }
    }
    
    var imageChangeBlock: ((UIImage?) -> Void)?
}
