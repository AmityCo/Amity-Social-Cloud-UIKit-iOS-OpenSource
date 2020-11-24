//
//  EkoPhotoViewerControllerDelegate.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

@objc public protocol EkoPhotoViewerControllerDelegate: NSObjectProtocol {
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, didScrollToPhotoAt index: Int)
    
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, didZoomOnPhotoAtIndex: Int, atScale scale: CGFloat)
    
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, didEndZoomingOnPhotoAtIndex: Int, atScale scale: CGFloat)
    
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, willZoomOnPhotoAtIndex: Int)
    
    @objc optional func photoViewerControllerDidReceiveTapGesture(_ photoViewerController: EkoPhotoViewerController)
    
    @objc optional func photoViewerControllerDidReceiveDoubleTapGesture(_ photoViewerController: EkoPhotoViewerController)
    
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, willBeginPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer)
    
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, didEndPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer)
    
    @objc optional func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: EkoPhotoViewerController)
    
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, scrollViewDidScroll: UIScrollView)
}
