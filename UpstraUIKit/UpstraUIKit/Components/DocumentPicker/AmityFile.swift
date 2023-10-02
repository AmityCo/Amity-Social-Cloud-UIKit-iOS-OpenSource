//
//  AmityFile.swift
//  AmityUIKit
//
//  Created by Nishan Niraula on 9/18/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import UIKit
import AmitySDK
import MobileCoreServices

extension AmityFileData {
    
    var fileName: String {
        return attributes["name"] as? String ?? "Unknown"
    }
    
}

enum AmityFileState {
    case local(document: AmityDocument)
    case uploading(progress: Double)
    case uploaded(data: AmityFileData)
    case downloadable(fileData: AmityFileData)
    case error(errorMessage: String)
}

public class AmityFile: Hashable, Equatable {
    let id = UUID().uuidString
    var state: AmityFileState {
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
    private var dataToUpload: AmityFileData?
    
    init(state: AmityFileState) {
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
            fileIcon = AmityIconSet.File.iconFileDefault
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
        if let availableExtension = AmityFileExtension(rawValue: fileExtension) {
            return availableExtension.icon
        }
        
        // Support for UTType
        let cfExtension = fileExtension as CFString
        
        if let fileUti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, cfExtension, nil)?.takeUnretainedValue() {
            
            if UTTypeConformsTo(fileUti, kUTTypeImage) {
                return AmityIconSet.File.iconFileIMG
            } else if UTTypeConformsTo(fileUti, kUTTypeAudio) {
                return AmityIconSet.File.iconFileAudio
            } else if UTTypeConformsTo(fileUti, kUTTypeMovie) {
                return AmityIconSet.File.iconFileMOV
            } else if UTTypeConformsTo(fileUti, kUTTypeZipArchive) {
                return AmityIconSet.File.iconFileZIP
            } else {
                return AmityIconSet.File.iconFileDefault
            }
            
        } else {
            return AmityIconSet.File.iconFileDefault
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: AmityFile, rhs: AmityFile) -> Bool {
        return lhs.id == rhs.id
    }
    
}
