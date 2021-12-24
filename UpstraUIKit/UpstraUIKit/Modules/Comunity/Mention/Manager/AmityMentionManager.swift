//
//  AmityMentionManager.swift
//  AmityUIKit
//
//  Created by Hamlet on 08.11.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import AmitySDK
import UIKit

struct AmityMentionUserModel {
    let userId: String
    let displayName: String
    let avatarURL: String
    let isGlobalBan: Bool
    
    init(user: AmityUser) {
        self.userId = user.userId
        self.displayName = user.displayName ?? AmityLocalizedStringSet.General.anonymous.localizedString
        self.avatarURL = user.getAvatarInfo()?.fileURL ?? ""
        self.isGlobalBan = user.isGlobalBan
    }
}

protocol AmityMentionManagerDelegate: AnyObject {
    func didGetUsers(users: [AmityMentionUserModel])
    func didCreateAttributedString(attributedString: NSAttributedString)
    func didMentionsReachToMaximumLimit()
    func didCharactersReachToMaximumLimit()
}

enum AmityMentionManagerType {
    case post(communityId: String?)
    case comment(communityId: String?)
    case message(channelId: String?)
}

final internal class AmityMentionManager {
    // Properties
    private let type: AmityMentionManagerType
    private var mentions: [AmityMention] = []
    private var searchingKey: String? = nil
    private(set) var isSearchingStarted: Bool = false
    private(set) var users: [AmityMentionUserModel] = []
    private lazy var mentionees: AmityMentioneesBuilder = AmityMentioneesBuilder()
    private let communityId: String?
    
    // Private community
    private lazy var privateCommunityRepository: AmityCommunityRepository = AmityCommunityRepository(client: AmityUIKitManagerInternal.shared.client)
    private var privateCommunityMembersCollection: AmityCollection<AmityCommunityMember>?
    
    // User repository
    private lazy var userRepository: AmityUserRepository = AmityUserRepository(client: AmityUIKitManagerInternal.shared.client)
    private var usersCollection: AmityCollection<AmityUser>?
    
    private var collectionToken: AmityNotificationToken?
    
    public static let maximumCharacterCountForPost = 50000
    public static let maximumMentionsCount = 30
    
    weak var delegate: AmityMentionManagerDelegate?
    
    init(withType type: AmityMentionManagerType) {
        self.type = type
        switch type {
        case .post(let communityId), .comment(let communityId):
            self.communityId = communityId
        default:
            self.communityId = nil
        }
    }
}

// MARK: - Internal methods
extension AmityMentionManager {
    func shouldChangeTextIn(_ textInput: UITextInput, inRange range: NSRange, replacementText: String, currentText text: String) -> Bool {
        if replacementText == "@" {
            if text == "" {
                isSearchingStarted = true
                search(withText: "")
                return true
            } else {
                if let selectedRange = textInput.selectedTextRange, canHanldeMention(textInput, inRange: range, withSelectedRange: selectedRange, inText: text) {
                    return true
                }
                finishSearching()
                return true
            }
        } else if replacementText == "" { // Started to remove
            // Removing during search
            if isSearchingStarted {
                if (searchingKey?.count ?? 0) > 0 {
                    searchingKey?.removeLast()
                    search(withText: searchingKey ?? "")
                } else if text.count > 0, text.dropLast().hasSuffix("@") {
                    searchingKey = ""
                    isSearchingStarted = true
                    search(withText: searchingKey ?? "")
                } else {
                    finishSearching()
                }
                return true
            }
            
            // Removing something from the text
            if let startPosition = textInput.position(from: textInput.beginningOfDocument, offset: range.location),
               let endPosition = textInput.position(from: textInput.beginningOfDocument, offset: range.location + range.length), let selectedRange = textInput.selectedTextRange {
                
                return canRemove(textInput, inRange: range, withSelectedRange: selectedRange, startPosition: startPosition, endPosition: endPosition)
            }
            
        } else if replacementText == " " { // When replacement text is a space then finish all operations related to mention
            finishSearching()
        } else if isSearchingStarted {
            // when searching is started just append the replacement text to the searching key and make search
            if searchingKey == nil {
                searchingKey = ""
            }
            searchingKey?.append(replacementText)
            search(withText: searchingKey ?? "")
        } else { // when writing a text
            let finalText = text.appending(replacementText)
            if finalText.count > AmityMentionManager.maximumCharacterCountForPost {
                delegate?.didCharactersReachToMaximumLimit()
                return false
            }
            // if there is a mention after the current position then change the indexes of existing message
            for i in 0..<mentions.count {
                if range.location < mentions[i].index {
                    mentions[i].index += replacementText.count
                }
            }
            finishSearching()
        }
        
        return true
    }
    
    func changeSelection(_ textInput: UITextInput) {
        if isSearchingStarted { return }

        guard let selectedRange = textInput.selectedTextRange, selectedRange != textInput.textRange(from: textInput.endOfDocument, to: textInput.endOfDocument), selectedRange != textInput.textRange(from: textInput.beginningOfDocument, to: textInput.beginningOfDocument) else { return }
        
        let cursorPosition = textInput.offset(from: textInput.beginningOfDocument, to: selectedRange.start)
        
        for mention in mentions {
            if mention.index <= cursorPosition && mention.index + mention.length >= cursorPosition, let startPosition = textInput.position(from: textInput.beginningOfDocument, offset: mention.index), let endPosition = textInput.position(from: textInput.beginningOfDocument, offset: mention.index + mention.length + 1)  {
                if selectedRange == textInput.textRange(from:startPosition, to: endPosition) { return }
                textInput.selectedTextRange = textInput.textRange(from:startPosition, to: endPosition)
            }
        }
    }
    
    func addMention(from textInput: UITextInput, in text: String, at indexPath: IndexPath) {
        if mentions.count > AmityMentionManager.maximumMentionsCount {
            delegate?.didMentionsReachToMaximumLimit()
            return
        }
        
        guard let selectedRange = textInput.selectedTextRange, indexPath.row < users.count else { return }
        
        var currentText = text
        let member = users[indexPath.row]
        
        if member.isGlobalBan {
            return
        }
        
        let userId: String? = member.userId
        let displayName: String = member.displayName
        let type: AmityMessageMentionType = .user

        let begOfDoc = textInput.beginningOfDocument
        let endOfDoc = textInput.endOfDocument
        
        // adding a mention from ending
        if selectedRange == textInput.textRange(from: endOfDoc, to: endOfDoc) {
            var range = NSRange()
            
            if let key = searchingKey, isSearchingStarted {
                // this is end of the line then we need to remove the suffix
                let rng = Range(NSRange(location: currentText.count - key.count, length: key.count), in: currentText)
                currentText = currentText.replacingOccurrences(of: "\(key)", with: "", options: .caseInsensitive, range: rng)
            }
            
            let start = currentText.count
            range = NSRange(location: start == 0 ? 0 : start - 1, length: displayName.count)
            currentText.append("\(displayName) ")
            
            let mention = AmityMention(type: type, index: range.location, length: range.length, userId: userId)

            mentions.append(mention)
        } else {
            let cursorOffset = textInput.offset(from: begOfDoc, to: selectedRange.start)
            var range = NSRange()
            if isSearchingStarted, let key = searchingKey {
                let rng = currentText.range(of: "@\(key)")
                currentText = currentText.replacingOccurrences(of: "@\(key)", with: "", options: .caseInsensitive, range: rng)
                range = NSRange(location: cursorOffset - "@\(key)".count, length: displayName.count + 1)
                if let cursorIndex = Range(.init(location: range.location, length: 0), in: currentText)?.lowerBound, cursorIndex <= currentText.endIndex {
                    currentText.insert(contentsOf: "@\(displayName)", at: cursorIndex)
                }
            } else {
                let location = cursorOffset - 1
                range = NSRange(location: location, length: displayName.count)
                let rangeToSet = NSRange(location: cursorOffset, length: displayName.count)
                if let cursorIndex = Range(.init(location: rangeToSet.location, length: 0), in: currentText)?.lowerBound, cursorIndex <= currentText.endIndex {
                    currentText.insert(contentsOf: "\(displayName)", at: cursorIndex)
                }
            }
                
            for mention in mentions {
                if range.location < mention.index {
                    mention.index += range.length + 2
                }
            }
            
            let mention = AmityMention(type: type, index: range.location, length: range.length, userId: userId)
            if mentions.count > 0 {
                var index = 0
                while index < mentions.count && mentions[index].index < range.location {
                    index += 1
                }
                mentions.insert(mention, at: index)
            } else {
                mentions.insert(mention, at: 0)
            }
        }
        
        createAttributedText(text: currentText)
        finishSearching()
    }
    
    func getUser(at indexPath: IndexPath) -> AmityMentionUserModel? {
        guard indexPath.row < users.count else { return nil }
        return users[indexPath.row]
    }
    
    func loadMore() {
        guard let _ = communityId else {
            if usersCollection?.hasNext ?? false {
                usersCollection?.nextPage()
            }
            return
        }
        
        if privateCommunityMembersCollection?.hasNext ?? false {
            privateCommunityMembersCollection?.nextPage()
        }
    }
    
    func getMetadata() -> [String: Any]? {
        if mentions.isEmpty { return nil }
        return AmityMentionMapper.metadata(from: mentions)
    }
    
    func getMentionees() -> AmityMentioneesBuilder? {
        if mentions.isEmpty { return nil }
        let userIds = mentions.filter{ $0.type == .user }.compactMap { $0.userId }
        if !userIds.isEmpty {
            mentionees.mentionUsers(userIds: userIds)
        }
        
        return mentionees
    }
    
    func setMentions(metadata: [String: Any], inText text: String) {
        mentions = AmityMentionMapper.mentions(fromMetadata: metadata)
        createAttributedText(text: text)
    }
    
    func resetState() {
        mentions = []
        searchingKey = nil
        isSearchingStarted = false
        users = []
        mentionees = AmityMentioneesBuilder()
        collectionToken?.invalidate()
        collectionToken = nil
        privateCommunityMembersCollection = nil
        usersCollection = nil
    }
}

// MARK: - Private methods
private extension AmityMentionManager {
    func search(withText text: String) {
        guard let communityId = communityId else {
            usersCollection = userRepository.searchUser(text, sortBy: .displayName)
            collectionToken = usersCollection?.observe { [weak self] (collection, _, error) in
                self?.handleSearchResponse(with: collection)
            }
            return
        }
        
        privateCommunityMembersCollection = privateCommunityRepository.searchMembers(communityId: communityId, displayName: text, membership: [.member], roles: [], sortBy: .lastCreated)
        collectionToken = privateCommunityMembersCollection?.observe { [ weak self] (collection, change, error) in
            self?.handleSearchResponse(with: collection)
        }
    }
    
    func handleSearchResponse<T>(with collection: AmityCollection<T>) {
        users = []
        switch collection.dataStatus {
        case .fresh:
            for index in 0..<collection.count() {
                guard let object = collection.object(at: index) else { continue }
                if T.self == AmityCommunityMember.self {
                    guard let memberObject = object as? AmityCommunityMember, let user = memberObject.user else { continue }
                    users.append(AmityMentionUserModel(user: user))
                } else {
                    guard let userObject = object as? AmityUser else { continue }
                    users.append(AmityMentionUserModel(user: userObject))
                }
            }
            delegate?.didGetUsers(users: users)
        case .error:
            collectionToken?.invalidate()
            delegate?.didGetUsers(users: users)
        default: break
        }
    }
    
    func finishSearching() {
        users = []
        searchingKey = nil
        isSearchingStarted = false
        
        delegate?.didGetUsers(users: users)
    }
    
    func removeMention(at range: NSRange) {
        // Find the mention and remove
        let theMentionToRemove = mentions.filter { mention in
            mention.index <= range.location && mention.index + mention.length >= range.location
        }
        
        if theMentionToRemove.count > 0 {
            let mentionToRemove = theMentionToRemove[0]
            mentions.removeAll { mention in
                mention.index == mentionToRemove.index
            }
            
            for i in 0..<mentions.count {
                if mentions[i].index > mentionToRemove.index {
                    // There is a space after every mention, range.length + 1 to count total length included the space
                    mentions[i].index = mentions[i].index - (range.length + 1)
                }
            }
        }
    }
    
    func hasMentionInRange(range: NSRange) -> Bool {
        let filteredMenion = mentions.filter { mention in
            mention.index <= range.location && mention.index + mention.length >= range.location
        }

        return filteredMenion.count > 0
    }
    
    func createAttributedText(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        
        for mention in mentions {
            let range = NSRange(location: mention.index, length: mention.length + 1)
            if range.location != NSNotFound && range.location < text.count {
                attributedString.addAttribute(.foregroundColor, value: AmityColorSet.primary, range: range)
            }
        }
        
        delegate?.didCreateAttributedString(attributedString: attributedString)
        
        if text.count > AmityMentionManager.maximumCharacterCountForPost {
            delegate?.didCharactersReachToMaximumLimit()
        }
    }
    
    // This method handles the activation of mention feature when text is not empty.
    // If can handle then will configure searchingKey and will call searc function
    func canHanldeMention(_ textInput: UITextInput, inRange range: NSRange, withSelectedRange selectedRange: UITextRange, inText text: String) -> Bool {
        let startPosition: UITextPosition = textInput.beginningOfDocument
        let endPosition: UITextPosition = textInput.endOfDocument
        
        // There are 3 cases for cursor position:
        //  - in the begining: can activate and make search if there is a space on the right side of the cursor
        //  - in the middle: can activate and make search if there are only space on the both right and left sides of the cursor
        //  - in the end: can activate and make search if there is a space on the left side of the cursor
        
        if let currentRange = textInput.textRange(from: endPosition, to: endPosition), selectedRange == currentRange, let leftRange = Range(NSRange(location: range.location  > 0 ? range.location - 1 : 0, length: range.length), in: text) {
            // In the end
            let leftSubstring = String(text[leftRange.lowerBound])
            let leftTrimmedString = leftSubstring.trimmingCharacters(in: .whitespacesAndNewlines)
            if leftTrimmedString.isEmpty {
                isSearchingStarted = true
                search(withText: searchingKey ?? "")
                return true
            }
        } else if let currentRange = textInput.textRange(from: startPosition, to: startPosition), selectedRange == currentRange, let rightRange = Range(NSRange(location: range.location  > 0 ? range.location + 1 : 0, length: range.length), in: text) {
            // in the beginning
            let rightSubstring = String(text[rightRange.lowerBound])
            let rightTrimmedString = rightSubstring.trimmingCharacters(in: .whitespacesAndNewlines)
            if rightTrimmedString.isEmpty {
                isSearchingStarted = true
                search(withText: searchingKey ?? "")
                return true
            }
        } else if let leftRange = Range(NSRange(location: range.location  > 0 ? range.location - 1 : 0, length: range.length), in: text), let rightRange = Range(NSRange(location: range.location, length: range.length), in: text) {
            // in the middle
            
            let leftSubstring = String(text[leftRange.lowerBound])
            let leftTrimmedString = leftSubstring.trimmingCharacters(in: .whitespacesAndNewlines)
                
            let rightSubstring = String(text[rightRange.lowerBound])
            let rightTrimmedString = rightSubstring.trimmingCharacters(in: .whitespacesAndNewlines)
                
            if rightTrimmedString.isEmpty && leftTrimmedString.isEmpty {
                isSearchingStarted = true
                search(withText: searchingKey ?? "")
                return true
            }
        }
        return false
    }
    
    // Checks is it possible to remove the text in the selected range
    // If it's possible then removes the selected mention in the given range if there is any
    func canRemove(_ textInput: UITextInput, inRange range: NSRange, withSelectedRange selectedRange: UITextRange, startPosition: UITextPosition, endPosition: UITextPosition) -> Bool {
        // Removing the selected text
        if selectedRange == textInput.textRange(from:startPosition, to: endPosition) {
            // check is there a mention in selected range, if there is any then remove
            if hasMentionInRange(range: range) {
                removeMention(at: range)
            } else {
                configureMentions(inRange: range)
            }
        } else {
            // Check wheater removing the mention of the ending
            let mention = mentions.filter { model in
                let rangeAfterChange = range.location - 1
                return rangeAfterChange >= model.index && rangeAfterChange <= model.index + model.length
            }
            
            if mention.count > 0 {
                // Select the whole mention
                if let startPosition = textInput.position(from: textInput.beginningOfDocument, in: .right, offset: mention[0].index),
                   let endPosition = textInput.position(from: textInput.beginningOfDocument, in: .right, offset: mention[0].index + mention[0].length + 1) {
                    textInput.selectedTextRange = textInput.textRange(from: startPosition, to: endPosition)
                    return false
                }
                
                if let selectedRange = textInput.selectedTextRange,
                   selectedRange == textInput.textRange(from: textInput.endOfDocument, to: textInput.endOfDocument) {
                    let cursorPosition = textInput.offset(from: textInput.beginningOfDocument, to: selectedRange.start)
                    if mention[0].index <= cursorPosition && mention[0].index + mention[0].length >= cursorPosition,
                       let startPosition = textInput.position(from: textInput.beginningOfDocument, offset: mention[0].index),
                       let endPosition = textInput.position(from: textInput.beginningOfDocument, offset: mention[0].index + mention[0].length)  {
                                
                        if selectedRange == textInput.textRange(from:startPosition, to: endPosition) { return false }
                        textInput.selectedTextRange = textInput.textRange(from:startPosition, to: endPosition)
                        removeMention(at: range)
                    }
                }
            } else {
                configureMentions(inRange: range)
                
                finishSearching()
            }
        }
        return true
    }
    
    // Configures the indexes of remaining mentions after removing a mention or text in the given range
    func configureMentions(inRange range: NSRange) {
        // If there is no mention in the selected range then change the indexes of every mention from mentions array
        for i in 0..<mentions.count {
            if range.location < mentions[i].index {
                let newIndex = mentions[i].index - (range.length == 0 ? 1 : range.length)
                mentions[i].index = newIndex > 0 ? newIndex : 0
            }
        }
    }
}

extension AmityMentionManager {
    static func getAttributes(fromText text: String, withMetadata metadata: [String: Any]) -> [MentionAttribute] {
        var attributes = [MentionAttribute]()
        
        let mentions = AmityMentionMapper.mentions(fromMetadata: metadata)
        if mentions.isEmpty { return [] }
        
        for mention in mentions {
            if mention.index < 0 || mention.length <= 0 { continue }
            let range = NSRange(location: mention.index, length: mention.length + 1)
            if range.location != NSNotFound && (range.location + range.length) <= text.count {
                attributes.append(MentionAttribute(name: .foregroundColor, value: AmityColorSet.primary, range: range, userId: mention.userId ?? ""))
            }
        }

        return attributes
    }
}
