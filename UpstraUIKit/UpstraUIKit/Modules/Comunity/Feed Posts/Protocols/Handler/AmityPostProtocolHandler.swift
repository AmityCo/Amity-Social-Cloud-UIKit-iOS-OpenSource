//
//  AmityPostProtocolHandler.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

final class AmityPostProtocolHandler {
    
    private weak var viewController: AmityViewController?
    private let tableView: UITableView
    
    init(viewController: AmityViewController, tableView: UITableView) {
        self.viewController = viewController
        self.tableView = tableView
    }
    
    private func handleFile(file: AmityFile) {
        guard let viewController = viewController else { return }
        switch file.state {
        case .downloadable(let fileData):
            AmityHUD.show(.loading)
            AmityFileService.shared.loadFile(fileURL: fileData.fileURL) { result in
                switch result {
                case .success(let data):
                    AmityHUD.hide {
                        let tempUrl = data.write(withName: fileData.fileName)
                        let documentPicker = UIDocumentPickerViewController(url: tempUrl, in: .exportToService)
                        documentPicker.modalPresentationStyle = .fullScreen
                        viewController.present(documentPicker, animated: true, completion: nil)
                    }
                case .failure:
                    AmityHUD.hide()
                }
            }
        case .error, .local, .uploaded, .uploading:
            break
        }
    }
}

extension AmityPostProtocolHandler: AmityPostDelegate {
    
    func didPerformAction(_ cell: AmityPostProtocol, action: AmityPostAction) {
        guard let post = cell.post else { return }
        guard let viewController = viewController else { return }
        switch action {
        case .tapFile(let file):
            handleFile(file: file)
        case .tapImage(let image):
            let photoViewerVC = AmityPhotoViewerController(referencedView: cell.imageView, imageModel: image)
            photoViewerVC.dataSource = (cell as? AmityPostGalleryTableViewCell)
            photoViewerVC.delegate = (cell as? AmityPostGalleryTableViewCell)
            viewController.present(photoViewerVC, animated: true, completion: nil)
        case .tapViewAll:
            AmityEventHandler.shared.postDidtap(from: viewController, postId: post.postId)
        case .tapExpandableLabel:
            AmityEventHandler.shared.postDidtap(from: viewController, postId: post.postId)
        case .willExpandExpandableLabel:
            tableView.beginUpdates()
        case .didExpandExpandableLabel:
            guard let section = cell.indexPath?.section else { return }
            // mark post flag to display with expanding
            post.appearance.isExpanding = true
            let indexPath = IndexPath(row: 0, section: section)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            tableView.endUpdates()
        case .willCollapseExpandableLabel:
            tableView.beginUpdates()
        case .didCollapseExpandableLabel(let label):
            // mark post flag to display with collapsing
            post.appearance.isExpanding = false
            let point = label.convert(CGPoint.zero, to: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            tableView.endUpdates()
        }
    }
    
}
