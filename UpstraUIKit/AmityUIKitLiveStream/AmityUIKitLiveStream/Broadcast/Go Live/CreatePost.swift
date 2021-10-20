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
        
        init(postRepository: AmityPostRepository, targetId: String?, targetType: AmityPostTargetType) {
            
            self.postRepository = postRepository
            self.targetId = targetId
            self.targetType = targetType
            
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
            
            // Note: we leave post.text as empty, because we render title/description from stream object.
            let builder = AmityLiveStreamPostBuilder(streamId: streamId, text: nil)
            
            postRepository.createPost(builder, targetId: targetId, targetType: targetType) { [weak self] post, error in
                if let error = error {
                    self?.result = .failure(error)
                    self?.finish()
                    return
                }
                guard let post = post else {
                    self?.result = .failure(GeneralError(message: "Unable to find post data"))
                    self?.finish()
                    return
                }
                self?.result = .success(post)
                self?.finish()
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
        
    }
    
    
}
