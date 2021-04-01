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
    private var screenViewModel: EkoTrendingCommunityScreenViewModelType!
    private var tableViewHeight: CGFloat = 0 {
        didSet {
            heightTableViewContraint.constant = tableViewHeight
        }
    }
    
    // MARK: - Callback
    public var selectedCommunityHandler: ((EkoCommunityModel) -> Void)?
    public var emptyHandler: ((Bool) -> Void)?
    
    // MARK: - View lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.delegate = self
        screenViewModel.action.retrieveTrending()
    }
    
    public static func make() -> EkoTrendingCommunityViewController {
        let trendingController = EkoCommunityTrendingController()
        let viewModel: EkoTrendingCommunityScreenViewModelType = EkoTrendingCommunityScreenViewModel(trendingController: trendingController)
        let vc = EkoTrendingCommunityViewController(nibName: EkoTrendingCommunityViewController.identifier, bundle: UpstraUIKitManager.bundle)
        vc.screenViewModel = viewModel  
        return vc
    }
    
    // MARK: - Refreshahble
    
    func handleRefreshing() {
        screenViewModel.action.retrieveTrending()
    }
}

// MARK: - Setup View
private extension EkoTrendingCommunityViewController {
    func setupView() {
        setupTitle()
        setupTableView()
    }
    
    func setupTitle() {
        titleLabel.text = EkoLocalizedStringSet.trendingCommunityTitle.localizedString
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

// MARK: - UITableViewDelegate
extension EkoTrendingCommunityViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community)
    }
}

// MARK: - UITableViewDataSource
extension EkoTrendingCommunityViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfTrending()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EkoTrendingCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let community = screenViewModel.dataSource.community(at: indexPath)
        cell.display(with: community)
        cell.displayNumber(with: indexPath)
        cell.delegate = self
        let cellHeight = cell.isCategoryLabelTruncated ? 70 : 56
        tableViewHeight += CGFloat(cellHeight)
        return cell
    }
}

// MARK: - EkoTrendingCommunityScreenViewModelDelegate
extension EkoTrendingCommunityViewController: EkoTrendingCommunityScreenViewModelDelegate {

    func screenViewModel(_ viewModel: EkoTrendingCommunityScreenViewModelType, didRetrieveTrending trending: [EkoCommunityModel], isEmpty: Bool) {
        emptyHandler?(isEmpty)
        tableViewHeight = 0
        heightTableViewContraint.constant = CGFloat(trending.count * 56)
        tableView.reloadData()
    }
    
    func screenViewModel(_ viewModel: EkoTrendingCommunityScreenViewModelType, didFail error: EkoError) {
        emptyHandler?(true)
    }

}

// MARK: - EkoTrendingCommunityTableViewCellDelegate
extension EkoTrendingCommunityViewController: EkoTrendingCommunityTableViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: EkoTrendingCommunityTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community)
    }
}
