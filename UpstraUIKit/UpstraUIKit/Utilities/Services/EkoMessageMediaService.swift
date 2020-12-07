//
//  EkoMessageMediaService.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 2/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoMessageMediaService {
    static let shared = EkoMessageMediaService()
    weak var repository: EkoMessageRepository?
    
    func download(for message: EkoMessage, progress: ((() -> Void)?) = nil, completion: @escaping (Result<URL, Error>) -> Void) {
        
        switch message.messageType {
        case .audio:
            let fileName = message.messageId + ".m4a"
            if let url = EkoFileCache.shared.getCacheURL(for: .audioDireectory, fileName: fileName) {
                completion(.success(url))
            } else {
                progress?()
                repository?.downloadFile(for: message, completion: { (data, error) in
                    guard error == nil, let data = data else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    EkoFileCache.shared.cacheData(for: .audioDireectory, data: data, fileName: fileName, completion: { url in
                        completion(.success(url))
                    })
                })
            }
        case .image:
            let fileName = message.messageId + ".png"
            if let url = EkoFileCache.shared.getCacheURL(for: .imageDirectory, fileName: fileName) {
                completion(.success(url))
            } else {
                progress?()
                repository?.downloadImage(for: message, size: .medium, completion: { (data, error) in
                    guard error == nil, let data = data else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    EkoFileCache.shared.cacheData(for: .imageDirectory, data: data, fileName: fileName, completion: { url in
                        completion(.success(url))
                    })
                })
            }
        default:
            break
        }
    }
}
