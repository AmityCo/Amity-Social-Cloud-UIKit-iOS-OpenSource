//
//  EkoCommunityMemberViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 15/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

extension EkoCommunityMemberViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: EkoPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: pageTitle)
    }
}

final class EkoCommunityMemberViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private let pageTitle: String
    private let screenViewModel: EkoCommunityMemberScreenViewModelType
    // MARK: - View lifecycle
    init(pageTitle: String, viewModel: EkoCommunityMemberScreenViewModelType) {
        self.pageTitle = pageTitle
        self.screenViewModel = viewModel
        super.init(nibName: EkoCommunityMemberViewController.identifier, bundle: UpstraUIKit.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
    }
    
    static func make(pageTitle: String, viewModel: EkoCommunityMemberScreenViewModelType) -> EkoCommunityMemberViewController {
        let vc = EkoCommunityMemberViewController(pageTitle: pageTitle, viewModel: viewModel)
        return vc
    }

}

// MARK: - Setup view
private extension EkoCommunityMemberViewController {
    func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(EkoCommunityMemberSettingsTableViewCell.nib, forCellReuseIdentifier: EkoCommunityMemberSettingsTableViewCell.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = EkoColorSet.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Binding ViewModel
private extension EkoCommunityMemberViewController {
    func bindingViewModel() {
        screenViewModel.action.getMember()
        
        screenViewModel.dataSource.loading.bind { [weak self] (state) in
            switch state {
            case .loadmore:
                self?.tableView.showLoadingIndicator()
            case .loaded:
                self?.tableView.tableFooterView = nil
            default:
                break
            }
        }
        
        screenViewModel.dataSource.membership.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        screenViewModel.dataSource.cellAction.bind { [weak self] in
            guard let action = $0 else { return }
            switch action {
            case .option(let indexPath):
                let bottomSheet = BottomSheetViewController()
                let reportOption = TextItemOption(title: EkoLocalizedStringSet.communityMemberSettingsOptionsReport)
                let contentView = ItemOptionView<TextItemOption>()
                contentView.configure(items: [reportOption], selectedItem: nil)
                contentView.didSelectItem = { sheetAction in
                    bottomSheet.dismissBottomSheet {
                        if sheetAction == reportOption {
                            EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.reportSent))
                        }
                    }
                }
                bottomSheet.sheetContentView = contentView
                bottomSheet.isTitleHidden = true
                bottomSheet.modalPresentationStyle = .overFullScreen
                self?.present(bottomSheet, animated: false, completion: nil)
            }
        }
        
    }
}

// MARK: - UITableView Delegate
extension EkoCommunityMemberViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isBottomReached {
            screenViewModel.action.loadMore()
        }
    }
}

// MARK: - UITableView DataSource
extension EkoCommunityMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.dataSource.numberOfMembers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkoCommunityMemberSettingsTableViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UITableViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoCommunityMemberSettingsTableViewCell {
            guard let item = screenViewModel.dataSource.item(at: indexPath) else { return }
            cell.display(with: item)
            cell.setViewModel(with: screenViewModel)
            cell.setIndexPath(with: indexPath)
        }
    }
}
