//
//  NotificationTrayViewController.swift
//  AmityUIKit
//
//  Created by GuIDe'MacbookAmityHQ on 31/10/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

public final class NotificationTrayViewController: AmityViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    private let screenViewModel = NotificationTrayScreenViewModel()
    
    // MARK: - Initializer
    
    private init() {
        super.init(nibName: NotificationTrayViewController.identifier, bundle: AmityUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> NotificationTrayViewController {
        return NotificationTrayViewController()
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenViewModel()
        setupTableView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private functions
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(NotificationTrayTableViewCell.nib, forCellReuseIdentifier: NotificationTrayTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
    }

}

extension NotificationTrayViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationTrayTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//        if tableView.isBottomReached {
//            screenViewModel.loadNext()
//        }
        return cell
    }
    
}

extension NotificationTrayViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? NotificationTrayTableViewCell else { return }
        if let item = screenViewModel.item(at: indexPath) {
            cell.configure(model: item)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = screenViewModel.item(at: indexPath) else { return }
        screenViewModel.updateReadItem(model: item)
        AmityEventHandler.shared.postDidtap(from: self, postId: item.targetId ?? "")
    }
}

extension NotificationTrayViewController: NotificationTrayScreenViewModelDelegate {
    func screenViewModelDidUpdateData(_ viewModel: NotificationTrayScreenViewModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
