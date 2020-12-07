//
//  EkoTrendingCommunityViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public final class EkoTrendingCommunityViewController: UIViewController, EkoRefreshable {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var heightTableViewContraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let screenViewModel: EkoTrendingCommunityScreenViewModelType
    
    // MARK: - Callback
    public var selectedCommunityHandler: ((EkoCommunityModel) -> Void)?
    
    // MARK: - View lifecycle
    private init(viewModel: EkoTrendingCommunityScreenViewModelType) {
        self.screenViewModel = viewModel
        super.init(nibName: EkoTrendingCommunityViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
    }
    
    public static func make() -> EkoTrendingCommunityViewController {
        let viewModel: EkoTrendingCommunityScreenViewModelType = EkoTrendingCommunityScreenViewModel()
        return EkoTrendingCommunityViewController(viewModel: viewModel)
    }
    
    // MARK: - Refreshahble
    
    func handleRefreshing() {
        screenViewModel.action.getTrending()
    }
    
}

// MARK: - Setup View
private extension EkoTrendingCommunityViewController {
    func setupView() {
        setupTitle()
        setupTableView()
    }
    
    func setupTitle() {
        titleLabel.text = EkoLocalizedStringSet.trendingCommunityTitle
        titleLabel.textColor = EkoColorSet.base
        titleLabel.font = EkoFontSet.title
    }
    
    func setupTableView() {
        tableView.register(EkoTrendingCommunityTableViewCell.nib, forCellReuseIdentifier: EkoTrendingCommunityTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
    }
}

// MARK: - Binding ViewModel
private extension EkoTrendingCommunityViewController {
    func bindingViewModel() {
        screenViewModel.action.getTrending()
        screenViewModel.dataSource.community.bind { [weak self] (communities) in
            self?.heightTableViewContraint.constant = CGFloat(communities.count * 56)
            self?.tableView.reloadData()
        }
    }
}


extension EkoTrendingCommunityViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = screenViewModel.dataSource.item(at: indexPath) else { return }
        selectedCommunityHandler?(item)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

extension EkoTrendingCommunityViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.community.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkoTrendingCommunityTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoTrendingCommunityTableViewCell {
            guard let item = screenViewModel.dataSource.item(at: indexPath) else { return }
            cell.display(with: item)
            cell.displayNumber(with: indexPath)
        }
    }
}
