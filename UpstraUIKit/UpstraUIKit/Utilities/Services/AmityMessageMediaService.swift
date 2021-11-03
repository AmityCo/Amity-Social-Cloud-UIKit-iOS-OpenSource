//
//  AmityMessageMediaService.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 2/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AmitySDK

final class AmityMessageMediaService {
    
    var fileRepository: AmityFileRepository?
    
    func download(for message: AmityMessage, progress: ((() -> Void)?) = nil, completion: @escaping (Result<URL, Error>) -> Void) {
        #warning("the implementation should be moved to AmityFileService")
        switch message.messageType {
        case .audio:
            let fileName = message.messageId + ".m4a"
            if let url = AmityFileCache.shared.getCacheURL(for: .audioDirectory, fileName: fileName) {
                completion(.success(url))
            } else {
                guard let fileRepository = fileRepository else {
                    completion(.failure(AmityError.fileServiceIsNotReady))
                    return
                }
                
                progress?()
                guard let messageInfo = message.getFileInfo() else { return }
                fileRepository.downloadFileAsData(fromURL: messageInfo.fileURL, completion: { (data, error) in
                    guard error == nil, let data = data else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    AmityFileCache.shared.cacheData(for: .audioDirectory, data: data, fileName: fileName, completion: { url in
                        completion(.success(url))
                    })
                })
            }
        case .image:
            break
        default:
            break
        }
    }
    
    func downloadImageForMessage(message: AmityMessage, size: AmityMediaSize, progress: ((() -> Void)?) = nil, completion: @escaping (Result<UIImage?, Error>) -> Void ) {
        
        #warning("the implementation should be moved to AmityFileService")
        // imageInfo contains information about fileId and fileURL & other attributes.
        guard let imageInfo = message.getImageInfo() else { return }
        
        let messageId = message.messageId
        
        switch message.syncState {
        case .syncing, .error:
            // In this case, the fileURL returned by imageInfo is local url. So we
            // can grab image from that URL path and just display it
            let absURLString = imageInfo.fileURL
            if let uploadURL = URL(string: absURLString) {
                DispatchQueue.main.async {
                    if let image = UIImage(contentsOfFile: uploadURL.path) {
                        // Image is already present locally, lets cache it
                        AmityFileCache.shared.cacheDownloadedFile(url: uploadURL, id: messageId)
                        completion(.success(image))
                    }
                }
            }
            
        case .synced:
            
            guard let fileRepository = fileRepository else {
                completion(.failure(AmityError.fileServiceIsNotReady))
                return
            }
            
            // In this case, the fileURL returned by imageInfo would be server URL. so we
            // grab image from that URL here and display it
            let fileURL = imageInfo.fileURL
                        
            // If image is present in cache, we load it from cache directly
            if let cachedURL = AmityFileCache.shared.getCachedDownloadedFile(id: messageId) {
                self.loadImageFromURL(fileURL: cachedURL) { image in
                    completion(.success(image))
                }
                return
            }
            
            // Notify about progress, telling that the file is downloading.
            progress?()
            
            // Else downlaod it from server
            fileRepository.downloadImage(fromURL: fileURL, size: size, completion: { [weak self] (url, error) in
                if let err = error {
                    Log.add("Error while downloading image \(String(describing: url)) \(err)")
                    return
                }
                
                if let localFileURL = url {
                    // Save in cache
                    AmityFileCache.shared.cacheDownloadedFile(url: localFileURL, id: messageId)
                    
                    guard let newFileLocation = AmityFileCache.shared.getCachedDownloadedFile(id: messageId) else {
                        completion(.failure(AmityError.unknown))
                        return
                    }
                                        
                    // Load image from URL and return it
                    self?.loadImageFromURL(fileURL: newFileLocation, completion: { image in
                        completion(.success(image))
                    })
                }
            })
            
        default:
            break
        }
    }
    
    private func loadImageFromURL(fileURL: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.main.async {
            let image = UIImage(contentsOfFile: fileURL.path)
            completion(image)
        }
    }
}
