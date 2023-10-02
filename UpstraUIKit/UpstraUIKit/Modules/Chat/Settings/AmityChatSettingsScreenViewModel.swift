//
//  AmityChatSettingsScreenViewModel.swift
//  AmityUIKit
//
//  Created by min khant on 06/05/2021.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

enum OptionsList: Equatable {
    case report(Bool)
    case leave
    case members
    case groupProfile
    var text: String {
        switch self {
        case .report(let isReported):
            if isReported {
                return AmityLocalizedStringSet.ChatSettings.unReportUser.localizedString
            }
            return AmityLocalizedStringSet.ChatSettings.reportUser.localizedString
        case .leave:
            return AmityLocalizedStringSet.ChatSettings.leaveChannel.localizedString
        case .members:
            return AmityLocalizedStringSet.ChatSettings.member.localizedString
        case .groupProfile:
            return AmityLocalizedStringSet.ChatSettings.groupProfile.localizedString
        }
    }
    var textColor: UIColor {
        switch self {
        case .report:
            return UIColor(hex: "#292B32")
        case .leave:
            return UIColor(hex: "#FA4D30")
        case .members:
            return UIColor(hex: "#292B32")
        case .groupProfile:
            return UIColor(hex: "#292B32")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .groupProfile:
            return AmityIconSet.CommunitySettings.iconItemEditProfile
        case .members:
            return AmityIconSet.CommunitySettings.iconItemMembers
        default:
            return nil
        }
    }
}

protocol AmityChatSettingsScreenViewModelDelegate: AnyObject {
    func screenViewModelDidFinishReport(error: String?)
    func screenViewModelDidFinishLeaveChat(error: String?)
    func screenViewModelDidPresentMember(channel: AmityChannelModel)
    func screenViewmodelDidPresentGroupDetail(channelId: String)
    func screenViewModelDidUpdate(viewModel: AmityChatSettingsScreenViewModel)
}

protocol AmityChatSettingsScreenViewModelDataSource {
    func title() -> String
    func getNumberOfItems() -> Int
    func getOption(with index: Int) -> OptionsList
    func getOptionTitle(with index: Int) -> String
    func getOptionTextColor(with index: Int) -> UIColor
    func getOptionImage(with index: Int) -> UIImage?
    func getMemberCount() -> String
}

protocol AmityChatSettingsScreenViewModelAction {
    func leaveChat()
    func presentMember()
    func didClickCell(index: Int)
    func changeReportStatus()
}

protocol AmityChatSettingsScreenViewModelType: AmityChatSettingsScreenViewModelAction, AmityChatSettingsScreenViewModelDataSource {
    var action: AmityChatSettingsScreenViewModelAction { get }
    var dataSource: AmityChatSettingsScreenViewModelDataSource { get }
    var delegate: AmityChatSettingsScreenViewModelDelegate? { get set }
}

extension AmityChatSettingsScreenViewModelType {
    var action: AmityChatSettingsScreenViewModelAction { return self }
    var dataSource: AmityChatSettingsScreenViewModelDataSource { return self }
}

final class AmityChatSettingsScreenViewModel: AmityChatSettingsScreenViewModelType {

    weak var delegate: AmityChatSettingsScreenViewModelDelegate?
    private var channelNotificationToken: AmityNotificationToken?
    private var userToken: AmityNotificationToken?
    
    // MARK: - Repository
    private var channelRepository: AmityChannelRepository?
    private var communityRepository: AmityCommunityRepository?
    private var userRepository: AmityUserRepository?
    
    private var flagger: AmityUserFlagger?
    
    private var channelId = String()
    var channelModel: AmityChannelModel?
    var otherUser: AmityUser?
    var isUserReported: Bool = false {
        didSet {
            directChatSetting = [.report(isUserReported), .leave]
        }
    }
    
    private let groupChatSetting: [OptionsList] = [ .groupProfile, .members, .leave]
    private var directChatSetting: [OptionsList] = []
    private var memberCount = String()
    
    init(channelId: String) {
        communityRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
        
        directChatSetting = [.report(isUserReported)]
        
        self.channelId = channelId
        
        AmityHUD.show(.loading)
        
        channelNotificationToken = channelRepository?.getChannel(channelId).observe { [weak self] (channel, error) in
            guard let weakSelf = self,
                  let model = channel.object else { return }
            let channelModel = AmityChannelModel(object: model)
            weakSelf.channelModel = channelModel
            weakSelf.memberCount = "\(model.memberCount)"
            if channelModel.isConversationChannel {
                weakSelf.getReportUserStatus()
            }
            weakSelf.delegate?.screenViewModelDidUpdate(viewModel: weakSelf)
            AmityHUD.hide()
        }
    }
}

// MARK: - DataSource
extension AmityChatSettingsScreenViewModel {
    func title() -> String {
        return AmityLocalizedStringSet.ChatSettings.title.localizedString
    }
    
    func getNumberOfItems() -> Int {
        guard let model = channelModel else {
            return 1
        }
        if model.isConversationChannel {
            return directChatSetting.count
        }
        return groupChatSetting.count
    }
    
    func getOptionTitle(with index: Int) -> String {
        guard let model = channelModel else {
            return OptionsList.leave.text
        }
        if model.isConversationChannel {
            return directChatSetting[index].text
        }
        return groupChatSetting[index].text
    }
    
    func getOptionTextColor(with index: Int) -> UIColor {
        guard let model = channelModel else {
            return OptionsList.leave.textColor
        }
        if model.isConversationChannel {
            return directChatSetting[index].textColor
        }
        return groupChatSetting[index].textColor
    }
    
    func getOptionImage(with index: Int) -> UIImage? {
        guard let model = channelModel else {
            return OptionsList.leave.image
        }
        if model.isConversationChannel {
            return directChatSetting[index].image
        }
        return groupChatSetting[index].image
    }
    
    func getOption(with index: Int) -> OptionsList {
        guard let model = channelModel else {
            return OptionsList.leave
        }
        if model.isConversationChannel {
            return directChatSetting[index]
        }
        return groupChatSetting[index]
    }
    
    func getMemberCount() -> String {
        return memberCount
    }
    
    private func getReportStatus() {
        guard let user = otherUser else {
            isUserReported = false
            return
        }
        flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
        flagger?.isFlaggedByMe {
            self.isUserReported = $0
        }
    }
    
    private func getReportUserStatus() {
        guard let channel = channelModel else { return }
        userToken?.invalidate()
        if !channel.getOtherUserId().isEmpty {
            userToken = userRepository?.getUser(channel.getOtherUserId()).observeOnce({ [weak self] user, error in
                guard let weakSelf = self else { return }
                if error == nil {
                    if let userObject = user.object {
                        weakSelf.otherUser = userObject
                        weakSelf.getReportStatus()
                    }

                }
            })
        }
    }
    
}

// MARK: - Action
extension AmityChatSettingsScreenViewModel {
    
    func changeReportStatus() {
        isUserReported ? unreportUser() : reportUser()
    }
    
    private func reportUser() {
        if let user = otherUser {
            flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
            flagger?.flag { [weak self] (success, error) in
                guard let weakSelf = self else { return }
                weakSelf.isUserReported = success
                weakSelf.delegate?.screenViewModelDidFinishReport(error: error?.localizedDescription)
            }
        }
    }
    
    private func unreportUser() {
        if let user = otherUser {
            flagger = AmityUserFlagger(client: AmityUIKitManagerInternal.shared.client, userId: user.userId)
            flagger?.unflag { [weak self] (success, error) in
                guard let weakSelf = self else { return }
                /// we have to take the opposite value of success
                weakSelf.isUserReported = !success
                weakSelf.delegate?.screenViewModelDidFinishReport(error: error?.localizedDescription)
            }
        }
    }
    
    func leaveChat() {
        AmityAsyncAwaitTransformer.toCompletionHandler(asyncFunction: channelRepository?.leaveChannel, parameters: channelId) { [weak self] success,error in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.screenViewModelDidFinishLeaveChat(error: error?.localizedDescription)
        }
    }
    
    func presentMember() {
        if let channelObject = channelRepository?.getChannel(channelId).object {
            let model = AmityChannelModel(object: channelObject)
            delegate?.screenViewModelDidPresentMember(channel: model)
        }
    }
    
    func presentGroupProfile() {
        delegate?.screenViewmodelDidPresentGroupDetail(channelId: channelId)
        
    }
    
    func didClickCell(index: Int) {
        var optionSetting: [OptionsList] = [.leave]
        if let model = channelModel {
            if model.isConversationChannel {
                optionSetting =  directChatSetting
            } else {
                optionSetting = groupChatSetting
            }
        }
        switch optionSetting[index] {
        case .leave:
            leaveChat()
        case .report:
            changeReportStatus()
        case .members:
            presentMember()
        case .groupProfile:
            presentGroupProfile()
        }
    }
}
