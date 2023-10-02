//
//  AmitySelectCategoryListViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 2/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK

public class AmityCategoryPickerViewController: AmityViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    private var doneBarButtonItem: UIBarButtonItem!
    private let screenViewModel = AmityCategoryPickerScreenViewModel()
    
    // A `referenceCategoryId` uses for validating selection state.
    // If the value changes, done button will be enable.
    private let referenceCategoryId: String?
    private var selectedCategory: AmityCommunityCategory?
    
    // This handler will be triggerd every time we tapping the cell.
    var selectionHandler: ((AmityCommunityCategory) -> Void)?
    
    // Completion only works for selection type list.
    // Get called by tapping done button.
    var completionHandler: ((AmityCommunityCategory?) -> Void)?
    
    // MARK: - Initializer
    
    private init(referenceCategoryId: String?) {
        self.referenceCategoryId = referenceCategoryId
        super.init(nibName: AmityCategoryPickerViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = AmityLocalizedStringSet.categorySelectionTitle.localizedString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make(referenceCategoryId: String? = nil) -> AmityCategoryPickerViewController {
        return AmityCategoryPickerViewController(referenceCategoryId: referenceCategoryId)
    }
    
    // MARK: - View's life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenViewModel()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Private functions
    
    private func setupNavigationBar() {
        doneBarButtonItem = UIBarButtonItem(title: AmityLocalizedStringSet.General.done.localizedString, style: .done, target: self, action: #selector(doneButtonTap))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        updateNavigationBarState()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(AmityCategorySeletionTableViewCell.nib, forCellReuseIdentifier: AmityCategorySeletionTableViewCell.identifier)
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

extension AmityCategoryPickerViewController: UITableViewDataSource {
    
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

extension AmityCategoryPickerViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AmityCategorySeletionTableViewCell else { return }
        if let item = screenViewModel.item(at: indexPath) {
            cell.configure(category: item, shouldSelectionEnable: true)
            
            if selectedCategory?.categoryId == item.categoryId || referenceCategoryId == item.categoryId {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = screenViewModel.item(at: indexPath) else { return }
        selectedCategory = item
        updateNavigationBarState()
        selectionHandler?(item)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AmityCommunityTableViewCell.defaultHeight
    }
    
}

extension AmityCategoryPickerViewController: AmityCategoryPickerScreenViewModelDelegate {
    
    func screenViewModelDidUpdateData(_ viewModel: AmityCategoryPickerScreenViewModel) {
        tableView.reloadData()
    }
    
}

