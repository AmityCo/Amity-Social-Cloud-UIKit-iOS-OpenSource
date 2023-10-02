//
//  AmityPostPollAnswerTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 29/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final public class AmityPostPollAnswerTableViewCell: UITableViewCell, Nibbable {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var votingStackView: UIStackView!
    @IBOutlet private var votedStackView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var statusView: UIView!
   
    @IBOutlet private var resultTitleLabel: UILabel!
    @IBOutlet private var voteProgressView: UIProgressView!
    @IBOutlet private var voteCountLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupTitleLabel()
        setupStatusView()
        setupContainer()
        setupResultTitleLabel()
        setupVoteProgressView()
        setupVoteCountLabel()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textAlignment = .left
        titleLabel.text = ""
        titleLabel.font = AmityFontSet.bodyBold
        titleLabel.textColor = AmityColorSet.base
        iconImageView.image = AmityIconSet.iconRadioOff
        iconImageView.isHidden = false
        containerView.layer.borderColor = AmityColorSet.base.blend(.shade4).cgColor
        statusView.isHidden = true
        votingStackView.isHidden = true
        votedStackView.isHidden = true
    }
    
    func display(poll: AmityPostModel.Poll, answer: AmityPostModel.Poll.Answer) {
        titleLabel.text = answer.text
        resultTitleLabel.text = answer.text
        
        votingStackView.isHidden = poll.isClosed || poll.isVoted
        votedStackView.isHidden = !poll.isClosed && !poll.isVoted
        statusView.isHidden = !answer.isVotedByUser
        
        if poll.isClosed || poll.isVoted {
            voteCountLabel.text = "\(answer.voteCount.formatUsingAbbrevation()) \(AmityLocalizedStringSet.Poll.Option.voteCountTitle.localizedString)"
            
            let voteProgress = poll.voteCount > 0 ? Double(answer.voteCount) / Double(poll.voteCount) : 0
            
            let progressTintColor = answer.isVotedByUser ? AmityColorSet.primary : AmityColorSet.base.blend(.shade1)
            let containerViewBorderColor = answer.isVotedByUser ? AmityColorSet.primary : AmityColorSet.base.blend(.shade4)
            
            voteProgressView.progress = Float(voteProgress)
            voteProgressView.trackTintColor = AmityColorSet.base.blend(.shade4)
            voteProgressView.progressTintColor = progressTintColor
            
            containerView.layer.borderColor = containerViewBorderColor.cgColor
        } else {
            if poll.isMultipleVoted {
                iconImageView.image = answer.isSelected ? AmityIconSet.iconRadioCheck : AmityIconSet.iconRadioOff
            } else {
                iconImageView.image = answer.isSelected ? AmityIconSet.iconRadioOn : AmityIconSet.iconRadioOff
            }
            
            if answer.isVotedByUser || answer.isSelected {
                containerView.layer.borderColor = AmityColorSet.primary.cgColor
            } else {
                containerView.layer.borderColor = AmityColorSet.base.blend(.shade4).cgColor
            }
        }
    }
    
    func displayMoreOption(poll: AmityPostModel.Poll, number: Int) {
        if poll.isClosed {
            titleLabel.text = AmityLocalizedStringSet.Poll.Option.viewFullResult.localizedString
        } else {
            titleLabel.text = "\(number) \(AmityLocalizedStringSet.Poll.Option.moreOption.localizedString)"
        }
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = AmityColorSet.base.blend(.shade1)
        titleLabel.font = AmityFontSet.body
        iconImageView.isHidden = true
        statusView.isHidden = true
        containerView.layer.borderColor = AmityColorSet.base.blend(.shade4).cgColor
        votingStackView.isHidden = false
        votedStackView.isHidden = true
    }
    
    private func setupTitleLabel() {
        titleLabel.text = ""
        titleLabel.font = AmityFontSet.bodyBold
        titleLabel.textColor = AmityColorSet.base
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.preferredMaxLayoutWidth = votingStackView.bounds.width - 34 // [ImageWidth + Spacing]
    }
    
    private func setupStatusView() {
        statusView.backgroundColor = AmityColorSet.primary
    }
    
    private func setupContainer() {
        containerView.layer.borderColor = AmityColorSet.base.blend(.shade4).cgColor
        containerView.layer.cornerRadius = 4
        containerView.layer.borderWidth = 1
        containerView.clipsToBounds = true
    }
 
    private func setupResultTitleLabel() {
        resultTitleLabel.text = ""
        resultTitleLabel.font = AmityFontSet.bodyBold
        resultTitleLabel.textColor = AmityColorSet.base
        resultTitleLabel.numberOfLines = 0
        resultTitleLabel.preferredMaxLayoutWidth = votedStackView.bounds.width
    }
    
    private func setupVoteProgressView() {
        voteProgressView.layer.cornerRadius = 6
        voteProgressView.clipsToBounds = true
        voteProgressView.layer.sublayers![1].cornerRadius = 6
        voteProgressView.subviews[1].clipsToBounds = true
    }
    
    private func setupVoteCountLabel() {
        voteCountLabel.text = "0"
        voteCountLabel.textColor = AmityColorSet.base.blend(.shade1)
        voteCountLabel.font = AmityFontSet.caption
    }
    
}
