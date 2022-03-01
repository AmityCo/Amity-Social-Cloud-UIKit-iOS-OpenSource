//
//  AmityCommunityProfileEditorViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public protocol AmityCommunityProfileEditorViewControllerDelegate: AnyObject {
    func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFinishCreateCommunity communityId: String)
    func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFailWithNoPermission: Bool)
}

extension AmityCommunityProfileEditorViewControllerDelegate {
    public func viewController(_ viewController: AmityCommunityProfileEditorViewController, didFailWithNoPermission: Bool) { }
}

/// A view controller for providing community profile editor.
public class AmityCommunityProfileEditorViewController: AmityViewController {
    
    enum ViewType {
        case create
        case edit(communityId: String)
    }
    
    private enum Constant {
        static let nameMaxLength = 30
        static let aboutMaxlength = 180
    }
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: - Community Display
    @IBOutlet private var avatarView: AmityImageView!
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var uploadPhotoButton: UIButton!
    
    // MARK: - Community Name
    @IBOutlet private var communityNameTitleLabel: UILabel!
    @IBOutlet private var communityNameCountLabel: UILabel!
    @IBOutlet private var communityNameTextfield: AmityTextField!
    @IBOutlet private var errorNameLabel: UILabel!
    
    // MARK: - Community About
    @IBOutlet private var communityAboutTitleLabel: UILabel!
    @IBOutlet private var communityAboutTextView: AmityTextView!
    @IBOutlet private var communityAboutCountLabel: UILabel!
    @IBOutlet private var communityAboutClearButton: UIButton!
    
    // MARK: - Community Category
    @IBOutlet private var communityCategoryTitleLabel: UILabel!
    @IBOutlet private var communityCategoryLabel: UILabel!
    @IBOutlet private var commnuityCategoryArrowImageView: UIImageView!
    
    // MARK: - Community Admin Rule
    @IBOutlet private var communityAdminRuleTitleLabel: UILabel!
    @IBOutlet private var communityAdminRuleDescLabel: UILabel!
    @IBOutlet private var communityAdminRuleSwitch: UISwitch!
    
    // MARK: - Community Type
    @IBOutlet private var communityTypePublicTitleLabel: UILabel!
    @IBOutlet private var communityTypePublicDescLabel: UILabel!
    @IBOutlet private var communityTypePublicRadioImageView: UIImageView!
    @IBOutlet private var communityTypePrivateTitleLabel: UILabel!
    @IBOutlet private var communityTypePrivateDescLabel: UILabel!
    @IBOutlet private var communityTypePrivateRadioImageView: UIImageView!
    @IBOutlet private var communityTypeBackgroundView: [UIView]!
    
    // MARK: - Add member
    @IBOutlet private var communityAddMemberView: UIView!
    @IBOutlet private var communityAddMemberTitleLabel: UILabel!
    @IBOutlet private var communityAddMemberCollectionView: AmityDynamicHeightCollectionView!
    
    // MARK: - Create Community
    @IBOutlet private var createCommunityButton: UIButton!
    
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Line
    @IBOutlet private var nameLineView: UIView!
    @IBOutlet private var aboutLineView: UIView!
    @IBOutlet private var categoryLineView: UIView!
    @IBOutlet private var adminRuleLineView: UIView!
    @IBOutlet private var communityTypeLineView: UIView!
    @IBOutlet private var addMemberLineView: UIView!
    @IBOutlet private var seperatorLineView: UIView!
    
    // MARK: - Properties
    private var screenViewModel: AmityCreateCommunityScreenViewModelType = AmityCreateCommunityScreenViewModel()
    private let selectMemberListViewModel: AmityMemberPickerScreenViewModelType = AmityMemberPickerScreenViewModel()
    private var rightItem: UIBarButtonItem?
    private let viewType: ViewType
    
    public weak var delegate: AmityCommunityProfileEditorViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewType: ViewType) {
        self.viewType = viewType
        super.init(nibName: AmityCommunityProfileEditorViewController.identifier, bundle: AmityUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didTapLeftBarButton() {
        screenViewModel.action.performDismiss()
    }

    private func setupView() {
        setupGeneral()
        setupCommunityDisplay()
        setupCommunityName()
        setupCommunityAbout()
        setupCommunityCategory()
        setupCommunityAdminRule()
        setupCommunityTypes()
        setupCommunityAddMember()
        setupCreateCommunityButton()
        setupUpdateButton()
        
        bindingViewModel()
    }
    
    private func setupGeneral() {
        dismissKeyboardFromVC()
        screenViewModel.delegate = self
        scrollView.keyboardDismissMode = .onDrag
        seperatorLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        switch viewType {
        case .create:
            title = title ?? AmityLocalizedStringSet.createCommunityTitle.localizedString
        case .edit:
            title = title ?? AmityLocalizedStringSet.editCommunityTitle.localizedString
        }
    }
    
    private func setupCommunityDisplay() {
        avatarView.placeholder = AmityIconSet.defaultCommunityAvatar
        avatarView.contentMode = .scaleAspectFill
        
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let attributedString = NSAttributedString(string: AmityLocalizedStringSet.General.uploadImage.localizedString,
                                                  attributes: [.font: AmityFontSet.bodyBold,
                                                               .foregroundColor: AmityColorSet.baseInverse])
        uploadPhotoButton.setAttributedTitle(attributedString, for: .normal)
        uploadPhotoButton.setImage(AmityIconSet.iconCameraFill, for: .normal)
        uploadPhotoButton.tintColor = AmityColorSet.baseInverse
        uploadPhotoButton.backgroundColor = .clear
        uploadPhotoButton.layer.borderColor = AmityColorSet.baseInverse.cgColor
        uploadPhotoButton.layer.borderWidth = 1
        uploadPhotoButton.layer.cornerRadius = 4
        uploadPhotoButton.setInsets(forContentPadding: UIEdgeInsets(top: 12, left: 40, bottom: 12, right: 40), imageTitlePadding: 8)
    }
    
    private func setupCommunityName() {
        communityNameTitleLabel.text = AmityLocalizedStringSet.createCommunityNameTitle.localizedString
        communityNameTitleLabel.font = AmityFontSet.title
        communityNameTitleLabel.textColor = AmityColorSet.base
        communityNameTitleLabel.markAsMandatoryField()
        
        communityNameCountLabel.text = "0/\(Constant.nameMaxLength)"
        communityNameCountLabel.textColor = AmityColorSet.base.blend(.shade1)
        communityNameCountLabel.font = AmityFontSet.caption
        
        communityNameTextfield.textColor = AmityColorSet.base
        communityNameTextfield.font = AmityFontSet.body
        communityNameTextfield.borderStyle = .none
        communityNameTextfield.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        communityNameTextfield.delegate = self
        communityNameTextfield.maxLength = Constant.nameMaxLength
        communityNameTextfield.returnKeyType = .done
        communityNameTextfield.attributedPlaceholder = NSAttributedString(string: AmityLocalizedStringSet.createCommunityNamePlaceholder.localizedString, attributes: [.foregroundColor : AmityColorSet.base.blend(.shade3)])
        
        nameLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        
        errorNameLabel.isHidden = true
        errorNameLabel.text = AmityLocalizedStringSet.createCommunityNameAlreadyTaken.localizedString
        errorNameLabel.textColor = AmityColorSet.alert
        errorNameLabel.font = AmityFontSet.caption
    }
    
    private func setupCommunityAbout() {
        communityAboutTitleLabel.text = AmityLocalizedStringSet.createCommunityAboutTitle.localizedString
        communityAboutTitleLabel.font = AmityFontSet.title
        communityAboutTitleLabel.textColor = AmityColorSet.base
        
        communityAboutCountLabel.text = "0/\(Constant.aboutMaxlength)"
        communityAboutCountLabel.textColor = AmityColorSet.base.blend(.shade1)
        communityAboutCountLabel.font = AmityFontSet.caption
        
        communityAboutTextView.maxLength = Constant.aboutMaxlength
        communityAboutTextView.font = AmityFontSet.body
        communityAboutTextView.placeholder = AmityLocalizedStringSet.createCommunityAboutPlaceholder.localizedString
        communityAboutTextView.placeholderColor = AmityColorSet.base.blend(.shade3)
        
        communityAboutTextView.customTextViewDelegate = self
        communityAboutTextView.padding = .init(top: 8, left: 0, bottom: 8, right: 0)
        
        communityAboutClearButton.alpha = 0
        
        aboutLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
    }
    
    private func setupCommunityCategory() {
        communityCategoryTitleLabel.text = AmityLocalizedStringSet.createCommunityCategoryTitle.localizedString
        communityCategoryTitleLabel.font = AmityFontSet.title
        communityCategoryTitleLabel.textColor = AmityColorSet.base
        communityCategoryTitleLabel.markAsMandatoryField()
        
        communityCategoryLabel.font = AmityFontSet.body
        communityCategoryLabel.text = AmityLocalizedStringSet.createCommunityCategoryPlaceholder.localizedString
        communityCategoryLabel.textColor = AmityColorSet.base.blend(.shade3)
        
        commnuityCategoryArrowImageView.image = AmityIconSet.iconNext
        commnuityCategoryArrowImageView.tintColor = AmityColorSet.base
        
        categoryLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
    }
    
    private func updateCommunityCategoryName(_ categoryName: String?) {
        if let categoryName = categoryName {
            communityCategoryLabel.text = categoryName
            communityCategoryLabel.font = AmityFontSet.body
            communityCategoryLabel.textColor = AmityColorSet.base
        } else {
            communityCategoryLabel.font = AmityFontSet.body
            communityCategoryLabel.text = AmityLocalizedStringSet.createCommunityCategoryPlaceholder.localizedString
            communityCategoryLabel.textColor = AmityColorSet.base.blend(.shade3)
        }
    }
    
    private func setupCommunityAdminRule() {
        communityAdminRuleTitleLabel.text = AmityLocalizedStringSet.createCommunityAdminRuleTitle.localizedString
        communityAdminRuleTitleLabel.textColor = AmityColorSet.base
        communityAdminRuleTitleLabel.font = AmityFontSet.title
        
        communityAdminRuleDescLabel.text = AmityLocalizedStringSet.createCommunityAdminRuleDesc.localizedString
        communityAdminRuleDescLabel.textColor = AmityColorSet.base.blend(.shade1)
        communityAdminRuleDescLabel.font = AmityFontSet.caption
        communityAdminRuleDescLabel.numberOfLines = 0
        
        adminRuleLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
    }
    
    private func setupCommunityTypes() {
        communityTypePublicTitleLabel.text = AmityLocalizedStringSet.createCommunityPublicTitle.localizedString
        communityTypePublicTitleLabel.textColor = AmityColorSet.base
        communityTypePublicTitleLabel.font = AmityFontSet.title
        
        communityTypePublicDescLabel.text = AmityLocalizedStringSet.createCommunityPublicDesc.localizedString
        communityTypePublicDescLabel.textColor = AmityColorSet.base.blend(.shade1)
        communityTypePublicDescLabel.font = AmityFontSet.caption
        communityTypePublicDescLabel.numberOfLines = 0
        
        communityTypePublicRadioImageView.image = AmityIconSet.iconRadioOn
        
        
        communityTypePrivateTitleLabel.text = AmityLocalizedStringSet.createCommunityPrivateTitle.localizedString
        communityTypePrivateTitleLabel.textColor = AmityColorSet.base
        communityTypePrivateTitleLabel.font = AmityFontSet.title
        
        communityTypePrivateDescLabel.text = AmityLocalizedStringSet.createCommunityPrivateDesc.localizedString
        communityTypePrivateDescLabel.textColor = AmityColorSet.base.blend(.shade1)
        communityTypePrivateDescLabel.font = AmityFontSet.caption
        communityTypePrivateDescLabel.numberOfLines = 0
        
        communityTypePrivateRadioImageView.image = AmityIconSet.iconRadioOff
        communityTypeLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        
        communityTypeBackgroundView.forEach {
            $0.backgroundColor = AmityColorSet.secondary.blend(.shade4)
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    private func setupCommunityAddMember() {
        if case .edit = viewType {
            communityAddMemberView.isHidden = true
        } else {
            communityAddMemberTitleLabel.text = AmityLocalizedStringSet.createCommunityAddMemberTitle.localizedString
            communityAddMemberTitleLabel.font = AmityFontSet.title
            communityAddMemberTitleLabel.textColor = AmityColorSet.base
            communityAddMemberTitleLabel.markAsMandatoryField()
            communityAddMemberView.isHidden = true
            communityAddMemberCollectionView.register(UINib(nibName: AmityMemberCollectionViewCell.identifier, bundle: AmityUIKitManager.bundle), forCellWithReuseIdentifier: AmityMemberCollectionViewCell.identifier)
            
            
            addMemberLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        }
    }
    
    private func setupCreateCommunityButton() {
        if case .edit = viewType {
            createCommunityButton.isHidden = true
        }
        createCommunityButton.setTitle(AmityLocalizedStringSet.createCommunityButtonCreate.localizedString, for: .normal)
        createCommunityButton.titleLabel?.font = AmityFontSet.bodyBold
        createCommunityButton.setTitleColor(AmityColorSet.baseInverse, for: .normal)
        createCommunityButton.setTitleColor(AmityColorSet.baseInverse, for: .disabled)
        createCommunityButton.isEnabled = false
        createCommunityButton.setBackgroundColor(color: AmityColorSet.primary, forState: .normal)
        createCommunityButton.setBackgroundColor(color: AmityColorSet.primary.blend(.shade2), forState: .disabled)
        createCommunityButton.layer.cornerRadius = 4
    }
    
    private func setupUpdateButton() {
        if case .edit = viewType {
            rightItem = UIBarButtonItem(title: AmityLocalizedStringSet.General.save.localizedString, style: .plain, target: self, action: #selector(updateProfile))
            rightItem?.tintColor = AmityColorSet.primary
            rightItem?.isEnabled = false
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
}

private extension AmityCommunityProfileEditorViewController {
    
    @objc func updateProfile() {
        AmityHUD.show(.loading)
        screenViewModel.action.update()
    }
    
    @IBAction func choosePhotoTap() {
        let bottomSheet = BottomSheetViewController()
        var cameraOption = TextItemOption(title: AmityLocalizedStringSet.General.camera.localizedString)
        cameraOption.completion = { [weak self] in
            #warning("Redundancy: camera picker should be replaced with a singleton class")
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            self?.present(cameraPicker, animated: true, completion: nil)
        }
        
        var galleryOption = TextItemOption(title: AmityLocalizedStringSet.General.imageGallery.localizedString)
        galleryOption.completion = { [weak self] in
            let imagePicker = AmityImagePickerController(selectedAssets: [])
            imagePicker.settings.theme.selectionStyle = .checked
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.max = 1
            imagePicker.settings.selection.unselectOnReachingMax = true
            self?.presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { [weak self] assets in
                guard let asset = assets.first else { return }
                asset.getImage { result in
                    switch result {
                    case .success(let avatar):
                        self?.avatarView.image = avatar
                        self?.screenViewModel.action.setImage(for: avatar)
                    case .failure:
                        break
                    }
                }
            })
        }
        
        let contentView = ItemOptionView<TextItemOption>()
        contentView.configure(items: [cameraOption, galleryOption], selectedItem: nil)
        contentView.didSelectItem = { [weak bottomSheet] action in
            bottomSheet?.dismissBottomSheet()
        }
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        present(bottomSheet, animated: false, completion: nil)
    }
    
    @objc func textFieldEditingChanged(_ textField: AmityTextField) {
        screenViewModel.action.textFieldEditingChanged(textField)
    }
    
    @IBAction func clearCommunityAboutTap(_ sender: UIButton) {
        communityAboutTextView.text = ""
        sender.alpha = 0
        screenViewModel.action.textViewDidChanged(communityAboutTextView)
    }
    
    @IBAction func chooseCategoryTap() {
        view.endEditing(true)
        let vc = AmityCategoryPickerViewController.make(referenceCategoryId: screenViewModel.dataSource.selectedCategoryId)
        vc.completionHandler = { [weak self] in
            self?.screenViewModel.updateSelectedCategory(categoryId: $0?.categoryId)
            self?.updateCommunityCategoryName($0?.name)
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func adminRuleValueChanged() {
        
    }
    
    @IBAction func chooseCommunityTypesTap(_ sender: UIButton) {
        view.endEditing(true)
        screenViewModel.action.selectCommunityType(sender.tag)
    }
    
    func addMemberTap() {
        let vc = AmityMemberPickerViewController.make(withCurrentUsers: screenViewModel.dataSource.storeUsers)
        vc.selectUsersHandler = { [weak self] storeUsers in
            self?.screenViewModel.action.updateSelectUser(users: storeUsers)
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func deleteTap(at indexPath: IndexPath) {
        screenViewModel.action.removeUser(at: indexPath)
    }
    
    @IBAction func createCommunityTap() {
        AmityHUD.show(.loading)
        screenViewModel.action.create()
    }
}

// MARK: - Binding ViewModel
private extension AmityCommunityProfileEditorViewController {
    func bindingViewModel() {
        if case .edit(let communityId) = viewType {
            screenViewModel.action.getInfo(communityId: communityId)
            screenViewModel.dataSource.community.bind { [weak self] (community) in
                self?.communityNameTextfield.text = community?.displayName
                self?.communityAboutTextView.text = community?.description
                self?.updateCommunityCategoryName(community?.category)
                self?.avatarView.setImage(withImageURL: community?.avatarURL ?? "", size: .medium, placeholder: AmityIconSet.defaultCommunityAvatar) {
                    self?.avatarView.state = .idle
                }
            }
        }
    }
}

extension AmityCommunityProfileEditorViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return screenViewModel.action.text(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}

extension AmityCommunityProfileEditorViewController: AmityTextViewDelegate {
    public func textViewDidChange(_ textView: AmityTextView) {
        screenViewModel.action.textViewDidChanged(textView)
    }
    
    public func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return screenViewModel.action.text(textView, shouldChangeCharactersIn: range, replacementString: text)
    }
}

extension AmityCommunityProfileEditorViewController: AmityKeyboardServiceDelegate {
    func keyboardWillChange(service: AmityKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        bottomConstraint.constant = -height + offset

        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
    }
}

extension AmityCommunityProfileEditorViewController: AmityCreateCommunityScreenViewModelDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func screenViewModel(_ viewModel: AmityCreateCommunityScreenViewModel, failure error: AmityError) {
        switch error {
        case .noPermission:
            let alert = UIAlertController(title: AmityLocalizedStringSet.Community.alertUnableToPerformActionTitle.localizedString, message: AmityLocalizedStringSet.Community.alertUnableToPerformActionDesc.localizedString, preferredStyle: .alert)
            alert.setTitle(font: AmityFontSet.title)
            alert.setMessage(font: AmityFontSet.body)
            alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.ok, style: .default, handler: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: true, completion: {
                    self?.delegate?.viewController(strongSelf, didFailWithNoPermission: true)
                })
            }))
        default:
            AmityHUD.show(.error(message: AmityLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        }
    }
    
    func screenViewModel(_ viewModel: AmityCreateCommunityScreenViewModel, state: AmityCreateCommunityState) {
        switch state {
        case let .textFieldOnChanged(_, lenght):
            communityNameCountLabel.text = "\(lenght)/\(Constant.nameMaxLength)"
        case let .textViewOnChanged(_, lenght, hasValue):
            communityAboutCountLabel.text = "\(lenght)/\(Constant.aboutMaxlength)"
            communityAboutClearButton.alpha = hasValue ? 1 : 0
        case .selectedCommunityType(let type):
            communityTypePublicRadioImageView.image = type == .public ? AmityIconSet.iconRadioOn : AmityIconSet.iconRadioOff
            communityTypePrivateRadioImageView.image = type == .public ? AmityIconSet.iconRadioOff : AmityIconSet.iconRadioOn
            switch viewType {
            case .create:
                communityAddMemberView.isHidden = type == .public
                communityAddMemberCollectionView.delegate = type == .public ? nil : self
                communityAddMemberCollectionView.dataSource = type == .public ? nil : self
            case .edit:
                communityAddMemberView.isHidden = true
            }
        case .updateAddMember:
            communityAddMemberCollectionView.reloadData()
        case .validateField(let status):
            rightItem?.isEnabled = status
            createCommunityButton.isEnabled = status
            errorNameLabel.isHidden = true
            nameLineView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        case .createSuccess(let communityId):
            
            AmityCommunityProfilePageViewController.newCreatedCommunityIds.insert(communityId)
            AmityHUD.hide { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: true) {
                    strongSelf.delegate?.viewController(strongSelf, didFinishCreateCommunity: communityId)
                }
            }
        case .onDismiss(let isChange):
            if isChange {
                let alert = UIAlertController(title: AmityLocalizedStringSet.createCommunityAlertTitle.localizedString, message: AmityLocalizedStringSet.createCommunityAlertDesc.localizedString, preferredStyle: .alert)
                alert.setTitle(font: AmityFontSet.title)
                alert.setMessage(font: AmityFontSet.body)
                alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.leave.localizedString, style: .destructive, handler: { [weak self] _ in
                    self?.generalDismiss()
                }))
                present(alert, animated: true, completion: nil)
            } else {
                generalDismiss()
            }
        case .communityAlreadyExist:
            createCommunityButton.isEnabled = false
            errorNameLabel.isHidden = false
            nameLineView.backgroundColor = AmityColorSet.alert
        case .updateSuccess:
            AmityHUD.hide { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension AmityCommunityProfileEditorViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let state = screenViewModel.dataSource.addMemberState
        
        let space: CGFloat = 8
        let column: CGFloat = 2
        let width = (collectionView.frame.width - space) / column
        switch state {
        case .add:
            return CGSize(width: 40, height: 40)
        case .adding(let number):
            if indexPath.item == number {
                return CGSize(width: 40, height: 40)
            } else {
                return CGSize(width: width, height: 40)
            }
        case .max(let number):
            if indexPath.item == 8 || (indexPath.item == 8 && number > 8){
                return CGSize(width: 40, height: 40)
            } else if (indexPath.item == (8 - 1)) {
                return CGSize(width: (width - 40) - space, height: 40)
            } else {
                return CGSize(width: width, height: 40)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension AmityCommunityProfileEditorViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfMemberSelected()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmityMemberCollectionViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        
        if let cell = cell as? AmityMemberCollectionViewCell {
            let item = indexPath.item
            cell.indexPath = indexPath
            cell.addHandler = addMemberTap
            cell.deleteHandler = deleteTap
            
            
            let state = screenViewModel.dataSource.addMemberState
            switch state {
            case .adding, .max:
                if let user = screenViewModel.dataSource.user(at: indexPath) {
                    cell.display(with: user)
                }
            default:
                break
            }
            
            switch state {
            case .add:
                cell.hideUser()
                cell.hideNumber()
                cell.showAddingView()
            case .adding(let number):
                cell.hideNumber()
                if item == number {
                    cell.showAddingView()
                    cell.hideUser()
                } else {
                    cell.showUser()
                    cell.hideAddingView()
                }
            case .max(let number):
                if item == 8 && number > 8 {
                    cell.hideUser()
                    cell.hideAddingView()
                    cell.showNumber(with: number - 8)
                } else if item == 8 {
                    cell.hideUser()
                    cell.hideNumber()
                    cell.showAddingView()
                } else if item < 8 {
                    cell.hideNumber()
                    cell.hideAddingView()
                    cell.showUser()
                }
            }
        }
    }
}

extension AmityCommunityProfileEditorViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let avatar = info[.originalImage] as? UIImage {
                self?.avatarView.image = avatar
                self?.screenViewModel.action.setImage(for: avatar)
            }
        }
    }
    
}
