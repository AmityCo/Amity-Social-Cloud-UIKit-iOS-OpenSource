//
//  AmityFileCache.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 2/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit

// Note: Every cachable file should be under this directory .../Caches/com.amity.amityuikit/...
final class AmityFileCache {
    
    private init() { }
    
    static let shared = AmityFileCache()
    
    private let fileManager = FileManager.default
    private let amityCacheFolder = "com.amity.amityuikit"
    
    enum Directory: String {
        case audioDirectory, imageDirectory
        var rawValue: String {
            switch self {
            case .audioDirectory:
                return "audio"
            case .imageDirectory:
                return "image"
            }
        }
    }
    
    // Note:
    // This generates directory ../Caches/com.amity.amityuikit/<audio/image>/
    //
    private func documentDireectory(for directory: Directory) -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let path = paths[0]
        let url = URL(string: path)!
        let urlPath = url.appendingPathComponent("\(amityCacheFolder)/\(directory.rawValue)")
        
        if !fileManager.fileExists(atPath: urlPath.absoluteString) {
            do {
                try fileManager.createDirectory(atPath: urlPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                Log.add(error.localizedDescription)
            }
        }
        return urlPath
    }
    
    func getFileURL(for directory: Directory, fileName: String) -> URL {
        return documentDireectory(for: directory).appendingPathComponent(fileName)
    }
    
    func deleteFile(for directory: Directory, fileName: String) {
        let path = getFileURL(for: directory, fileName: fileName)
        do {
            try fileManager.removeItem(atPath: path.absoluteString)
        } catch {
            Log.add(error.localizedDescription)
        }
    }
    
    func updateFile(for directory: Directory, originFilename: String, destinationFilename: String) {
        let originPath = getFileURL(for: directory, fileName: originFilename)
        let destinationPath = getFileURL(for: directory, fileName: destinationFilename)
        
        do {
            try fileManager.moveItem(atPath: originPath.absoluteString, toPath: destinationPath.absoluteString)
        } catch {
            Log.add(error.localizedDescription)
        }
    }
    
    func convertToData(for directory: Directory, fileName: String) -> Data? {
        let url = getFileURL(for: directory, fileName: fileName)
        let newUrl = URL(fileURLWithPath: url.absoluteString)
        do {
            return try Data(contentsOf: newUrl)
        } catch {
            Log.add(error.localizedDescription)
        }
        return nil
    }
    
    func cacheData(for directory: Directory, data: Data, fileName: String, completion: (URL) -> Void) {
        let path = getFileURL(for: directory, fileName: fileName)
        let url = URL(fileURLWithPath: path.absoluteString)
        do {
            try data.write(to: url)
            completion(url)
        } catch {
            Log.add(error.localizedDescription)
        }
    }
    
    func getCacheURL(for directory: Directory, fileName: String) -> URL? {
        let file = getFileURL(for: directory, fileName: fileName)
        switch directory {
        case .imageDirectory:
            if fileExists(file: file) {
                return file
            }
            return nil
        case .audioDirectory:
            if fileExists(file: file) {
                let audioCacheUrl = URL(fileURLWithPath: file.absoluteString)
                return audioCacheUrl
            }
            return nil
        }
    }
    
    private func fileExists(file: URL) -> Bool {
        return fileManager.fileExists(atPath: file.absoluteString)
    }
    
    func clearCache() {
        // We only remove everything related to UIKit from the cache folder i.e ../Caches/com.amity.amityuikit/...
        do {
            let defaultCacheDirectory = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let uikitDirectory = defaultCacheDirectory.appendingPathComponent(amityCacheFolder, isDirectory: true)
            
            let directoryContents = try fileManager.contentsOfDirectory(at: uikitDirectory, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents {
                
                do {
                    try fileManager.removeItem(at: file)
                } catch {
                    Log.add("Error when deleting file from cache directory")
                }
            }
        } catch {
            Log.add(error.localizedDescription)
        }
    }
    
    // MARK: Image Cache
    
    /// Moves the downloaded file to our cache directory. Id passed is used to
    /// create final directory.
    func cacheDownloadedFile(url: URL, id: String) {
        Log.add("Source URL: \(url)")
        
        do {
            let destination = try generateDestinationURLForFile(withId: id)
            try moveDownloadedFile(from: url, to: destination)
        } catch let moveError {
            Log.add("File cannot be cached in destination \(moveError)")
        }
    }
    
    /// Returns url for the downloaded file from cache. Id passed is used to
    /// generate the cached directory
    func getCachedDownloadedFile(id: String) -> URL? {
        
        do {
            let destination = try generateDestinationURLForFile(withId: id)
            
            if fileManager.fileExists(atPath: destination.path) {
                return destination
            } else {
                return nil
            }
            
        } catch let fetchError {
            Log.add("Error while fetching file from destination \(fetchError)")
            return nil
        }
    }
}

extension AmityFileCache {
    
    // Moves file from origin to destination. If file already exists at destination
    // it removes that file first.
    private func moveDownloadedFile(from origin: URL, to destination: URL) throws {
        let fileManager = FileManager.default
        
        do {
            // Remove the file if it already exists
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            
            // Then we try to create the directory for this new file
            try fileManager.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            
            // Then we move the file to this new directory
            try fileManager.moveItem(at: origin, to: destination)
        } catch let error {
            throw error
        }
    }
    
    // Generates the destination URL for file based on its id
    // .../Caches/com.amity.amityuikit/<id>/
    func generateDestinationURLForFile(withId id: String) throws -> URL {
        do {
            let cacheDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileDirectory = cacheDirectory.appendingPathComponent("\(amityCacheFolder)/\(id)", isDirectory: true)
            return fileDirectory
        } catch let error {
            throw error
        }
    }
    
}
