//
//  EkoFileService.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 28/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

class EkoFileService {
    
    var fileRepository: EkoFileRepository?
    private let cache = EkoImageCache()
    
    func uploadImage(image: UIImage, progressHandler: @escaping (Double) -> Void, completion: @escaping (Result<EkoImageData, Error>) -> Void) {
        
        guard let fileRepository = fileRepository else {
            completion(.failure(EkoError.fileServiceIsNotReady))
            return
        }
        
        fileRepository.uploadImage(image, progress: { progress in
            progressHandler(progress)
        }) { [weak self] (imageData, error) in
            if let data = imageData {
                self?.cache.setImage(key: data.fileId, value: image)
                completion(.success(data))
            } else {
                completion(.failure(EkoError.unknown))
            }
        }
    }
    
    func uploadFile(file: UploadableFile, progressHandler: @escaping (Double) -> Void, completion: @escaping (Result<EkoFileData, Error>) -> Void) {
        
        guard let fileRepository = fileRepository else {
            completion(.failure(EkoError.fileServiceIsNotReady))
            return
        }
        
        fileRepository.uploadFile(file, progress: { fileUploadProgress in
            progressHandler(fileUploadProgress)
        }) { fileData, error in
            if let data = fileData {
                completion(.success(data))
            } else {
                completion(.failure(EkoError.unknown))
            }
        }
    }
    
    func loadImage(with imageId: String, size: EkoMediaSize, completion: ((Result<UIImage, Error>) -> Void)?) {
        
        guard let fileRepository = fileRepository else {
            completion?(.failure(EkoError.fileServiceIsNotReady))
            return
        }
        
        guard !imageId.isEmpty else {
            completion?(.failure(EkoError.unknown))
            return
        }
        
        if let image = cache.getImage(key: imageId) {
            completion?(.success(image))
            return
        }
        
        fileRepository.downloadImage(imageId, size: size) { [weak self] (image, _, error) in
            if let image = image {
                self?.cache.setImage(key: imageId, value: image)
                completion?(.success(image))
            } else if let error = error {
                completion?(.failure(error))
            } else {
                let error = EkoError.unknown
                completion?(.failure(error))
            }
        }
    }
    
    func loadFile(with fileId: String, completion: ((Result<Data, Error>) -> Void)?) {
        guard let fileRepository = fileRepository else {
            completion?(.failure(EkoError.fileServiceIsNotReady))
            return
        }
        
        fileRepository.downloadFile(fileId) { (data, error) in
            if let data = data {
                completion?(.success(data))
            } else if let error = error {
                completion?(.failure(error))
            } else {
                let error = EkoError.unknown
                completion?(.failure(error))
            }
        }
    }
    
}
