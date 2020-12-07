//
//  EkoEditUserProfileViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import Photos
import UIKit

final public class EkoEditUserProfileViewController: EkoViewController {
    
    @IBOutlet private weak var userAvatarView: EkoAvatarView!
    @IBOutlet private weak var avatarButton: UIButton!
    @IBOutlet private weak var cameraImageView: UIView!
    @IBOutlet private weak var displayNameLabel: UILabel!
    @IBOutlet private weak var displayNameTextField: EkoTextField!
    @IBOutlet private weak var aboutLabel: UILabel!
    @IBOutlet private weak var aboutCounterLabel: UILabel!
    @IBOutlet private weak var aboutTextView: EkoTextView!
    @IBOutlet private weak var aboutSeparatorView: UIView!
    @IBOutlet private weak var displaynameSeparatorView: UIView!
    private var saveBarButtonItem: UIBarButtonItem!
    
    private var screenViewModel: EkoEditUserProfileScreenViewModelType?
    
    // To support reuploading image
    // use this variable to store a new image
    private var uploadingAvatarImage: UIImage?
    
    private var isValueChanged: Bool {
        guard let user = screenViewModel?.dataSource.user else {
            return false
        }
        let isValueChanged = (displayNameTextField.text != user.displayName) || (aboutTextView.text != user.about) || (uploadingAvatarImage != nil)
        let isValueExisted = !displayNameTextField.text!.isEmpty
        return isValueChanged && isValueExisted
    }
    
    private init() {
        self.screenViewModel = EkoEditUserProfileScreenViewModel()
        super.init(nibName: EkoEditUserProfileViewController.identifier, bundle: UpstraUIKitManager.bundle)
        
        title = EkoLocalizedStringSet.editUserProfileTitle
        screenViewModel?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> EkoEditUserProfileViewController {
        return EkoEditUserProfileViewController()
    }
    
    // MARK: - view's life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        saveBarButtonItem = UIBarButtonItem(title: EkoLocalizedStringSet.save, style: .done, target: self, action: #selector(saveButtonTap))
        saveBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    private func setupView() {
        // avatar
        userAvatarView.placeholder = EkoIconSet.defaultAvatar
        cameraImageView.backgroundColor = EkoColorSet.base.blend(.shade4)
        cameraImageView.layer.borderColor = UIColor.white.cgColor
        cameraImageView.layer.borderWidth = 1.0
        cameraImageView.layer.cornerRadius = 14.0
        cameraImageView.clipsToBounds = true
        
        // display name
        displayNameLabel.text = EkoLocalizedStringSet.editUserProfileDisplayNameTitle + "*"
        displayNameLabel.font = EkoFontSet.title
        displayNameLabel.textColor = EkoColorSet.base
        displayNameTextField.borderStyle = .none
        displayNameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        // about
        aboutLabel.text = EkoLocalizedStringSet.createCommunityAboutTitle
        aboutLabel.font = EkoFontSet.title
        aboutLabel.textColor = EkoColorSet.base
        aboutCounterLabel.font = EkoFontSet.caption
        aboutCounterLabel.textColor = EkoColorSet.base.blend(.shade1)
        aboutTextView.customTextViewDelegate = self
        aboutTextView.maxCharacters = 100
        
        // separator
        aboutSeparatorView.backgroundColor = EkoColorSet.base.blend(.shade4)
        displaynameSeparatorView.backgroundColor = EkoColorSet.base.blend(.shade4)
        
        updateViewState()
    }
    
    @objc private func saveButtonTap() {
        view.endEditing(true)
        
        // Update display name and about
        screenViewModel?.action.update(displayName: displayNameTextField.text ?? "", about: aboutTextView.text ?? "")
        
        // Update user avatar
        if let avatar = uploadingAvatarImage {
            userAvatarView.state = .loading
            screenViewModel?.action.update(avatar: avatar) { [weak self] success in
                if success {
                    EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.successfullyUpdated))
                    self?.userAvatarView.image = avatar
                } else {
                    EkoHUD.show(.error(message: EkoLocalizedStringSet.HUD.somethingWentWrong))
                }
                self?.userAvatarView.state = .idle
                self?.uploadingAvatarImage = nil
                self?.updateViewState()
            }
        }
    }
    
    @IBAction private func avatarButtonTap(_ sender: Any) {
        view.endEditing(true)
        let bottomSheet = BottomSheetViewController()
        let cameraOption = TextItemOption(title: EkoLocalizedStringSet.camera)
        let galleryOption = TextItemOption(title: EkoLocalizedStringSet.imageGallery)
        let contentView = ItemOptionView<TextItemOption>()
        contentView.configure(items: [cameraOption, galleryOption], selectedItem: nil)
        contentView.didSelectItem = { [weak bottomSheet] action in
            bottomSheet?.dismissBottomSheet { [weak self] in
                if action == cameraOption {
                    let cameraPicker = UIImagePickerController()
                    cameraPicker.sourceType = .camera
                    cameraPicker.delegate = self
                    self?.present(cameraPicker, animated: true, completion: nil)
                } else {
                    let imagePicker = EkoImagePickerController(selectedAssets: [])
                    imagePicker.settings.theme.selectionStyle = .checked
                    imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
                    imagePicker.settings.selection.max = 1
                    imagePicker.settings.selection.unselectOnReachingMax = true
                    self?.presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { [weak self] assets in
                        let image = assets.first?.getImage()
                        self?.handleImage(image)
                    })
                }
            }
        }
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        present(bottomSheet, animated: false, completion: nil)
    }
    
    @objc private func textFieldEditingChanged(_ textView: EkoTextView) {
        updateViewState()
    }
    
    private func handleImage(_ image: UIImage?) {
        uploadingAvatarImage = image
        userAvatarView.image = image
        updateViewState()
    }
    
    private func updateViewState() {
        saveBarButtonItem?.isEnabled = isValueChanged
        aboutCounterLabel?.text = "\(aboutTextView.text.count)/\(aboutTextView.maxCharacters)"
    }

}

extension EkoEditUserProfileViewController: EkoEditUserProfileScreenViewModelDelegate {
    
    func screenViewModelDidUpdate(_ viewModel: EkoEditUserProfileScreenViewModelType) {
        guard let user = screenViewModel?.dataSource.user else { return }
        displayNameTextField?.text = user.displayName
        aboutTextView?.text = user.about
        
        if let image = uploadingAvatarImage {
            // While uploading avatar, view model will get call once with an old image.
            // To prevent image view showing an old image, checking if it nil here.
            userAvatarView.image = image
        } else {
            userAvatarView?.setImage(withImageId: user.avatarFileId, placeholder: EkoIconSet.defaultAvatar)
        }
        
        updateViewState()
    }
    
}

extension EkoEditUserProfileViewController: EkoTextViewDelegate {
    
    func textViewDidChange(_ textView: EkoTextView) {
        updateViewState()
    }
    
}

extension EkoEditUserProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            let image = info[.originalImage] as? UIImage
            self?.handleImage(image)
        }
    }
    
}
