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
        case dissmiss
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
    
    private let debouncer = Debouncer(delay: 0.6)
    private var dataSourceHash: Int = -1 // to track if data source changes
    private var lastMessageHash: Int = -1 // to track if the last message changes
    private var didEnterBackgroundObservation: NSObjectProtocol?
    private var connectionObservation: NSKeyValueObservation?
    private var lastNotOnline: Date?
    private var lastEnterBackground: Date?
    
    private var otherUserNickname: String?
    
    init(channelId: String) {
        self.channelId = channelId
        membershipParticipation = AmityChannelParticipation(client: AmityUIKitManagerInternal.shared.client, andChannel: channelId)
        channelRepository = AmityChannelRepository(client: AmityUIKitManagerInternal.shared.client)
        messageRepository = AmityMessageRepository(client: AmityUIKitManagerInternal.shared.client)
        userRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
    }
    
    // MARK: - DataSource
    private let queue = OperationQueue()
    private var channelModel: AmityChannelModel?
    private var messages: [[AmityMessageModel]] = []
    private var unsortedMessages: [AmityMessageModel] = []
    private var keyboardEvents: KeyboardInputEvents = .default
    private var keyboardVisible: Bool = false
    private var text: String = "" {
        didSet {
            delegate?.screenViewModelDidTextChange(text: text)
        }
    }
    
    private(set) var allCellNibs: [String: UINib] = [:]
    private(set) var allCellClasses: [String: AmityMessageCellProtocol.Type] = [:]
    
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
    
    func numberOfMessages() -> Int {
        return messages.reduce(0, { $0 + $1.count })
    }
    
    func numberOfMessage(in section: Int) -> Int {
        return messages[section].count
    }
    
    func getChannelId() -> String {
        return channelId
    }
    
    func getChannelModel() -> AmityChannelModel? {
        return channelModel
    }
    
    func getCommunityId() -> String {
        return channelId
    }
    
    func getOtherUserNickName() -> String {
        return otherUserNickname ?? ""
    }
    
    private func connectionStateDidChanged() {
        
        // When the SDK disconnect, it will miss all real-time events during offline period.
        //
        // Once SDK reconnect, we reset the live collection to fetch the most recent data.
        // The page state will be reset to first page (last chunk messages).
        //
        switch AmityUIKitManagerInternal.shared.client.connectionStatus {
        case .notConnected, .connecting, .disconnected:
            // AmityHUD.show(.error(message: "Not Online"))
            // We don't care how many offline states are updated, we only record the first one.
            if lastNotOnline == nil {
                lastNotOnline = Date()
            }
        case .connected:
            var shouldRefresh = false
            // The seconds to reset live collection, if sdk is offline more than x seconds.
            let thresholdToResetLiveCollection = TimeInterval(3)
            if let lastNotOnline = lastNotOnline, Date().timeIntervalSince(lastNotOnline) > thresholdToResetLiveCollection {
                shouldRefresh = true
            } else if let lastEnterBackground = lastEnterBackground, Date().timeIntervalSince(lastEnterBackground) > thresholdToResetLiveCollection {
                // When the app goes into background, we cannot know the connection status.
                // If the background takes longer than the threshold, we refresh the collection, once connected no matter what.
                shouldRefresh = true
            }
            if shouldRefresh {
                 // AmityHUD.show(.success(message: "Online and refresh"))
                // Toggle `isFirstTimeLoaded` to trigger scroll to bottom logic.
                delegate?.screenViewModelIsRefreshing(true)
                isFirstTimeLoaded = true
                messagesCollection?.resetPage()
            } else {
                 // AmityHUD.show(.success(message: "Online without refresh"))
            }
            // SDK is online now, we reset this to nil.
            // This variable, gonna be set again when the connection state is changed to not_online.
            lastNotOnline = nil
            lastEnterBackground = nil
        @unknown default:
            break
        }
        
    }
    
}

// MARK: - Action
extension AmityMessageListScreenViewModel {
    
    func registerCellNibs() {
        AmityMessageTypes.allCases.forEach { item in
            if allCellNibs[item.identifier] == nil {
                allCellNibs[item.identifier] = item.nib
                allCellClasses[item.identifier] = item.class
            }
        }
    }
    
    func register(items: [AmityMessageTypes : AmityMessageCellProtocol.Type]) {
        for (key, _) in allCellNibs {
            for item in items {
                if item.key.identifier == key {
                    allCellNibs[key] = UINib(nibName: item.value.cellIdentifier, bundle: nil)
                    allCellClasses[key] = item.value
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
            let model = AmityChannelModel(object: object)
            self?.channelModel = model
            self?.getOtherUserData(channelModel: model)
        }
    }
    
    func getMessage() {
        
        messagesCollection = messageRepository.getMessages(channelId: channelId, includingTags: [], excludingTags: [], filterByParentId: false, parentId: nil, reverse: true)
        
        messagesNotificationToken = messagesCollection?.observe { [weak self] (liveCollection, change, error) in
            self?.groupMessages(in: liveCollection, change: change)
        }
        
        didEnterBackgroundObservation = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.lastEnterBackground = Date()
        }
        
        connectionObservation = AmityUIKitManagerInternal.shared.client.observe(\.connectionStatus) { [weak self] client, changes in
            self?.connectionStateDidChanged()
        }
        
    }
    
    func getOtherUserData(channelModel: AmityChannelModel) {
        let otherUserId = channelModel.getOtherUserId()
        userNotificationToken = userRepository.getUser(otherUserId).observe({[weak self] user, error in
            guard let weakSelf = self else { return }
            if let userObject = user.object {
                weakSelf.otherUserNickname = userObject.displayName
                weakSelf.userNotificationToken?.invalidate()
            }
            weakSelf.delegate?.screenViewModelDidGetChannel(channel: channelModel)
        })
    }
    
    func send(withText text: String?) {
        let textMessage = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !textMessage.isEmpty else {
            return
        }
        self.text = ""
        delegate?.screenViewModelEvents(for: .didSendText)
        messageRepository.createTextMessage(withChannelId: channelId, text: textMessage, tags: nil, parentId: nil) { [weak self] _,_ in
            
        }
    }
    
    func editText(with text: String, messageId: String) {
        let textMessage = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textMessage.isEmpty else { return }
        delegate?.screenViewModelDidGetChannel(channel: channelModel!)
        
        editor = AmityMessageEditor(client: AmityUIKitManagerInternal.shared.client, messageId: messageId)
        editor?.editText(textMessage, completion: { [weak self] (isSuccess, error) in
            guard isSuccess else { return }
            
            self?.delegate?.screenViewModelEvents(for: .didEditText)
            
            self?.editor = nil
        })
    }
    
    func delete(withMessage message: AmityMessageModel, at indexPath: IndexPath) {
        AmityHUD.show(.loading)
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
    func groupMessages(in collection: AmityCollection<AmityMessage>, change: AmityCollectionChange?) {
        
        // First we get message from the collection
        let storedMessages: [AmityMessageModel] = collection.allObjects().map(AmityMessageModel.init)
        
        // Ignore performing data if it don't change.
        guard dataSourceHash != storedMessages.hashValue else {
            return
        }
        
        dataSourceHash = storedMessages.hashValue
        unsortedMessages = storedMessages
        
        // We use debouncer to prevent data updating too frequently and interupting UI.
        // When data is settled for a particular second, then updating UI in one time.
        debouncer.run { [weak self] in
            self?.notifyView()
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
    
    // MARK: - Helper
    
    private func notifyView() {
        messages = unsortedMessages.groupSort(byDate: { $0.createdAtDate })
        delegate?.screenViewModelLoadingState(for: .loaded)
        delegate?.screenViewModelEvents(for: .updateMessages)
                        
        if isFirstTimeLoaded {
            delegate?.screenViewModelIsRefreshing(false)
            // If this screen is opened for first time, we want to scroll to bottom.
            shouldScrollToBottom(force: true)
            isFirstTimeLoaded = false
        } else if let lastMessage = messages.last?.last,
                  lastMessageHash != lastMessage.hashValue {
            // Compare message hash
            // - if it's equal, the last message remains the same -> do nothing
            // - if it's not equal, there is new message -> scroll to bottom
            
            if lastMessageHash != -1 {
                shouldScrollToBottom(force: false)
            }
            lastMessageHash = lastMessage.hashValue
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.delegate?.screenViewModelEvents(for: .didSendImage)
        })
    }
    
}

// MARK: - Send Audio
extension AmityMessageListScreenViewModel {
    func sendAudio() {
        messageAudio = AmityMessageAudioController(channelId: channelId, repository: messageRepository)
        messageAudio?.create { [weak self] in
            self?.messageAudio = nil
            self?.delegate?.screenViewModelEvents(for: .updateMessages)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self?.delegate?.screenViewModelEvents(for: .didSendAudio)
            })
        }
    }

}

// MARK: - Audio Recording
extension AmityMessageListScreenViewModel {
    func performAudioRecordingEvents(for event: AudioRecordingEvents) {
        delegate?.screenViewModelAudioRecordingEvents(for: event)
    }
}
