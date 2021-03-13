//
//  EkoCategoryCommunityListViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

/// A view controller for providing category community list.
public class EkoCategoryCommunityListViewController: EkoViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var screenViewModel: EkoCategoryCommunityListScreenViewModelType
    
    // MARK: - Initializer
    
    private init(categoryId: String) {
        screenViewModel = EkoCategoryCommunityListScreenViewModel(categoryId: categoryId)
        super.init(nibName: EkoCategoryCommunityListViewController.identifier, bundle: UpstraUIKitManager.bundle)
        screenViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make(categoryId: String) -> EkoCategoryCommunityListViewController {
        return EkoCategoryCommunityListViewController(categoryId: categoryId)
    }
    
    // MARK: - View's life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(EkoMyCommunityTableViewCell.nib, forCellReuseIdentifier: EkoMyCommunityTableViewCell.identifier)
        tableView.register(EkoEmptyStateHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: EkoEmptyStateHeaderFooterView.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension EkoCategoryCommunityListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EkoMyCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let community = screenViewModel.dataSource.item(at: indexPath) {
            cell.display(with: community)
        }
        if tableView.isBottomReached {
            screenViewModel.loadNext()
        }
        return cell
    }
    
}

extension EkoCategoryCommunityListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let community = screenViewModel.dataSource.item(at: indexPath) else { return }
        EkoEventHandler.shared.communityDidTap(from: self, communityId: community.communityId)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EkoMyCommunityTableViewCell.defaultHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let bottomView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EkoEmptyStateHeaderFooterView.identifier) as? EkoEmptyStateHeaderFooterView else {
            return nil
        }
        let emptyView = EkoCategoryCommunityListViewEmptyView()
        bottomView.setLayout(layout: .custom(emptyView))
        return bottomView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return screenViewModel.numberOfItems() > 0 ? 0 : tableView.frame.height
    }
    
}

extension EkoCategoryCommunityListViewController: EkoCategoryCommunityListScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: EkoCategoryCommunityListScreenViewModelType) {
        tableView?.reloadData()
    }
    
}
