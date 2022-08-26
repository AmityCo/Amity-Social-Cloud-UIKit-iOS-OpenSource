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
                setTargetDetail(name: nil, avatarUrl: nil, isCustom: false)
                assertionFailure("community target must have targetId.")
                return
            }
            liveObjectQueryToken = communityRepository.getCommunity(withId: targetId).observeOnce { [weak self] result, error in
                self?.liveObjectQueryToken = nil
                guard let community = result.object else {
                    self?.setTargetDetail(name: nil, avatarUrl: nil, isCustom: false)
                    return
                }
                if (community.user?.avatarCustomUrl == nil) {
                    self?.setTargetDetail(name: community.displayName, avatarUrl: community.avatar?.fileURL, isCustom: false)
                } else {
                    self?.setTargetDetail(name: community.displayName, avatarUrl: community.user?.avatarCustomUrl, isCustom: true)
                }
            }
        case .user:
            if let targetId = targetId {
                liveObjectQueryToken = userRepository.getUser(targetId).observeOnce { [weak self] result, error in
                    self?.liveObjectQueryToken = nil
                    guard let user = result.object else {
                        self?.setTargetDetail(name: nil, avatarUrl: nil, isCustom: false)
                        return
                    }
                    if (user.avatarCustomUrl == nil) {
                        self?.setTargetDetail(name: user.displayName, avatarUrl: user.getAvatarInfo()?.fileURL, isCustom: false)
                    } else {
                        self?.setTargetDetail(name: user.displayName, avatarUrl: user.avatarCustomUrl, isCustom: true)
                    }
                }
            } else {
                let currentUser = client.currentUser?.object
                if currentUser?.avatarCustomUrl == nil {
                    setTargetDetail(
                        name: currentUser?.displayName,
                        avatarUrl: currentUser?.getAvatarInfo()?.fileURL, isCustom: false
                    )
                } else {
                    setTargetDetail(
                        name: currentUser?.displayName,
                        avatarUrl: currentUser?.avatarCustomUrl, isCustom: true
                    )
                }
            }
        @unknown default:
            assertionFailure("Unhandled case")
            break
        }
        
    }
    
    private func setTargetDetail(name: String?, avatarUrl: String?,isCustom: Bool) {
        if let name = name {
            targetNameLabel.text = name
        } else {
            targetNameLabel.text = "Not Found"
        }
        if let avatarUrl = avatarUrl {
            if !isCustom {
                fileRepository.downloadImageAsData(fromURL: avatarUrl, size: .small) { [weak self] image, size, error in
                    guard let image = image else {
                        return
                    }
                    self?.targetImageView.image = image
                }
            } else {
                self.targetImageView.downloaded(from: avatarUrl)

            }
        }
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
