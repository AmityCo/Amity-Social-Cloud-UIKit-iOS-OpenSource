//
//  AmityDocumentPickerViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 27/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol AmityFilePickerDelegate: AnyObject {
    func didPickFiles(files: [AmityFile])
}

public class AmityDocument: UIDocument {

    var data: Data?
    var fileSize: Int = 0
    var typeIdentifier: String = ""

    public override func contents(forType typeName: String) throws -> Any {
        guard let data = data else { return Data() }
        return try NSKeyedArchiver.archivedData(withRootObject:data,
                                                requiringSecureCoding: true)
    }

    public override func load(fromContents contents: Any, ofType typeName:
        String?) throws {
        guard let data = contents as? Data else { return }
        self.data = data
    }

    public override init(fileURL url: URL) {
        super.init(fileURL: url)
        let resources = try? url.resourceValues(forKeys:[.fileSizeKey, .typeIdentifierKey])
        fileSize = resources?.fileSize ?? 0
        typeIdentifier = resources?.typeIdentifier ?? ""
    }

    var fileName: String {
        return fileURL.lastPathComponent
    }

}

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    }
}

open class AmityFilePicker: NSObject {
    private var pickerController: UIDocumentPickerViewController?
    private weak var presentationController: UIViewController?
    private weak var delegate: AmityFilePickerDelegate?
    private var folderURL: URL?
    private var files = [AmityFile]()
    
    enum Constant {
        static let numberOfIFiles: Int = 10
        static let maximumSizeOfIFiles: Int = 1_000_000_000 // 1GB
    }
    
    init(presentationController: UIViewController, delegate: AmityFilePickerDelegate) {
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    public func present(from sourceView: UIView, files: [AmityFile]) {
        pickerController = UIDocumentPickerViewController(documentTypes: [kUTTypeContent, kUTTypeArchive] as [String], in: .import)
        pickerController?.modalPresentationStyle = .overFullScreen
        pickerController?.allowsMultipleSelection = true
        pickerController?.delegate = self
        self.files = files
        presentationController?.present(pickerController!, animated: true)
        
    }
    
    public func present(from sourceView: UIView) {
        pickerController = UIDocumentPickerViewController(documentTypes: [kUTTypeContent, kUTTypeArchive] as [String], in: .open)
        pickerController?.modalPresentationStyle = .overFullScreen
        pickerController?.delegate = self
        presentationController?.present(pickerController!, animated: true)
        
    }
    
}

extension AmityFilePicker: UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let fileSizes = urls.compactMap { try? $0.resourceValues(forKeys:[.fileSizeKey]).fileSize }
        
        #warning("Localized")
        guard fileSizes.filter({ $0 > Constant.maximumSizeOfIFiles}).isEmpty else {
            let alertController = UIAlertController(title: "Unable to attached the file", message: "The selected file is larger than 1GB. Plese select a new file.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.ok.localizedString, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            presentationController?.present(alertController, animated: true, completion: nil)
            return
        }
        
        let sumNumberOfItems = files.count + urls.count
        guard sumNumberOfItems <= Constant.numberOfIFiles else {
            #warning("Localized")
            let alertController = UIAlertController(title: "Maximum number of files exceeded", message: "Maximum number of files that can be uploaded is \(Constant.numberOfIFiles). The rest files will be discarded.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.ok.localizedString, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            presentationController?.present(alertController, animated: true, completion: nil)
            return
        }
        
        for url in urls {
            documentFromURL(pickedURL: url)
        }
        
        delegate?.didPickFiles(files: files)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // User cancelled
    }
    
    private func documentFromURL(pickedURL: URL) {
        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
            
            let document = AmityDocument(fileURL: folderURL)
            let file = AmityFile(state: .local(document: document))
            files.append(file)
        }
        
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
        
        if shouldStopAccessing {
            pickedURL.stopAccessingSecurityScopedResource()
        }
    }
    
}

extension AmityFilePicker: UINavigationControllerDelegate {}
