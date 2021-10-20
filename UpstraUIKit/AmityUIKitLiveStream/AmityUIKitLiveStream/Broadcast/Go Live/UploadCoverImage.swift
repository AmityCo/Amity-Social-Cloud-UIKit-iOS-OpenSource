//
//  UploadCoverImage.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 2/9/2564 BE.
//

import Foundation
import AmitySDK

extension GoLive {
    
    class UploadCoverImage: AsyncOperation {
        
        var result: Result<AmityImageData, Error>?
        
        private let fileRepository: AmityFileRepository
        private let imageFileUrl: URL
        
        init(fileRepository: AmityFileRepository, imageFileUrl: URL) {
            self.fileRepository = fileRepository
            self.imageFileUrl = imageFileUrl
        }
        
        override func main() {
            fileRepository.uploadImage(with: imageFileUrl, isFullImage: true, progress: nil, completion: { [weak self] imageData, error in
                if let error = error {
                    self?.result = .failure(error)
                    self?.finish()
                    return
                }
                guard let imageData = imageData else {
                    self?.result = .failure(GeneralError(message: "Unable to find image data"))
                    self?.finish()
                    return
                }
                self?.result = .success(imageData)
                self?.finish()
            })
        }
        
        func getCoverImageData() -> AmityImageData? {
            switch result {
            case .success(let imageData):
                return imageData
            case .failure:
                return nil
            case .none:
                return nil
            }
        }
        
    }
    
}
