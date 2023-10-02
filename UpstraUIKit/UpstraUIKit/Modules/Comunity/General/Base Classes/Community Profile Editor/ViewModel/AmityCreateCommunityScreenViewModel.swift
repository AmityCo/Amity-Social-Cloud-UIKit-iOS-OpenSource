//
//  AmityCreateCommunityScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

#warning("should be renmae to AmityCommunityProfileEditScreenViewModel")
final class AmityCreateCommunityScreenViewModel: AmityCreateCommunityScreenViewModelType {
    
    private let repository: AmityCommunityRepository
    private var communityModeration: AmityCommunityModeration?
    
    private var communityInfoToken: AmityNotificationToken?
    weak var delegate: AmityCreateCommunityScreenViewModelDelegate?
    var addMemberState: AmityCreateCommunityMemberState = .add
    var community: AmityBoxBinding<AmityCommunityModel?> = AmityBoxBinding(nil)
    private var communityId: String = ""
    var storeUsers: [AmitySelectMemberModel] = [] {
        didSet {
            validate()
        }
    }
    private(set) var selectedCategoryId: String? {
        didSet {
            validate()
        }
    }
    
    private var displayName: String = "" {
        didSet {
            validate()
        }
    }
    private var description: String = "" {
        didSet {
            validate()
        }
    }
    private var isPublic: Bool = true {
        didSet {
            validate()
        }
    }
    private var imageAvatar: UIImage? {
        didSet {
            validate()
        }
    }
    
    private var isAdminPost: Bool = true
    private var imageData: AmityImageData?
    
    init() {
        repository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    private var isRequiredFieldExisted: Bool {
        if let community = community.value {
            // Edit community
            let isValueChanged = (displayName != community.displayName) || (description != community.description) || (community.isPublic != isPublic) || (imageAvatar != nil) || (community.categoryId != selectedCategoryId)
            return !displayName.trimmingCharacters(in: .whitespaces).isEmpty && isValueChanged
        } else {
            let isRequiredFieldExisted = !displayName.trimmingCharacters(in: .whitespaces).isEmpty && selectedCategoryId != nil
            if isPublic {
                // Create public community
                return isRequiredFieldExisted
            } else {
                // Create private community
                return isRequiredFieldExisted && !storeUsers.isEmpty
            }
        }
    }
    
    private func validate() {
        delegate?.screenViewModel(self, state: .validateField(status: isRequiredFieldExisted))
    }
}

// MARK: - Data Source
extension AmityCreateCommunityScreenViewModel {
    
    func numberOfMemberSelected() -> Int {
        var userCount = storeUsers.count
        if userCount == 0 {
            addMemberState = .add
        } else if userCount < 8 {
            addMemberState = .adding(number: userCount)
        } else {
            addMemberState = .max(number: userCount)
            userCount = 8
        }
        delegate?.screenViewModel(self, state: .updateAddMember)
        return userCount + 1
    }
    
    func user(at indexPath: IndexPath) -> AmitySelectMemberModel? {
        guard !storeUsers.isEmpty, indexPath.item < storeUsers.count else { return nil }
        return storeUsers[indexPath.item]
    }
    
}
// MARK: - Action
extension AmityCreateCommunityScreenViewModel {
    func textFieldEditingChanged(_ textField: AmityTextField) {
        guard let text = textField.text else { return }
        updateDisplayName(text: text)
    }
    
    private func updateDisplayName(text: String) {
        let count = text.utf16.count
        displayName = text
        delegate?.screenViewModel(self, state: .textFieldOnChanged(text: text, lenght: count))
    }
    
    func textViewDidChanged(_ textView: AmityTextView) {
        guard let text = textView.text else { return }
        updateDescription(text: text)
    }
    
    private func updateDescription(text: String) {
        let count = text.utf16.count
        description = text
        delegate?.screenViewModel(self, state: .textViewOnChanged(text: text, lenght: count, hasValue: count > 0))
    }
    
    func text<T>(_ object: T, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textField = object as? AmityTextField {
            return textField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        } else if let textView = object as? AmityTextView {
            return textView.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
        } else {
            return false
        }
    }

    func selectCommunityType(_ tag: Int) {
        guard let communityType = AmityCreateCommunityTypes(rawValue: tag) else { return }
        isPublic = communityType == .public
        delegate?.screenViewModel(self, state: .selectedCommunityType(type: communityType))
    }
    
    func updateSelectUser(users: [AmitySelectMemberModel]) {
        storeUsers = users
        delegate?.screenViewModel(self, state: .updateAddMember)
    }
    
    func removeUser(at indexPath: IndexPath) {
        storeUsers.remove(at: indexPath.item)
        delegate?.screenViewModel(self, state: .updateAddMember)
    }
    
    func updateSelectedCategory(categoryId: String?) {
        selectedCategoryId = categoryId
    }
    
    func create() {
        if let image = imageAvatar {
            // create community with avatar
            AmityUIKitManagerInternal.shared.fileService.uploadImage(image: image, progressHandler: { _ in }) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let image):
                    strongSelf.createCommunity(image: image)
                case .failure(let error):
                    AmityHUD.hide()
                    strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
                }
            }
        } else {
            createCommunity(image: nil)
        }
    }
    
    func update() {
        if let image = imageAvatar {
            // update community with avatar
            AmityUIKitManagerInternal.shared.fileService.uploadImage(image: image, progressHandler: { _ in }) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let image):
                    strongSelf.updateCommunity(image: image)
                case .failure(let error):
                    AmityHUD.hide()
                    strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
                }
            }
        } else {
            updateCommunity(image: nil)
        }
    }
    
    func performDismiss() {
        var isValueChanged: Bool = false
        
        if imageAvatar != nil {
            isValueChanged = true
        }
        
        if !displayName.trimmingCharacters(in: .whitespaces).isEmpty {
            isValueChanged = true
        }
        
        if !description.isEmpty {
            isValueChanged = true
        }
        
        if selectedCategoryId != nil {
            isValueChanged = true
        }
         
        if !isPublic || !storeUsers.isEmpty {
            isValueChanged = true
        }
        
        delegate?.screenViewModel(self, state: .onDismiss(isChange: isValueChanged))
    }
    
    func getInfo(communityId: String) {
        self.communityId = communityId
        communityInfoToken = repository.getCommunity(withId: communityId).observe{ [weak self] (community, error) in
            guard let object = community.object else { return }
            let model = AmityCommunityModel(object: object)
            self?.community.value = model
            self?.showProfile(model: model)
            if community.dataStatus == .fresh {
                self?.communityInfoToken?.invalidate()
            }
        }
    }
    
    func setImage(for image: UIImage) {
        imageAvatar = image
    }
    
}

private extension AmityCreateCommunityScreenViewModel {
    private func showProfile(model: AmityCommunityModel) {
        updateDisplayName(text: model.displayName)
        updateDescription(text: model.description)
        selectedCategoryId = model.categoryId
        isPublic = model.isPublic
        selectCommunityType(model.isPublic ? 0 : 1)
    }
    
    private func createCommunity(image: AmityImageData?) {
        let createOptions = AmityCommunityCreateOptions()
        createOptions.setDisplayName(displayName)
        createOptions.setCommunityDescription(description)
        createOptions.setIsPublic(isPublic)
        
        if !isPublic {
            let userIds = storeUsers.map { $0.userId }
            createOptions.setUserIds(userIds)
        }
        
        if let selectedCategoryId = selectedCategoryId {
            createOptions.setCategoryIds([selectedCategoryId])
        }
        
        if let image = image {
            createOptions.setAvatar(image)
        }
        
        repository.createCommunity(with: createOptions) { [weak self] (community, error) in
            guard let strongSelf = self else { return }
            
            if let community = community {
                strongSelf.delegate?.screenViewModel(strongSelf, state: .createSuccess(communityId: community.communityId))
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
            }
        }
    }
    
    private func updateCommunity(image: AmityImageData?) {
        let updateOptions = AmityCommunityUpdateOptions()
        updateOptions.setDisplayName(displayName)
        updateOptions.setCommunityDescription(description)
        updateOptions.setIsPublic(isPublic)
        if let imageData = imageData {
            updateOptions.setAvatar(imageData)
        }
        
        if let selectedCategoryId = selectedCategoryId {
            updateOptions.setCategoryIds([selectedCategoryId])
        }
        
        if let image = image {
            updateOptions.setAvatar(image)
        }
        
        repository.updateCommunity(withId: communityId, options: updateOptions) { [weak self] (community, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.screenViewModel(strongSelf, failure: AmityError(error: error) ?? .unknown)
            } else {
                strongSelf.delegate?.screenViewModel(strongSelf, state: .updateSuccess)
            }
        }
    }
    
}
