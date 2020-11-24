//
//  EkoSelectCategoryListViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 2/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
import EkoChat

class EkoSelectCategoryListViewController: EkoViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    private var doneBarButtonItem: UIBarButtonItem!
    private let screenViewModel = EkoSelectCategoryListScreenViewModel()
    
    // A `referenceCategoryId` uses for validating selection state.
    // If the value changes, done button will be enable.
    private let referenceCategoryId: String?
    private var selectedCategory: EkoCommunityCategory?
    
    // This handler will be triggerd every time we tapping the cell.
    var selectionHandler: ((EkoCommunityCategory) -> Void)?
    
    // Completion only works for selection type list.
    // Get called by tapping done button.
    var completionHandler: ((EkoCommunityCategory?) -> Void)?
    
    // MARK: - Initializer
    
    private init(referenceCategoryId: String?) {
        self.referenceCategoryId = referenceCategoryId
        super.init(nibName: EkoSelectCategoryListViewController.identifier, bundle: UpstraUIKit.bundle)
        title = EkoLocalizedStringSet.categorySelectionTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(referenceCategoryId: String? = nil) -> EkoSelectCategoryListViewController {
        return EkoSelectCategoryListViewController(referenceCategoryId: referenceCategoryId)
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenViewModel()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Private functions
    
    private func setupNavigationBar() {
        doneBarButtonItem = UIBarButtonItem(title: EkoLocalizedStringSet.done, style: .done, target: self, action: #selector(doneButtonTap))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        updateNavigationBarState()
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

extension EkoSelectCategoryListViewController: UITableViewDataSource {
    
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

extension EkoSelectCategoryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EkoCategorySeletionTableViewCell else { return }
        if let item = screenViewModel.item(at: indexPath) {
            cell.configure(category: item, shouldSelectionEnable: true)
            
            if selectedCategory?.categoryId == item.categoryId || referenceCategoryId == item.categoryId {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = screenViewModel.item(at: indexPath) else { return }
        selectedCategory = item
        updateNavigationBarState()
        selectionHandler?(item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EkoCommunityTableViewCell.defaultHeight
    }
    
}

extension EkoSelectCategoryListViewController: EkoSelectCategoryListScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: EkoSelectCategoryListScreenViewModel) {
        tableView.reloadData()
    }
    
}

