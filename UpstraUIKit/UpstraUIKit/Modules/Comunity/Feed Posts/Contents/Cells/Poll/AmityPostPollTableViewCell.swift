//
//  AmityPostPollTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 29/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final public class AmityPostPollTableViewCell: UITableViewCell, Nibbable, AmityPostProtocol {
    
    private struct Constant {
        static let pollTitleContentMaxLines = 8
        static let maxPollOptionRowCountInNormalFeed = 2
        static let maxRowCountInNormalFeed = 3
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var titlePollLabel: AmityExpandableLabel!
    @IBOutlet private var statusPollLabel: UILabel!
    @IBOutlet private var voteCountLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var submitVoteButton: UIButton!
    
    // MARK: - Properties
    public weak var delegate: AmityPostDelegate?
    public var post: AmityPostModel?
    public var indexPath: IndexPath?
    
    private(set) var selectedAnswerIds: [String] = []
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupTitlePollLabel()
        setupStatusPollLabel()
        setupVoteCountLabel()
        setupTableView()
        setupSubmitVoteButton()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        titlePollLabel.isExpanded = false
        titlePollLabel.text = nil
        titlePollLabel.shouldCollapse = false
        titlePollLabel.text = ""
        statusPollLabel.text = ""
        voteCountLabel.text = ""
    }
    
    public func display(post: AmityPostModel, indexPath: IndexPath) {
        self.post = post
        self.indexPath = indexPath
        
        guard let poll = post.poll else { return }
        if let metadata = post.metadata, let mentionees = post.mentionees {
            let attributes = AmityMentionManager.getAttributes(fromText: poll.question, withMetadata: metadata, mentionees: mentionees)
            titlePollLabel.setText(poll.question, withAttributes: attributes)
        } else {
            titlePollLabel.text = poll.question
        }
        
        var pollStatus: String = AmityLocalizedStringSet.Poll.Option.openForVoting.localizedString
        if !poll.isClosed && poll.closedIn > 0 {
            pollStatus = computePollStatus(poll: poll)
        }
        
        statusPollLabel.text = poll.isClosed ? AmityLocalizedStringSet.Poll.Option.finalResult.localizedString : pollStatus
        voteCountLabel.text = "\(poll.voteCount.formatUsingAbbrevation()) \(AmityLocalizedStringSet.Poll.Option.voteCountTitle.localizedString)"
        submitVoteButton.isHidden = poll.isClosed || poll.isVoted || !(post.feedType == .published)
        
        poll.answers.forEach { answer in
            answer.isSelected = selectedAnswerIds.contains(where: { $0 == answer.id})
        }
        submitVoteButton.isEnabled = poll.answers.contains(where: { $0.isSelected })
        titlePollLabel.isExpanded = post.appearance.shouldContentExpand
        tableView.reloadData()
    }
    
    private func computePollStatus(poll: AmityPostModel.Poll) -> String {
        let closedInDate = poll.createdAt.addingTimeInterval(Double(poll.closedIn) / 1000)
        
        let status = PollStatus(closedInDate: closedInDate)
        return status.statusInfo
    }
    
    private func setupTitlePollLabel() {
        titlePollLabel.font = AmityFontSet.body
        titlePollLabel.textColor = AmityColorSet.base
        titlePollLabel.shouldCollapse = false
        titlePollLabel.textReplacementType = .character
        titlePollLabel.numberOfLines = Constant.pollTitleContentMaxLines
        titlePollLabel.isExpanded = false
        titlePollLabel.delegate = self
    }
    
    private func setupStatusPollLabel() {
        statusPollLabel.text = ""
        statusPollLabel.font = AmityFontSet.captionBold
        statusPollLabel.textColor = AmityColorSet.base
    }
    
    private func setupVoteCountLabel() {
        voteCountLabel.text = "0 \(AmityLocalizedStringSet.Poll.Option.voteCountTitle.localizedString)"
        voteCountLabel.font = AmityFontSet.caption
        voteCountLabel.textColor = AmityColorSet.base.blend(.shade2)
    }
    
    private func setupTableView() {
        tableView.register(cell: AmityPostPollAnswerTableViewCell.self)
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets.zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    private func setupSubmitVoteButton() {
        submitVoteButton.setTitle(AmityLocalizedStringSet.Poll.Option.submitVoteTitle.localizedString, for: .normal)
        submitVoteButton.setTitleColor(AmityColorSet.primary, for: .normal)
        submitVoteButton.setTitleColor(AmityColorSet.primary.blend(.shade2), for: .disabled)
        submitVoteButton.titleLabel?.font = AmityFontSet.bodyBold
    }
    
    // MARK: - Action
    @IBAction private func onTapSubmitPoll() {
        delegate?.didPerformAction(self, action: .submit)
    }

}

extension AmityPostPollTableViewCell: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let post = post, let poll = post.poll, post.feedType == .published else { return }
        let row = indexPath.row
        
        switch post.appearance.displayType {
        case .feed:
            // If user taps on "x more options" button, we show
            // post detail page here.
            if row == Constant.maxPollOptionRowCountInNormalFeed {
                delegate?.didPerformAction(self, action: .tapViewAll)
                return
            }
        case .postDetail:
            break
        }
        
        guard !poll.isClosed, !poll.isVoted else { return }
        
        self.handlePollAnswerSelection(at: indexPath, for: poll)
    }
    
    private func handlePollAnswerSelection(at indexPath: IndexPath, for poll: AmityPostModel.Poll) {
        
        let selectedAnswer = poll.answers[indexPath.row]
        
        // We need to remove previous selection for single selection mode.
        if !poll.isMultipleVoted, selectedAnswerIds.count > 0 {
            
            if let previousSelectionId = selectedAnswerIds.first {
                // If user tries to select the same option, do nothing.
                if selectedAnswer.id != previousSelectionId {
                    for item in poll.answers {
                        if item.id == previousSelectionId {
                            item.isSelected.toggle()
                            break
                        }
                    }
                } else {
                    return
                }
            }
            
            selectedAnswerIds.removeAll()
            selectAnswer(poll: poll, answer: selectedAnswer, tableView: tableView)
        } else {
            selectAnswer(poll: poll, answer: selectedAnswer, tableView: tableView)
        }
    }
    
    private func selectAnswer(poll: AmityPostModel.Poll, answer: AmityPostModel.Poll.Answer, tableView: UITableView)  {
        answer.isSelected = !answer.isSelected
        if answer.isSelected {
            selectedAnswerIds.append(answer.id)
        } else {
            if let index = selectedAnswerIds.firstIndex(of: answer.id) {
                selectedAnswerIds.remove(at: index)
            }
        }
        submitVoteButton.isEnabled = poll.answers.contains(where: { $0.isSelected })
        tableView.reloadData()
    }
}

extension AmityPostPollTableViewCell: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let post = post, let poll = post.poll else { return 0 }
        let answersCount = poll.answers.count
        switch post.appearance.displayType {
        case .feed:
            return answersCount == Constant.maxPollOptionRowCountInNormalFeed ? answersCount : Constant.maxRowCountInNormalFeed
        case .postDetail:
            return answersCount
        }
    }
    
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let pollAnswer = post?.poll?.answers else { return }
        tableView.frame.size.height = (cell.frame.height * CGFloat(pollAnswer.count) )
        tableView.layoutIfNeeded()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = post, let poll = post.poll else { return UITableViewCell() }
        let row = indexPath.row
        let cell: AmityPostPollAnswerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let answerCount = poll.answers.count
        switch post.appearance.displayType {
        case .feed:
            if answerCount == Constant.maxPollOptionRowCountInNormalFeed {
                cell.display(poll: poll, answer: poll.answers[row])
            } else {
                if row == Constant.maxPollOptionRowCountInNormalFeed {
                    cell.displayMoreOption(poll: poll, number: answerCount - Constant.maxPollOptionRowCountInNormalFeed)
                } else {
                    cell.display(poll: poll, answer: poll.answers[row])
                }
            }
        case .postDetail:
            cell.display(poll: poll, answer: poll.answers[row])
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: AmityExpandableLabelDelegate
extension AmityPostPollTableViewCell: AmityExpandableLabelDelegate {
    
    // MARK: - Perform Action
    private func performAction(action: AmityPostAction) {
        delegate?.didPerformAction(self, action: action)
    }
    
    public func willExpandLabel(_ label: AmityExpandableLabel) {
        performAction(action: .willExpandExpandableLabel(label: label))
    }
    
    public func didExpandLabel(_ label: AmityExpandableLabel) {
        performAction(action: .didExpandExpandableLabel(label: label))
    }
    
    public func willCollapseLabel(_ label: AmityExpandableLabel) {
        performAction(action: .willCollapseExpandableLabel(label: label))
    }
    
    public func didCollapseLabel(_ label: AmityExpandableLabel) {
        performAction(action: .didCollapseExpandableLabel(label: label))
    }
    
    public func expandableLabeldidTap(_ label: AmityExpandableLabel) {
        performAction(action: .tapExpandableLabel(label: label))
    }

    public func didTapOnMention(_ label: AmityExpandableLabel, withUserId userId: String) {
        performAction(action: .tapOnMentionWithUserId(userId: userId))
    }
}
