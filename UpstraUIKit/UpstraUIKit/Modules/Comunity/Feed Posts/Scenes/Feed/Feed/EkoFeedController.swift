//
//  AmityFeedController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 25/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
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
        tableView.register(AmityPostFeedTableViewCell.nib, forCellReuseIdentifier: AmityPostFeedTableViewCell.identifier)
    }
    
    // MARK: - Navigation
    
    func presentCreatePost() {
        let vc = AmityPostToViewController()
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
        let cell: AmityPostFeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
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

extension EkoFeedController: AmityPostViewControllerDelegate {
    
    public func postViewController(_ viewController: UIViewController, didCreatePost post: AmityPostModel) {
        reloadAndScroll()
    }
    
    public func postViewController(_ viewController: UIViewController, didUpdatePost post: AmityPostModel) {
        reloadAndScroll()
    }
}

extension EkoFeedController: AmityPostToViewControllerDelegate {
    
    func postToViewController(_ viewController: AmityPostToViewController, didCreatePost post: AmityPostModel) {
        reloadAndScroll()
    }
    
    func postToViewController(_ viewController: AmityPostToViewController, didUpdatePost post: AmityPostModel) {
        reloadAndScroll()
    }
}

extension EkoFeedController: AmityExpandableLabelDelegate {
    
    private func navigateToPostDetail(with post: AmityPostModel) {
        let detailView = AmityPostDetailViewController.make(postId: post.id)
        presenterViewController?.navigationController?.pushViewController(detailView, animated: true)
    }
    
    public func expandableLabeldidTap(_ label: AmityExpandableLabel) {
        guard let cell = label.superview(of: AmityPostFeedTableViewCell.self),
            let indexPath = tableView?.indexPath(for: cell),
            let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        navigateToPostDetail(with: item)
    }
    
    public func willExpandLabel(_ label: AmityExpandableLabel) {
        tableView?.beginUpdates()
    }
    
    public func didExpandLabel(_ label: AmityExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView?.indexPathForRow(at: point) as IndexPath? {
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView?.endUpdates()
    }
    
    public func willCollapseLabel(_ label: AmityExpandableLabel) {
        tableView?.beginUpdates()
    }
    
    public func didCollapseLabel(_ label: AmityExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView?.indexPathForRow(at: point) as IndexPath? {
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView?.endUpdates()
    }
    
}

extension EkoFeedController: AmityPostFeedTableViewCellDelegate {
    
    func postTableViewCellNeedLayout(_ cell: AmityPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        tableView?.beginUpdates()
        tableView?.reloadRows(at: [indexPath], with: .automatic)
        tableView?.endUpdates()
    }
    
    func postTableViewCellDidTapAvatar(_ cell: AmityPostFeedTableViewCell, userId: String) {
        let vc = AmityUserProfileViewController.make(withUserId: userId)
        presenterViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func postTableViewCellDidTapLike(_ cell: AmityPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell),
            let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        if item.isLiked {
            screenViewModel.action.unlikePost(postId: item.id)
        } else {
            screenViewModel.action.likePost(postId: item.id)
        }
    }
    
    func postTableViewCellDidTapComment(_ cell: AmityPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell),
            let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        navigateToPostDetail(with: item)
    }
    
    func postTableViewCellDidTapViewAll(_ cell: AmityPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell),
            let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        navigateToPostDetail(with: item)
    }
    
    func postTableViewCellDidTapOption(_ cell: AmityPostFeedTableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        let bottomSheet = BottomSheetViewController()
        let editOption = TextItemOption(title: AmityLocalizedStringSet.edit)
        let deleteOption = TextItemOption(title: AmityLocalizedStringSet.delete)
        let contentView = ItemOptionView<TextItemOption>()
        contentView.configure(items: [editOption, deleteOption], selectedItem: nil)
        contentView.didSelectItem = { action in
            bottomSheet.dismissBottomSheet { [weak self] in
                if action == editOption {
                    guard let strongSelf = self else { return }
                    var postTarget: AmityPostTarget
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
                    let alert = UIAlertController(title: AmityLocalizedStringSet.postDetailDeletePostTitle, message: AmityLocalizedStringSet.postDetailDeletePostMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.cancel, style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.delete, style: .destructive, handler: { _ in
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
    
    func postTableViewCellDidTapImage(_ cell: AmityPostFeedTableViewCell, image: EkoImage) {
        let viewController = EkoPhotoViewerController(referencedView: cell.imageView, imageModel: image)
        viewController.dataSource = cell
        viewController.delegate = cell
        presenterViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func postTableViewCell(_ cell: AmityPostFeedTableViewCell, didUpdate post: AmityPostModel) {
        reloadAndScroll()
    }
    
}

extension EkoFeedController: EkoGlobalFeedScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: EkoGlobalFeedScreenViewModel) {
        tableView?.reloadData()
        dataDidChangeHandler?()
    }
    
}
