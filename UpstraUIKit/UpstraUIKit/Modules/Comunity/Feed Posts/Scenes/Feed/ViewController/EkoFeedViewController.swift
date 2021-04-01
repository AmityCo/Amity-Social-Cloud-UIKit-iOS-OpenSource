//
//  EkoFeedViewController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/13/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

public final class EkoFeedViewController: EkoViewController, EkoRefreshable {
    
    var pageTitle: String?
    var pageIndex: Int = 0
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: EkoPostTableView!
    
    // MARK: - Properties
    private var screenViewModel: EkoFeedScreenViewModelType!
    private var shouldShowLoadingIndicator = true
    
    // MARK: - Post Protocol Handler
    private var postHeaderProtocolHandler: EkoPostHeaderProtocolHandler?
    private var postFooterProtocolHandler: EkoPostFooterProtocolHandler?
    private var postPostProtocolHandler: EkoPostProtocolHandler?

    private let refreshControl = UIRefreshControl()
    var headerView: UIView? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var emptyView: UIView?
    var dataDidUpdateHandler: ((Int) -> Void)?
    var emptyViewHandler: ((UIView?) -> Void)?
    
    private var cellHeights = [IndexPath: CGFloat]()
    private var isVisible: Bool = false
    // It will be marked as dirty when data source changed on view disappear.
    private var isDataSourceDirty: Bool = false
    
    // MARK: - View lifecycle
    deinit {
        screenViewModel.action.stopObserveFeedUpdate()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupProtocolHandler()
        setupScreenViewModel()   
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
    
    public static func make(feedType: EkoPostFeedType) -> EkoFeedViewController {
        let postController = EkoPostController()
        let commentController = EkoCommentController()
        let reaction = EkoReactionController()
        let viewModel = EkoFeedScreenViewModel(withFeedType: feedType,
                                                      postController: postController,
                                                      commentController: commentController,
                                                      reactionController: reaction)
        let vc = EkoFeedViewController(nibName: EkoFeedViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }

    // MARK: Setup Post Protocol Handler
    private func setupProtocolHandler() {
        postHeaderProtocolHandler = EkoPostHeaderProtocolHandler(viewController: self)
        postHeaderProtocolHandler?.delegate = self
        
        postFooterProtocolHandler = EkoPostFooterProtocolHandler(viewController: self)
        postFooterProtocolHandler?.delegate = self
        
        postPostProtocolHandler = EkoPostProtocolHandler(viewController: self, tableView: tableView)
    }
    
    // MARK: - Setup ViewModel
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.startObserveFeedUpdate()
        screenViewModel.action.fetchPosts()
    }
    
    // MARK: - Setup Views
    private func setupView() {
        setupTableView()
        setupRefreshControl()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerCustomCell()
        tableView.registerPostCell()
        tableView.register(EkoFeedHeaderTableViewCell.self, forCellReuseIdentifier: EkoFeedHeaderTableViewCell.identifier)
        tableView.register(EkoEmptyStateHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: EkoEmptyStateHeaderFooterView.identifier)
        tableView.eko_dataSource = self
        tableView.eko_delegate = self
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefreshingControl), for: .valueChanged)
        refreshControl.tintColor = EkoColorSet.base.blend(.shade3)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: SrollToTop
    func scrollToTop() {
        guard tableView.numberOfRows(inSection: 0) > 0 else { return }
        
        let topRow = IndexPath(row: 0, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(at: topRow, at: .top, animated: false)
        }
    }
    
    // MARK: - Refreshing
    func handleRefreshing() {
        screenViewModel.action.reload()
    }
    
    @objc private func handleRefreshingControl() {
        screenViewModel.action.reload()
    }
}

// MARK: - EkoPostTableViewDelegate
extension EkoFeedViewController: EkoPostTableViewDelegate {
    
    func tableView(_ tableView: EkoPostTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        return cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: EkoPostTableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return cellHeights[indexPath] ?? UITableView.automaticDimension
        } else {
            if cellHeights.isEmpty {
                let singleComponent = screenViewModel.dataSource.postComponents(in: indexPath.section)
                if let component = tableView.postDataSource?.getUIComponentForPost(post: singleComponent._composable.post, at: indexPath.section) {
                    return component.getComponentHeight(indexPath: indexPath)
                }
                return cellHeights[indexPath] ?? UITableView.automaticDimension
            }
            return cellHeights[indexPath] ?? UITableView.automaticDimension
        }   
    }
    
    func tableView(_ tableView: EkoPostTableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            screenViewModel.action.loadMore()
        }
    }
    
    func tableView(_ tableView: EkoPostTableView, didSelectRowAt indexPath: IndexPath) {
        // skip header section handling
        guard indexPath.section > 0 else { return }
        
        let singleComponent = screenViewModel.dataSource.postComponents(in: indexPath.section)
        let postId = singleComponent._composable.post.id
        EkoEventHandler.shared.postDidtap(from: self, postId: postId)
    }
    
    func tableView(_ tableView: EkoPostTableView, heightForFooterInSection section: Int) -> CGFloat {
        let postComponentsCount = screenViewModel.dataSource.numberOfPostComponents() - (headerView == nil ? 1:0)
        return postComponentsCount > 0 ? 0 : tableView.frame.height
    }

    func tableView(_ tableView: EkoPostTableView, viewForFooterInSection section: Int) -> UIView? {
        guard let bottomView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EkoEmptyStateHeaderFooterView.identifier) as? EkoEmptyStateHeaderFooterView, !shouldShowLoadingIndicator else {
            let loading = UIActivityIndicatorView(style: .gray)
            loading.center = tableView.center
            loading.startAnimating()
            return loading
        }
        if let emptyView = emptyView {
            bottomView.setLayout(layout: .custom(emptyView))
        } else {
            switch screenViewModel.dataSource.getFeedType() {
            case .userFeed:
                bottomView.setLayout(layout: .label(title: EkoLocalizedStringSet.emptyTitleNoPosts.localizedString, subtitle: nil, image: EkoIconSet.emptyNoPosts))
            default:
                emptyViewHandler?(bottomView)
                return bottomView
            }
        }
        emptyViewHandler?(bottomView)
        return bottomView
    }
}

// MARK: - EkoPostTableViewDataSource
extension EkoFeedViewController: EkoPostTableViewDataSource {
    func numberOfSections(in tableView: EkoPostTableView) -> Int {
        return screenViewModel.dataSource.numberOfPostComponents()
    }
    
    func tableView(_ tableView: EkoPostTableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return headerView == nil ? 0 : 1
        } else {
            let singleComponent = screenViewModel.dataSource.postComponents(in: section)
            if let component = tableView.postDataSource?.getUIComponentForPost(post: singleComponent._composable.post, at: section) {
                return component.getComponentCount(for: section)
            }
            return singleComponent.getComponentCount(for: section)
        }
        
    }
    
    func tableView(_ tableView: EkoPostTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: EkoFeedHeaderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(headerView: headerView)
            return cell
        } else {
            let singleComponent = screenViewModel.dataSource.postComponents(in: indexPath.section)
            var cell: UITableViewCell
            if let clientComponent = tableView.postDataSource?.getUIComponentForPost(post: singleComponent._composable.post, at: indexPath.section) {
                cell = clientComponent.getComponentCell(tableView, at: indexPath)
            } else {
                cell = singleComponent.getComponentCell(tableView, at: indexPath)
            }
            (cell as? EkoPostHeaderProtocol)?.delegate = postHeaderProtocolHandler
            (cell as? EkoPostFooterProtocol)?.delegate = postFooterProtocolHandler
            (cell as? EkoPostProtocol)?.delegate = postPostProtocolHandler
            (cell as? EkoPostPreviewCommentProtocol)?.delegate = self
            return cell
        }
    }
}

// MARK: - EkoFeedScreenViewModelDelegate
extension EkoFeedViewController: EkoFeedScreenViewModelDelegate {
    func screenViewModelDidUpdateDataSuccess(_ viewModel: EkoFeedScreenViewModelType) {
        // When view is invisible but data source request updates, mark it as a dirty data source.
        // Then after view already appear, reload table view for refreshing data.
        guard isVisible else {
            isDataSourceDirty = true
            return
        }
        shouldShowLoadingIndicator = false
        tableView.reloadData()
        dataDidUpdateHandler?(screenViewModel.dataSource.numberOfPostComponents())
        refreshControl.endRefreshing()
    }
    
    func screenViewModelLoadingState(_ viewModel: EkoFeedScreenViewModelType, for loadingState: EkoLoadingState) {
        switch loadingState {
        case .loading:
            tableView.showLoadingIndicator()
        case .loaded:
            tableView.tableFooterView = UIView()
        case .initial:
            break
        }
    }
    
    func screenViewModelScrollToTop(_ viewModel: EkoFeedScreenViewModelType) {
        scrollToTop()
    }
    
    func screenViewModelDidSuccess(_ viewModel: EkoFeedScreenViewModelType, message: String) {
        EkoHUD.show(.success(message: message.localizedString))
    }
    
    func screenViewModelDidFail(_ viewModel: EkoFeedScreenViewModelType, failure error: EkoError) {
        switch error {
        case .unknown:
            EkoHUD.show(.error(message: EkoLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        default:
            break
        }
    }
    
    // MARK: Post
    func screenViewModelDidLikePostSuccess(_ viewModel: EkoFeedScreenViewModelType) {
        tableView.postDelegate?.didPerformActionLikePost()
    }
    
    func screenViewModelDidUnLikePostSuccess(_ viewModel: EkoFeedScreenViewModelType) {
        tableView.postDelegate?.didPerformActionUnLikePost()
    }
    
    func screenViewModelDidGetReportStatusPost(isReported: Bool) {
        postHeaderProtocolHandler?.showOptions(withReportStatus: isReported)
    }
    
    // MARK: Commend
    func screenViewModelDidLikeCommentSuccess(_ viewModel: EkoFeedScreenViewModelType) {
        tableView.postDelegate?.didPerformActionLikeComment()
    }
    
    func screenViewModelDidUnLikeCommentSuccess(_ viewModel: EkoFeedScreenViewModelType) {
        tableView.postDelegate?.didPerformActionUnLikeComment()
    }
    
    func screenViewModelDidDeleteCommentSuccess(_ viewModel: EkoFeedScreenViewModelType) {
        // Do something with success
    }
    
    func screenViewModelDidEditCommentSuccess(_ viewModel: EkoFeedScreenViewModelType) {
        // Do something with success
    }
    
}

// MARK: - EkoPostHeaderProtocolHandlerDelegate
extension EkoFeedViewController: EkoPostHeaderProtocolHandlerDelegate {
    func headerProtocolHandlerDidPerformAction(_ handler: EkoPostHeaderProtocolHandler, action: EkoPostProtocolHeaderHandlerAction, withPost post: EkoPostModel) {
        let postId: String = post.id
        switch action {
        case .tapOption:
            screenViewModel.action.getReportStatus(withPostId: post.id)
        case .tapDelete:
            screenViewModel.action.delete(withPostId: postId)
        case .tapReport:
            screenViewModel.action.report(withPostId: postId)
        case .tapUnreport:
            screenViewModel.action.unreport(withPostId: postId)
        }
    }
    
}


// MARK: - EkoPostFooterProtocolHandlerDelegate
extension EkoFeedViewController: EkoPostFooterProtocolHandlerDelegate {
    func footerProtocolHandlerDidPerformAction(_ handler: EkoPostFooterProtocolHandler, action: EkoPostFooterProtocolHandlerAction, withPost post: EkoPostModel) {
        switch action {
        case .tapLike:
            if post.isLiked {
                screenViewModel.action.unlike(id: post.id, referenceType: .post)
            } else {
                screenViewModel.action.like(id: post.id, referenceType: .post)
            }
        case .tapComment:
            EkoEventHandler.shared.postDidtap(from: self, postId: post.id)
        }
    }
}

// MARK: EkoPostPreviewCommentDelegate
extension EkoFeedViewController: EkoPostPreviewCommentDelegate {
    
    public func didPerformAction(_ cell: EkoPostPreviewCommentProtocol, action: EkoPostPreviewCommentAction) {
        guard let post = cell.post else { return }
        switch action {
        case .tapAvatar(let comment):
            EkoEventHandler.shared.userDidTap(from: self, userId: comment.userId)
        case .tapLike(let comment):
            if let comment = post.latestComments.first(where: { $0.id == comment.id}) {
                comment.isLiked ? screenViewModel.action.unlike(id: comment.id, referenceType: .comment) : screenViewModel.action.like(id: comment.id, referenceType: .comment)
            }
        case .tapOption(let comment):
            if let comment = post.latestComments.first(where: { $0.id == comment.id }) {
                handleCommentOption(comment: comment)
            }
        case .tapReply:
            EkoEventHandler.shared.postDidtap(from: self, postId: post.id)
        case .tapExpandableLabel:
            EkoEventHandler.shared.postDidtap(from: self, postId: post.id)
        case .willExpandExpandableLabel:
            tableView.beginUpdates()
        case .didExpandExpandableLabel(let label):
            let point = label.convert(CGPoint.zero, to: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            tableView.endUpdates()
        case .willCollapseExpandableLabel:
            tableView.beginUpdates()
        case .didCollapseExpandableLabel(let label):
            let point = label.convert(CGPoint.zero, to: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            tableView.endUpdates()
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
            
            let editOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.editComment.localizedString) { [weak self] in
                guard let strongSelf = self else { return }
                let editTextViewController = EkoEditTextViewController.make(message: comment.text, editMode: .edit)
                editTextViewController.title = EkoLocalizedStringSet.PostDetail.editComment.localizedString
                editTextViewController.editHandler = { [weak self] text in
                    self?.screenViewModel.action.edit(withComment: comment, text: text)
                    editTextViewController.dismiss(animated: true, completion: nil)
                }
                editTextViewController.dismissHandler = {
                    editTextViewController.dismiss(animated: true, completion: nil)
                }
                let nvc = UINavigationController(rootViewController: editTextViewController)
                nvc.modalPresentationStyle = .fullScreen
                strongSelf.present(nvc, animated: true, completion: nil)
            }
            let deleteOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.deleteComment.localizedString) { [weak self] in
                let alert = UIAlertController(title: EkoLocalizedStringSet.PostDetail.deleteCommentTitle.localizedString, message: EkoLocalizedStringSet.PostDetail.deleteCommentMessage.localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.delete.localizedString, style: .destructive) { [weak self] _ in
                    self?.screenViewModel.action.delete(withComment: comment)
                })
                self?.present(alert, animated: true, completion: nil)
            }
            
            contentView.configure(items: [editOption, deleteOption], selectedItem: nil)
            present(bottomSheet, animated: false, completion: nil)
        } else {
            screenViewModel.action.getReportStatus(withCommendId: comment.id) { [weak self] (isReported) in
                if isReported {
                    let unreportOption = TextItemOption(title: EkoLocalizedStringSet.General.undoReport.localizedString) {
                        self?.screenViewModel.action.unreport(withCommentId: comment.id)
                    }
                    contentView.configure(items: [unreportOption], selectedItem: nil)
                } else {
                    let reportOption = TextItemOption(title: EkoLocalizedStringSet.General.report.localizedString) {
                        self?.screenViewModel.action.report(withCommentId: comment.id)
                    }
                    contentView.configure(items: [reportOption], selectedItem: nil)
                }
                self?.present(bottomSheet, animated: false, completion: nil)
            }
            
        }
    }
}

extension EkoFeedViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: EkoPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle ?? "\(pageIndex)")
    }
    
}
