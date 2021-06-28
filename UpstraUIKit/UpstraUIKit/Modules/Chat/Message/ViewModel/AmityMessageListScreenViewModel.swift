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
    private let membershipParticipation: AmityChannelParticipation!
    private let channelRepository: AmityChannelRepository!
    private var messageRepository: AmityMessageRepository!
    private var editor: AmityMessageEditor?
    
    // MARK: - Collection
    private var messagesCollection: AmityCollection<AmityMessage>?
    
    // MARK: - Notification Token
    private var channelNotificationToken: AmityNotificationToken?
    private var messagesNotificationToken: AmityNotificationToken?
    private var createMessageNotificationToken: AmityNotificationToken?
    
    private var messageAudio: AmityMessageAudioController?
    
    // MARK: - Properties
    private let channelId: String
    private var canScrollToBottom: Bool = true
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
    
    func message(at indexPath: IndexPath) -> AmityMessageModel? {
        guard !messages.isEmpty else { return nil }
        return messages[indexPath.section][indexPath.row]
    }
    
    func getKeyboardVisible() -> Bool {
        return keyboardVisible
    }
    
    func numberOfSection() -> Int {
        return messages.count
    }
    
    func numberOfMessage(in section: Int) -> Int {
        return messages[section].count
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
            guard let model = channel.object else { return }
            self?.delegate?.screenViewModelDidGetChannel(channel: model)
        }
    }
    
    func getMessage() {
        messagesCollection = messageRepository.getMessages(channelId: channelId, includingTags: [], excludingTags: [], filterByParentId: false, parentId: nil, reverse: true)
        messagesNotificationToken = messagesCollection?.observe { [weak self] (_messages, change, error) in
            self?.groupingMessages(with: _messages)
        }
    }
    
    func send(withText text: String?) {
        let textMessage = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !textMessage.isEmpty else { return }
        
        createMessageNotificationToken = messageRepository.createTextMessage(withChannelId: channelId, text: textMessage, tags: nil, parentId: nil)
            .observe { [weak self] (_message, error) in
                self?.text = ""
                self?.delegate?.screenViewModelEvents(for: .didSendText)
                self?.scrollToBottom()
        }
    }
    
    func editText(with text: String, messageId: String) {
        let textMessage = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textMessage.isEmpty else { return }
        
        editor = AmityMessageEditor(client: AmityUIKitManagerInternal.shared.client, messageId: messageId)
        editor?.editText(textMessage, completion: { [weak self] (status, error) in
            if let error = error {
                return
            }
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
                AmityFileCache.shared.deleteFile(for: .audioDireectory, fileName: message.messageId + ".m4a")
            default:
                break
            }
            self?.delegate?.screenViewModelEvents(for: .didDelete(indexPath: indexPath))
            self?.editor = nil
        })
    }
    
    
    func deleteErrorMessage(with messageId: String, at indexPath: IndexPath) {
        messageRepository.deleteFailedMessage(messageId) { [weak self] (status, error) in
            if let error = error {
                return
            }
                
            if status {
                self?.delegate?.screenViewModelEvents(for: .didDeeleteErrorMessage(indexPath: indexPath))
                self?.delegate?.screenViewModelEvents(for: .updateMessages)
            }
        }
    }
    
    func startReading() {
        membershipParticipation.startReading()
    }
    
    func stopReading() {
        membershipParticipation.stopReading()
    }
    
    func scrollToBottom() {
        guard let indexPath = lastIndexMessage() else { return }
        delegate?.screenViewMdoelScrollToBottom(for: indexPath)
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
}

private extension AmityMessageListScreenViewModel {
    
    func lastIndexMessage() -> IndexPath? {
        guard !messages.isEmpty else { return nil }
        let lastSection = messages.count - 1
        let messageCount = messages[lastSection].count - 1
        return IndexPath(item: messageCount, section: lastSection)
    }
    
    func groupingMessages(with collection: AmityCollection<AmityMessage>?) {
        guard let collection = collection else { return }
        var storeMessages: [AmityMessageModel] = []
        for index in 0..<collection.count() {
            guard let message = collection.object(at: UInt(index)) else { return }
            let model = AmityMessageModel(object: message)
            let index = storeMessages.firstIndex(where: { $0.messageId == model.messageId })
            if let index = index {
                storeMessages[index] = model
            } else {
                storeMessages.append(model)
            }
        }
        let queue = DispatchQueue(label: "group.message.queue", qos: .background, attributes: .concurrent)
        queue.async { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.messages = storeMessages.groupSort(byDate: { $0.createdAtDate })
                strongSelf.delegate?.screenViewModelLoadingState(for: .loaded)
                strongSelf.delegate?.screenViewModelEvents(for: .updateMessages)
                if strongSelf.canScrollToBottom {
                    strongSelf.scrollToBottom()
                    strongSelf.canScrollToBottom = false
                }
            }
        }
    }
}

// MARK: - Send Image
extension AmityMessageListScreenViewModel {
    
    func send(withImages images: [AmityImage]) {
        let operations = images.map { UploadImageMessageOperation(channelId: channelId, image: $0, repository: messageRepository) }
        
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
            self?.scrollToBottom()
        }
    }

}

// MARK: - Audio Recording
extension AmityMessageListScreenViewModel {
    func performAudioRecordingEvents(for event: AudioRecordingEvents) {
        delegate?.screenViewModelAudioRecordingEvents(for: event)
    }
}
