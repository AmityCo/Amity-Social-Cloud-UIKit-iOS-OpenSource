//
//  AmityPostProtocolHandler.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmitySDK

protocol AmityPostProtocolHandlerDelegate: AnyObject {
    func amityPostProtocolHandlerDidTapSubmit(_ cell: AmityPostProtocol)
}

final class AmityPostProtocolHandler {
    
    weak var delegate: AmityPostProtocolHandlerDelegate?
    weak var viewController: AmityViewController?
    weak var tableView: UITableView?
    
    private func handleFile(file: AmityFile) {
        guard let viewController = viewController else { return }
        switch file.state {
        case .downloadable(let fileData):
            AmityHUD.show(.loading)
            AmityUIKitManagerInternal.shared.fileService.loadFile(fileURL: fileData.fileURL) { result in
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
    
    private func presentPhotoViewer(media: AmityMedia, from cell: AmityPostGalleryTableViewCell) {
        let photoViewerVC = AmityPhotoViewerController(referencedView: cell.imageView, media: media)
        photoViewerVC.dataSource = cell
        photoViewerVC.delegate = cell
        viewController?.present(photoViewerVC, animated: true, completion: nil)
    }
    
}

extension AmityPostProtocolHandler: AmityPostDelegate {
    
    func didPerformAction(_ cell: AmityPostProtocol, action: AmityPostAction) {
        guard let post = cell.post else { return }
        switch action {
        case .tapFile(let file):
            handleFile(file: file)
        case .tapMedia(let media):
            guard let cell = cell as? AmityPostGalleryTableViewCell else {
                assertionFailure("Unsupported cell type")
                return
            }
            switch media.type {
            case .image, .video:
                presentPhotoViewer(media: media, from: cell)
            }
        case .tapMediaInside(let media, let photoViewer):
            switch media.type {
            case .video:
                if let videoInfo = media.video {
                    if let fileUrl = videoInfo.getVideo(resolution: .original), let url = URL(string: fileUrl) {
                        photoViewer.presentVideoPlayer(at: url)
                    } else if let url = URL(string: videoInfo.fileURL ) {
                        photoViewer.presentVideoPlayer(at: url)
                    }
                }
            case .image:
                break
            }
        case .tapViewAll, .tapExpandableLabel:
            if let viewController = viewController {
                AmityEventHandler.shared.postDidtap(from: viewController, postId: post.postId)
            }
        case .willExpandExpandableLabel:
            tableView?.beginUpdates()
        case .didExpandExpandableLabel:
            if let section = cell.indexPath?.section {
                // mark post flag to display with expanding
                post.appearance.isExpanding = true
                let indexPath = IndexPath(row: 0, section: section)
                DispatchQueue.main.async { [weak self] in
                    self?.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            tableView?.endUpdates()
        case .willCollapseExpandableLabel:
            tableView?.beginUpdates()
        case .didCollapseExpandableLabel(let label):
            // mark post flag to display with collapsing
            post.appearance.isExpanding = false
            let point = label.convert(CGPoint.zero, to: tableView)
            if let indexPath = tableView?.indexPathForRow(at: point) as IndexPath? {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            tableView?.endUpdates()
        case .submit:
            delegate?.amityPostProtocolHandlerDidTapSubmit(cell)

        case .tapLiveStream(let stream):
            switch stream.status {
            case .recorded:
                AmityEventHandler.shared.openRecordedLiveStreamPlayer(
                    from: viewController!,
                    postId: post.postId,
                    stream: stream
                )
            default:
                AmityEventHandler.shared.openLiveStreamPlayer(
                    from: viewController!,
                    postId: post.postId,
                    streamId: stream.streamId
                )
            }
        case .tapOnMentionWithUserId(let userId):
            AmityEventHandler.shared.userDidTap(from: viewController!, userId: userId)
        }
        
    }
    
}
