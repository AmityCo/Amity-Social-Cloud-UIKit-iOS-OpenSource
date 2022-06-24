//
//  AmityTrendingCommunityViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 5/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import UIKit

public final class AmityTrendingCommunityViewController: UIViewController, AmityRefreshable {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var heightTableViewContraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var screenViewModel: AmityTrendingCommunityScreenViewModelType!
    private var tableViewHeight: CGFloat = 0 {
        didSet {
            heightTableViewContraint.constant = tableViewHeight
        }
    }
    
    // MARK: - Callback
    public var selectedCommunityHandler: ((AmityCommunity) -> Void)?
    public var emptyHandler: ((Bool) -> Void)?
    
    // MARK: - View lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        screenViewModel.delegate = self
        screenViewModel.action.retrieveTrending()
    }
    
    public static func make() -> AmityTrendingCommunityViewController {
        let trendingController = AmityCommunityTrendingController()
        let viewModel: AmityTrendingCommunityScreenViewModelType = AmityTrendingCommunityScreenViewModel(trendingController: trendingController)
        let vc = AmityTrendingCommunityViewController(nibName: AmityTrendingCommunityViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel  
        return vc
    }
    
    // MARK: - Refreshahble
    
    func handleRefreshing() {
        screenViewModel.action.retrieveTrending()
    }
}

// MARK: - Setup View
private extension AmityTrendingCommunityViewController {
    func setupView() {
        setupTitle()
        setupTableView()
    }
    
    func setupTitle() {
        titleLabel.text = AmityLocalizedStringSet.trendingCommunityTitle.localizedString
        titleLabel.textColor = AmityColorSet.base
        titleLabel.font = AmityFontSet.title
    }
    
    func setupTableView() {
        tableView.register(AmityTrendingCommunityTableViewCell.nib, forCellReuseIdentifier: AmityTrendingCommunityTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
    }
}

// MARK: - UITableViewDelegate
extension AmityTrendingCommunityViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community.object)
    }
}

// MARK: - UITableViewDataSource
extension AmityTrendingCommunityViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfTrending()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AmityTrendingCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let community = screenViewModel.dataSource.community(at: indexPath)
        cell.display(with: community)
        cell.displayNumber(with: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - AmityTrendingCommunityScreenViewModelDelegate
extension AmityTrendingCommunityViewController: AmityTrendingCommunityScreenViewModelDelegate {
    
    func screenViewModel(_ viewModel: AmityTrendingCommunityScreenViewModelType, didRetrieveTrending trending: [AmityCommunityModel], isEmpty: Bool) {
        emptyHandler?(isEmpty)
        tableViewHeight = 0
        heightTableViewContraint.constant = 0
        self.tableView.layoutIfNeeded()
        if AmityUIKitManager.AmityLanguage == "my" {
            heightTableViewContraint.constant = CGFloat(trending.count * 85)
        } else {
            heightTableViewContraint.constant = CGFloat(trending.count * 65)
        }
        self.tableView.layoutIfNeeded()
        tableView.reloadData()
    }
    
    func screenViewModel(_ viewModel: AmityTrendingCommunityScreenViewModelType, didFail error: AmityError) {
        emptyHandler?(true)
    }
    
    func didJoinFailure(error: AmityError) {
        
    }
    
    func didLeaveFailure(error: AmityError) {
    
    }

}


// MARK: - AmityTrendingCommunityTableViewCellDelegate
extension AmityTrendingCommunityViewController: AmityTrendingCommunityTableViewCellDelegate {
    func didJoin(with item: AmityCommunityModel) {
        screenViewModel.action.joinCommunity(community: item)
    }
    
    func didLeave(with item: AmityCommunityModel) {
        screenViewModel.action.leaveCommunity(community: item)
    }
    
    func cellDidTapOnAvatar(_ cell: AmityTrendingCommunityTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community.object)
    }
}
