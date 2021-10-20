//
//  AmityMessageListScreenViewModel.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 5/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import Photos
import AmitySDK

final class AmityMessageListScreenViewModel: AmityMessageListScreenViewModelType {
    
    enum Route {
        case pop
    }
    
    enum Events {
        case updateMessages
        case didSendText
        case didEditText
        case didDelete(indexPath: IndexPath)
        case didDeeleteErrorMessage(indexPath: IndexPath)
        case didSendImage
        case didUploadImage(indexPath: IndexPath)
        case didSendAudio
    }
    
    enum AudioRecordingEvents {
        case show
        case hide
        case deleting
        case cancelingDelete
        case delete
        case record
        case timeoutRecord
    }

    enum CellEvents {
        case edit(indexPath: IndexPath)
        case delete(indexPath: IndexPath)
        case deleteErrorMessage(indexPath: IndexPath)
        case report(indexPath: IndexPath)
        case imageViewer(indexPath: IndexPath, imageView: UIImageView)
    }
    
    enum KeyboardInputEvents {
        case `default`, composeBarMenu, audio
    }
    
    weak var delegate: AmityMessageListScreenViewModelDelegate?
        
    // MARK: - Repository
    private var membershipParticipation: AmityChannelParticipation?
    private let channelRepository: AmityChannelRepository!
    private var messageRepository: AmityMessageRepository!
    private var userRepository: AmityUserRepository!
    private var editor: AmityMessageEditor?
    private var messageFlagger: AmityMessageFlagger?
    
    // MARK: - Collection
    private var messagesCollection: AmityCollection<AmityMessage>?
    
    // MARK: - Notification Token
    private var channelNotificationToken: AmityNotificationToken?
    private var messagesNotificationToken: AmityNotificationToken?
    private var createMessageNotificationToken: AmityNotificationToken?
    private var userNotificationToken: AmityNotificationToken?
    
    private var messageAudio: AmityMessageAudioController?
    
    // MARK: - Properties
    private let channelId: String
    private var isFirstTimeLoaded: Bool = true
    private let debouncer = Debouncer(delay: 0.3)
    
    init(channelId: String) {
        self.channelId = channelId
        
        membershipParticipation = AmityChannelParticipation(client: AmityUIKitManagerInternal.shared.client, andChannel: channelId)
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        messageRepository = AmityMessageRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    // MARK: - DataSource
    private let queue = OperationQueue()
    private var messages: [[AmityMessageModel]] = []
    private var keyboardEvents: KeyboardInputEvents = .default
    private var keyboardVisible: Bool = false
    private var text: String = "" {
        didSet {
            delegate?.screenViewModelDidTextChange(text: text)
        }
    }
    
    private(set) var allCells: [String: UINib] = [:]
    
    private var messageQueue = DispatchQueue(label: "group.message.queue", qos: .background)
    
    func message(at indexPath: IndexPath) -> AmityMessageModel? {
        guard !messages.isEmpty else { return nil }
        return messages[indexPath.section][indexPath.row]
    }
    
    func isKeyboardVisible() -> Bool {
        return keyboardVisible
    }
    
    func numberOfSection() -> Int {
        return messages.count
    }
    
    func numberOfMessage(in section: Int) -> Int {
        return messages[section].count
    }
    
    func getChannelId() -> String {
        return channelId
    }
    
    func getCommunityId() -> String {
        return channelId
    }
}

// MARK: - Action
extension AmityMessageListScreenViewModel {
    
    func registerCell() {
        AmityMessageTypes.allCases.forEach { item in
            if self.allCells[item.identifier] == nil {
                self.allCells[item.identifier] = item.nib
            }
        }
    }
    
    func register(items: [AmityMessageTypes : AmityMessageCellProtocol.Type]) {
        for (key, _) in allCells {
            for item in items {
                if item.key.identifier == key {
                    allCells[key] = UINib(nibName: item.value.cellIdentifier, bundle: nil)
                }
            }
        }
    }
    
    func route(for route: Route) {
        delegate?.screenViewModelRoute(route: route)
    }
    
    func setText(withText text: String?) {
        guard let text = text else { return }
        self.text = text
    }
    
    func getChannel(){
        channelNotificationToken?.invalidate()
        channelNotificationToken = channelRepository.getChannel(channelId).observe { [weak self] (channel, error) in
            guard let object = channel.object else { return }
            let channelModel = AmityChannelModel(object: object)
            self?.delegate?.screenViewModelDidGetChannel(channel: channelModel)
        }
    }
    
    func getMessage() {
        messagesCollection = messageRepository.getMessages(channelId: channelId, includingTags: [], excludingTags: [], filterByParentId: false, parentId: nil, reverse: true)
        messagesNotificationToken = messagesCollection?.observe { [weak self] (liveCollection, change, error) in
            self?.debouncer.run {
                self?.groupMessages(in: liveCollection)
            }
        }
    }
    
    func send(withText text: String?) {
        let textMessage = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !textMessage.isEmpty else { return }
        
        createMessageNotificationToken = messageRepository.createTextMessage(withChannelId: channelId, text: textMessage, tags: nil, parentId: nil)
            .observe { [weak self] (_message, error) in
                self?.text = ""
                self?.delegate?.screenViewModelEvents(for: .didSendText)
                self?.shouldScrollToBottom(force: true)
        }
    }
    
    func editText(with text: String, messageId: String) {
        let textMessage = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textMessage.isEmpty else { return }
        
        editor = AmityMessageEditor(client: AmityUIKitManagerInternal.shared.client, messageId: messageId)
        editor?.editText(textMessage, completion: { [weak self] (isSuccess, error) in
            guard isSuccess else { return }
            
            self?.delegate?.screenViewModelEvents(for: .didEditText)
            self?.editor = nil
        })
    }
    
    func delete(withMessage message: AmityMessageModel, at indexPath: IndexPath) {
        messageRepository = AmityMessageRepository(client: AmityUIKitManagerInternal.shared.client)
        messageRepository?.deleteMessage(withId: message.messageId, completion: { [weak self] (status, error) in
            guard error == nil , status else { return }
            switch message.messageType {
            case .audio:
                AmityFileCache.shared.deleteFile(for: .audioDirectory, fileName: message.messageId + ".m4a")
            default:
                break
            }
            self?.delegate?.screenViewModelEvents(for: .didDelete(indexPath: indexPath))
            self?.editor = nil
        })
    }
    
    
    func deleteErrorMessage(with messageId: String, at indexPath: IndexPath) {
        messageRepository.deleteFailedMessage(messageId) { [weak self] (isSuccess, error) in
            if isSuccess {
                self?.delegate?.screenViewModelEvents(for: .didDeeleteErrorMessage(indexPath: indexPath))
                self?.delegate?.screenViewModelEvents(for: .updateMessages)
            }
        }
    }
    
    func startReading() {
        membershipParticipation?.startReading()
    }
    
    func stopReading() {
        membershipParticipation?.stopReading()
        membershipParticipation = nil
    }
    
    func shouldScrollToBottom(force: Bool) {
        guard let indexPath = lastIndexMessage() else { return }
        
        if force {
            // Forcely scroll to bottom regardless of current view state.
            delegate?.screenViewModelScrollToBottom(for: indexPath)
        } else {
            // Determining when to scroll or not when receiving message
            // depends upon the view state.
            delegate?.screenViewModelShouldUpdateScrollPosition(to: indexPath)
        }
    }
    
    func inputSource(for event: KeyboardInputEvents) {
        keyboardEvents = event
        delegate?.screenViewModelKeyboardInputEvents(for: event)
    }
    
    func toggleInputSource() {
        if keyboardEvents == .default {
            keyboardEvents = .composeBarMenu
        } else {
            keyboardEvents = .default
        }
        delegate?.screenViewModelKeyboardInputEvents(for: keyboardEvents)
    }
    
    func toggleKeyboardVisible(visible: Bool) {
        keyboardVisible = visible
    }
    
    func loadMoreScrollUp(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // load previous page when scrolled to the top
        if targetContentOffset.pointee.y.isLessThanOrEqualTo(0) {
            guard let collection = messagesCollection else { return }
            switch collection.loadingStatus {
            case .loaded:
                if collection.hasPrevious {
                    collection.previousPage()
                    delegate?.screenViewModelLoadingState(for: .loading)
                }
            default:
                break
            }
        }
    }
    
    func performCellEvent(for event: CellEvents) {
        delegate?.screenViewModelCellEvents(for: event)
    }
    
    func toggleShowDefaultKeyboardAndAudioKeyboard(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 0 {
            delegate?.screenViewModelToggleDefaultKeyboardAndAudioKeyboard(for: .audio)
        } else if tag == 1 {
            delegate?.screenViewModelToggleDefaultKeyboardAndAudioKeyboard(for: .default)
        }
    }
    
    func reportMessage(at indexPath: IndexPath) {
        getReportMessageStatus(at: indexPath) { [weak self] isFlaggedByMe in
            guard let message = self?.message(at: indexPath) else { return }
            self?.messageFlagger = AmityMessageFlagger(client: AmityUIKitManagerInternal.shared.client, messageId: message.messageId)
            if isFlaggedByMe {
                self?.messageFlagger?.unflag { [weak self] success, error in
                    self?.handleReportResponse(at: indexPath, isSuccess: success, error: error)
                }
            } else {
                self?.messageFlagger?.flag { [weak self] success, error in
                    self?.handleReportResponse(at: indexPath, isSuccess: success, error: error)
                }
            }
        }
    }
}

private extension AmityMessageListScreenViewModel {
    
    func lastIndexMessage() -> IndexPath? {
        guard !messages.isEmpty else { return nil }
        let lastSection = messages.count - 1
        let messageCount = messages[lastSection].count - 1
        return IndexPath(item: messageCount, section: lastSection)
    }
    
    /*
     TODO: Refactor this
     
     Now we loop through whole collection and update the tableview for messages. The observer block also
     provides collection `change` object which can be used to track which indexpaths to add/remove/change.
     */
    func groupMessages(in collection: AmityCollection<AmityMessage>) {
        
        // First we get message from the collection
        var storedMessages: [AmityMessageModel] = []
        for index in 0..<collection.count() {
            guard let message = collection.object(at: UInt(index)) else { return }
            storedMessages.append(AmityMessageModel(object: message))
        }
        // Then we group message as per date. This method gets called everytime observer is triggered with changes.
        // We want to handle the changes in the same order it gets triggered.
        messageQueue.sync { [weak self] in
            guard let strongSelf = self else { return }
            let groupedMessage = storedMessages.groupSort(byDate: { $0.createdAtDate })
            
            // We then ask view to update
            DispatchQueue.main.async {
                strongSelf.messages = groupedMessage
                strongSelf.delegate?.screenViewModelLoadingState(for: .loaded)
                strongSelf.delegate?.screenViewModelEvents(for: .updateMessages)
                                
                if strongSelf.isFirstTimeLoaded {
                    // If this screen is opened for first time, we want to scroll to bottom.
                    strongSelf.shouldScrollToBottom(force: true)
                    strongSelf.isFirstTimeLoaded = false
                } else {
                    strongSelf.shouldScrollToBottom(force: false)
                }
            }
        }
    }
    
    func getReportMessageStatus(at indexPath: IndexPath, completion: ((Bool) -> Void)?) {
        guard let message = message(at: indexPath) else { return }
        messageFlagger = AmityMessageFlagger(client: AmityUIKitManagerInternal.shared.client, messageId: message.messageId)
        messageFlagger?.isFlaggedByMe {
            completion?($0)
        }
    }
    
    func handleReportResponse(at indexPath: IndexPath, isSuccess: Bool, error: Error?) {
        if isSuccess {
            delegate?.screenViewModelDidReportMessage(at: indexPath)
        } else {
            delegate?.screenViewModelDidFailToReportMessage(at: indexPath, with: error)
        }
    }
}

// MARK: - Send Image
extension AmityMessageListScreenViewModel {
    
    func send(withMedias medias: [AmityMedia]) {
        let operations = medias.map { UploadImageMessageOperation(channelId: channelId, media: $0, repository: messageRepository) }
        
        // Define serial dependency A <- B <- C <- ... <- Z
        for (left, right) in zip(operations, operations.dropFirst()) {
            right.addDependency(left)
        }

        queue.addOperations(operations, waitUntilFinished: false)
    }
    
}

// MARK: - Send Audio
extension AmityMessageListScreenViewModel {
    func sendAudio() {
        messageAudio = AmityMessageAudioController(channelId: channelId, repository: messageRepository)
        messageAudio?.create { [weak self] in
            self?.messageAudio = nil
            self?.delegate?.screenViewModelEvents(for: .updateMessages)
            self?.delegate?.screenViewModelEvents(for: .didSendAudio)
            self?.shouldScrollToBottom(force: true)
        }
    }

}

// MARK: - Audio Recording
extension AmityMessageListScreenViewModel {
    func performAudioRecordingEvents(for event: AudioRecordingEvents) {
        delegate?.screenViewModelAudioRecordingEvents(for: event)
    }
}
