//
//  EkoPostDetailViewController.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/14/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

/// A view controller for providing post and relevant comments.
public final class EkoPostDetailViewController: EkoViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: EkoPostTableView!
    @IBOutlet private var commentComposeBarView: EkoPostDetailCompostView!
    @IBOutlet private var commentComposeBarBottomConstraint: NSLayoutConstraint!
    private var optionButton: UIBarButtonItem!
    
    // MARK: - Post Protocol Handler
    private var postHeaderProtocolHandler: EkoPostHeaderProtocolHandler?
    private var postFooterProtocolHandler: EkoPostFooterProtocolHandler?
    private var postProtocolHandler: EkoPostProtocolHandler?
    
    // MARK: - Properties
    private var screenViewModel: EkoPostDetailScreenViewModelType
    private var selectedIndexPath: IndexPath?
    private var referenceId: String?
    private var expandedIds: [String] = []
    private var showReplyIds: [String] = []
    
    private var parentComment: EkoCommentModel? {
        didSet {
            commentComposeBarView.replyingUsername = parentComment?.displayName
        }
    }
    
    // MARK: - Initializer
    init(withPostId postId: String) {
        let postController = EkoPostController()
        let commentController = EkoCommentController()
        let reactionController = EkoReactionController()
        let childrenController = EkoCommentChildrenController(postId: postId)
        screenViewModel = EkoPostDetailScreenViewModel(withPostId: postId,
                                                             postController: postController,
                                                             commentController: commentController,
                                                             reactionController: reactionController,
                                                             childrenController: childrenController)
        super.init(nibName: EkoPostDetailViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make(withPostId postId: String) -> EkoPostDetailViewController {
        return EkoPostDetailViewController(withPostId: postId)
    }
    
    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTableView()
        setupComposeBarView()
        setupProtocolHandler()
        setupScreenViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setBackgroundColor(with: .white)
        EkoKeyboardService.shared.delegate = self
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.reset()
    }
    
    // MARK: Setup Post Protocol Handler
    private func setupProtocolHandler() {
        postHeaderProtocolHandler = EkoPostHeaderProtocolHandler(viewController: self)
        postHeaderProtocolHandler?.delegate = self
        
        postFooterProtocolHandler = EkoPostFooterProtocolHandler(viewController: self)
        postFooterProtocolHandler?.delegate = self
        
        postProtocolHandler = EkoPostProtocolHandler(viewController: self, tableView: tableView)
    }
    
    // MARK: - Setup ViewModel
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.fetchPost()
        screenViewModel.action.fetchComments()
    }
    
    // MARK: Setup views
    private func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
    }
    
    private func setupNavigationBar() {
        optionButton = UIBarButtonItem(image: EkoIconSet.iconOption, style: .plain, target: self, action: #selector(optionTap))
        optionButton.tintColor = EkoColorSet.base
        navigationItem.rightBarButtonItem = optionButton
    }
    
    private func setupTableView() {
        tableView.registerCustomCell()
        tableView.registerPostCell()
        tableView.register(cell: EkoCommentTableViewCell.self)
        tableView.register(cell: EkoPostDetailDeletedTableViewCell.self)
        tableView.register(cell: EkoViewMoreReplyTableViewCell.self)
        tableView.register(cell: EkoDeletedReplyTableViewCell.self)
        tableView.backgroundColor = EkoColorSet.backgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.eko_delegate = self
        tableView.eko_dataSource = self
    }
    
    private func setupComposeBarView() {
        commentComposeBarView.delegate = self
    }
    
    @objc private func optionTap() {
        guard let post = screenViewModel.post else {
            assertionFailure("Post should not be nil")
            return
        }
        if post.isOwner {
            let bottomSheet = BottomSheetViewController()
            let contentView = ItemOptionView<TextItemOption>()
            bottomSheet.isTitleHidden = true
            bottomSheet.sheetContentView = contentView
            bottomSheet.modalPresentationStyle = .overFullScreen
            
            let editOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.editPost.localizedString) { [weak self] in
                guard let strongSelf = self else { return }
                EkoEventHandler.shared.editPostDidTap(from: strongSelf, postId: post.id)
            }
            let deleteOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.deletePost.localizedString) { [weak self] in
                // delete option
                let alert = UIAlertController(title: EkoLocalizedStringSet.PostDetail.deletePostTitle.localizedString, message: EkoLocalizedStringSet.PostDetail.deletePostMessage.localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.delete.localizedString, style: .destructive, handler: { [weak self] _ in
                    self?.screenViewModel.deletePost()
                    self?.navigationController?.popViewController(animated: true)
                }))
                self?.present(alert, animated: true, completion: nil)
            }
            
            contentView.configure(items: [editOption, deleteOption], selectedItem: nil)
            present(bottomSheet, animated: false, completion: nil)
        } else {
            screenViewModel.action.getPostReportStatus()
        }
    }
    
}

// MARK: - EkoPostTableViewDelegate
extension EkoPostDetailViewController: EkoPostTableViewDelegate {
    
    func tableView(_ tableView: EkoPostTableView, didSelectRowAt indexPath: IndexPath) {
        // load more reply did tap
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == EkoViewMoreReplyTableViewCell.identifier {
            screenViewModel.action.getReplyComments(at: indexPath.section)
        }
    }
    
    func tableView(_ tableView: EkoPostTableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: 0.0, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 1.0))
        separatorView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        return separatorView
    }
    
}

// MARK: - EkoPostTableViewDataSource
extension EkoPostDetailViewController: EkoPostTableViewDataSource {
    
    func numberOfSections(in tableView: EkoPostTableView) -> Int {
        return screenViewModel.dataSource.numberOfSection()
    }
    
    func tableView(_ tableView: EkoPostTableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: EkoPostTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = screenViewModel.item(at: indexPath)
        switch viewModel {
        case .post(let postComponent):
            var cell: UITableViewCell
            if let clientComponent = tableView.postDataSource?.getUIComponentForPost(post: postComponent._composable.post, at: indexPath.section) {
                cell = clientComponent.getComponentCell(tableView, at: indexPath)
            } else {
                cell = postComponent.getComponentCell(tableView, at: indexPath)
            }
            (cell as? EkoPostHeaderProtocol)?.delegate = postHeaderProtocolHandler
            (cell as? EkoPostFooterProtocol)?.delegate = postFooterProtocolHandler
            (cell as? EkoPostProtocol)?.delegate = postProtocolHandler
            return cell
        case .comment(let comment):
            if comment.isDeleted {
                let cell: EkoPostDetailDeletedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configure(deletedAt: comment.updatedAt)
                return cell
            }
            
            let cell: EkoCommentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let shouldActionShow = screenViewModel.post?.isCommentable ?? false
            let layout: EkoCommentViewLayout = .comment(contentExpanded: false, shouldActionShow: shouldActionShow, shouldLineShow: viewModel.isReplyType)
            cell.configure(with: comment, layout: layout)
            cell.labelDelegate = self
            cell.actionDelegate = self
            return cell
        case .replyComment(let comment):
            if comment.isDeleted {
                let cell: EkoDeletedReplyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            }
            let cell: EkoCommentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let shouldActionShow = screenViewModel.post?.isCommentable ?? false
            let layout: EkoCommentViewLayout = .reply(contentExpanded: false, shouldActionShow: shouldActionShow, shouldLineShow: viewModel.isReplyType)
            cell.configure(with: comment, layout: layout)
            cell.labelDelegate = self
            cell.actionDelegate = self
            return cell
        case .loadMoreReply:
            let cell: EkoViewMoreReplyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
}

extension EkoPostDetailViewController: EkoPostDetailScreenViewModelDelegate {
    
    // MARK: Post
    func screenViewModelDidUpdateData(_ viewModel: EkoPostDetailScreenViewModelType) {
        tableView.reloadData()
        if let post = screenViewModel.post {
            commentComposeBarView.configure(with: post)
        }
    }
    
    func screenViewModelDidUpdatePost(_ viewModel: EkoPostDetailScreenViewModelType) {
        // Do something with success
    }
    
    func screenViewModelDidLikePost(_ viewModel: EkoPostDetailScreenViewModelType) {
        tableView.postDelegate?.didPerformActionLikePost()
    }
    
    func screenViewModelDidUnLikePost(_ viewModel: EkoPostDetailScreenViewModelType) {
        tableView.postDelegate?.didPerformActionUnLikePost()
    }
    
    func screenViewModel(_ viewModel: EkoPostDetailScreenViewModelType, didReceiveReportStatus isReported: Bool) {
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        bottomSheet.isTitleHidden = true
        bottomSheet.sheetContentView = contentView
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        if isReported {
            let unreportOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.unreportPost.localizedString) { [weak self] in
                self?.screenViewModel.action.unreportPost()
            }
            contentView.configure(items: [unreportOption], selectedItem: nil)
        } else {
            let reportOption = TextItemOption(title: EkoLocalizedStringSet.PostDetail.reportPost.localizedString) { [weak self] in
                self?.screenViewModel.action.reportPost()
            }
            contentView.configure(items: [reportOption], selectedItem: nil)
        }
        present(bottomSheet, animated: false, completion: nil)
    }
    
    // MARK: Comment
    func screenViewModelDidCreateComment(_ viewModel: EkoPostDetailScreenViewModelType) {
        // Do something with success
    }
    
    func screenViewModelDidDeleteComment(_ viewModel: EkoPostDetailScreenViewModelType) {
        // Do something with success
    }
    func screenViewModelDidEditComment(_ viewModel: EkoPostDetailScreenViewModelType) {
        // Do something with success
    }
    
    func screenViewModelDidLikeComment(_ viewModel: EkoPostDetailScreenViewModelType) {
        tableView.postDelegate?.didPerformActionLikeComment()
    }
    
    func screenViewModelDidUnLikeComment(_ viewModel: EkoPostDetailScreenViewModelType) {
        tableView.postDelegate?.didPerformActionUnLikeComment()
    }
    
    func screenViewModel(_ viewModel: EkoPostDetailScreenViewModelType, didFinishWithMessage message: String) {
        EkoHUD.show(.success(message: message.localizedString))
    }
    
    func screenViewModel(_ viewModel: EkoPostDetailScreenViewModelType, comment: EkoCommentModel, didReceiveCommentReportStatus isReported: Bool) {
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<TextItemOption>()
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        if isReported {
            let reportTitle = comment.isParent ? EkoLocalizedStringSet.PostDetail.unreportComment.localizedString : EkoLocalizedStringSet.PostDetail.unreportReply.localizedString
            let unreportOption = TextItemOption(title: reportTitle) {
                self.screenViewModel.action.unreportComment(withCommentId: comment.id)
            }
            contentView.configure(items: [unreportOption], selectedItem: nil)
        } else {
            let unreportTitle = comment.isParent ? EkoLocalizedStringSet.PostDetail.reportComment.localizedString : EkoLocalizedStringSet.PostDetail.reportReply.localizedString
            let reportOption = TextItemOption(title: unreportTitle) {
                self.screenViewModel.action.reportComment(withCommentId: comment.id)
            }
            contentView.configure(items: [reportOption], selectedItem: nil)
        }
        present(bottomSheet, animated: false, completion: nil)
    }
    
    func screenViewModel(_ viewModel: EkoPostDetailScreenViewModelType, didFinishWithError error: EkoError) {
        switch error {
        case .unknown:
            EkoHUD.show(.error(message: EkoLocalizedStringSet.HUD.somethingWentWrong.localizedString))
        case .bannedWord:
            EkoHUD.show(.error(message: EkoLocalizedStringSet.PostDetail.banndedCommentErrorMessage.localizedString))
        default:
            break
        }
    }
    
}

// MARK: - EkoPostHeaderProtocolHandlerDelegate
extension EkoPostDetailViewController: EkoPostHeaderProtocolHandlerDelegate {
    
    func headerProtocolHandlerDidPerformAction(_ handler: EkoPostHeaderProtocolHandler, action: EkoPostProtocolHeaderHandlerAction, withPost post: EkoPostModel) {
        switch action {
        case .tapOption:
            screenViewModel.action.getPostReportStatus()
        case .tapDelete:
            screenViewModel.action.deletePost()
        case .tapReport:
            screenViewModel.action.reportPost()
        case .tapUnreport:
            screenViewModel.action.reportPost()
        }
    }
    
}

// MARK: - EkoPostFooterProtocolHandlerDelegate
extension EkoPostDetailViewController: EkoPostFooterProtocolHandlerDelegate {
    
    func footerProtocolHandlerDidPerformAction(_ handler: EkoPostFooterProtocolHandler, action: EkoPostFooterProtocolHandlerAction, withPost post: EkoPostModel) {
        switch action {
        case .tapLike:
            if post.isLiked {
                screenViewModel.action.unlikePost()
            } else {
                screenViewModel.action.likePost()
            }
        case .tapComment:
            parentComment = nil
            _ = commentComposeBarView.becomeFirstResponder()
        }
    }
    
}

// MARK: - EkoPostDetailCompostViewDelegate
extension EkoPostDetailViewController: EkoPostDetailCompostViewDelegate {
    
    func composeViewDidTapReplyDismiss(_ view: EkoPostDetailCompostView) {
        parentComment = nil
    }
    
    func composeViewDidTapExpand(_ view: EkoPostDetailCompostView) {
        var editTextViewController: EkoEditTextViewController
        if let parentComment = parentComment {
            // create reply
            let header = String.localizedStringWithFormat(EkoLocalizedStringSet.PostDetail.replyingTo.localizedString, parentComment.displayName)
            editTextViewController = EkoEditTextViewController.make(header: header, message: commentComposeBarView.text, editMode: .create)
            editTextViewController.title = EkoLocalizedStringSet.PostDetail.createReply.localizedString
        } else {
            // create comment
            editTextViewController = EkoEditTextViewController.make(message: commentComposeBarView.text, editMode: .create)
            editTextViewController.title = EkoLocalizedStringSet.PostDetail.createComment.localizedString
        }
        editTextViewController.editHandler = { [weak self, weak editTextViewController] text in
            self?.screenViewModel.action.createComment(withText: text, parentId: self?.parentComment?.id)
            self?.parentComment = nil
            self?.commentComposeBarView.resetState()
            editTextViewController?.dismiss(animated: true, completion: nil)
        }
        editTextViewController.dismissHandler = { [weak self, weak editTextViewController] in
            let alertTitle = (self?.parentComment == nil) ? EkoLocalizedStringSet.PostDetail.discardCommentTitle.localizedString : EkoLocalizedStringSet.PostDetail.discardReplyTitle.localizedString
            let alertMessage = (self?.parentComment == nil) ? EkoLocalizedStringSet.PostDetail.discardCommentMessage.localizedString : EkoLocalizedStringSet.PostDetail.discardReplyMessage.localizedString
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil)
            let discardAction = UIAlertAction(title: EkoLocalizedStringSet.discard.localizedString, style: .destructive) { _ in
                editTextViewController?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(discardAction)
            editTextViewController?.present(alertController, animated: true, completion: nil)
        }
        let navigationController = UINavigationController(rootViewController: editTextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func composeView(_ view: EkoPostDetailCompostView, didPostText text: String) {
        screenViewModel.action.createComment(withText: text, parentId: parentComment?.id)
        parentComment = nil
        commentComposeBarView.resetState()
    }
    
}

// MARK: - EkoKeyboardServiceDelegate
extension EkoPostDetailViewController: EkoKeyboardServiceDelegate {
    
    func keyboardWillChange(service: EkoKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        commentComposeBarBottomConstraint.constant = -height + offset
        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
    }
    
}

extension EkoPostDetailViewController: EkoExpandableLabelDelegate {
    
    public func expandableLabeldidTap(_ label: EkoExpandableLabel) {
        // Internally left empty
    }
    
    public func willExpandLabel(_ label: EkoExpandableLabel) {
        tableView.beginUpdates()
    }
    
    public func didExpandLabel(_ label: EkoExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath?,
           case .comment(let comment) = screenViewModel.dataSource.item(at: indexPath) {
            expandedIds.append(comment.id)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
    public func willCollapseLabel(_ label: EkoExpandableLabel) {
        tableView.beginUpdates()
    }
    
    public func didCollapseLabel(_ label: EkoExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath?,
           case .comment(let comment) = screenViewModel.dataSource.item(at: indexPath) {
            expandedIds = expandedIds.filter({ $0 != comment.id })
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
}

extension EkoPostDetailViewController: EkoCommentTableViewCellDelegate {
    
    func commentCellDidTapAvatar(_ cell: EkoCommentTableViewCell, userId: String) {
        EkoEventHandler.shared.userDidTap(from: self, userId: userId)
    }
    
    func commentCellDidTapReadMore(_ cell: EkoCommentTableViewCell) {
        //
    }
    
    func commentCellDidTapLike(_ cell: EkoCommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        switch screenViewModel.item(at: indexPath) {
        case .comment(let comment), .replyComment(let comment):
            if comment.isLiked {
                screenViewModel.action.unlikeComment(withCommendId: comment.id)
            } else {
                screenViewModel.action.likeComment(withCommendId: comment.id)
            }
        case .post, .loadMoreReply:
            break
        }
    }
    
    func commentCellDidTapReply(_ cell: EkoCommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            case .comment(let comment) = screenViewModel.item(at: indexPath) else { return }
        parentComment = comment
        _ = commentComposeBarView.becomeFirstResponder()
    }
    
    func commentCellDidTapOption(_ cell: EkoCommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        switch screenViewModel.item(at: indexPath) {
        case .comment(let comment), .replyComment(let comment):
            presentOptionBottomSheet(comment: comment)
        case .post, .loadMoreReply:
            break
        }
    }
    
    private func presentOptionBottomSheet(comment: EkoCommentModel) {
        // Comment options
        if comment.isOwner {
            let bottomSheet = BottomSheetViewController()
            let contentView = ItemOptionView<TextItemOption>()
            bottomSheet.sheetContentView = contentView
            bottomSheet.isTitleHidden = true
            bottomSheet.modalPresentationStyle = .overFullScreen
            
            let editOptionTitle = comment.isParent ? EkoLocalizedStringSet.PostDetail.editComment.localizedString : EkoLocalizedStringSet.PostDetail.editReply.localizedString
            let deleteOptionTitle = comment.isParent ? EkoLocalizedStringSet.PostDetail.deleteComment.localizedString : EkoLocalizedStringSet.PostDetail.deleteReply.localizedString
            
            let editOption = TextItemOption(title: editOptionTitle) { [weak self] in
                guard let strongSelf = self else { return }
                let editTextViewController = EkoEditTextViewController.make(message: comment.text, editMode: .edit)
                editTextViewController.title = comment.isParent ? EkoLocalizedStringSet.PostDetail.editComment.localizedString : EkoLocalizedStringSet.PostDetail.editReply.localizedString
                editTextViewController.editHandler = { [weak self] text in
                    self?.screenViewModel.action.editComment(with: comment, text: text)
                    editTextViewController.dismiss(animated: true, completion: nil)
                }
                editTextViewController.dismissHandler = { [weak editTextViewController] in
                    let alertTitle = comment.isParent ? EkoLocalizedStringSet.PostDetail.discardCommentTitle.localizedString : EkoLocalizedStringSet.PostDetail.discardReplyTitle.localizedString
                    let alertMessage = comment.isParent ? EkoLocalizedStringSet.PostDetail.discardEditedCommentMessage.localizedString : EkoLocalizedStringSet.PostDetail.discardEditedReplyMessage.localizedString
                    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil)
                    let discardAction = UIAlertAction(title: EkoLocalizedStringSet.discard.localizedString, style: .destructive) { _ in
                        editTextViewController?.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(cancelAction)
                    alertController.addAction(discardAction)
                    editTextViewController?.present(alertController, animated: true, completion: nil)
                }
                let nvc = UINavigationController(rootViewController: editTextViewController)
                nvc.modalPresentationStyle = .fullScreen
                strongSelf.present(nvc, animated: true, completion: nil)
            }
            let deleteOption = TextItemOption(title: deleteOptionTitle) { [weak self] in
                let alertTitle = comment.isParent ? EkoLocalizedStringSet.PostDetail.deleteCommentTitle.localizedString : EkoLocalizedStringSet.PostDetail.deleteReplyTitle.localizedString
                let alertMessage = comment.isParent ? EkoLocalizedStringSet.PostDetail.deleteCommentMessage.localizedString : EkoLocalizedStringSet.PostDetail.deleteReplyMessage.localizedString
                let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.delete.localizedString, style: .destructive) { [weak self] _ in
                    self?.screenViewModel.action.deleteComment(with: comment)
                })
                self?.present(alert, animated: true, completion: nil)
            }
            
            contentView.configure(items: [editOption, deleteOption], selectedItem: nil)
            present(bottomSheet, animated: false, completion: nil)
        } else {
            // get report status for comment and then trigger didReceiveCommentReportStatus on delegate
            screenViewModel.action.getCommentReportStatus(with: comment)
        }
    }
    
}
