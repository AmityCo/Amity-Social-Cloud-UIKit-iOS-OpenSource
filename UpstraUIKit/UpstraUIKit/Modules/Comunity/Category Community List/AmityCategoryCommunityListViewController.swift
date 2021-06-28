//
//  AmityCategoryCommunityListViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

/// A view controller for providing category community list.
public class AmityCategoryCommunityListViewController: AmityViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var screenViewModel: AmityCategoryCommunityListScreenViewModelType
    
    // MARK: - Initializer
    
    private init(categoryId: String) {
        screenViewModel = AmityCategoryCommunityListScreenViewModel(categoryId: categoryId)
        super.init(nibName: AmityCategoryCommunityListViewController.identifier, bundle: AmityUIKitManager.bundle)
        screenViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make(categoryId: String) -> AmityCategoryCommunityListViewController {
        return AmityCategoryCommunityListViewController(categoryId: categoryId)
    }
    
    // MARK: - View's life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(AmityMyCommunityTableViewCell.nib, forCellReuseIdentifier: AmityMyCommunityTableViewCell.identifier)
        tableView.register(AmityEmptyStateHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: AmityEmptyStateHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func communityDidTap(at indexPath: IndexPath) {
        guard let community = screenViewModel.dataSource.item(at: indexPath) else { return }
        AmityEventHandler.shared.communityDidTap(from: self, communityId: community.communityId)
    }
}

extension AmityCategoryCommunityListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AmityMyCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let community = screenViewModel.dataSource.item(at: indexPath) {
            cell.display(with: community)
            cell.delegate = self
        }
        if tableView.isBottomReached {
            screenViewModel.loadNext()
        }
        return cell
    }
    
}

extension AmityCategoryCommunityListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        communityDidTap(at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AmityMyCommunityTableViewCell.defaultHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let bottomView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AmityEmptyStateHeaderFooterView.identifier) as? AmityEmptyStateHeaderFooterView else {
            return nil
        }
        let emptyView = AmityCategoryCommunityListViewEmptyView()
        bottomView.setLayout(layout: .custom(emptyView))
        return bottomView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return screenViewModel.numberOfItems() > 0 ? 0 : tableView.frame.height
    }
    
}

extension AmityCategoryCommunityListViewController: AmityCategoryCommunityListScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: AmityCategoryCommunityListScreenViewModelType) {
        tableView?.reloadData()
    }
    
}

// MARK: - AmityMyCommunityTableViewCellDelegate
extension AmityCategoryCommunityListViewController: AmityMyCommunityTableViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: AmityMyCommunityTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        communityDidTap(at: indexPath)
    }
}
