//
//  AmityMediaConverter.swift
//  AmityUIKit
//
//  Created by Hamlet Kosakyan on 7/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import Foundation
import ImageIO
import MobileCoreServices
import UIKit

class AmityMediaConverter {
    static func convertImage(fromPath path: String) -> URL? {
        let options = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceSubsampleFactor: 2
        ] as CFDictionary
        
        guard let url = URL(string: path), let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil), let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options), let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any] else { return nil }

        let uuid = UUID().uuidString
        let suffix = "\(uuid).png"
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return nil }
        
        directory.appendingPathComponent(suffix)
        guard let absoluteString = directory.absoluteString, let destinationURL = URL(string: "\(absoluteString)\(suffix)"), let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else { return nil }
        
        CGImageDestinationAddImage(destination, cgImage, options)
        if CGImageDestinationFinalize(destination) {
            return destinationURL
        }

        return nil
    }
}

import AVFoundation

extension AmityMediaConverter {
    static func convertVideo(asset: AVAsset, completion: @escaping (_ responseURL : URL?) -> Void) {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
        let uuid = UUID().uuidString
        let suffix = "\(uuid).mp4"
        
        guard let absoluteString = directory.absoluteString, let destinationURL = URL(string: "\(absoluteString)\(suffix)") else { return }
        
        let preset = AVAssetExportPresetPassthrough
        let outFileType = AVFileType.mp4
        
        AVAssetExportSession.determineCompatibility(ofExportPreset: preset, with: asset, outputFileType: outFileType) { isCompatible in
            guard isCompatible else { return }
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: preset) else { return }
            exportSession.outputFileType = outFileType
            exportSession.outputURL = destinationURL
            exportSession.exportAsynchronously {
                completion(destinationURL)
            }
        }
    }
}
