//
//  EkoFeedController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 25/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

class EkoFeedController: NSObject {
    
    // MARK: - Variables
    
    private weak var presenterViewController: UIViewController?
    private weak var tableView: UITableView?
    private var screenViewModel: EkoGlobalFeedScreenViewModelType
    private var expandedIds: [String] = []
    
    var numberOfItems: Int {
        return screenViewModel.dataSource.numberOfItems()
    }
    
    var dataDidChangeHandler: (() -> Void)?
    var emptyCellConfiguration: ((UITableViewCell) -> Void)?
    
    // MARK: - Initializer
    
    init(feedMode: FeedMode) {
        screenViewModel = EkoGlobalFeedScreenViewModel(feedMode: feedMode)
        super.init()
        screenViewModel.delegate = self
    }
    
    func setup(tableView: UITableView, viewController: UIViewController) {
        self.presenterViewController = viewController
        self.tableView = tableView
        if tableView.dataSource == nil {
            tableView.dataSource = self
        }
        if tableView.delegate == nil {
            tableView.delegate = self
        }
        tableView.register(EkoEmptyStateHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: EkoEmptyStateHeaderFooterView.identifier)
        tableView.register(EkoPostFeedTableViewCell.nib, forCellReuseIdentifier: EkoPostFeedTableViewCell.identifier)
    }
    
    // MARK: - Navigation
    
    func presentCreatePost() {
        let vc = EkoPostToViewController()
        vc.delegate = self
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .fullScreen
        presenterViewController?.present(nvc, animated: true, completion: nil)
    }
    
    // MARK: - Private functions
    
    private func reloadAndScroll() {
        tableView?.reloadData()
        tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
}

extension EkoFeedController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = screenViewModel.dataSource.item(at: indexPath) else {
            fatalError("Item not found")
        }
        let cell: EkoPostFeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(item: item, shouldContentExpand: expandedIds.contains(item.id), isFirstCell: indexPath.row == 0)
        cell.contentLabel.delegate = self
        cell.actionDelegate = self
        if tableView.isBottomReached {
            screenViewModel.dataSource.loadNext()
        }
        return cell
    }
    
}

extension EkoFeedController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bottomView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EkoEmptyStateHeaderFooterView.identifier)
        return bottomView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return screenViewModel.numberOfItems() > 0 ? 0 : tableView.frame.height
    }
    
}

extension EkoFeedController: EkoPostViewControllerDelegate {
    
    public func postViewController(_ viewController: UIViewController, didCreatePost post: EkoPostModel) {
        reloadAndScroll()
    }
    
    public func postViewController(_ viewController: UIViewController, didUpdatePost post: EkoPostModel) {
        reloadAndScroll()
    }
}

extension EkoFeedController: EkoPostToViewControllerDelegate {
    
    func postToViewController(_ viewController: EkoPostToViewController, didCreatePost post: EkoPostModel) {
        reloadAndScroll()
    }
    
    func postToViewController(_ viewController: EkoPostToViewController, didUpdatePost post: EkoPostModel) {
        reloadAndScroll()
    }
}

extension EkoFeedController: EkoExpandableLabelDelegate {
    
    private func navigateToPostDetail(with post: EkoPostModel) {
        let detailView = EkoPostDetailViewController.make(postId: post.id)
        presenterViewController?.navigationController?.pushViewController(detailView, animated: true)
    }
    
    public func expandableLabeldidTap(_ label: EkoExpandableLabel) {
        guard let cell = label.superview(of: EkoPostFeedTableViewCell.self),
            let indexPath = tableView?.indexPath(for: cell),
            let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        navigateToPostDetail(with: item)
    }
    
    public func willExpandLabel(_ label: EkoExpandableLabel) {
        tableView?.beginUpdates()
    }
    
    public func didExpandLabel(_ label: EkoExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView?.indexPathForRow(at: point) as IndexPath? {
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView?.endUpdates()
    }
    
    public func willCollapseLabel(_ label: EkoExpandableLabel) {
        tableView?.beginUpdates()
    }
    
    public func didCollapseLabel(_ label: EkoExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView?.indexPathForRow(at: point) as IndexPath? {
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView?.endUpdates()
    }
    
}

extension EkoFeedController: EkoPostFeedTableViewCellDelegate {
    
    func postTableViewCellNeedLayout(_ cell: EkoPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        tableView?.beginUpdates()
        tableView?.reloadRows(at: [indexPath], with: .automatic)
        tableView?.endUpdates()
    }
    
    func postTableViewCellDidTapAvatar(_ cell: EkoPostFeedTableViewCell, userId: String) {
        let vc = EkoUserProfileViewController.make(withUserId: userId)
        presenterViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func postTableViewCellDidTapLike(_ cell: EkoPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell),
            let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        if item.isLiked {
            screenViewModel.action.unlikePost(postId: item.id)
        } else {
            screenViewModel.action.likePost(postId: item.id)
        }
    }
    
    func postTableViewCellDidTapComment(_ cell: EkoPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell),
            let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        navigateToPostDetail(with: item)
    }
    
    func postTableViewCellDidTapViewAll(_ cell: EkoPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell),
            let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        navigateToPostDetail(with: item)
    }
    
    func postTableViewCellDidTapOption(_ cell: EkoPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        let bottomSheet = BottomSheetViewController()
        let editOption = TextItemOption(title: EkoLocalizedStringSet.edit)
        let deleteOption = TextItemOption(title: EkoLocalizedStringSet.delete)
        let contentView = ItemOptionView<TextItemOption>()
        contentView.configure(items: [editOption, deleteOption], selectedItem: nil)
        contentView.didSelectItem = { action in
            bottomSheet.dismissBottomSheet { [weak self] in
                if action == editOption {
                    guard let strongSelf = self else { return }
                    var postTarget: EkoPostTarget
                    if indexPath.section == 0 {
                        postTarget = .myFeed
                    } else {
                        fatalError()
                    }
                    let vc = EkoCreatePostViewController.make(postTarget: postTarget, postMode: .edit(strongSelf.screenViewModel.dataSource.item(at: indexPath)!))
                    vc.delegate = self
                    let nvc = UINavigationController(rootViewController: vc)
                    nvc.modalPresentationStyle = .overFullScreen
                    strongSelf.presenterViewController?.present(nvc, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: EkoLocalizedStringSet.postDetailDeletePostTitle, message: EkoLocalizedStringSet.postDetailDeletePostMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.delete, style: .destructive, handler: { _ in
                        self?.screenViewModel.removeItem(at: indexPath)
                        self?.tableView?.reloadData()
                    }))
                    self?.presenterViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        presenterViewController?.present(bottomSheet, animated: false, completion: nil)
    }
    
    func postTableViewCellDidTapImage(_ cell: EkoPostFeedTableViewCell, image: EkoImage) {
        let viewController = EkoPhotoViewerController(referencedView: cell.imageView, imageModel: image)
        viewController.dataSource = cell
        viewController.delegate = cell
        presenterViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func postTableViewCell(_ cell: EkoPostFeedTableViewCell, didUpdate post: EkoPostModel) {
        reloadAndScroll()
    }
    
}

extension EkoFeedController: EkoGlobalFeedScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: EkoGlobalFeedScreenViewModel) {
        tableView?.reloadData()
        dataDidChangeHandler?()
    }
    
}
