//
//  AmityPostNewJoinerTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/4/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmityUIKit

private struct AmityNewEmployeeModel {
    
    let jobTitle: String
    let displayName: String
    
    init(post: AmityPostModel) {
        jobTitle = post.data["title"] as? String ?? ""
        displayName = post.postedUser?.displayName ?? ""
    }
  
}

final class AmityPostNewJoinerTableViewCell: UITableViewCell {

    private enum Constant {
        static let DISPLAY_NAME_MAXIMUM_LINE = 3
        static let JOB_MAXIMUM_LINE = 2
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var welcomeLabel: UILabel!
    @IBOutlet private var jobTitleLabel: UILabel!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func display(withPost post: AmityPostModel) {
        let user = AmityNewEmployeeModel(post: post)
        welcomeLabel.text = "Welcome to the team,\n" + user.displayName + "!"
        jobTitleLabel.text = user.jobTitle
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .white
        setupWelcomeLabeL()
        setupJobTitleLabel()
        setupAvatarView()
        setupMessageLabel()
    }
    
    private func setupWelcomeLabeL() {
        #warning("temporary text")
        welcomeLabel.text = "Welcome to the team,\nSarah!"
        welcomeLabel.font = .systemFont(ofSize: 20, weight: .bold)
        welcomeLabel.textColor = .white
        welcomeLabel.numberOfLines = Constant.DISPLAY_NAME_MAXIMUM_LINE
        welcomeLabel.setLineSpacing(8)
    }
    
    private func setupJobTitleLabel() {
        #warning("temporary text")
        jobTitleLabel.text = "Learning and Development Lead Consultant, Global Financial Markets Training, eLearning and..."
        jobTitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        jobTitleLabel.textColor = .white
        jobTitleLabel.numberOfLines = Constant.JOB_MAXIMUM_LINE
        jobTitleLabel.textAlignment = .center
    }
    
    private func setupAvatarView() {
        avatarView.avatarShape = .circle
        avatarView.placeholder = AmityIconSet.defaultAvatar
        avatarView.actionHandler = { [weak self] in
            self?.avatarTap()
        }
    }
    
    private func setupMessageLabel() {
        contentLabel.text = "Send your friend a welcome message!"
        contentLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        contentLabel.textColor = UIColor(hex: "292B32")
        contentLabel.textAlignment = .center
        contentLabel.setLineSpacing(8)
    }
}

private extension AmityPostNewJoinerTableViewCell {
    func avatarTap() {
        // tap on avatar
    }
}
