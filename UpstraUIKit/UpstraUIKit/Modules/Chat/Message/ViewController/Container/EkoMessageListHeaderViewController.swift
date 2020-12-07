//
//  EkoMessageListHeaderViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 1/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoMessageListHeaderViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var backButton: UIButton!
    
    // MARK: - Properties
    private let screenViewModel: EkoMessageListScreenViewModelType
    
    // MARK: View lifecycle
    private init(viewModel: EkoMessageListScreenViewModelType) {
        screenViewModel = viewModel
        super.init(nibName: EkoMessageListHeaderViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.action.getChannel()
    }
    
    static func make(viewModel: EkoMessageListScreenViewModelType) -> EkoMessageListHeaderViewController {
        let vc = EkoMessageListHeaderViewController(viewModel: viewModel)
        return vc
    }
}

// MARK: - Action
private extension EkoMessageListHeaderViewController {
    @IBAction func backTap() {
        screenViewModel.action.route(for: .pop)
    }
}

private extension EkoMessageListHeaderViewController {
    func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
        
        backButton.tintColor = EkoColorSet.base
        backButton.setImage(EkoIconSet.iconBack, for: .normal)
        
        displayNameLabel.textColor = EkoColorSet.base
        displayNameLabel.font = EkoFontSet.title
        
        avatarView.image = nil
        avatarView.placeholder = EkoIconSet.defaultAvatar
    }
}

extension EkoMessageListHeaderViewController {
    
    func updateViews(channel: EkoChannel) {
        displayNameLabel.text = channel.displayName ?? EkoLocalizedStringSet.anonymous
        
        switch channel.channelType {
        case .standard:
            avatarView.image = nil
            avatarView.placeholder = EkoIconSet.defaultGroupChat
        case .conversation:
            if let avatarId = channel.avatarFileId {
                avatarView.setImage(withImageId: avatarId, placeholder: EkoIconSet.defaultAvatar)
            }
        default:
            break
        }
    }
}
