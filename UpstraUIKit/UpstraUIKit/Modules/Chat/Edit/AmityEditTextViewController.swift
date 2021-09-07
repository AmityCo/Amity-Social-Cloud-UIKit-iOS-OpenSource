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
        case create
        case edit
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var textView: AmityTextView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let editMode: EditMode
    private var saveBarButton: UIBarButtonItem!
    private let headerTitle: String?
    private let message: String
    var editHandler: ((String) -> Void)?
    var dismissHandler: (() -> Void)?
    
    // MARK: - View lifecycle
    
    init(headerTitle: String?, text: String, editMode: EditMode) {
        self.headerTitle = headerTitle
        self.message = text
        self.editMode = editMode
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
        let buttonTitle = (editMode == .create) ? AmityLocalizedStringSet.General.post.localizedString : AmityLocalizedStringSet.General.save.localizedString
        saveBarButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(saveTap))
        saveBarButton.tintColor = AmityColorSet.primary
        navigationItem.rightBarButtonItem = saveBarButton
        textView.text = message
        textView.placeholder = AmityLocalizedStringSet.textMessagePlaceholder.localizedString
        textView.showsVerticalScrollIndicator = false
        textView.customTextViewDelegate = self
        saveBarButton.isEnabled = (editMode == .create) ? !message.isEmpty : false
        AmityKeyboardService.shared.delegate = self
    }
    
    @objc private func saveTap() {
        dismiss(animated: true) { [weak self] in
            self?.editHandler?(self?.textView.text ?? "")
        }
    }
    
}

extension AmityEditTextViewController: AmityKeyboardServiceDelegate {
    func keyboardWillChange(service: AmityKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        bottomConstraint.constant = -height + offset

        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
    }
}

extension AmityEditTextViewController: AmityTextViewDelegate {
    func textViewDidChange(_ textView: AmityTextView) {
        guard let text = textView.text else { return }
        saveBarButton.isEnabled = !text.isEmpty
    }
}

// MARK: handle popup
extension AmityEditTextViewController {
    
    func handleCreatePostError(_ error: AmityError) {
        switch error {
        case .bannedWord:
            let message = AmityLocalizedStringSet.ErrorHandling.errorMessageCommentBanword.localizedString
            let title = AmityLocalizedStringSet.ErrorHandling.errorMessageTitle.localizedString
            showError(title: title, message: message)
        case .linkNotAllowed:
            let message = AmityLocalizedStringSet.ErrorHandling.errorMessageLinkNotAllowedDetail.localizedString
            let title = AmityLocalizedStringSet.ErrorHandling.errorMessageLinkNotAllowed.localizedString
            showError(title: title, message: message)
        case .userIsBanned, .userIsGlobalBanned:
            let message = AmityLocalizedStringSet.ErrorHandling.errorMessageUserIsBanned.localizedString
            showError(title: "", message: message)
        default:
            let message = AmityLocalizedStringSet.ErrorHandling.errorMessageDefault.localizedString + " (\(error.rawValue))"
            showError(title: "", message: message)
        }
    }
    
    private func showError(title: String, message: String) {
        AmityUtilities.showAlert(title: title, message: message, viewController: self) { _ in
            
        }
    }
    
}
