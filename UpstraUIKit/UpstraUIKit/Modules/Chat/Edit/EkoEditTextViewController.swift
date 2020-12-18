//
//  EkoEditTextViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import EkoChat

class EkoEditTextViewController: EkoViewController {
    
    enum EditMode {
        case create
        case edit
    }
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var textView: EkoTextView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let editMode: EditMode
    private var saveBarButton: UIBarButtonItem!
    private var message: String
    var editHandler: ((String) -> Void)?
    var dismissHandler: (() -> Void)?
    
    // MARK: - View lifecycle
    
    private init(message: String, editMode: EditMode) {
        self.message = message
        self.editMode = editMode
        super.init(nibName: EkoEditTextViewController.identifier, bundle: UpstraUIKitManager.bundle)
        title = EkoLocalizedStringSet.editMessageTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(message: String, editMode: EditMode) -> EkoEditTextViewController {
        return EkoEditTextViewController(message: message, editMode: editMode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didTapLeftBarButton() {
        dismissHandler?()
    }
    
    private func setupView() {
        let buttonTitle = (editMode == .create) ? EkoLocalizedStringSet.post : EkoLocalizedStringSet.save
        saveBarButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: self, action: #selector(saveTap))
        saveBarButton.tintColor = EkoColorSet.primary
        navigationItem.rightBarButtonItem = saveBarButton
        textView.text = message
        textView.placeholder = EkoLocalizedStringSet.textMessagePlaceholder
        textView.showsVerticalScrollIndicator = false
        textView.customTextViewDelegate = self
        saveBarButton.isEnabled = (editMode == .create) ? !message.isEmpty : false
        EkoKeyboardService.shared.delegate = self
    }
    
    @objc private func saveTap() {
        dismiss(animated: true) { [weak self] in
            self?.editHandler?(self?.textView.text ?? "")
        }
    }
    
}

extension EkoEditTextViewController: EkoKeyboardServiceDelegate {
    func keyboardWillChange(service: EkoKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        bottomConstraint.constant = -height + offset

        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
    }
}

extension EkoEditTextViewController: EkoTextViewDelegate {
    func textViewDidChange(_ textView: EkoTextView) {
        guard let text = textView.text else { return }
        saveBarButton.isEnabled = !text.isEmpty
    }
}
