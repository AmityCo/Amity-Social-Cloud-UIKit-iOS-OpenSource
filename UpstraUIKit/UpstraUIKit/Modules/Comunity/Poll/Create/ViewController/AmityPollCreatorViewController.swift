//
//  AmityPollCreatorViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 19/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

public final class AmityPollCreatorViewController: AmityViewController {
    
    private enum Section: Int, CaseIterable {
        case question
        case options
        case answers
        case addOption
        case multipleSeaction
        case schedule
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var mentionTableView: AmityMentionTableView!
    @IBOutlet private var mentionTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var mentionTableViewBottomConstraint: NSLayoutConstraint!
    private var pollTimeframeView: AmityPollCreatorTimeframeView?
    
    // MARK: - Properties
    private var postButton: UIBarButtonItem?
    private var screenViewModel: AmityPollCreatorScreenViewModelType?
    private var mentionManager: AmityMentionManager?
    
    // MARK: - View's lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTitle()
        setupPostNavigationBarbutton()
        setupTableView()
        setupMentionTableView()
        
        mentionManager?.delegate = self
        AmityKeyboardService.shared.delegate = self
    }
    
    public static func make(postTarget: AmityPostTarget) -> AmityPollCreatorViewController {
        let viewModel = AmityPollCreatorScreenViewModel(postTarget: postTarget)
        let vc = AmityPollCreatorViewController(nibName: AmityPollCreatorViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        var communityId: String? = nil
        switch postTarget {
        case .community(let object):
            if !object.isPublic {
                communityId = object.communityId
            }
        default: break
        }
        vc.mentionManager = AmityMentionManager(withType: .post(communityId: communityId))
        return vc
    }
    
    public override func didTapLeftBarButton() {
        screenViewModel?.action.validateFieldsIsChange()
    }
    
    // MARK: - Setup view
    private func setupViewModel() {
        screenViewModel?.delegate = self
    }
    
    private func setupTitle() {
        guard let postTarget = screenViewModel?.dataSource.postTarget else { return }
        switch postTarget {
        case .myFeed:
            title = AmityLocalizedStringSet.postCreationMyTimelineTitle.localizedString
        case .community(let comunity):
            title = comunity.displayName
        }
    }
    
    private func setupPostNavigationBarbutton() {
        postButton = UIBarButtonItem(title: AmityLocalizedStringSet.General.post.localizedString, style: .plain, target: self, action: #selector(onPostButtonTap))
        postButton?.tintColor = AmityColorSet.primary
        navigationItem.rightBarButtonItem = postButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupTableView() {
        tableView.register(cell: AmityPollCreatorQusetionTableViewCell.self)
        tableView.register(cell: AmityPollCreatorOptionTableViewCell.self)
        tableView.register(cell: AmityPollCreatorAnswerTableViewCell.self)
        tableView.register(cell: AmityPollCreatorAddOptionTableViewCell.self)
        tableView.register(cell: AmityPollCreatorMultipleSelectionTableViewCell.self)
        tableView.register(cell: AmityPollCreatorScheduleTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupMentionTableView() {
        mentionTableView.isHidden = true
        mentionTableView.delegate = self
        mentionTableView.dataSource = self
    }
}

extension AmityPollCreatorViewController: AmityKeyboardServiceDelegate {
    func keyboardWillChange(service: AmityKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        mentionTableViewBottomConstraint.constant = height

        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
    }
}

// MARK: - Action
private extension AmityPollCreatorViewController {
    @objc func onPostButtonTap() {
        let metadata = mentionManager?.getMetadata()
        let mentionees = mentionManager?.getMentionees()
        screenViewModel?.action.createPoll(withMetadata: metadata, andMentionees: mentionees)
    }
}

// MARK: - AmityPollCreatorScreenViewModelDelegate
extension AmityPollCreatorViewController: AmityPollCreatorScreenViewModelDelegate {
    
    func screenViewModelDidCreatePost(_ viewModel: AmityPollCreatorScreenViewModelType, post: AmityPost?, error: Error?) {
        if let post = post {
            switch post.getFeedType() {
            case .reviewing:
                AmityAlertController.present(title: AmityLocalizedStringSet.postCreationSubmitTitle.localizedString,
                                             message: AmityLocalizedStringSet.postCreationSubmitDesc.localizedString, actions: [.ok(style: .default, handler: { [weak self] in
                                                self?.postButton?.isEnabled = true
                                                self?.closeViewController()
                                             })], from: self)
            case .published, .declined:
                postButton?.isEnabled = true
                closeViewController()
            @unknown default:
                break
            }
        } else {
            postButton?.isEnabled = true
            closeViewController()
        }
    }
    
    private func closeViewController() {
        if let firstVCInNavigationVC = navigationController?.viewControllers.first {
            if firstVCInNavigationVC is AmityCommunityHomePageViewController {
                navigationController?.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func screenViewModelCanPost(_ isEnabled: Bool) {
        postButton?.isEnabled = isEnabled
    }
    
    func screenViewModelFieldsChange(_ isChanged: Bool) {
        let navigationBarType = self.navigationBarType
        if isChanged {
            let cancelAction = AmityAlertController.Action.cancel(style: .cancel, handler: nil)
            let leaveAction = AmityAlertController.Action.custom(
                title: AmityLocalizedStringSet.General.leave.localizedString,
                style: .destructive,
                handler: { [weak self] in
                    guard let strongSelf = self else { return }
                    switch navigationBarType {
                    case .present:
                        self?.dismiss(animated: true, completion: nil)
                    case .push:
                        strongSelf.navigationController?.popViewController(animated: true)
                    default:
                        break
                    }
                })
            AmityAlertController.present(title: AmityLocalizedStringSet.Poll.Create.alertTitle.localizedString, message: AmityLocalizedStringSet.Poll.Create.alertDesc.localizedString, actions: [cancelAction, leaveAction], from: self)
        } else {
            switch navigationBarType {
            case .present:
                dismiss(animated: true, completion: nil)
            case .push:
                navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
}

extension AmityPollCreatorViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mentionTableView, let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AmityPollCreatorQusetionTableViewCell, let textView = cell.getTextView() {
            mentionManager?.addMention(from: textView, in: textView.text, at: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == mentionTableView {
            if tableView.isBottomReached {
                mentionManager?.loadMore()
            }
        }
    }
}

extension AmityPollCreatorViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == mentionTableView {
            return 1
        }
        return Section.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mentionTableView {
            return mentionManager?.users.count ?? 0
        }
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .answers:
            return screenViewModel?.dataSource.answersItem.count ?? 0
        default:
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mentionTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AmityMentionTableViewCell.identifier) as? AmityMentionTableViewCell, let model = mentionManager?.item(at: indexPath) else { return UITableViewCell() }
            cell.display(with: model)
            return cell
        }
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .question:
            let cell: AmityPollCreatorQusetionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .options:
            let cell: AmityPollCreatorOptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(screenViewModel?.dataSource.answersItem.count ?? 0)
            return cell
        case .answers:
            let cell: AmityPollCreatorAnswerTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            guard let answer = screenViewModel?.dataSource.getAnswer(at: indexPath) else { return UITableViewCell() }
            cell.display(answer: answer)
            cell.indexPath = indexPath
            return cell
        case .addOption:
            let cell: AmityPollCreatorAddOptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        case .multipleSeaction:
            let cell: AmityPollCreatorMultipleSelectionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .schedule:
            let cell: AmityPollCreatorScheduleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.display(screenViewModel?.dataSource.selectedDay ?? 0)
            return cell
        }
    }
    
}

extension AmityPollCreatorViewController: AmityPollCreatorCellProtocolDelegate {
    func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return mentionManager?.shouldChangeTextIn(textView, inRange: range, replacementText: text, currentText: textView.text) ?? true
    }
    
    func didPerformAction(_ cell: AmityPollCreatorCellProtocol, action: AmityPollCreatorCellAction) {
        switch action {
        case .textViewDidChange(let textView):
            tableView.beginUpdates()
            tableView.endUpdates()
            
            if cell is AmityPollCreatorQusetionTableViewCell {
                screenViewModel?.action.setPollQuestion(textView.text)
            }
            
            if cell is AmityPollCreatorAnswerTableViewCell {
                screenViewModel?.action.updateAnswer(textView.text, at: cell.indexPath, completion: nil)
            }
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AmityPollCreatorQusetionTableViewCell, let textView = cell.getTextView() {
                textView.typingAttributes = [.font: AmityFontSet.body, .foregroundColor: AmityColorSet.base]
                screenViewModel?.action.setPollQuestion(textView.text)
            }
        case .textViewDidChangeSelection(let textView):
            mentionManager?.changeSelection(textView)
        case .multipleSelectionChange(let isMultiple):
            screenViewModel?.action.setIsMultipleSelection(isMultiple)
        case .selectSchedule:
            let keyWindow = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            guard let window = keyWindow else { return }
            if pollTimeframeView == nil {
                pollTimeframeView = AmityPollCreatorTimeframeView(frame: window.frame)
            }
            guard let pollTimeframeView = pollTimeframeView else { return }
            pollTimeframeView.selectRow(screenViewModel?.dataSource.selectedDay ?? 0)
            window.addSubview(pollTimeframeView)
            
            pollTimeframeView.didSelectDayHandler = { [weak self] day in
                self?.screenViewModel?.action.setTimeToClosePoll(day)
                self?.tableView.reloadData()
            }
        case .addAnswerOption:
            screenViewModel?.action.addNewOption { [weak self] in
                let section = Section.answers.rawValue
                let answerCount = self?.screenViewModel?.answersItem.count ?? 0
                let row = answerCount > 0 ? answerCount - 1 : 0
                
                // We don't want keyboard to disappear when new option is added
                // so we manually reload the rows added.
                let insertIndexPath = IndexPath(row: row, section: section)
                self?.tableView.insertRows(at: [insertIndexPath], with: .top)
                
                if let cell = tableView.cellForRow(at: insertIndexPath) as? AmityPollCreatorAnswerTableViewCell {
                    cell.moveInputCursorToTextView()
                }
            }
        case let .updateAnswerOption(text):
            screenViewModel?.action.updateAnswer(text, at: cell.indexPath) { [weak self] in
                self?.tableView.reloadData()
            }
        case .deleteAnswerOption:
            screenViewModel?.action.deleteAnswer(at: cell.indexPath) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - AmityMentionManagerDelegate
extension AmityPollCreatorViewController: AmityMentionManagerDelegate {
    public func didCreateAttributedString(attributedString: NSAttributedString) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AmityPollCreatorQusetionTableViewCell, let textView = cell.getTextView() {
            textView.attributedText = attributedString
            textView.typingAttributes = [.font: AmityFontSet.body, .foregroundColor: AmityColorSet.base]
            screenViewModel?.action.setPollQuestion(textView.text)
        }
    }
    
    public func didGetUsers(users: [AmityMentionUserModel]) {
        if users.isEmpty {
            mentionTableViewHeightConstraint.constant = 0
            mentionTableView.isHidden = true
        } else {
            var heightConstant:CGFloat = 240.0
            if users.count < 5 {
                heightConstant = CGFloat(users.count) * 52.0
            }
            mentionTableViewHeightConstraint.constant = heightConstant
            mentionTableView.isHidden = false
            mentionTableView.reloadData()
        }
    }
    
    public func didMentionsReachToMaximumLimit() {
        let alertController = UIAlertController(title: AmityLocalizedStringSet.Mention.unableToMentionTitle.localizedString, message: AmityLocalizedStringSet.Mention.unableToMentionReplyDescription.localizedString, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.done.localizedString, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func didCharactersReachToMaximumLimit() {
    }
}
