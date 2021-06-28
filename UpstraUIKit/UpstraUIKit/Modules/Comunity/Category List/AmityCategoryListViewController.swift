//
//  AmityCategoryListViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import UIKit

public class AmityCategoryListViewController: AmityViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    private let screenViewModel = AmityCategoryListScreenViewModel()
    
    // MARK: - Initializer
    
    private init() {
        super.init(nibName: AmityCategoryListViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = AmityLocalizedStringSet.createCommunityCategoryTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> AmityCategoryListViewController {
        return AmityCategoryListViewController()
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenViewModel()
        setupTableView()
    }
    
    // MARK: - Private functions
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(AmityCategorySeletionTableViewCell.nib, forCellReuseIdentifier: AmityCategorySeletionTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
    }

}

extension AmityCategoryListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AmityCategorySeletionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if tableView.isBottomReached {
            screenViewModel.loadNext()
        }
        return cell
    }
    
}

extension AmityCategoryListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AmityCategorySeletionTableViewCell else { return }
        if let item = screenViewModel.item(at: indexPath) {
            cell.configure(category: item, shouldSelectionEnable: false)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = screenViewModel.item(at: indexPath) else { return }
        let vc = AmityCategoryCommunityListViewController.make(categoryId: item.categoryId)
        vc.title = item.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AmityCommunityTableViewCell.defaultHeight
    }
    
}

extension AmityCategoryListViewController: AmityCategoryListScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: AmityCategoryListScreenViewModel) {
        tableView.reloadData()
    }
    
}
