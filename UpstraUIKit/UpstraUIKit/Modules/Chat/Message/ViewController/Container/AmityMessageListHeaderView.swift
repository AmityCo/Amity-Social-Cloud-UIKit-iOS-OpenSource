//
//  AmityMessageListHeaderView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 1/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityMessageListHeaderViewDelegate {
    func avatarDidTapGesture(userId: String)
}

final class AmityMessageListHeaderView: AmityView {
    
    // MARK: - Properties
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var backButton: UIButton!
    
    // MARK: - Collections
    private var repository: AmityUserRepository?
    private var token: AmityNotificationToken?
    private var participateToken: AmityNotificationToken?
    
    // MARK: - Properties
    private var screenViewModel: AmityMessageListScreenViewModelType?
    var amityNavigationBarType: AmityNavigationBarType = .push
    var avatarURL: String?
    var userId: String?
    
    var delegate: AmityMessageListHeaderViewDelegate?
    
    convenience init(viewModel: AmityMessageListScreenViewModelType) {
        self.init(frame: .zero)
        loadNibContent()
        screenViewModel = viewModel
        setupView()
    }
}

// MARK: - Action
private extension AmityMessageListHeaderView {
    @IBAction func backTap() {
        if amityNavigationBarType == .push {
            screenViewModel?.action.route(for: .pop)
        } else {
            screenViewModel?.action.route(for: .dissmiss)
        }
    }
    
    @objc func avatarTap(_ sender: UITapGestureRecognizer) {
        guard let userId = userId else { return }
        delegate?.avatarDidTapGesture(userId: userId)
    }
}

private extension AmityMessageListHeaderView {
    func setupView() {
        repository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        
        contentView.backgroundColor = AmityColorSet.backgroundColor
        
        if amityNavigationBarType == .push {
              backButton.tintColor = AmityColorSet.base
              backButton.setImage(AmityIconSet.iconBack, for: .normal)
          } else {
              backButton.tintColor = AmityColorSet.base
              backButton.setImage(AmityIconSet.iconClose, for: .normal)
          }
        
        displayNameLabel.textColor = AmityColorSet.base
        displayNameLabel.font = AmityFontSet.title
        displayNameLabel.text = AmityLocalizedStringSet.General.anonymous.localizedString
        
        avatarView.image = nil
        avatarView.placeholder = AmityIconSet.defaultAvatar
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarTap))
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(avatarTap))
        avatarView.addGestureRecognizer(tap)
        displayNameLabel.addGestureRecognizer(tapLabel)
    }
}

extension AmityMessageListHeaderView {
    
    func updateViews(channel: AmityChannelModel) {
        displayNameLabel.text = channel.displayName
        switch channel.channelType {
        case .standard:
            avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultGroupChat)
        case .conversation:
//            avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultAvatar)
            participateToken?.invalidate()
            participateToken = channel.participation.getMembers(filter: .all, sortBy: .firstCreated, roles: []).observe { collection, change, error in
                for i in 0..<collection.count(){
                    let userId = collection.object(at: i)?.userId
                    if userId != AmityUIKitManagerInternal.shared.currentUserId {
                        self.token = self.repository?.getUser(userId ?? "").observe { [weak self] user, error in
                            self?.token?.invalidate()
                            guard let userObject = user.object else { return }
                            self?.userId = userObject.userId
                            self?.displayNameLabel.text = userObject.displayName
                            let userModel = AmityUserModel(user: userObject)
                            if !userModel.avatarCustomURL.isEmpty {
                                if self?.avatarURL != userModel.avatarCustomURL {
                                    self?.avatarView.setImage(withCustomURL: userModel.avatarCustomURL,
                                                             placeholder: AmityIconSet.defaultAvatar)
                                    self?.avatarURL = userModel.avatarCustomURL
                                }
                                
                            } else {
                                if self?.avatarURL != userModel.avatarURL {
                                    self?.avatarView.setImage(withImageURL: userModel.avatarURL,
                                                              placeholder: AmityIconSet.defaultAvatar)
                                    self?.avatarURL = userModel.avatarURL
                                }
                            }
                        }
                    }
                }
            }
        case .community:
            avatarView.setImage(withImageURL: channel.avatarURL, placeholder: AmityIconSet.defaultAvatar)
            if !channel.getOtherUserId().isEmpty {
                token?.invalidate()
                token = repository?.getUser(channel.getOtherUserId()).observeOnce { [weak self] user, error in
                    guard let weakSelf = self else { return }
                    if let userObject = user.object {
                        let userModel = AmityUserModel(user: userObject)
                        if !userModel.avatarCustomURL.isEmpty {
                            weakSelf.avatarView.setImage(withCustomURL: userModel.avatarCustomURL,
                                                         placeholder: AmityIconSet.defaultAvatar)
                        } else {
                            weakSelf.avatarView.setImage(withImageURL: userModel.avatarURL,
                                                         placeholder: AmityIconSet.defaultAvatar)
                        }
                        weakSelf.displayNameLabel.text = userObject.displayName
                    }
                }
            }
        default:
            break
        }
    }
}

extension AmityMessageListHeaderView {
    
    func setupData() {
        setupView()
    }
    
}
