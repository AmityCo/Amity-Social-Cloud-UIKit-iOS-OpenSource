//
//  EkoPhotoScrollView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

public class EkoPhotoScrollView: UIScrollView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        panGestureRecognizer.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: UIGestureRecognizerDelegate
extension EkoPhotoScrollView: UIGestureRecognizerDelegate {
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            if gestureRecognizer.numberOfTouches == 1 && zoomScale == 1.0 {
                return false
            }
        }
        
        return true
    }
}
