//
//  EkoPostProtocolHandler.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

final class EkoPostProtocolHandler {
    
    private weak var viewController: EkoViewController?
    private let tableView: UITableView
    
    init(viewController: EkoViewController, tableView: UITableView) {
        self.viewController = viewController
        self.tableView = tableView
    }
    
    private func handleFile(file: EkoFile) {
        guard let viewController = viewController else { return }
        switch file.state {
        case .downloadable(let fileData):
            EkoHUD.show(.loading)
            UpstraUIKitManagerInternal.shared.fileService.loadFile(with: fileData.fileId) { result in
                switch result {
                case .success(let data):
                    EkoHUD.hide {
                        let tempUrl = data.write(withName: fileData.fileName)
                        let documentPicker = UIDocumentPickerViewController(url: tempUrl, in: .exportToService)
                        documentPicker.modalPresentationStyle = .fullScreen
                        viewController.present(documentPicker, animated: true, completion: nil)
                    }
                case .failure:
                    EkoHUD.hide()
                }
            }
        case .error, .local, .uploaded, .uploading:
            break
        }
    }
}

extension EkoPostProtocolHandler: EkoPostDelegate {
    
    func didPerformAction(_ cell: EkoPostProtocol, action: EkoPostAction) {
        guard let post = cell.post else { return }
        guard let viewController = viewController else { return }
        switch action {
        case .tapFile(let file):
            handleFile(file: file)
        case .tapImage(let image):
            let photoViewerVC = EkoPhotoViewerController(referencedView: cell.imageView, imageModel: image)
            photoViewerVC.dataSource = (cell as? EkoPostGalleryTableViewCell)
            photoViewerVC.delegate = (cell as? EkoPostGalleryTableViewCell)
            viewController.present(photoViewerVC, animated: true, completion: nil)
        case .tapViewAll:
            EkoEventHandler.shared.postDidtap(from: viewController, postId: post.id)
        case .tapExpandableLabel:
            EkoEventHandler.shared.postDidtap(from: viewController, postId: post.id)
        case .willExpandExpandableLabel:
            tableView.beginUpdates()
        case .didExpandExpandableLabel:
            guard let section = cell.indexPath?.section else { return }
            // mark post flag to display with expanding
            post.isExpanding = true
            let indexPath = IndexPath(row: 0, section: section)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            tableView.endUpdates()
        case .willCollapseExpandableLabel:
            tableView.beginUpdates()
        case .didCollapseExpandableLabel(let label):
            // mark post flag to display with collapsing
            post.isExpanding = false
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
