//
//  GroupChatEditViewController.swift
//  AmityUIKit
//
//  Created by min khant on 13/05/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

class AmityGroupChatEditViewController: AmityViewController {
    
    private enum Constant {
        static let maxCharactor: Int = 100
    }

    @IBOutlet private weak var uploadButton: UIButton!
    @IBOutlet private weak var cameraImageView: UIView!
    @IBOutlet private weak var groupNameTitleLabel: UILabel!
    @IBOutlet private weak var nameTextField: AmityTextField!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var avatarView: AmityAvatarView!
    
    private var screenViewModel: AmityGroupChatEditorScreenViewModelType?
    private var channelId = String()
    private var saveBarButtonItem: UIBarButtonItem!
    
    // To support reuploading image
    // use this variable to store a new image
    private var uploadingAvatarImage: UIImage?
    
    private var isValueChanged: Bool {
        guard let channel = screenViewModel?.dataSource.channel else {
            return false
        }
        let isValueChanged = (nameTextField.text != channel.displayName) || (uploadingAvatarImage != nil)
        let isValueExisted = !nameTextField.text!.isEmpty
        return (isValueChanged && isValueExisted)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    static func make(channelId: String) -> AmityViewController {
        let vc = AmityGroupChatEditViewController(
            nibName: AmityGroupChatEditViewController.identifier,
            bundle: AmityUIKitManager.bundle)
        vc.channelId = channelId
        return vc
    }
    
    private func updateView() {
        screenViewModel?.dataSource.getChannelEditUserPermission({ [weak self] hasPermission in
            guard let weakSelf = self else { return }
            weakSelf.nameTextField.isEnabled = hasPermission
            weakSelf.uploadButton.isEnabled = hasPermission
            
            if hasPermission {
                weakSelf.setupNavigationBar()
            }
        })
    }
    
    private func setupNavigationBar() {
        saveBarButtonItem = UIBarButtonItem(title: AmityLocalizedStringSet.General.save.localizedString, style: .done, target: self, action: #selector(saveButtonTap))
        saveBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    func setupView() {
        title = AmityLocalizedStringSet.editUserProfileTitle.localizedString
        screenViewModel = AmityGroupChatEditScreenViewModel(channelId: channelId)
        screenViewModel?.delegate = self
        avatarView.placeholder = AmityIconSet.defaultGroupChat
        cameraImageView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        cameraImageView.layer.borderColor = AmityColorSet.backgroundColor.cgColor
        cameraImageView.layer.borderWidth = 1.0
        cameraImageView.layer.cornerRadius = 14.0
        cameraImageView.clipsToBounds = true
        
        // display name
        groupNameTitleLabel.text = AmityLocalizedStringSet.editUserProfileDisplayNameTitle.localizedString + "*"
        groupNameTitleLabel.font = AmityFontSet.title
        groupNameTitleLabel.textColor = AmityColorSet.base
        countLabel.font = AmityFontSet.caption
        countLabel.textColor = AmityColorSet.base.blend(.shade1)
        nameTextField.delegate = self
        nameTextField.borderStyle = .none
        nameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        nameTextField.maxLength = Constant.maxCharactor
    }
    
    @objc private func textFieldEditingChanged(_ textView: AmityTextView) {
        updateViewState()
    }
    
    private func handleImage(_ image: UIImage?) {
        uploadingAvatarImage = image
        avatarView.image = image
        updateViewState()
    }
    
    private func updateViewState() {
        saveBarButtonItem?.isEnabled = isValueChanged || uploadingAvatarImage != nil
        countLabel?.text = "\(nameTextField.text?.count ?? 0)/\(nameTextField.maxLength)"
    }
    
    @IBAction private func didTapUpload(_ sender: Any) {
        // Show camera
        var cameraOption = TextItemOption(title: AmityLocalizedStringSet.General.camera.localizedString)
        cameraOption.completion = { [weak self] in
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            self?.present(cameraPicker, animated: true, completion: nil)
        }
        
        // Show image picker
        var galleryOption = TextItemOption(title: AmityLocalizedStringSet.General.imageGallery.localizedString)
        galleryOption.completion = { [weak self] in
            let imagePicker = AmityImagePickerController(selectedAssets: [])
            imagePicker.settings.theme.selectionStyle = .checked
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.max = 1
            imagePicker.settings.selection.unselectOnReachingMax = true
            
            self?.presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { assets in
                guard let asset = assets.first else { return }
                asset.getImage { result in
                    switch result {
                    case .success(let image):
                        self?.handleImage(image)
                    case .failure:
                        break
                    }
                }
            })
        }
        
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        contentView.configure(items: [cameraOption, galleryOption], selectedItem: nil)
        contentView.didSelectItem = { _ in
            bottomSheet.dismissBottomSheet()
        }
        
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        present(bottomSheet, animated: false, completion: nil)
    }
    
    @objc private func saveButtonTap() {
        AmityHUD.show(.loading)
        // Update user avatar
        if let avatar = uploadingAvatarImage {
            avatarView.state = .loading
            screenViewModel?.action.update(avatar: avatar, completion: {[weak self] result in
                guard let weakSelf = self else { return }
                weakSelf.avatarView.state = .idle
                if result {
                    weakSelf.uploadingAvatarImage = nil
                    if weakSelf.isValueChanged {
                        weakSelf.screenViewModel?.action.update(displayName: weakSelf.nameTextField.text ?? "")
                    } else {
                        AmityHUD.show(.success(message: AmityLocalizedStringSet.HUD.successfullyUpdated.localizedString))
                        AmityChannelEventHandler.shared.channelGroupChatUpdateDidComplete(from: weakSelf)
                    }
                } else {
                    AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
                }
            })
        } else if isValueChanged {
            screenViewModel?.action.update(displayName: nameTextField.text ?? "")
        }
    }
}

extension AmityGroupChatEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            let image = info[.originalImage] as? UIImage
            self?.handleImage(image)
        }
    }
    
}

extension AmityGroupChatEditViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return nameTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        
    }
    
}

extension AmityGroupChatEditViewController: AmityGroupChatEditorScreenViewModelDelegate {
    
    func screenViewModelDidUpdateFailed(_ viewModel: AmityGroupChatEditorScreenViewModelType, withError error: String) {
        AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        updateViewState()
    }
    
    func screenViewModelDidUpdateSuccess(_ viewModel: AmityGroupChatEditorScreenViewModelType) {
        AmityHUD.show(.success(message: AmityLocalizedStringSet.HUD.successfullyUpdated.localizedString))
        AmityChannelEventHandler.shared.channelGroupChatUpdateDidComplete(from: self)
    }
    
    func screenViewModelDidUpdate(_ viewModel: AmityGroupChatEditorScreenViewModelType) {
        guard let channel = viewModel.dataSource.channel else { return }
        setupNavigationBar()
        nameTextField.text = channel.displayName
        if let image = uploadingAvatarImage {
            // While uploading avatar, view model will get call once with an old image.
            // To prevent image view showing an old image, checking if it nil here.
            avatarView.image = image
        } else {
            // MKL : FIX
            avatarView.setImage(withImageURL: channel.getAvatarInfo()?.fileURL ?? "",
                                placeholder: AmityIconSet.defaultGroupChat)
        }
        updateViewState()
    }
}
