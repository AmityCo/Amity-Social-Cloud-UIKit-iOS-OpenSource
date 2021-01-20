//
//  EkoSearchViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 20/9/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit
private class EmptyView: UIView {
    var text: String? {
        didSet {
            label.text = text
        }
    }
    private var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = EkoColorSet.base.blend(.shade3)
        label.font = EkoFontSet.title
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 44 + 100),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
        ])
    }
}

class EkoSearchViewController: EkoViewController {
    enum SearchType {
        case inTableView
        case inNavigationBar
    }

    var searchTextDidChangeHandler: ((String) -> Void)?
    var searchActionHandler: ((String) -> Void)?
    var numberOfSectionsHandler: (() -> Int)?
    var numberOfRowHandler: ((Int) -> Int)?
    var cellForRowHandler: ((UITableView, IndexPath) -> UITableViewCell)?
    var selectedItemHandler: ((IndexPath) -> Void)?
    var searchCancelHandler: (() -> Void)?
    
    // MARK: - Properties
    var tableView = UITableView(frame: .zero, style: .plain)
    private var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    private var emptyView: EmptyView = EmptyView()
    var emptyText: String? {
        didSet {
            emptyView.text = emptyText
        }
    }
    
    var isSearch: Bool = false
    
    let searchType: SearchType
    private var searchTask: DispatchWorkItem?
    private let viewController: UIViewController?
    private let duration: TimeInterval
    
    init(for viewController: UIViewController?, duration: TimeInterval = 0.2, searchType: SearchType) {
        self.viewController = viewController
        self.duration = duration
        self.searchType = searchType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if searchType == .inNavigationBar {
            navigationController?.setBackgroundColor(with: .white)
        }
        navigationBarType = (searchType == .inNavigationBar) ? .custom : .push
    }
    
    private func setupView() {
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = EkoLocalizedStringSet.search.localizedString
        searchController.searchBar.tintColor = EkoColorSet.base
        searchController.searchBar.returnKeyType = .done
        
        (searchController.searchBar.value(forKey: "cancelButton") as? UIButton)?.tintColor = EkoColorSet.base
        
        if #available(iOS 13, *) {
            searchController.searchBar.searchTextField.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        } else {
            if let textField = (searchController.searchBar.value(forKey: "searchField") as? UITextField) {
                textField.backgroundColor = EkoColorSet.secondary.blend(.shade4)
                textField.tintColor = EkoColorSet.base
            }
        }
        
        if searchType == .inNavigationBar {
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.setShowsCancelButton(true, animated: true)
            navigationItem.titleView = searchController.searchBar
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            searchController.searchBar.backgroundImage = UIImage()
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.backgroundColor = EkoColorSet.backgroundColor
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        
        if searchType == .inTableView {
            tableView.tableHeaderView = searchController.searchBar
            tableView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        }
        
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    func showSearchBar() {
        let nav = UINavigationController(rootViewController: self)
        nav.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        viewController?.view.window?.layer.add(transition, forKey: kCATransition)
        viewController?.present(nav, animated: false, completion: nil)
        
    }
    
    func hideSearchBar() {
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = .fade
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false, completion: nil)
    }
}

extension EkoSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numberOfData = numberOfRowHandler?(indexPath.section) ?? 0
        guard numberOfData != 0 else { return }

        tableView.deselectRow(at: indexPath, animated: true)
        selectedItemHandler?(indexPath)
    }
}

extension EkoSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSectionsHandler?() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfData = numberOfRowHandler?(section) ?? 0
        if isSearch {
            tableView.setEmptyView(with: emptyView, with: numberOfData)
        } else {
            tableView.backgroundView = nil
        }
        return numberOfData
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cellForRowHandler?(tableView, indexPath) else {
            fatalError("TableView must register cell")
        }
        return cell
    }
}

extension EkoSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = searchText != ""
        searchTask?.cancel()
        let request = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.searchTextDidChangeHandler?(searchText)
        }
        searchTask = request
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: request)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchType == .inTableView {
            searchController.searchBar.setShowsCancelButton(false, animated: true)
        } else {
            searchController.isActive = false
        }
        hideSearchBar()
        searchCancelHandler?()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchType == .inTableView {
            searchController.searchBar.setShowsCancelButton(true, animated: true)
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchActionHandler?(searchText)
        searchBar.resignFirstResponder()
    }
}
