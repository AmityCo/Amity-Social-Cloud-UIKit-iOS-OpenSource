//
//  AmityCategorySelectionViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 24/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK
import UIKit

enum EkoCategoryListType {
    case view
    case selection(referenceId: String?)
}

class EkoCategoryListViewController: AmityViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    private var doneBarButtonItem: UIBarButtonItem!
    
    private let screenViewModel = EkoCategorySelectionScreenViewModel()
    private let listType: EkoCategoryListType
    
    // A `referenceCategoryId` uses for validating selection state.
    // If the value changes, done button will be enable.
    private var referenceCategoryId: String?
    private var selectedCategory: AmityCommunityCategory?
    
    // This handler will be triggerd every time we tapping the cell.
    var selectionHandler: ((AmityCommunityCategory) -> Void)?
    
    // Completion only works for selection type list.
    // Get called by tapping done button.
    var completionHandler: ((AmityCommunityCategory?) -> Void)?
    
    // MARK: - Initializer
    
    private init(listType: EkoCategoryListType) {
        self.listType = listType
        super.init(nibName: EkoCategoryListViewController.identifier, bundle: UpstraUIKit.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(listType: EkoCategoryListType) -> EkoCategoryListViewController {
        let vc = EkoCategoryListViewController(listType: listType)
        return vc
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        setupScreenViewModel()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Private functions
    
    private func prepareData() {
        if case .selection(let referenceId) = listType {
            referenceCategoryId = referenceId
        }
    }
    
    private func setupNavigationBar() {
        if case .selection = listType {
            title = AmityLocalizedStringSet.categorySelectionTitle
            doneBarButtonItem = UIBarButtonItem(title: AmityLocalizedStringSet.done, style: .done, target: self, action: #selector(doneButtonTap))
            navigationItem.rightBarButtonItem = doneBarButtonItem
            updateNavigationBarState()
        } else {
            title = AmityLocalizedStringSet.createCommunityCategoryTitle
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(EkoCategorySeletionTableViewCell.nib, forCellReuseIdentifier: EkoCategorySeletionTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
    }
    
    private func updateNavigationBarState() {
        let isSelected = selectedCategory != nil
        let isValueChange = selectedCategory?.categoryId != referenceCategoryId
        doneBarButtonItem.isEnabled = isSelected && isValueChange
    }
    
    @objc private func doneButtonTap() {
        completionHandler?(selectedCategory)
        dismiss(animated: true, completion: nil)
    }

}

extension EkoCategoryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EkoCategorySeletionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if tableView.isBottomReached {
            screenViewModel.loadNext()
        }
        return cell
    }
    
}

extension EkoCategoryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EkoCategorySeletionTableViewCell else { return }
        let item = screenViewModel.item(at: indexPath)!
        
        switch listType {
        case .view:
            cell.configure(category: item, shouldSelectionEnable: false)
        case .selection:
            cell.configure(category: item, shouldSelectionEnable: true)
        }
        
        if selectedCategory?.categoryId == item.categoryId || referenceCategoryId == item.categoryId {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = screenViewModel.item(at: indexPath) else { return }
        if case .selection = listType {
            selectedCategory = item
            updateNavigationBarState()
        } else {
            let vc = EkoCategoryDetailViewController.make(categoryId: item.categoryId, title: item.name)
            navigationController?.pushViewController(vc, animated: true)
        }
        selectionHandler?(item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AmityCommunityTableViewCell.defaultHeight
    }
    
}

extension EkoCategoryListViewController: EkoCategorySelectionScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: EkoCategorySelectionScreenViewModel) {
        tableView.reloadData()
    }
    
}
