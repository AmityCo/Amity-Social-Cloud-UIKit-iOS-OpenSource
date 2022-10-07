//
//  AmityPollCreatorScreenViewModelProtocol.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 20/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityPollCreatorScreenViewModelDelegate: AnyObject {
    func screenViewModelCanPost(_ isEnabled: Bool)
    func screenViewModelFieldsChange(_ isChanged: Bool)
    func screenViewModelDidCreatePost(_ viewModel: AmityPollCreatorScreenViewModelType, post: AmityPost?, error: Error?)
    
}

protocol AmityPollCreatorScreenViewModelDataSource {
    var postTarget: AmityPostTarget { get }
    var pollQuestion: String { get }
    var answersItem: [String] { get }
    var isMultipleSelection: Bool { get }
    var selectedDay: Int { get }
    var timeMilliseconds: Int? { get }
    func getAnswer(at indexPath: IndexPath) -> String
}

protocol AmityPollCreatorScreenViewModelAction {
    func setPollQuestion(_ text: String?)
    func setIsMultipleSelection(_ isMultiple: Bool)
    func setTimeToClosePoll(_ day: Int?)
    func addNewOption(completion: () -> Void)
    func updateAnswer(_ text: String?, at indexPath: IndexPath?, completion: (() -> Void)?)
    func deleteAnswer(at indexPath: IndexPath?, completion: (() -> Void))
    
    func createPoll(withMetadata metadata: [String: Any]?, andMentionees mentionees: AmityMentioneesBuilder?)
    func validateFieldsIsChange()
}


protocol AmityPollCreatorScreenViewModelType: AmityPollCreatorScreenViewModelAction, AmityPollCreatorScreenViewModelDataSource {
    var delegate: AmityPollCreatorScreenViewModelDelegate? { get set }
    var action: AmityPollCreatorScreenViewModelAction { get }
    var dataSource: AmityPollCreatorScreenViewModelDataSource { get }
}

extension AmityPollCreatorScreenViewModelType  {
    var action: AmityPollCreatorScreenViewModelAction { return self }
    var dataSource: AmityPollCreatorScreenViewModelDataSource { return self }
}
