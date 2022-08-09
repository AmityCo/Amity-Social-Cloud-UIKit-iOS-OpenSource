//
//  AmityEditTextViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import AmitySDK

public class AmityEditTextViewController: AmityViewController {
    
    enum EditMode {
        case create(communityId: String?, isReply: Bool)
        // Comment, Reply
        case edit(communityId: String?, metadata: [String: Any]?, isReply: Bool)
        // Message
        case editMessage
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var textView: AmityTextView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var mentionTableView: AmityMentionTableView!
    @IBOutlet private var mentionTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var mentionTableViewBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    private let editMode: EditMode
    private var saveBarButton: UIBarButtonItem!
    private let headerTitle: String?
    private let message: String
    var editHandler: ((String, [String: Any]?, AmityMentioneesBuilder?) -> Void)?
    var dismissHandler: (() -> Void)?
    private let mentionManager: AmityMentionManager
    private var metadata: [String: Any]? = nil
    
    // MARK: - View lifecycle
    
    init(headerTitle: String?, text: String, editMode: EditMode) {
        self.headerTitle = headerTitle
        self.message = text
        self.editMode = editMode
        switch editMode {
        case .editMessage:
            mentionManager = AmityMentionManager(withType: .message(channelId: nil))
        case .create(let communityId, _):
            mentionManager = AmityMentionManager(withType: .comment(communityId: communityId))
        case .edit(let communityId, let metadata, _):
            mentionManager = AmityMentionManager(withType: .comment(communityId: communityId))
            self.metadata = metadata
        }
        super.init(nibName: AmityEditTextViewController.identifier, bundle: AmityUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(headerTitle: String? = nil, text: String, editMode: EditMode) -> AmityEditTextViewController {
        return AmityEditTextViewController(headerTitle: headerTitle, text: text, editMode: editMode)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        setupView()
        setupMentionTableView()
        
        mentionManager.delegate = self
        mentionManager.setColor(AmityColorSet.base, highlightColor: AmityColorSet.primary)
        mentionManager.setFont(AmityFontSet.body, highlightFont: AmityFontSet.bodyBold)
        if let metadata = metadata {
            mentionManager.setMentions(metadata: metadata, inText: message)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AmityKeyboardService.shared.delegate = self
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AmityKeyboardService.shared.delegate = nil
    }
    
    public override func didTapLeftBarButton() {
        dismissHandler?()
    }
    
    private func setupHeaderView() {
        if let header = headerTitle {
            headerView.isHidden = false
            headerView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
            headerLabel.textColor = AmityColorSet.base.blend(.shade1)
            headerLabel.font = AmityFontSet.body
            headerLabel.text = header
            textView.contentInset.top = 40
        } else {
            headerView.isHidden = true
        }
    }
    
    private func setupView() {
        switch editMode {
        case .create(_, _):
            saveBarButton = UIBarButtonItem(title: AmityLocalizedStringSet.General.post.localizedString, style: .plain, target: self, action: #selector(saveTap))
            saveBarButton.isEnabled = !message.isEmpty
        case .edit, .editMessage:
            saveBarButton = UIBarButtonItem(title: AmityLocalizedStringSet.General.save.localizedString, style: .plain, target: self, action: #selector(saveTap))
            saveBarButton.isEnabled = false
        }

        saveBarButton.tintColor = AmityColorSet.primary
        navigationItem.rightBarButtonItem = saveBarButton
        textView.text = message
        textView.placeholder = AmityLocalizedStringSet.textMessagePlaceholder.localizedString
        textView.showsVerticalScrollIndicator = false
        textView.customTextViewDelegate = self
    }
    
    private func setupMentionTableView() {
        mentionTableView.isHidden = true
        mentionTableView.delegate = self
        mentionTableView.dataSource = self
    }
    
    @objc private func saveTap() {
        let metadata = mentionManager.getMetadata()
        let mentionees = mentionManager.getMentionees()
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.editHandler?(strongSelf.textView.text ?? "", metadata, mentionees)
        }
    }
    
    private func showAlertForMaximumCharacters() {
        var title = AmityLocalizedStringSet.postUnableToCommentTitle.localizedString
        var message = AmityLocalizedStringSet.postUnableToCommentDescription.localizedString
        switch editMode {
        case .edit(_, _, let isReply), .create(_, let isReply):
            title = isReply ? AmityLocalizedStringSet.postUnableToReplyTitle.localizedString : AmityLocalizedStringSet.postUnableToCommentTitle.localizedString
            message = isReply ? AmityLocalizedStringSet.postUnableToReplyDescription.localizedString : AmityLocalizedStringSet.postUnableToCommentDescription.localizedString
        default:
            break
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.done.localizedString, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension AmityEditTextViewController: AmityKeyboardServiceDelegate {
    func keyboardWillChange(service: AmityKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        let constant = -height + offset
        bottomConstraint.constant = constant
        mentionTableViewBottomConstraint.constant = constant

        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
    }
}

extension AmityEditTextViewController: AmityTextViewDelegate {
    public func textViewDidChange(_ textView: AmityTextView) {
        guard let text = textView.text else { return }
        saveBarButton.isEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.attributedText = nil
            textView.textColor = AmityColorSet.base
        }
    }
    
    public func textViewDidChangeSelection(_ textView: AmityTextView) {
        mentionManager.changeSelection(textView)
    }
    
    public func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count > AmityMentionManager.maximumCharacterCountForPost {
            showAlertForMaximumCharacters()
            return false
        }
        return mentionManager.shouldChangeTextIn(textView, inRange: range, replacementText: text, currentText: textView.text)
    }
}

// MARK: - UITableViewDataSource
extension AmityEditTextViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionManager.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AmityMentionTableViewCell.identifier) as? AmityMentionTableViewCell, let model = mentionManager.item(at: indexPath) else { return UITableViewCell() }
        cell.display(with: model)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AmityEditTextViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AmityMentionTableViewCell.height
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mentionManager.addMention(from: textView, in: textView.text, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            mentionManager.loadMore()
        }
    }
}

// MARK: - AmityMentionManagerDelegate
extension AmityEditTextViewController: AmityMentionManagerDelegate {
    public func didCreateAttributedString(attributedString: NSAttributedString) {
        textView.attributedText = attributedString
        textView.typingAttributes = [.font: AmityFontSet.body, .foregroundColor: AmityColorSet.base]
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
        showAlertForMaximumCharacters()
    }
}
