//
//  EkoPostDetailViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 5/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

/// A view controller for providing post and relevant comments.
public class EkoPostDetailViewController: EkoViewController {
    
    var post: EkoPostModel? {
        return screenViewModel.post
    }
    
    private let postId: String
    private let screenViewModel: EkoPostDetailScreenViewModel
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let commentComposeBar = EkoPostDetailCompostView(frame: .zero)
    private var optionButton: UIBarButtonItem!
    private var commentComposeBarBottomConstraint: NSLayoutConstraint!
    private var selectedIndexPath: IndexPath?
    private var referenceId: String?
    private var expandedIds: [String] = []
    private var showReplyIds: [String] = []
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTableView()
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
    
    // MARK: - Initializer
    
    private init(postId: String) {
        self.postId = postId
        self.screenViewModel = EkoPostDetailScreenViewModel(postId: postId)
        super.init(nibName: nil, bundle: nil)
        title = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(postId: String) -> EkoPostDetailViewController {
        return EkoPostDetailViewController(postId: postId)
    }
    
    private func setupNavigationBar() {
        optionButton = UIBarButtonItem(image: EkoIconSet.iconOption, style: .plain, target: self, action: #selector(optionTap))
        optionButton.tintColor = EkoColorSet.base
        navigationItem.rightBarButtonItem = optionButton
    }
    
    private func setupView() {
        #warning("ViewController must be implemented with storyboard")
        view.backgroundColor = EkoColorSet.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = EkoColorSet.backgroundColor
        commentComposeBar.translatesAutoresizingMaskIntoConstraints = false
        commentComposeBar.setContentHuggingPriority(.defaultHigh, for: .vertical)
        commentComposeBar.delegate = self
        view.addSubview(tableView)
        view.addSubview(commentComposeBar)
        commentComposeBarBottomConstraint = commentComposeBar.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        screenViewModel.delegate = self
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentComposeBar.topAnchor),
            commentComposeBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentComposeBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentComposeBarBottomConstraint
        ])
    }
    
    private func setupTableView() {
        tableView.register(EkoPostDetailTableViewCell.nib, forCellReuseIdentifier: EkoPostDetailTableViewCell.identifier)
        tableView.register(EkoCommentTableViewCell.nib, forCellReuseIdentifier: EkoCommentTableViewCell.identifier)
        tableView.register(EkoPostDetailDeletedTableViewCell.nib, forCellReuseIdentifier: EkoPostDetailDeletedTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0.01
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func optionTap() {
        guard let post = screenViewModel.post else {
            assertionFailure("Post should not be nil")
            return
        }
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
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: EkoLocalizedStringSet.delete, style: .destructive, handler: { [weak self] _ in
                    self?.screenViewModel.deletePost()
                    self?.navigationController?.popViewController(animated: true)
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
    
}

extension EkoPostDetailViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch screenViewModel.item(at: indexPath.row) {
        case .post(let post):
            let cell: EkoPostDetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.actionDelegate = self
            cell.configureDetail(item: post)
            return cell
        case .comment(let comment):
            if comment.isDeleted {
                let cell: EkoPostDetailDeletedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configure(deletedAt: comment.updatedAt)
                return cell
            }
            
            let cell: EkoCommentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.labelDelegate = self
            cell.actionDelegate = self
            let shouldActionShow = post?.isCommentable ?? false
            let layout: EkoCommentViewLayout = .comment(contentExpanded: false, shouldActionShow: shouldActionShow, shouldLineShow: false)
            cell.configure(with: comment, layout: layout)
            return cell
        }
        #warning("show all replies will be implemented together with reply cell")
        //        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
        //        cell.textLabel?.text = EkoLocalizedStringSet.postDetailViewAllReplies
        //        cell.textLabel?.font = EkoFontSet.body
        //        cell.textLabel?.textColor = EkoColorSet.base.blend(.shade2)
        //        cell.selectionStyle = .none
        //        return cell
    }
    
}

extension EkoPostDetailViewController: EkoPostDetailScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: EkoPostDetailScreenViewModel) {
        tableView.reloadData()
        let bottomMostIndexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
        tableView.scrollToRow(at: bottomMostIndexPath, at: .bottom, animated: true)
        commentComposeBar.configure(with: post!)
    }
    
}

extension EkoPostDetailViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #warning("show all replies will be implemented together with reply cell")
        //        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == UITableViewCell.identifier,
        //            let commentId = screenViewModel.comment(at: indexPath.row)?.id {
        //            showReplyIds.append(commentId)
        //            tableView.reloadData()
        //        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.01))
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let isLastSection = (section == tableView.numberOfSections - 1)
        return isLastSection ? 0.0 : 1.0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: 0.0, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 1.0))
        separatorView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        return separatorView
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
            case .comment(let comment) = screenViewModel.item(at: indexPath.row) {
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
            case .comment(let comment) = screenViewModel.item(at: indexPath.row) {
            expandedIds = expandedIds.filter({ $0 != comment.id })
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    
}

extension EkoPostDetailViewController: EkoPostDetailTableViewCellDelegate {
    
    func postTableViewCellDidTapLike(_ cell: EkoPostDetailTableViewCell) {
        if post!.isLiked {
            screenViewModel.action.unlikePost(postId: post!.id)
        } else {
            screenViewModel.action.likePost(postId: post!.id)
        }
    }
    
    func postTableViewCellDidTapComment(_ cell: EkoPostDetailTableViewCell) {
        referenceId = nil
        _ = commentComposeBar.becomeFirstResponder()
    }
    
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, didUpdate: EkoPostModel) {
        // Intentionally left empty
    }
    
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, didTapDisplayName userId: String) {
        EkoEventHandler.shared.userDidTap(from: self, userId: userId)
    }
    
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, disTapCommunityName communityId: String) {
        EkoEventHandler.shared.communityDidTap(from: self, communityId: communityId)
    }
    
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, didTapImage image: EkoImage) {
        let viewController = EkoPhotoViewerController(referencedView: cell.imageView, imageModel: image)
        viewController.dataSource = cell
        viewController.delegate = cell
        present(viewController, animated: true, completion: nil)
    }
    
    func postTableViewCell(_ cell: EkoPostDetailTableViewCell, didTapFile file: EkoFile) {
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

    func postTableViewCellDidTapShare(_ cell: EkoPostDetailTableViewCell) {
        guard let post = post else { return }
        let postId = post.id

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

extension EkoPostDetailViewController: EkoPostViewControllerDelegate {
    
    public func postViewController(_ viewController: UIViewController, didCreatePost post: EkoPostModel) {
        // Internally left empty
    }
    
    public func postViewController(_ viewController: UIViewController, didUpdatePost post: EkoPostModel) {
        screenViewModel.updatePost(text: post.text ?? "")
    }
    
}

extension EkoPostDetailViewController: EkoKeyboardServiceDelegate {
    
    func keyboardWillChange(service: EkoKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        commentComposeBarBottomConstraint.constant = -height + offset
        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
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
        guard let indexPath = tableView.indexPath(for: cell),
            case .comment(let comment) = screenViewModel.item(at: indexPath.row) else { return }
        if comment.isLiked {
            screenViewModel.action.unlikeComment(commentId: comment.id)
        } else {
            screenViewModel.action.likeComment(commentId: comment.id)
        }
    }
    
    func commentCellDidTapReply(_ cell: EkoCommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            case .comment(let comment) = screenViewModel.item(at: indexPath.row) else { return }
        referenceId = comment.id
        commentComposeBar.becomeFirstResponder()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func commentCellDidTapOption(_ cell: EkoCommentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            case .comment(let comment) = screenViewModel.item(at: indexPath.row) else { return }
        referenceId = comment.id
        
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

extension EkoPostDetailViewController: EkoPostDetailCompostViewDelegate {
    
    func composeViewDidTapExpand(_ view: EkoPostDetailCompostView) {
        let editTextViewController = EkoEditTextViewController.make(message: commentComposeBar.text, editMode: .create)
        editTextViewController.editHandler = { [weak self, weak editTextViewController] text in
            self?.screenViewModel.action.createComment(text: text)
            editTextViewController?.dismiss(animated: true, completion: nil)
        }
        editTextViewController.dismissHandler = { [weak editTextViewController] in
            let alertController = UIAlertController(title: EkoLocalizedStringSet.postCreationDiscardPostTitle, message: EkoLocalizedStringSet.postCreationDiscardPostMessage, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .cancel, handler: nil)
            let discardAction = UIAlertAction(title: EkoLocalizedStringSet.discard, style: .destructive) { _ in
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
        screenViewModel.action.createComment(text: text)
        commentComposeBar.resetState()
    }
    
}
