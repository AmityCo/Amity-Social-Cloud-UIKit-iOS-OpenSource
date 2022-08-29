//
//  AmityShareFromGalleryProcessingView.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 25/8/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

class AmityShareFromGalleryProcessingView: AmityViewController {

    @IBOutlet var resultImageView: UIImageView!
    @IBOutlet var resultLabel: UILabel!
    
    var isSuccessPost: Bool = true

    init(isSuccess: Bool) {
        isSuccessPost = isSuccess
        super.init(nibName: AmityShareFromGalleryProcessingView.identifier, bundle: AmityUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        resultLabel.font = AmityFontSet.caption.withSize(20)
        updateProcessing(success: isSuccessPost)
    }
    
    func updateProcessing(success: Bool) {
        if success {
            resultImageView.image = AmityIconSet.iconShareFromGallerySuccess
            resultLabel.text = AmityLocalizedStringSet.ShareFromGallery.shareSuccessMessage.localizedString
        } else {
            resultImageView.image = AmityIconSet.iconShareFromGalleryFail
            resultLabel.text = AmityLocalizedStringSet.ShareFromGallery.shareFailMessage.localizedString
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
