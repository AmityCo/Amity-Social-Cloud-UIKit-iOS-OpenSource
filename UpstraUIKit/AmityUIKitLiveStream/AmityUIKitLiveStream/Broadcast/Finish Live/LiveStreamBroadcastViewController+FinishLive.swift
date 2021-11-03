//
//  LiveStreamBroadcastViewController+FinishLive.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 2/9/2564 BE.
//

import UIKit
import AmityUIKit

extension LiveStreamBroadcastViewController {
    
    /// Call this function when the user tap "finish live".
    func finishLive() {
        
        broadcaster?.stopPublish()
        switchToUIState(.end)
        
        // broadcaster?.stopPublish() will happen internally (probably very quick).
        // Here we just show ending spinner for 2 seconds, before we present post detail page.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            self?.streamEndActivityIndicator.stopAnimating()
            self?.streamEndActivityIndicator.isHidden = true
            guard let createdPost = self?.createdPost else {
                assertionFailure("createdPost must exist at this point, please check the logic.")
                return
            }
            // TODO: This makes the UIKit reload the feed.
            // So the livestream post that already rendered can update the latest state.
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postDidCreate"), object: nil)
            // Present post detail page after everything is done.
            let postDetailViewController = LiveStreamPostDetailViewController.make(withPostId: createdPost.postId)
            postDetailViewController.customDismiss = { [weak self] in
                self?.destinationToUnwindBackAfterFinish?.dismiss(animated: true, completion: nil)
            }
            let navController = UINavigationController(rootViewController: postDetailViewController)
            navController.modalPresentationStyle = .fullScreen
            self?.present(navController, animated: true) { [weak self] in
                // As soon as we fully present post detail page...
                // - We shut down the camera and the preview view.
                // - Since the user can no longer back to see this streaming page again.
                self?.broadcaster?.previewView.removeFromSuperview()
                self?.broadcaster = nil
            }
        }
    }
    
}

/// Private subclass just to override didTapLeftBarButton to implement custom dismiss, when the user close the post detail page.
private class LiveStreamPostDetailViewController: AmityPostDetailViewController {
    
    var customDismiss: (() -> Void)?
    
    override func didTapLeftBarButton() {
        customDismiss?()
    }
    
}
