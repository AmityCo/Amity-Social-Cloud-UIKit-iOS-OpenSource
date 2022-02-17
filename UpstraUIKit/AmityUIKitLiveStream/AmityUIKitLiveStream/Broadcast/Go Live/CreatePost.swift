//
//  CreatePost.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 2/9/2564 BE.
//

import Foundation
import AmitySDK

extension GoLive {
    
    class CreatePost: AsyncOperation {

        var result: Result<AmityPost, Error>?
        
        private var completion: ((Result<AmityPost, Error>) -> Void)?
        
        private let postRepository: AmityPostRepository
        private let targetId: String?
        private let targetType: AmityPostTargetType
        private let metadata: [String: Any]?
        private let mentionees: AmityMentioneesBuilder?
        private let text: String
        
        init(postRepository: AmityPostRepository, text: String, targetId: String?, targetType: AmityPostTargetType, metadata: [String: Any]?, mentionees: AmityMentioneesBuilder?) {
            
            self.postRepository = postRepository
            self.targetId = targetId
            self.targetType = targetType
            self.metadata = metadata
            self.mentionees = mentionees
            self.text = text
        }
        
        override func main() {
            
            // Inputs
            let streamId: String!
            
            let createStreamResult = findCreateStreamResult()
            switch createStreamResult {
            case .failure(let error):
                result = .failure(error)
                finish()
                return
            case .success(let streamObject):
                streamId = streamObject.streamId
            }
            
            assert(streamId != nil, "streamId must exist at this point, please check the logic.")
            
            let builder = AmityLiveStreamPostBuilder(streamId: streamId, text: text)
            
            if let metadata = metadata, let mentionees = mentionees {
                postRepository.createPost(builder, targetId: targetId, targetType: targetType, metadata: metadata, mentionees: mentionees) { [weak self] post, error in
                    self?.handleResponse(post: post, error: error)
                }
            } else {
                postRepository.createPost(builder, targetId: targetId, targetType: targetType) { [weak self] post, error in
                    self?.handleResponse(post: post, error: error)
                }
            }
        }
        
        private func findCreateStreamResult() -> Result<AmityStream, Error> {
            // Find result from dependencies.
            for dependency in dependencies {
                if let createStream = dependency as? CreateStream,
                   let result = createStream.result {
                    return result
                }
            }
            return .failure(GeneralError(message: "Unable to find create stream result"))
        }
        
        private func handleResponse(post: AmityPost?, error: Error?) {
            if let error = error {
                result = .failure(error)
                finish()
                return
            }
            guard let post = post else {
                result = .failure(GeneralError(message: "Unable to find post data"))
                finish()
                return
            }
            result = .success(post)
            finish()
        }
        
    }
    
    
}
