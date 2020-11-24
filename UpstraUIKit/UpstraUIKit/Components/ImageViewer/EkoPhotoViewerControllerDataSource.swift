//
//  EkoPhotoViewerControllerDataSource.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 26/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

@objc public protocol EkoPhotoViewerControllerDataSource: NSObjectProtocol {
    /// Total number of photo in viewer.
    func numberOfItems(in photoViewerController: EkoPhotoViewerController) -> Int
    
    /// Configure each photo in viewer
    /// Implementation for photoViewerController:configurePhotoAt:withImageView is mandatory.
    /// Not implementing this method will cause viewer not to work properly.
    func photoViewerController(_ photoViewerController: EkoPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView)
    
    /// This is usually used if you have custom EkoPhotoCollectionViewCell and configure each photo differently.
    /// Remember this method cannot be a replacement of photoViewerController:configurePhotoAt:withImageView
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, configureCell cell: EkoPhotoCollectionViewCell, forPhotoAt index: Int)
    
    /// This method provide the specific referenced view for each photo item in viewer that will be used for smoother dismissal transition.
    @objc optional func photoViewerController(_ photoViewerController: EkoPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView?
}
