//
//  AmityPostBirthdayTableViewCell.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/4/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmityUIKit

private struct AmityBirthdayModel {
    
    let jobTitle: String
    let date: String
    let displayName: String
    
    init(post: AmityPostModel) {
        jobTitle = post.data["title"] as? String ?? ""
        date = AmityBirthdayModel.convertDate(input: post.data["date"] as? String ?? "")
        displayName = post.postedUser?.displayName ?? ""
    }
    
    private static func convertDate(input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let showDate = inputFormatter.date(from: input)
        inputFormatter.dateFormat = "dd MMMM"
        if let date = showDate {
            return inputFormatter.string(from: date)
        }
        return ""
    }
}

final class AmityPostBirthdayTableViewCell: UITableViewCell {
    
    private enum Constant {
        static let DISPLAY_NAME_MAXIMUM_LINE = 3
        static let JOB_MAXIMUM_LINE = 2
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var birthdayDateLabel: UILabel!
    @IBOutlet private var displayNameLabel: UILabel!
    @IBOutlet private var jobTitleLabel: UILabel!
    @IBOutlet private var avatarView: AmityAvatarView!
    @IBOutlet private var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
 
    func display(withPost post: AmityPostModel) {
        let user = AmityBirthdayModel(post: post)
        birthdayDateLabel.text = user.date
        displayNameLabel.text = "Happy birthday,\n" + user.displayName + "!"
        jobTitleLabel.text = user.jobTitle
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .white
        setupBirthdayDateLabel()
        setupDisplayNameLabel()
        setupJobLabel()
        setupAvatarView()
        setupMessage()
    }
    
    private func setupBirthdayDateLabel() {
        #warning("temporary text")
        birthdayDateLabel.text = "24 November"
        birthdayDateLabel.textColor = .white
        birthdayDateLabel.font = UIFont.boldSystemFont(ofSize: 13)
        birthdayDateLabel.textAlignment = .center
    }
    
    private func setupDisplayNameLabel() {
        #warning("temporary text")
        displayNameLabel.text = "Happy birthday,\nJackie!"
        displayNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        displayNameLabel.textColor = .white
        displayNameLabel.numberOfLines = Constant.DISPLAY_NAME_MAXIMUM_LINE
        displayNameLabel.setLineSpacing(8)
    }
    
    private func setupJobLabel() {
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
    
    private func setupMessage() {
        contentLabel.text = "Send your friend a birthday wish!"
        contentLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        contentLabel.textColor = UIColor(hex: "292B32")
        contentLabel.textAlignment = .center
        contentLabel.setLineSpacing(8)
    }
}

private extension AmityPostBirthdayTableViewCell {
    func avatarTap() {
        // tap on avatar
    }
        
}
