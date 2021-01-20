//
//  EkoCommunityCreateViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 26/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
private let NAME_MAX_LENGHT = 30
private let ABOUT_MAX_LENGHT = 180

protocol EkoCommunityProfileEditViewControllerDelegate: class {
    func viewController(_ viewController: EkoCommunityProfileEditViewController, didFinishCreateCommunity communityId: String)
}

/// A view controller for providing community profile editor.
public final class EkoCommunityProfileEditViewController: EkoViewController {
    
    public enum ViewType {
        case create
        case edit(communityId: String)
    }
    // MARK: - IBOutlet Properties
    
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: - Community Display
    @IBOutlet private var avatarView: EkoAvatarView!
    @IBOutlet private var cameraImageView: UIImageView!
    @IBOutlet private var cameraBackgroundView: UIView!
    
    // MARK: - Community Name
    @IBOutlet private var communityNameTitleLabel: UILabel!
    @IBOutlet private var communityNameCountLabel: UILabel!
    @IBOutlet private var communityNameTextfield: EkoTextField!
    @IBOutlet private var errorNameLabel: UILabel!
    
    // MARK: - Community About
    @IBOutlet private var communityAboutTitleLabel: UILabel!
    @IBOutlet private var communityAboutTextView: EkoTextView!
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
    @IBOutlet private var communityAddMemberCollectionView: EkoDynamicHeightCollectionView!
    
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
    private var screenViewModel: EkoCreateCommunityScreenViewModelType = EkoCreateCommunityScreenViewModel()
    private let selectMemberListViewModel: EkoSelectMemberListScreenViewModelType = EkoSelectMemberListScreenViewModel()
    private var rightItem: UIBarButtonItem?
    private var viewType: ViewType!
    
    weak var delegate: EkoCommunityProfileEditViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = title ?? EkoLocalizedStringSet.createCommunityTitle.localizedString
        setupView()
    }
    
    public static func make(viewType: ViewType) -> EkoCommunityProfileEditViewController {
        let vc = EkoCommunityProfileEditViewController(nibName: EkoCommunityProfileEditViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.viewType = viewType
        return vc
    }
    
    override func didTapLeftBarButton() {
        screenViewModel.action.dismiss()
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
        seperatorLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        
        setupCreateCommunityButton()
        setupUpdateButton()
        
        bindingViewModel()
    }
    
    private func setupGeneral() {
        dismissKeyboardFromVC()
        screenViewModel.delegate = self
        scrollView.keyboardDismissMode = .onDrag
    }
    
    private func setupCommunityDisplay() {
        avatarView.placeholder = EkoIconSet.defaultCommunity
        
        cameraBackgroundView.layer.borderColor = EkoColorSet.backgroundColor.cgColor
        cameraBackgroundView.layer.borderWidth = 1
        cameraBackgroundView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        cameraBackgroundView.layer.cornerRadius = cameraBackgroundView.frame.height / 2
        cameraImageView.image = EkoIconSet.iconCamera
    }
    
    private func setupCommunityName() {
        
        let fullString = NSMutableAttributedString(string: EkoLocalizedStringSet.createCommunityNameTitle.localizedString,
                                                   attributes: [.font : EkoFontSet.title,
                                                                .foregroundColor : EkoColorSet.base])
        fullString.setColorForText(textForAttribute: "*", withColor: EkoColorSet.alert)
        
        communityNameTitleLabel.attributedText = fullString
        communityNameTitleLabel.font = EkoFontSet.title
        
        communityNameCountLabel.text = "0/\(NAME_MAX_LENGHT)"
        communityNameCountLabel.textColor = EkoColorSet.base.blend(.shade1)
        communityNameCountLabel.font = EkoFontSet.caption
        
        communityNameTextfield.textColor = EkoColorSet.base
        communityNameTextfield.font = EkoFontSet.body
        communityNameTextfield.borderStyle = .none
        communityNameTextfield.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        communityNameTextfield.delegate = self
        communityNameTextfield.maxLength = NAME_MAX_LENGHT
        communityNameTextfield.returnKeyType = .done
        communityNameTextfield.attributedPlaceholder = NSAttributedString(string: EkoLocalizedStringSet.createCommunityNamePlaceholder.localizedString, attributes: [.foregroundColor : EkoColorSet.base.blend(.shade3)])
        
        nameLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        
        errorNameLabel.isHidden = true
        errorNameLabel.text = EkoLocalizedStringSet.createCommunityNameAlreadyTaken.localizedString
        errorNameLabel.textColor = EkoColorSet.alert
        errorNameLabel.font = EkoFontSet.caption
    }
    
    private func setupCommunityAbout() {
        communityAboutTitleLabel.text = EkoLocalizedStringSet.createCommunityAboutTitle.localizedString
        communityAboutTitleLabel.font = EkoFontSet.title
        communityAboutTitleLabel.textColor = EkoColorSet.base
        
        communityAboutCountLabel.text = "0/\(ABOUT_MAX_LENGHT)"
        communityAboutCountLabel.textColor = EkoColorSet.base.blend(.shade1)
        communityAboutCountLabel.font = EkoFontSet.caption
        
        communityAboutTextView.maxLength = ABOUT_MAX_LENGHT
        communityAboutTextView.font = EkoFontSet.body
        communityAboutTextView.placeholder = EkoLocalizedStringSet.createCommunityAboutPlaceholder.localizedString
        communityAboutTextView.placeholderColor = EkoColorSet.base.blend(.shade3)
        
        communityAboutTextView.customTextViewDelegate = self
        communityAboutTextView.padding = .init(top: 8, left: 0, bottom: 8, right: 0)
        
        communityAboutClearButton.alpha = 0
        
        aboutLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
    }
    
    private func setupCommunityCategory() {
        communityCategoryTitleLabel.text = EkoLocalizedStringSet.createCommunityCategoryTitle.localizedString
        communityCategoryTitleLabel.font = EkoFontSet.title
        communityCategoryTitleLabel.textColor = EkoColorSet.base
        
        communityCategoryLabel.font = EkoFontSet.body
        communityCategoryLabel.text = EkoLocalizedStringSet.createCommunityCategoryPlaceholder.localizedString
        communityCategoryLabel.textColor = EkoColorSet.base.blend(.shade3)
        
        commnuityCategoryArrowImageView.image = EkoIconSet.iconArrowRight
        commnuityCategoryArrowImageView.tintColor = EkoColorSet.base
        
        categoryLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
    }
    
    private func updateCommunityCategoryName(_ categoryName: String?) {
        if let categoryName = categoryName {
            communityCategoryLabel.text = categoryName
            communityCategoryLabel.font = EkoFontSet.body
            communityCategoryLabel.textColor = EkoColorSet.base
        } else {
            communityCategoryLabel.font = EkoFontSet.body
            communityCategoryLabel.text = EkoLocalizedStringSet.createCommunityCategoryPlaceholder.localizedString
            communityCategoryLabel.textColor = EkoColorSet.base.blend(.shade3)
        }
    }
    
    private func setupCommunityAdminRule() {
        communityAdminRuleTitleLabel.text = EkoLocalizedStringSet.createCommunityAdminRuleTitle.localizedString
        communityAdminRuleTitleLabel.textColor = EkoColorSet.base
        communityAdminRuleTitleLabel.font = EkoFontSet.title
        
        communityAdminRuleDescLabel.text = EkoLocalizedStringSet.createCommunityAdminRuleDesc.localizedString
        communityAdminRuleDescLabel.textColor = EkoColorSet.base.blend(.shade1)
        communityAdminRuleDescLabel.font = EkoFontSet.caption
        communityAdminRuleDescLabel.numberOfLines = 0
        
        adminRuleLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
    }
    
    private func setupCommunityTypes() {
        communityTypePublicTitleLabel.text = EkoLocalizedStringSet.createCommunityPublicTitle.localizedString
        communityTypePublicTitleLabel.textColor = EkoColorSet.base
        communityTypePublicTitleLabel.font = EkoFontSet.title
        
        communityTypePublicDescLabel.text = EkoLocalizedStringSet.createCommunityPublicDesc.localizedString
        communityTypePublicDescLabel.textColor = EkoColorSet.base.blend(.shade1)
        communityTypePublicDescLabel.font = EkoFontSet.caption
        communityTypePublicDescLabel.numberOfLines = 0
        
        communityTypePublicRadioImageView.image = EkoIconSet.iconRadioOn
        
        
        communityTypePrivateTitleLabel.text = EkoLocalizedStringSet.createCommunityPrivateTitle.localizedString
        communityTypePrivateTitleLabel.textColor = EkoColorSet.base
        communityTypePrivateTitleLabel.font = EkoFontSet.title
        
        communityTypePrivateDescLabel.text = EkoLocalizedStringSet.createCommunityPrivateDesc.localizedString
        communityTypePrivateDescLabel.textColor = EkoColorSet.base.blend(.shade1)
        communityTypePrivateDescLabel.font = EkoFontSet.caption
        communityTypePrivateDescLabel.numberOfLines = 0
        
        communityTypePrivateRadioImageView.image = EkoIconSet.iconRadioOff
        communityTypeLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        
        communityTypeBackgroundView.forEach {
            $0.backgroundColor = EkoColorSet.secondary.blend(.shade4)
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    private func setupCommunityAddMember() {
        if case .edit = viewType {
            communityAddMemberView.isHidden = true
        } else {
            let fullString = NSMutableAttributedString(string: EkoLocalizedStringSet.createCommunityAddMemberTitle.localizedString, attributes: [.font : EkoFontSet.title,
                                                                                                                        .foregroundColor : EkoColorSet.base])
            fullString.setColorForText(textForAttribute: "*", withColor: EkoColorSet.alert)
            
            communityAddMemberView.isHidden = true
            communityAddMemberTitleLabel.attributedText = fullString
                
            
            communityAddMemberCollectionView.register(UINib(nibName: EkoMemberCollectionViewCell.identifier, bundle: UpstraUIKitManager.bundle), forCellWithReuseIdentifier: EkoMemberCollectionViewCell.identifier)
            
            
            addMemberLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        }
    }
    
    private func setupCreateCommunityButton() {
        if case .edit = viewType {
            createCommunityButton.isHidden = true
        }
        createCommunityButton.setTitle(EkoLocalizedStringSet.createCommunityButtonCreate.localizedString, for: .normal)
        createCommunityButton.titleLabel?.font = EkoFontSet.bodyBold
        createCommunityButton.setTitleColor(EkoColorSet.baseInverse, for: .normal)
        createCommunityButton.setTitleColor(EkoColorSet.baseInverse, for: .disabled)
        createCommunityButton.isEnabled = false
        createCommunityButton.setBackgroundColor(color: EkoColorSet.primary, forState: .normal)
        createCommunityButton.setBackgroundColor(color: EkoColorSet.primary.blend(.shade2), forState: .disabled)
        createCommunityButton.layer.cornerRadius = 4
    }
    
    private func setupUpdateButton() {
        if case .edit = viewType {
            rightItem = UIBarButtonItem(title: EkoLocalizedStringSet.save.localizedString, style: .plain, target: self, action: #selector(updateProfile))
            rightItem?.tintColor = EkoColorSet.primary
            rightItem?.isEnabled = false
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
}

private extension EkoCommunityProfileEditViewController {
    
    @objc func updateProfile() {
        EkoHUD.show(.loading)
        screenViewModel.action.update()
    }
    
    @IBAction func choosePhotoTap() {
        let bottomSheet = BottomSheetViewController()
        let cameraOption = TextItemOption(title: EkoLocalizedStringSet.camera.localizedString)
        let galleryOption = TextItemOption(title: EkoLocalizedStringSet.imageGallery.localizedString)
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
                        guard let avatar = assets.first?.getImage() else { return }
                        self?.avatarView.image = avatar
                        self?.screenViewModel.action.setImage(for: avatar)
                    })
                }
            }
        }
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        present(bottomSheet, animated: false, completion: nil)
    }
    
    @objc func textFieldEditingChanged(_ textField: EkoTextField) {
        screenViewModel.action.textFieldEditingChanged(textField)
    }
    
    @IBAction func clearCommunityAboutTap(_ sender: UIButton) {
        communityAboutTextView.text = ""
        sender.alpha = 0
    }
    
    @IBAction func chooseCategoryTap() {
        let vc = EkoSelectCategoryListViewController.make(referenceCategoryId: screenViewModel.dataSource.selectedCategoryId)
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
        screenViewModel.action.selectCommunityType(sender.tag)
    }
    
    func addMemberTap() {
        let vc = EkoSelectMemberListViewController.make()
        
        vc.selectUsersHandler = { [weak self] storeUsers in
            self?.screenViewModel.action.updateSelectUser(users: storeUsers)
        }
        vc.getCurrentUsersList(users: screenViewModel.dataSource.storeUsers)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func deleteTap(at indexPath: IndexPath) {
        screenViewModel.action.removeUser(at: indexPath)
    }
    
    @IBAction func createCommunityTap() {
        EkoHUD.show(.loading)
        screenViewModel.action.create()
    }
}

// MARK: - Binding ViewModel
private extension EkoCommunityProfileEditViewController {
    func bindingViewModel() {
        if case .edit(let communityId) = viewType {
            screenViewModel.action.getInfo(communityId: communityId)
            avatarView.state = .loading
            screenViewModel.dataSource.community.bind { [weak self] (community) in
                self?.communityNameTextfield.text = community?.displayName
                self?.communityAboutTextView.text = community?.description
                self?.updateCommunityCategoryName(community?.category)
                self?.avatarView.setImage(withImageId: community?.avatarId ?? "", placeholder: EkoIconSet.defaultCommunity) {
                    self?.avatarView.state = .idle
                }
            }
        }
    }
}

extension EkoCommunityProfileEditViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return screenViewModel.action.text(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}

extension EkoCommunityProfileEditViewController: EkoTextViewDelegate {
    func textViewDidChange(_ textView: EkoTextView) {
        screenViewModel.action.textViewDidChanged(textView)
    }
    
    func textView(_ textView: EkoTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return screenViewModel.action.text(textView, shouldChangeCharactersIn: range, replacementString: text)
    }
}

extension EkoCommunityProfileEditViewController: EkoKeyboardServiceDelegate {
    func keyboardWillChange(service: EkoKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        bottomConstraint.constant = -height + offset

        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
    }
}

extension EkoCommunityProfileEditViewController: EkoCreateCommunityScreenViewModelDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func screenViewModel(_ viewModel: EkoCreateCommunityScreenViewModel, state: EkoCreateCommunityState) {
        switch state {
        case let .textFieldOnChanged(text, lenght):
            communityNameCountLabel.text = "\(lenght)/\(NAME_MAX_LENGHT)"
        case let .textViewOnChanged(text, lenght, hasValue):
            communityAboutCountLabel.text = "\(lenght)/\(ABOUT_MAX_LENGHT)"
            communityAboutClearButton.alpha = hasValue ? 1 : 0
        case .selectedCommunityType(let type):
            communityTypePublicRadioImageView.image = type == .public ? EkoIconSet.iconRadioOn : EkoIconSet.iconRadioOff
            communityTypePrivateRadioImageView.image = type == .public ? EkoIconSet.iconRadioOff : EkoIconSet.iconRadioOn
            if case .edit = viewType {
                communityAddMemberView.isHidden = true
            } else {
                communityAddMemberView.isHidden = type == .public
                communityAddMemberCollectionView.delegate = type == .public ? nil : self
                communityAddMemberCollectionView.dataSource = type == .public ? nil : self
            }
        case .updateAddMember:
            communityAddMemberCollectionView.reloadData()
        case .validateField(let status):
            rightItem?.isEnabled = status
            createCommunityButton.isEnabled = status
            errorNameLabel.isHidden = true
            nameLineView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        case .createSuccess(let communityId):
            EkoHUD.hide { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: true) {
                    strongSelf.delegate?.viewController(strongSelf, didFinishCreateCommunity: communityId)
                }
            }
        case .onDismiss(let isChange):
            if isChange {
                let alert = UIAlertController(title: EkoLocalizedStringSet.createCommunityAlertTitle.localizedString, message: EkoLocalizedStringSet.createCommunityAlertDesc.localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.leave.localizedString, style: .destructive, handler: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            } else {
                dismiss(animated: true, completion: nil)
            }
        case .communityAlreadyExist:
            createCommunityButton.isEnabled = false
            errorNameLabel.isHidden = false
            nameLineView.backgroundColor = EkoColorSet.alert
        case .updateSuccess:
            EkoHUD.hide { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension EkoCommunityProfileEditViewController: UICollectionViewDelegateFlowLayout {
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

extension EkoCommunityProfileEditViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfMemberSelected()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EkoMemberCollectionViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        
        if let cell = cell as? EkoMemberCollectionViewCell {
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

extension EkoCommunityProfileEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let avatar = info[.originalImage] as? UIImage {
                self?.avatarView.image = avatar
                self?.screenViewModel.action.setImage(for: avatar)
            }
        }
    }
    
}
