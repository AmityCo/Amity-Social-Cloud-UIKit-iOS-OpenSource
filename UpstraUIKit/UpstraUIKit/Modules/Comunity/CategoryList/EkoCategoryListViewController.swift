//
//  EkoCategoryListViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 24/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat
import UIKit

public class EkoCategoryListViewController: EkoViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    private let screenViewModel = EkoCategoryListScreenViewModel()
    
    // MARK: - Initializer
    
    private init() {
        super.init(nibName: EkoCategoryListViewController.identifier, bundle: UpstraUIKitManager.bundle)
        title = EkoLocalizedStringSet.createCommunityCategoryTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> EkoCategoryListViewController {
        return EkoCategoryListViewController()
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
        tableView.register(EkoCategorySeletionTableViewCell.nib, forCellReuseIdentifier: EkoCategorySeletionTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
    }

}

extension EkoCategoryListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EkoCategorySeletionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if tableView.isBottomReached {
            screenViewModel.loadNext()
        }
        return cell
    }
    
}

extension EkoCategoryListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EkoCategorySeletionTableViewCell else { return }
        if let item = screenViewModel.item(at: indexPath) {
            cell.configure(category: item, shouldSelectionEnable: false)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = screenViewModel.item(at: indexPath) else { return }
        let vc = EkoCategoryCommunityListViewController.make(categoryId: item.categoryId)
        vc.title = item.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EkoCommunityTableViewCell.defaultHeight
    }
    
}

extension EkoCategoryListViewController: EkoCategoryListScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: EkoCategoryListScreenViewModel) {
        tableView.reloadData()
    }
    
}
