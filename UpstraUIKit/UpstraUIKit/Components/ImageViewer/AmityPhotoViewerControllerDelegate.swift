//
//  AmityPhotoViewerControllerDelegate.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

@objc public protocol AmityPhotoViewerControllerDelegate: NSObjectProtocol {
    @objc optional func photoViewerController(_ photoViewerController: AmityPhotoViewerController, didScrollToPhotoAt index: Int)
    
    @objc optional func photoViewerController(_ photoViewerController: AmityPhotoViewerController, didZoomOnPhotoAtIndex: Int, atScale scale: CGFloat)
    
    @objc optional func photoViewerController(_ photoViewerController: AmityPhotoViewerController, didEndZoomingOnPhotoAtIndex: Int, atScale scale: CGFloat)
    
    @objc optional func photoViewerController(_ photoViewerController: AmityPhotoViewerController, willZoomOnPhotoAtIndex: Int)
    
    @objc optional func photoViewerControllerDidReceiveTapGesture(_ photoViewerController: AmityPhotoViewerController)
    
    @objc optional func photoViewerControllerDidReceiveDoubleTapGesture(_ photoViewerController: AmityPhotoViewerController)
    
    @objc optional func photoViewerController(_ photoViewerController: AmityPhotoViewerController, willBeginPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer)
    
    @objc optional func photoViewerController(_ photoViewerController: AmityPhotoViewerController, didEndPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer)
    
    @objc optional func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: AmityPhotoViewerController)
    
    @objc optional func photoViewerController(_ photoViewerController: AmityPhotoViewerController, scrollViewDidScroll: UIScrollView)
}
