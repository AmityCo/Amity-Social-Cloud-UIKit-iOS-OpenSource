//
//  AmityFileExtension.swift
//  AmityUIKit
//
//  Created by Nishan Niraula on 9/18/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import Foundation
import UIKit

enum AmityFileExtension: String {
    
    case doc
    case docx
    case xls
    case xlsx
    case ppt
    case pptx
    case csv
    case txt
    case pdf
    case html
    case mpeg
    case avi
    case mp3
    case mp4
    
    // Extensions for files in Post
    var uti: String {
        switch self {
        case .doc:
            return "com.microsoft.word.doc"
        case .docx:
            return "org.openxmlformats.wordprocessingml.document"
        case .xls:
            return "com.microsoft.excel.xls"
        case .xlsx:
            return "org.openxmlformats.spreadsheetml.sheet"
        case .ppt:
            return "com.microsoft.powerpoint.​ppt"
        case .pptx:
            return "org.openxmlformats.presentationml.presentation"
        case .csv:
            return "public.comma-separated-values-text"
        case .txt:
            return "public.plain-text" // kUTTypePlainText
        case .pdf:
            return "com.adobe.pdf" // kUTTypePDF
        case .html:
            return "public.html" // kUTTypeHTML
        case .mpeg:
            return "public.mpeg" // kUTTypeMPEG
        case .avi:
            return "public.avi" // kUTTypeAVIMovie
        case .mp3:
            return "public.mp3" // kUTTypeMP3
        case .mp4:
            return "public.mpeg-4" // kUTTypeMPEG4
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .doc, .docx:
            return AmityIconSet.File.iconFileDoc
        case .xls, .xlsx:
            return AmityIconSet.File.iconFileXLS
        case .ppt, .pptx:
            return AmityIconSet.File.iconFilePPT
        case .csv:
            return AmityIconSet.File.iconFileCSV
        case .txt:
            return AmityIconSet.File.iconFileTXT
        case .pdf:
            return AmityIconSet.File.iconFilePDF
        case .html:
            return AmityIconSet.File.iconFileHTML
        case .mpeg:
            return AmityIconSet.File.iconFileMPEG
        case .avi:
            return AmityIconSet.File.iconFileAVI
        case .mp3:
            return AmityIconSet.File.iconFileMP3
        case .mp4:
            return AmityIconSet.File.iconFileMP4
        }
    }
}
