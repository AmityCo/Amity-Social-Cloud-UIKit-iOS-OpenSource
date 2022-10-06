//
//  LivestreamWatchingTableViewCell.swift
//  AmityUIKitLiveStream
//
//  Created by Mono TheForestcat on 26/9/2565 BE.
//

import UIKit
import AmityUIKit
import AmitySDK


protocol LivestreamWatchingProtocol {
    func didAvatarTap(userId: String) -> ()
}

class LivestreamWatchingTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet weak var avatarImageView: AmityAvatarView!
    @IBOutlet weak var displayName: UILabel!
    
    var token: AmityNotificationToken?
    var delegate: LivestreamWatchingProtocol?
    var currentUserId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func display(userId: String) {
        self.backgroundColor = .clear
        
        currentUserId = userId
        
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didAvatarInCellIsTapped)))
        
        displayName.font = AmityFontSet.title
        displayName.textColor = .black
        
        let userRepository = AmityUserRepository(client: AmityUIKitManager.client)
        token?.invalidate()
        token = userRepository.getUser(userId).observe({ [weak self] user, error in
            if error != nil {
                print("[Amity] Get watcher data error. \(error?.localizedDescription ?? "")")
            }
            guard let userObject = user.object else { return }
            let model: AmityUserModel = AmityUserModel(user: userObject)
            
            DispatchQueue.main.async {
                if model.avatarCustomURL != "" {
                    self?.avatarImageView.setImage(withCustomURL: model.avatarCustomURL)
                } else {
                    self?.avatarImageView.setImage(withImageURL: model.avatarURL)
                }
            }
            
            self?.displayName.text = model.displayName
        })
    }
    
    @objc func didAvatarInCellIsTapped() {
        delegate?.didAvatarTap(userId: currentUserId)
    }
}
