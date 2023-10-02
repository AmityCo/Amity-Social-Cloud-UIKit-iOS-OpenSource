//
//  AmityFileService.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 28/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

class AmityFileService {
    
    var fileRepository: AmityFileRepository?
    
    // A path mapper for binding image path with a local path
    // Example:
    //    [ "https://blahblah.com/4336ae5d38a56b504ddf/download_large": "/Caches/1621310039.941842/Screen%20Shot%202564-05-17%20at%2012.08.29.png",
    //      "https://blahblah.com/4336ae5d38a56b504ddf/download_small": "/Caches/1523310040.942232/Screen%20Shot%202564-05-17%20at%2012.08.29.png" ]
    private var pathCache: [String: String] = [:]
    
    // Create a key for identifying image size
    //
    // Example: origin path is https://blahblah.com/4336ae5d38a56b504ddf/download and after concantinated with size key
    // - large: https://blahblah.com/4336ae5d38a56b504ddf/download_large
    // - small: https://blahblah.com/4336ae5d38a56b504ddf/download_small
    private func key(forImageURL imageURL: String, size: AmityMediaSize) -> String {
        return "\(imageURL)_\(size.description)"
    }
    
    func uploadImage(image: UIImage, progressHandler: @escaping (Double) -> Void, completion: @escaping (Result<AmityImageData, Error>) -> Void) {
        
        guard let fileRepository = fileRepository else {
            completion(.failure(AmityError.fileServiceIsNotReady))
            return
        }
        
        fileRepository.uploadImage(image, progress: { progress in
            progressHandler(progress)
        }) { (imageData, error) in
            if let data = imageData {
                completion(.success(data))
            } else {
                completion(.failure(AmityError.unknown))
            }
        }
        
    }
    
    func uploadFile(file: AmityUploadableFile, progressHandler: @escaping (Double) -> Void, completion: @escaping (Result<AmityFileData, Error>) -> Void) {
        
        guard let fileRepository = fileRepository else {
            completion(.failure(AmityError.fileServiceIsNotReady))
            return
        }
        
        fileRepository.uploadFile(file, progress: { fileUploadProgress in
            progressHandler(fileUploadProgress)
        }) { fileData, error in
            if let data = fileData {
                completion(.success(data))
            } else {
                completion(.failure(AmityError.unknown))
            }
        }
        
    }
    
    func uploadVideo(url: URL,
                     progressHandler: @escaping (Double) -> Void,
                     completion: @escaping (Result<AmityVideoData, Error>) -> Void) {
        
        guard let fileRepository = fileRepository else {
            completion(.failure(AmityError.fileServiceIsNotReady))
            return
        }
        
        fileRepository.uploadVideo(with: url, progress: progressHandler) { videoData, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = videoData {
                completion(.success(data))
                return
            }
            completion(.failure(AmityError.unknown))
        }
        
    }
    
    func loadImage(imageURL: String, size: AmityMediaSize, optimisticLoad: Bool = false, completion: ((Result<UIImage, Error>) -> Void)?) {
        
        guard !imageURL.isEmpty else {
            completion?(.failure(AmityError.unknown))
            return
        }
        
        let imageCacheKey = key(forImageURL: imageURL, size: size)
        
        if let path = pathCache[imageCacheKey],
           let image = UIImage(contentsOfFile: path) {
            completion?(.success(image))
            return
        } else if optimisticLoad {
            // if a desire image size is not there, return largest size possible of the image.
            let largeImageKey = key(forImageURL: imageURL, size: .large)
            let mediumImageKey = key(forImageURL: imageURL, size: .medium)
            let smallImageKey = key(forImageURL: imageURL, size: .small)
            
            if let path = pathCache[largeImageKey], let image = UIImage(contentsOfFile: path) {
                completion?(.success(image))
            } else if let path = pathCache[mediumImageKey], let image = UIImage(contentsOfFile: path) {
                completion?(.success(image))
            } else if let path = pathCache[smallImageKey], let image = UIImage(contentsOfFile: path) {
                completion?(.success(image))
            }
        }
        
        guard let fileRepository = fileRepository else {
            completion?(.failure(AmityError.fileServiceIsNotReady))
            return
        }
        
        fileRepository.downloadImage(fromURL: imageURL, size: size) { [weak self] (url, error) in
            if let imagePath = url?.path, // a local path returned from sdk
               let image = UIImage(contentsOfFile: imagePath) {
                self?.pathCache[imageCacheKey] = imagePath
                completion?(.success(image))
            } else if let error = error {
                completion?(.failure(error))
            } else {
                let error = AmityError.unknown
                completion?(.failure(error))
            }
        }
        
    }
    
    func loadFile(fileURL: String, completion: ((Result<Data, Error>) -> Void)?) {
        
        guard let fileRepository = fileRepository else {
            completion?(.failure(AmityError.fileServiceIsNotReady))
            return
        }
        
        fileRepository.downloadFileAsData(fromURL: fileURL) { (data, error) in
            if let data = data {
                completion?(.success(data))
            } else if let error = error {
                completion?(.failure(error))
            } else {
                let error = AmityError.unknown
                completion?(.failure(error))
            }
        }
        
    }
    
}
