//
//  EkoFile.swift
//  UpstraUIKit
//
//  Created by Nishan Niraula on 9/18/20.
//  Copyright © 2020 Upstra. All rights reserved.
//

import Foundation
import EkoChat
import MobileCoreServices

extension EkoFileData {
    
    var fileName: String {
        return attributes["name"] as? String ?? "Unknown"
    }
    
}

enum EkoFileState {
    case local(document: EkoDocument)
    case uploading(progress: Double)
    case uploaded(data: EkoFileData)
    case downloadable(fileData: EkoFileData)
    case error(errorMessage: String)
}

public class EkoFile: Hashable, Equatable {
    let id = UUID().uuidString
    var state: EkoFileState {
        didSet {
            config()
        }
    }
    
    private(set) var fileName: String = "Unknown File"
    var fileExtension: String?
    var fileIcon: UIImage?
    var mimeType: String?
    var fileSize: Int64 = 0
    var fileURL: URL?
    
    // We need this file data for creating file post, for uploading state
    private var dataToUpload: EkoFileData?
    
    init(state: EkoFileState) {
        self.state = state
        config()
    }
    
    private func config() {
        switch state {
        case .local(let document):
            fileName = document.fileName
            fileSize = Int64(document.fileSize)
            fileIcon = getFileIcon(fileExtension: document.fileURL.pathExtension)
            fileURL = document.fileURL
            fileExtension = document.typeIdentifier
        case .uploaded(let fileData), .downloadable(let fileData):
            fileName = fileData.attributes["name"] as? String ?? "Unknown File"
            fileExtension = fileData.attributes["extension"] as? String
            fileIcon = getFileIcon(fileExtension: fileExtension ?? "")
            mimeType = fileData.attributes["mimeType"] as? String
            let size = fileData.attributes["size"] as? Int64 ?? 0
            fileSize = size
        case .error(let errorMessage):
            fileName = errorMessage
            fileSize = 0
            fileIcon = EkoIconSet.File.iconFileDefault
            fileURL = nil
        case .uploading:
            break
        }
    }
    
    func formattedFileSize() -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [ .useBytes, .useKB, .useMB, .useGB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: fileSize)
        return string
    }
    
    func getFileIcon(fileExtension: String) -> UIImage? {
        // For supported extension
        if let availableExtension = EkoFileExtension(rawValue: fileExtension) {
            return availableExtension.icon
        }
        
        // Support for UTType
        let cfExtension = fileExtension as CFString
        
        if let fileUti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, cfExtension, nil)?.takeUnretainedValue() {
            
            if UTTypeConformsTo(fileUti, kUTTypeImage) {
                return EkoIconSet.File.iconFileIMG
            } else if UTTypeConformsTo(fileUti, kUTTypeAudio) {
                return EkoIconSet.File.iconFileAudio
            } else if UTTypeConformsTo(fileUti, kUTTypeMovie) {
                return EkoIconSet.File.iconFileMOV
            } else if UTTypeConformsTo(fileUti, kUTTypeZipArchive) {
                return EkoIconSet.File.iconFileZIP
            } else {
                return EkoIconSet.File.iconFileDefault
            }
            
        } else {
            return EkoIconSet.File.iconFileDefault
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: EkoFile, rhs: EkoFile) -> Bool {
        return lhs.id == rhs.id
    }
    
}
