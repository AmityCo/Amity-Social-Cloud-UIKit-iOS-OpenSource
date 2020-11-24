//
//  EkoSeachCommunitiesViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 23/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoSearchCommunityViewController: EkoSearchViewController {
    
    private let viewModel = EkoSearchCommunitiesViewModel()
    private var router: EkoSearchCommunitiesRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = EkoSearchCommunitiesRouter(viewController: self, viewModel: viewModel)
        emptyText = EkoLocalizedStringSet.searchCommunityNotFound
        
        
        tableView.register(EkoMyCommunityTableViewCell.nib, forCellReuseIdentifier: EkoMyCommunityTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset.left = view.frame.width

        cellForRow { [weak self] (tableView, indexPath) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: EkoMyCommunityTableViewCell.identifier, for: indexPath)
            self?.configure(tableView, for: cell, at: indexPath)
            return cell
        }
        
        selectedItem ({ [weak self] (indexPath) in
            guard let self = self else { return }
            self.router.route(to: .communityProfile(indexPath: indexPath))
        })
        
        numberOfRow { [weak self] section in
            guard let self = self else { return 0 }
            return self.viewModel.numberOfItem()
        }
        
        textDidChange { [weak self] text in
            self?.viewModel.search(with: text) {
                self?.tableView.reloadData()
            }
        }
        
        searchCancel { [weak self] in
            self?.viewModel.clear()
            self?.tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.layoutIfNeeded()
        navigationController?.view.layoutSubviews()
    }
    
    private func configure(_ tableView: UITableView, for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoMyCommunityTableViewCell {
            let community = viewModel.community(at: indexPath)
            cell.display(with: community)
            if tableView.isBottomReached {
                viewModel.loadMore()
            }
        }
    }
}
