//
//  EkoFeedViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 30/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import MobileCoreServices

public final class EkoFeedViewController: EkoViewController, EkoRefreshable {
    
    // MARK: - Properties
    
    var pageTitle: String?
    var pageIndex: Int = 0
    var headerView: UIView? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard self?.tableView.numberOfSections ?? 0 > 0 else { return }
                self?.tableView.reloadSections([0], with: .none)
            }
        }
    }
    var emptyView: UIView?
    var dataDidUpdateHandler: ((Int) -> Void)?
    var emptyViewHandler: ((UIView?) -> Void)?
    
    private let refreshControl = UIRefreshControl()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var screenViewModel: EkoFeedScreenViewModelType!
    private var expandedIds: [String] = []
    private var cellHeights = [IndexPath: CGFloat]()
    private var isVisible: Bool = false
    // It will be marked as dirty when data source changed on view disappear.
    private var isDataSourceDirty: Bool = false
    
    // MARK: - Initializer
    
    public static func make(feedType: FeedType) -> EkoFeedViewController {
        let vc = EkoFeedViewController()
        vc.screenViewModel = EkoFeedScreenViewModel(feedType: feedType)
        return vc
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupScreenViewModel()
        addNotificationObserver()
        setupRefreshControl()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isVisible = true
        
        if isDataSourceDirty {
            isDataSourceDirty = false
            tableView.reloadData()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isVisible = false
    }
    
    deinit {
        removeNotificationObserver()
    }
    
    // MARK: - Notification Center
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(feedNeedsUpdate(_:)), name: Notification.Name.Post.didCreate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(feedNeedsUpdate(_:)), name: Notification.Name.Post.didUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(feedNeedsUpdate(_:)), name: Notification.Name.Post.didDelete, object: nil)
    }
    
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Post.didCreate, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Post.didUpdate, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Post.didDelete, object: nil)
    }
    
    @objc private func feedNeedsUpdate(_ notification: NSNotification) {
        // Feed can't get notified from SDK after posting because backend handles a query step.
        // So, it needs to be notified from our side over NotificationCenter.
        screenViewModel.dataSource.reloadData()
        if notification.name == Notification.Name.Post.didCreate {
            scrollToTop()
        }
    }
    
    // MARK: - Refreshable
    
    func handleRefreshing() {
        screenViewModel.reloadData()
    }
    
    // MARK: - Private functions
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(EkoPostFeedTableViewCell.nib, forCellReuseIdentifier: EkoPostFeedTableViewCell.identifier)
        tableView.register(EkoFeedHeaderTableViewCell.self, forCellReuseIdentifier: EkoFeedHeaderTableViewCell.identifier)
        tableView.register(EkoEmptyStateHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: EkoEmptyStateHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        refreshControl.tintColor = EkoColorSet.base.blend(.shade3)
        tableView.refreshControl = refreshControl
    }

    func scrollToTop() {
        guard tableView.numberOfRows(inSection: 0) > 0 else { return }
        
        let topRow = IndexPath(row: 0, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(at: topRow, at: .top, animated: false)
        }
    }
    
    // MARK: - Helper functions
    
    @objc private func handleRefreshControl() {
        screenViewModel.reloadData()
    }
    
    private func handlePostOption(post: EkoPostModel) {
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        bottomSheet.isTitleHidden = true
        bottomSheet.sheetContentView = contentView
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        if post.isOwner {
            let editOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.editPost) { [weak self] in
                guard let strongSelf = self else { return }
                EkoEventHandler.shared.editPostDidTap(from: strongSelf, postId: post.id)
            }
            let deleteOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.deletePost) { [weak self] in
                // delete option
                let alert = UIAlertController(title: EkoLocalizedStringSet.PostDetail.deletePostTitle, message: EkoLocalizedStringSet.PostDetail.deletePostMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.delete, style: .destructive, handler: { _ in
                    self?.screenViewModel.deletePost(postId: post.id)
                    self?.tableView.reloadData()
                }))
                self?.present(alert, animated: true, completion: nil)
            }
            
            contentView.configure(items: [editOption, deleteOption], selectedItem: nil)
            present(bottomSheet, animated: false, completion: nil)
        } else {
            screenViewModel.dataSource.getReportPostStatus(postId: post.id) { [weak self] isReported in
                if isReported {
                    let unreportOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.unreportPost) {
                        self?.screenViewModel.action.unreportPost(postId: post.id)
                    }
                    contentView.configure(items: [unreportOption], selectedItem: nil)
                } else {
                    let reportOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.reportPost) {
                        self?.screenViewModel.action.reportPost(postId: post.id)
                    }
                    contentView.configure(items: [reportOption], selectedItem: nil)
                }
                self?.present(bottomSheet, animated: false, completion: nil)
            }
        }
        
    }
    
    private func handleCommentOption(comment: EkoCommentModel) {
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        // Comment options
        if comment.isOwner {
            
            let editOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.editComment) { [weak self] in
                guard let strongSelf = self else { return }
                let editTextViewController = EkoEditTextViewController.make(message: comment.text, editMode: .edit)
                editTextViewController.editHandler = { [weak self] text in
                    self?.screenViewModel.action.editComment(comment: comment, text: text)
                    editTextViewController.dismiss(animated: true, completion: nil)
                }
                editTextViewController.dismissHandler = {
                    editTextViewController.dismiss(animated: true, completion: nil)
                }
                let nvc = UINavigationController(rootViewController: editTextViewController)
                nvc.modalPresentationStyle = .fullScreen
                strongSelf.present(nvc, animated: true, completion: nil)
            }
            let deleteOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.deleteComment) { [weak self] in
                let alert = UIAlertController(title: EkoLocalizedStringSet.PostDetail.deleteCommentTitle, message: EkoLocalizedStringSet.PostDetail.deleteCommentMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.delete, style: .destructive) { [weak self] _ in
                    self?.screenViewModel.action.deleteComment(comment: comment)
                })
                self?.present(alert, animated: true, completion: nil)
            }
            
            contentView.configure(items: [editOption, deleteOption], selectedItem: nil)
            present(bottomSheet, animated: false, completion: nil)
        } else {
            
            screenViewModel.dataSource.getReportCommentStatus(commentId: comment.id) { [weak self] isReported in
                if isReported {
                    let unreportOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.unreportComment) {
                        self?.screenViewModel.action.unreportComment(commentId: comment.id)
                    }
                    contentView.configure(items: [unreportOption], selectedItem: nil)
                } else {
                    let reportOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.reportComment) {
                        self?.screenViewModel.action.reportComment(commentId: comment.id)
                    }
                    contentView.configure(items: [reportOption], selectedItem: nil)
                }
                self?.present(bottomSheet, animated: false, completion: nil)
            }
        }
    }
    
}

extension EkoFeedViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return headerView == nil ? 0 : 1
        }
        return screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: EkoFeedHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(headerView: headerView)
            return cell
        }
        if case .post(let item) = screenViewModel.dataSource.item(at: indexPath) {
            let cell: EkoPostFeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let shouldContentExpand = expandedIds.contains(item.id)
            let isFirstCell = indexPath.row == 0
            
            // If we are on community feed, hide the community name on post.
            var shouldCommunityNameHide = false
            if case .communityFeed = screenViewModel.feedType {
                shouldCommunityNameHide = true
            }
            
            cell.configure(item: item, shouldContentExpand: shouldContentExpand, shouldCommunityNameHide: shouldCommunityNameHide, isFirstCell: isFirstCell)
            cell.actionDelegate = self
            return cell
        }
        fatalError()
    }
    
}

extension EkoFeedViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            screenViewModel.dataSource.loadNext()
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0,
            let bottomView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EkoEmptyStateHeaderFooterView.identifier) as? EkoEmptyStateHeaderFooterView else {
            return nil
        }
        if let emptyView = emptyView {
            bottomView.setLayout(layout: .custom(emptyView))
        } else if case .userFeed = screenViewModel.dataSource.feedType {
            bottomView.setLayout(layout: .label(title: EkoLocalizedStringSet.emptyTitleNoPosts, subtitle: nil, image: EkoIconSet.emptyNoPosts))
        }
        emptyViewHandler?(bottomView)
        return bottomView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return screenViewModel.numberOfItems() > 0 ? 0 : tableView.frame.height
        }
        return 0.0
    }
    
}

extension EkoFeedViewController: EkoPostFeedTableViewCellDelegate {
    
    func cellDidTapDisplayName(_ cell: EkoPostFeedTableViewCell, userId: String) {
        EkoEventHandler.shared.userDidTap(from: self, userId: userId)
    }
    
    func cellDidTapCommunityName(_ cell: EkoPostFeedTableViewCell, communityId: String) {
        EkoEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
    func cellNeedLayout(_ cell: EkoPostFeedTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func cellDidTapAvatar(_ cell: EkoPostFeedTableViewCell, userId: String) {
        EkoEventHandler.shared.userDidTap(from: self, userId: userId)
    }
    
    func cellDidTapLike(_ cell: EkoPostFeedTableViewCell, referenceType: EkoPostFeedReferenceType) {
        guard let indexPath = tableView.indexPath(for: cell), case .post(let post) = screenViewModel.dataSource.item(at: indexPath) else { return }
        
        if case .comment(let commentId) = referenceType,
            let comment = post.latestComments.first(where: { $0.id == commentId }) {
            comment.isLiked ? screenViewModel.action.unlikeComment(commentId: commentId) : screenViewModel.action.likeComment(commentId: commentId)
        } else {
            post.isLiked ? screenViewModel.action.unlikePost(postId: post.id) : screenViewModel.action.likePost(postId: post.id)
        }
    }
    
    func cellDidTapComment(_ cell: EkoPostFeedTableViewCell, referenceType: EkoPostFeedReferenceType) {
        guard let indexPath = tableView.indexPath(for: cell),
            case .post(let post) = screenViewModel.dataSource.item(at: indexPath) else { return }
        EkoEventHandler.shared.postDidtap(from: self, postId: post.id)
    }
    
    func cellDidTapViewAll(_ cell: EkoPostFeedTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            case .post(let post) = screenViewModel.dataSource.item(at: indexPath) else { return }
        EkoEventHandler.shared.postDidtap(from: self, postId: post.id)
    }
    
    func cellDidTapOption(_ cell: EkoPostFeedTableViewCell, referenceType: EkoPostFeedReferenceType) {
        guard let indexPath = tableView.indexPath(for: cell), case .post(let post) = screenViewModel.dataSource.item(at: indexPath) else { return }
        
        if case .comment(let commentId) = referenceType,
            let comment = post.latestComments.first(where: { $0.id == commentId }) {
            handleCommentOption(comment: comment)
        } else {
            handlePostOption(post: post)
        }
    }
    
    func cell(_ cell: EkoPostFeedTableViewCell, didTapImage image: EkoImage) {
        let viewController = EkoPhotoViewerController(referencedView: cell.imageView, imageModel: image)
        viewController.dataSource = cell
        viewController.delegate = cell
        present(viewController, animated: true, completion: nil)
    }
    
    func cell(_ cell: EkoPostFeedTableViewCell, didTapFile file: EkoFile) {
        guard case .downloadable(let fileData) = file.state else { return }
        EkoHUD.show(.loading)
        EkoFileService.shared.loadFile(with: fileData.fileId) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                EkoHUD.hide {
                    let tempUrl = data.write(withName: fileData.fileName)
                    let documentPicker = UIDocumentPickerViewController(url: tempUrl, in: .exportToService)
                    documentPicker.modalPresentationStyle = .fullScreen
                    strongSelf.present(documentPicker, animated: true, completion: nil)
                }
            case .failure:
                EkoHUD.hide()
            }
        }
    }
    
    func cell(_ cell: EkoPostFeedTableViewCell, didUpdate post: EkoPostModel) {
        scrollToTop()
    }
    
    func cell(_ cell: EkoPostFeedTableViewCell, didTapLabel label: EkoExpandableLabel) {
        guard let indexPath = tableView.indexPath(for: cell),
            case .post(let post) = screenViewModel.dataSource.item(at: indexPath) else { return }
        EkoEventHandler.shared.postDidtap(from: self, postId: post.id)
    }
    
    func cell(_ cell: EkoPostFeedTableViewCell, willExpand label: EkoExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func cell(_ cell: EkoPostFeedTableViewCell, didExpand label: EkoExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func cell(_ cell: EkoPostFeedTableViewCell, willCollapse label: EkoExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func cell(_ cell: EkoPostFeedTableViewCell, didCollapse label: EkoExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    func cellDidTapShare(_ cell: EkoPostFeedTableViewCell, postId: String) {
        let bottomSheet = BottomSheetViewController()
        let shareToTimeline = TextItemOption(title: EkoLocalizedStringSet.SharingType.shareToMyTimeline)
        let shareToGroup = TextItemOption(title: EkoLocalizedStringSet.SharingType.shareToGroup)
        let moreOptions = TextItemOption(title: EkoLocalizedStringSet.SharingType.moreOptions)
        let contentView = ItemOptionView<TextItemOption>()
        contentView.configure(items: [shareToTimeline, shareToGroup, moreOptions], selectedItem: nil)
        contentView.didSelectItem = { [weak bottomSheet] action in
            bottomSheet?.dismissBottomSheet { [weak self] in
                guard let strongSelf = self else { return }
                switch action {
                case moreOptions:
                    EkoEventHandler.shared.sharePostDidTap(from: strongSelf, postId: postId)
                default: break
                }
            }
        }
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        present(bottomSheet, animated: false, completion: nil)
    }
}

extension EkoFeedViewController: EkoFeedScreenViewModelDelegate {
    func screenViewModelDidUpdateData(_ viewModel: EkoFeedScreenViewModelType) {
        
        // When view is invisible but data source request updates, mark it as a dirty data source.
        // Then after view already appear, reload table view for refreshing data.
        guard isVisible else {
            isDataSourceDirty = true
            return
        }
        tableView.reloadData()
        dataDidUpdateHandler?(screenViewModel.dataSource.numberOfItems())
        refreshControl.endRefreshing()
    }
    
}

extension EkoFeedViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: EkoPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle ?? "\(pageIndex)")
    }
    
}
