//
//  EkoFileCache.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 2/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit

final class EkoFileCache {
    private init() { }
    static let shared = EkoFileCache()
    private let fileManager = FileManager.default
    private static let directory = "com.upstra.upstrauikit"
    
    enum Directory: String {
        case audioDireectory, imageDirectory
        var rawValue: String {
            switch self {
            case .audioDireectory:
                return directory + ".audio"
            case .imageDirectory:
                return directory + ".image"
            }
        }
    }
    
    func documentDireectory(for directory: Directory) -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let path = paths[0]
        let url = URL(string: path)!
        let urlPath = url.appendingPathComponent(directory.rawValue)
        
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
        case .audioDireectory:
            if fileExists(file: file) {
                return URL(fileURLWithPath: file.absoluteString)
            }
            return nil
        }
    }
    
    private func fileExists(file: URL) -> Bool {
        return fileManager.fileExists(atPath: file.absoluteString)
    }
    
    func clearCache() {
        let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents {
                do {
                    try fileManager.removeItem(at: file)
                } catch {
                    Log.add(error.localizedDescription)
                }
            }
        } catch {
            Log.add(error.localizedDescription)
        }
    }
}
