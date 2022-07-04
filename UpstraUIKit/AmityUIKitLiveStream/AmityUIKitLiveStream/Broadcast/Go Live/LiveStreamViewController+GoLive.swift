//
//  LiveStreamViewController+GoLive.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 2/9/2564 BE.
//

import Foundation
import AmitySDK
import AmityUIKit

extension LiveStreamBroadcastViewController {
    
    /// Call this function when the user tap "Go live".
    func goLive(metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?) {
        
        // Validate Inputs
        switch validateInputs() {
        case .failure(let error):
            presentErrorDialogue(title: AmityLocalizedStringSet.LiveStream.Alert.imputError.localizedString, message: error.localizedDescription)
            return
        case .success:
            break
        }
        
        // This will turn back on again when the operation complete (either fail or success.)
        goLiveButton.isEnabled = false
        
        // Create and perform go live operations.
        let operations = createGoLiveOperations(metadata: metadata, mentionees: mentionees)
        goLiveOperationQueue.addOperations(operations, waitUntilFinished: false)
        
    }
    
    private func validateInputs() -> Result<Void, Error> {
        let title = titleTextField.text ?? ""
        if title.isEmpty {
            return .failure(GeneralError(message: AmityLocalizedStringSet.LiveStream.Alert.titleCanNotEmpty.localizedString))
        }
        let description = descriptionTextView.text ?? ""
        if description.isEmpty {
            return .failure(GeneralError(message: AmityLocalizedStringSet.LiveStream.Alert.descriptionCanNotEmpty.localizedString))
        }
        return .success(Void())
    }
    
    func createGoLiveOperations(metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?) -> [Operation] {
        
        var operations: [Operation] = []
        
        // uploadCoverImage
        let uploadCoverImage: GoLive.UploadCoverImage?
        if let coverImageUrl = coverImageUrl {
            uploadCoverImage = GoLive.UploadCoverImage(fileRepository: fileRepository, imageFileUrl: coverImageUrl)
        } else {
            uploadCoverImage = nil
        }
        
        // createStream
        let title = titleTextField.text ?? ""
        
        let description: String? = {
            let text = descriptionTextView.text ?? ""
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedText.isEmpty {
                return trimmedText
            } else {
                return nil
            }
        } ()
        
        let createStream = GoLive.CreateStream(streamRepository: streamRepository, title: title, description: description, meta: nil)
        
        // createPost
        let postText = "\(title)\n\n\(description ?? "")"
        let createPost = GoLive.CreatePost(postRepository: postRepository, text: postText, targetId: targetId, targetType: targetType, metadata: metadata, mentionees: mentionees)
        
        // Set up dependencies
        if let uploadCoverImage = uploadCoverImage {
            createStream.addDependency(uploadCoverImage)
        }
        createPost.addDependency(createStream)
        
        // Add all operations to the result array.
        if let uploadCoverImage = uploadCoverImage {
            operations.append(uploadCoverImage)
        }
        operations.append(createStream)
        operations.append(createPost)
        
        // Observe last create psot completion, to update UI.
        AmityHUD.show(.loading)
        createPost.completionBlock = { [weak createPost, weak self] in
            guard let result = createPost?.result else {
                assertionFailure("create post result must be ready at this point.")
                return
            }
            DispatchQueue.main.async {
                AmityHUD.hide()
                self?.handleCreatePostResult(result)
            }
        }
        
        return operations
        
    }
    
    private func handleCreatePostResult(_ result: Result<AmityPost, Error>) {
        
        // Either fail or success, we enable this button back again.
        goLiveButton.isEnabled = true
        
        switch result {
        case .success(let post):
            // The post itself is a text post.
            // The stream object post, is in the post.children[0].
            guard let firstChildPost = post.childrenPosts?.first,
                  let streamObject = firstChildPost.getLiveStreamInfo() else {
                assertionFailure("post.getLiveStreamInfo must exist at this point.")
//                presentErrorDialogue(title: AmityLocalizedStringSet.ErrorHandling.errorTitle.localizedString, message: AmityLocalizedStringSet.LiveStream.Live.findPostLiveStreamData.localizedString)
                return
            }
            createdPost = post
            broadcaster?.startPublish(existingStreamId: streamObject.streamId)
            streamId = streamObject.streamId
            startLiveDurationTimer()
            switchToUIState(.streaming)
        case .failure(let error):
            presentErrorDialogue(title: AmityLocalizedStringSet.ErrorHandling.errorTitle.localizedString, message: error.localizedDescription)
        }
        
    }
    
   
    
}
