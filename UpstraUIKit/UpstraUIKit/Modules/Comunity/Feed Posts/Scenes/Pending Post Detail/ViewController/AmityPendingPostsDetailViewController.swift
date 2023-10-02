//
//  AmityPendingPostsDetailViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 12/5/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

final class AmityPendingPostsDetailViewController: AmityViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: AmityPostTableView!
    
    // MARK: - Properties
    private var screenViewModel: AmityPendingPostsDetailScreenViewModelType!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
    }
    
    static func make(communityId: String, postId: String) -> AmityPendingPostsDetailViewController {
        let viewModel = AmityPendingPostsDetailScreenViewModel(communityId: communityId, postId: postId)
        let vc = AmityPendingPostsDetailViewController(nibName: AmityPendingPostsDetailViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.getMemberStatus()
    }
    
    // MARK: - Setup views
    private func setupTableView() {
        tableView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerCustomCell()
        tableView.registerPostCell()
        tableView.register(cell: AmityPendingPostsActionTableViewCell.self)
        tableView.postDataSource = self
        tableView.postDelegate = self
    }
}

extension AmityPendingPostsDetailViewController: AmityPostTableViewDelegate {
   
}

extension AmityPendingPostsDetailViewController: AmityPostTableViewDataSource {
   
    func numberOfSections(in tableView: AmityPostTableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: AmityPostTableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfPostComponents()
    }

    func tableView(_ tableView: AmityPostTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let singleComponent = screenViewModel.dataSource.postComponents(at: indexPath) else { return UITableViewCell() }
        
        var cell: UITableViewCell
        if let clientComponent = tableView.feedDataSource?.getUIComponentForPost(post: singleComponent._composable.post, at: indexPath.section) {
            cell = clientComponent.getComponentCell(tableView, at: indexPath)
        } else {
            cell = singleComponent.getComponentCell(tableView, at: indexPath)
        }
        (cell as? AmityPostHeaderProtocol)?.delegate = self
        (cell as? AmityPostProtocol)?.delegate = self
        (cell as? AmityPendingPostsActionCellProtocol)?.delegate = self
        return cell
    }
    
}

extension AmityPendingPostsDetailViewController: AmityPendingPostsDetailScreenViewModelDelegate {
    
    func screenViewModel(_ viewModel: AmityPendingPostsDetailScreenViewModelType, didGetMemberStatusCommunity status: AmityMemberStatusCommunity) {
        switch status {
        case .member, .admin:
            viewModel.action.getPost()
        case .guest:
            break
        }
        tableView.reloadData()
    }
    
    func screenViewModelDidGetPost(_ viewModel: AmityPendingPostsDetailScreenViewModelType) {
        tableView.reloadData()
    }
    
    func screenViewModelDidDeletePostFail(title: String, message: String) {
        AmityAlertController.present(title: title,
                                     message: message,
                                     actions: [.ok(style: .default, handler: nil)],
                                     from: self, completion: nil)
    }
    
    func screenViewModelDidDeletePostFinish() {
        navigationController?.popViewController(animated: true)
    }
    
    func screenViewModelDidApproveOrDeclinePost() {
        navigationController?.popViewController(animated: true)
    }
}

extension AmityPendingPostsDetailViewController: AmityPostHeaderDelegate {
    
    func didPerformAction(_ cell: AmityPostHeaderProtocol, action: AmityPostHeaderAction) {
        switch action {
        case .tapOption:
            let bottomSheet = BottomSheetViewController()
            let contentView = ItemOptionView<TextItemOption>()
            bottomSheet.sheetContentView = contentView
            bottomSheet.isTitleHidden = true
            bottomSheet.modalPresentationStyle = .overFullScreen
            
            let deleteOption = TextItemOption(title: AmityLocalizedStringSet.PendingPosts.alertDeleteTitle.localizedString) { [weak self] in
                let alert = UIAlertController(title: AmityLocalizedStringSet.PendingPosts.alertDeleteTitle.localizedString,
                                              message: AmityLocalizedStringSet.PendingPosts.alertDeleteDesc.localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.delete.localizedString, style: .destructive, handler: { _ in
                    self?.screenViewModel.action.deletePost()
                }))
                self?.present(alert, animated: true, completion: nil)
            }
            contentView.configure(items: [deleteOption], selectedItem: nil)
            present(bottomSheet, animated: false, completion: nil)
        default:
            break
        }
    }
    
}

extension AmityPendingPostsDetailViewController: AmityPostDelegate {
    
    private func presentPhotoViewer(media: AmityMedia, from cell: AmityPostGalleryTableViewCell) {
        let photoViewerVC = AmityPhotoViewerController(referencedView: cell.imageView, media: media)
        photoViewerVC.dataSource = cell
        photoViewerVC.delegate = cell
        present(photoViewerVC, animated: true, completion: nil)
    }
    
    func didPerformAction(_ cell: AmityPostProtocol, action: AmityPostAction) {
        switch action {
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
        case .tapFile(let file):
            switch file.state {
            case .downloadable(let fileData):
                AmityHUD.show(.loading)
                AmityUIKitManagerInternal.shared.fileService.loadFile(fileURL: fileData.fileURL) { [weak self] result in
                    switch result {
                    case .success(let data):
                        AmityHUD.hide {
                            let tempUrl = data.write(withName: fileData.fileName)
                            let documentPicker = UIDocumentPickerViewController(url: tempUrl, in: .exportToService)
                            documentPicker.modalPresentationStyle = .fullScreen
                            self?.present(documentPicker, animated: true, completion: nil)
                        }
                    case .failure:
                        AmityHUD.hide()
                    }
                }
            case .error, .local, .uploaded, .uploading:
                break
            }
        default:
            break

        }
    }
}

extension AmityPendingPostsDetailViewController: AmityPendingPostsActionCellDelegate {
    
    func performAction(_ cell: AmityPendingPostsActionCellProtocol, action: AmityPendingPostsAction) {
        switch action {
        case .tapAccept:
            screenViewModel.action.approvePost()
        case .tapDecline:
            screenViewModel.action.declinePost()
        }
    }
    
}
