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
    
    // MARK: - Callback
    public var selectedCommunityHandler: ((AmityCommunity) -> Void)?
    public var emptyHandler: ((Bool) -> Void)?
    private var estimatedHeight: CGFloat = 0 // Initial estimated height for 5 trending communities (5 x 56)
    
    struct Constant {
        // Cell height when category label is truncated
        static let cellHeightLabelTruncated: Double = 70
        // Cell height when category label is not truncated
        static let cellHeightLabelNormal: Double = 56
    }
    
    var heightCache: [IndexPath: Double] = [:]
    
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
        
        // Update the height cache. If the number of items becomes larger
        // in future, optimize this code to not update in case of already
        // cached height.
        heightCache[indexPath] = cell.isCategoryLabelTruncated ? Constant.cellHeightLabelTruncated : Constant.cellHeightLabelNormal
        updateTableViewHeight()
        
        return cell
    }
}

// MARK: - AmityTrendingCommunityScreenViewModelDelegate
extension AmityTrendingCommunityViewController: AmityTrendingCommunityScreenViewModelDelegate {

    func screenViewModel(_ viewModel: AmityTrendingCommunityScreenViewModelType, didRetrieveTrending trending: [AmityCommunityModel], isEmpty: Bool) {
        emptyHandler?(isEmpty)
        
        // Estimated height of tableview. It can differ based on category label truncation
        self.estimatedHeight = Double(trending.count) * Constant.cellHeightLabelNormal
        self.heightTableViewContraint.constant = self.estimatedHeight
        
        tableView.reloadData()
    }
    
    func updateTableViewHeight() {
        let finalHeight = heightCache.reduce(0) { partialResult, cacheItem in
            return partialResult + cacheItem.value
        }
        self.heightTableViewContraint.constant = finalHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.cellHeightLabelNormal
    }
    
    func screenViewModel(_ viewModel: AmityTrendingCommunityScreenViewModelType, didFail error: AmityError) {
        emptyHandler?(true)
    }
}

// MARK: - AmityTrendingCommunityTableViewCellDelegate
extension AmityTrendingCommunityViewController: AmityTrendingCommunityTableViewCellDelegate {
    func cellDidTapOnAvatar(_ cell: AmityTrendingCommunityTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let community = screenViewModel.dataSource.community(at: indexPath)
        selectedCommunityHandler?(community.object)
    }
}
