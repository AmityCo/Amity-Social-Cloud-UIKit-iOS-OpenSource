//
//  CreateStream.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 2/9/2564 BE.
//

import Foundation
import AmitySDK

extension GoLive {
    
    class CreateStream: AsyncOperation {
        
        var result: Result<AmityStream, Error>?
        
        private let streamRepository: AmityStreamRepository
        private let title: String
        private let streamDescription: String?
        private let meta: [String: Any]?
        
        init(streamRepository: AmityStreamRepository,
             title: String,
             description: String?,
             meta: [String : Any]?) {
            
            self.streamRepository = streamRepository
            self.title = title
            self.streamDescription = description
            self.meta = meta
            
        }
        
        
        override func main() {
            
            let coverImageData = findOptionalCoverImageData()
            
            streamRepository.createVideoStream(withTitle: title, description: streamDescription, thumbnailImage: coverImageData, meta: meta) { [weak self] stream, error in
                if let error = error {
                    self?.result = .failure(error)
                    self?.finish()
                    return
                }
                guard let stream = stream else {
                    self?.result = .failure(GeneralError(message: "Unable to find stream data"))
                    self?.finish()
                    return
                }
                self?.result = .success(stream)
                self?.finish()
            }
            
            
        }
        
        private func findOptionalCoverImageData() -> AmityImageData? {
            // Find result from dependencies.
            for dependency in dependencies {
                if let uploadCoverImage = dependency as? UploadCoverImage {
                    return uploadCoverImage.getCoverImageData()
                }
            }
            return nil
        }
        
    }
    
}

