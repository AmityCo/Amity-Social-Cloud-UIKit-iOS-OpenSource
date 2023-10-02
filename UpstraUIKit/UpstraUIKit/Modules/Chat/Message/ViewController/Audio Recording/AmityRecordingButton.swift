//
//  AmityRecordingButton.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 1/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit

#warning("NOTED: Should improvements this class")
final class AmityRecordingButton: UIButton {
    
    var isTimeout: Bool = false
    var deletingTarget: UIView?
    
    var deleteHandler: (() -> Void)?
    var recordHandler: (() -> Void)?
    var deletingHandler: (() -> Void)?
    var recordingHandler: (() -> Void)?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isTimeout else { return }
        guard let deleteView = deletingTarget else { return }
        let deleteX = ((touches.first as AnyObject) as! UITouch).location(in: deleteView).x
        let deleteY = ((touches.first as AnyObject) as! UITouch).location(in: deleteView).y
        
        if (((deleteX > 0) && (deleteX <= 48)) && ((deleteY > 0) && (deleteY <= 48))) {
            deletingHandler?()
        } else {
            recordingHandler?()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isTimeout else { return }
        guard let deleteView = deletingTarget else { return }
        
        let deleteX = ((touches.first as AnyObject) as! UITouch).location(in: deleteView).x
        let deleteY = ((touches.first as AnyObject) as! UITouch).location(in: deleteView).y
        
        if (((deleteX > 0) && (deleteX <= 48)) && ((deleteY > 0) && (deleteY <= 48))) {
            deleteHandler?()
        } else {
            recordHandler?()
        }
    }
}
