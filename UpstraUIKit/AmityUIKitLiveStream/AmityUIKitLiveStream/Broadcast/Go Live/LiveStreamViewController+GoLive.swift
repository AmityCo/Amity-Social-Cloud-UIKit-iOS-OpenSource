//
//  LiveStreamViewController+GoLive.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 2/9/2564 BE.
//

import Foundation
import AmitySDK

extension LiveStreamBroadcastViewController {
    
    /// Call this function when the user tap "Go live".
    func goLive() {
        
        // Validate Inputs
        switch validateInputs() {
        case .failure(let error):
            presentErrorDialogue(title: "Input Error", message: error.localizedDescription)
            return
        case .success:
            break
        }
        
        // This will turn back on again when the operation complete (either fail or success.)
        goLiveButton.isEnabled = false
        
        // Create and perform go live operations.
        let operations = createGoLiveOperations()
        goLiveOperationQueue.addOperations(operations, waitUntilFinished: false)
        
    }
    
    private func validateInputs() -> Result<Void, Error> {
        let title = titleTextField.text ?? ""
        if title.isEmpty {
            return .failure(GeneralError(message: "Title can not be empty."))
        }
        return .success(Void())
    }
    
    func createGoLiveOperations() -> [Operation] {
        
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
        let description = descriptionTextView.text
        let createStream = GoLive.CreateStream(streamRepository: streamRepository, title: title, description: description, meta: nil)
        
        // createPost
        let createPost = GoLive.CreatePost(postRepository: postRepository, targetId: targetId, targetType: targetType)
        
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
        createPost.completionBlock = { [weak createPost, weak self] in
            guard let result = createPost?.result else {
                assertionFailure("create post result must be ready at this point.")
                return
            }
            DispatchQueue.main.async {
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
                presentErrorDialogue(title: "Error", message: "Unable to find live stream data in post.")
                return
            }
            createdPost = post
            broadcaster?.startPublish(existingStreamId: streamObject.streamId)
            startLiveDurationTimer()
            switchToUIState(.streaming)
        case .failure(let error):
            presentErrorDialogue(title: "Error", message: error.localizedDescription)
        }
        
    }
    
   
    
}
