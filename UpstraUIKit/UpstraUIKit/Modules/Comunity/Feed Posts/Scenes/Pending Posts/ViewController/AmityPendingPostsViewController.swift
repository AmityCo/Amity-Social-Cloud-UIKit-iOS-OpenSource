//
//  AmityPendingPostsViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 19/4/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

public class AmityPendingPostsViewController: AmityViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: AmityPostTableView!
    
    // MARK: - Properties
    private var screenViewModel: AmityPendingPostsScreenViewModelType!
    private let headerView = AmityPendingPostsHeaderView()
    private let emptyView = AmityPendingPostsEmptyView()
    
    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        
    }
    
    public static func make(communityId: String) -> AmityPendingPostsViewController {
        let viewModel = AmityPendingPostsScreenViewModel(communityId: communityId)
        let vc = AmityPendingPostsViewController(nibName: AmityPendingPostsViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        return vc
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewModel()
    }
    
    // MARK: - Setup ViewModel
    private func setupViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.getMemberStatus()
    }
    
    // MARK: - Setup views
    private func setupView() {
        title = AmityLocalizedStringSet.PendingPosts.title.localizedString
    }
    
    private func setupTableView()  {
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

extension AmityPendingPostsViewController: AmityPostTableViewDelegate {
    func tableView(_ tableView: AmityPostTableView, didSelectRowAt indexPath: IndexPath) {
        let singleComponent = screenViewModel.dataSource.postComponents(in: indexPath.section)
        let postId = singleComponent._composable.post.postId
        let vc = AmityPendingPostsDetailViewController.make(communityId: screenViewModel.dataSource.communityId, postId: postId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AmityPendingPostsViewController: AmityPostTableViewDataSource {
    
    func numberOfSections(in tableView: AmityPostTableView) -> Int {
        let numberOfPostComponents = screenViewModel.dataSource.numberOfPostComponents()
        if numberOfPostComponents > 0 {
            switch screenViewModel.dataSource.memberStatusCommunity {
            case .admin:
                tableView.setHeaderView(view: headerView)
            case .member, .guest:
                tableView.tableHeaderView = nil
            }
            emptyView.removeFromSuperview()
        } else {
            tableView.setEmptyView(view: emptyView)
        }
        return numberOfPostComponents
    }
    
    func tableView(_ tableView: AmityPostTableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfItemComponents(tableView, in: section)
    }
    
    func tableView(_ tableView: AmityPostTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleComponent = screenViewModel.dataSource.postComponents(in: indexPath.section)
        var cell: UITableViewCell
        if let clientComponent = tableView.feedDataSource?.getUIComponentForPost(post: singleComponent._composable.post, at: indexPath.section) {
            cell = clientComponent.getComponentCell(tableView, at: indexPath)
        } else {
            cell = singleComponent.getComponentCell(tableView, at: indexPath)
        }
        (cell as? AmityPostHeaderProtocol)?.delegate = self
        (cell as? AmityPendingPostsActionCellProtocol)?.delegate = self
        (cell as? AmityPostProtocol)?.delegate = self
        return cell
    }
        
}

extension AmityPendingPostsViewController: AmityPendingPostsScreenViewModelDelegate {
    
    func screenViewModel(_ viewModel: AmityPendingPostsScreenViewModelType, didGetMemberStatusCommunity status: AmityMemberStatusCommunity) {
        switch status {
        case .admin, .member:
            viewModel.action.getPendingPosts()
        case .guest:
            break
        }
        tableView.reloadData()
    }
    
    func screenViewModelDidGetPendingPosts(_ viewModel: AmityPendingPostsScreenViewModelType) {
        tableView.reloadData()
    }
    
    func screenViewModel(_ viewModel: AmityPendingPostsScreenViewModelType, didFail error: AmityError) {
        
    }
    
    func screenViewModelDidDeletePostFail(title: String, message: String) {
        AmityAlertController.present(title: title,
                                     message: message,
                                     actions: [.ok(style: .default, handler: nil)],
                                     from: self, completion: nil)
    }
}

extension AmityPendingPostsViewController: AmityPostHeaderDelegate {
    
    public func didPerformAction(_ cell: AmityPostHeaderProtocol, action: AmityPostHeaderAction) {
        guard let post = cell.post else { return }
        switch action {
        case .tapOption:
            let bottomSheet = BottomSheetViewController()
            let contentView = ItemOptionView<TextItemOption>()
            bottomSheet.sheetContentView = contentView
            bottomSheet.isTitleHidden = true
            bottomSheet.modalPresentationStyle = .overFullScreen
            
            let deleteOption = TextItemOption(title: AmityLocalizedStringSet.PostDetail.deletePost.localizedString) { [weak self] in
                let alert = UIAlertController(title: AmityLocalizedStringSet.PostDetail.deletePostTitle.localizedString, message: AmityLocalizedStringSet.PostDetail.deletePostMessage.localizedString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: AmityLocalizedStringSet.General.delete.localizedString, style: .destructive, handler: { _ in
                    self?.screenViewModel.action.deletePost(withPostId: post.postId)
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

extension AmityPendingPostsViewController: AmityPendingPostsActionCellDelegate {
    
    func performAction(_ cell: AmityPendingPostsActionCellProtocol, action: AmityPendingPostsAction) {
        guard let post = cell.post else { return }
        switch action {
        case .tapAccept:
            screenViewModel.action.approvePost(withPostId: post.postId)
        case .tapDecline:
            screenViewModel.action.declinePost(withPostId: post.postId)
        }
    }
    
}

extension AmityPendingPostsViewController: AmityPostDelegate {

    public func didPerformAction(_ cell: AmityPostProtocol, action: AmityPostAction) {
        switch action {
        case .didExpandExpandableLabel:
            return
        default:
            break
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let singleComponent = screenViewModel.dataSource.postComponents(in: indexPath.section)
        let postId = singleComponent._composable.post.postId
        let vc = AmityPendingPostsDetailViewController.make(communityId: screenViewModel.dataSource.communityId, postId: postId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
