//
//  LiveStreamBroadcastVC+TargetDetail.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 2/9/2564 BE.
//

import UIKit
import AmitySDK
import AmityUIKit

extension LiveStreamBroadcastViewController {
    
    func queryTargetDetail() {
        switch targetType {
        case .community:
            guard let targetId = targetId else {
                setTargetDetail(name: nil, avatarUrl: nil)
                assertionFailure("community target must have targetId.")
                return
            }
            liveObjectQueryToken = communityRepository.getCommunity(withId: targetId).observeOnce { [weak self] result, error in
                self?.liveObjectQueryToken = nil
                guard let community = result.object else {
                    self?.setTargetDetail(name: nil, avatarUrl: nil)
                    return
                }
                self?.setTargetDetail(name: community.displayName, avatarUrl: community.avatar?.fileURL)
            }
        case .user:
            if let targetId = targetId {
                liveObjectQueryToken = userRepository.getUser(targetId).observeOnce { [weak self] result, error in
                    self?.liveObjectQueryToken = nil
                    guard let user = result.object else {
                        self?.setTargetDetail(name: nil, avatarUrl: nil)
                        return
                    }
                    self?.setTargetDetail(name: user.displayName, avatarUrl: user.getAvatarInfo()?.fileURL)
                }
            } else {
                let currentUser = client.currentUser?.object
                setTargetDetail(
                    name: currentUser?.displayName,
                    avatarUrl: currentUser?.getAvatarInfo()?.fileURL
                )
            }
        @unknown default:
            assertionFailure("Unhandled case")
            break
        }
        
    }
    
    private func setTargetDetail(name: String?, avatarUrl: String?) {
        if let name = name {
            targetNameLabel.text = name
        } else {
            targetNameLabel.text = "Not Found"
        }
        if let avatarUrl = avatarUrl {
            fileRepository.downloadImageAsData(fromURL: avatarUrl, size: .small) { [weak self] image, size, error in
                guard let image = image else {
                    return
                }
                self?.targetImageView.image = image
            }
        }
    }
    
}
