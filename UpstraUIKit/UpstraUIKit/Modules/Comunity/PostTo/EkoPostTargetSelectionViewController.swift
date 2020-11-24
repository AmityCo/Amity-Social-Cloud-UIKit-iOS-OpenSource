//
//  EkoPostTargetSelectionViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 31/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

protocol EkoPostTargetSelectionViewControllerDelegate: class {
    func postTargetSelectionViewController(_ viewController: EkoPostTargetSelectionViewController, didCreatePost post: EkoPostModel)
    func postTargetSelectionViewController(_ viewController: EkoPostTargetSelectionViewController, didUpdatePost post: EkoPostModel)
}

final public class EkoPostTargetSelectionViewController: EkoViewController {
    
    weak var delegate: EkoPostTargetSelectionViewControllerDelegate?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let screenViewModel = EkoPostToScreenViewModel()
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        title = EkoLocalizedStringSet.postToTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func make() -> EkoPostTargetSelectionViewController {
        return EkoPostTargetSelectionViewController()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupScreenViewModel()
    }
    
    private func setupView() {
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(EkoCommunityTableViewCell.nib, forCellReuseIdentifier: EkoCommunityTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func setupScreenViewModel() {
        screenViewModel.delegate = self
        screenViewModel.observe()
    }
    
}

extension EkoPostTargetSelectionViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return screenViewModel.numberOfItems()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EkoCommunityTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if indexPath.section == 0 {
            cell.configure(with: .myFeed)
        } else if let item = screenViewModel.dataSource.community(at: indexPath) {
            cell.configure(with: .community(item))
        }
        if tableView.isBottomReached {
            screenViewModel.loadNext()
        }
        return cell
    }
    
}

extension EkoPostTargetSelectionViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 72 : 56
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return screenViewModel.numberOfItems() > 0 ? 44 : 0
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 44))
        headerView.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 16.0, y: 0.0, width: headerView.frame.width - 32.0, height: 44))
        label.text = EkoLocalizedStringSet.myCommunityTitle
        label.textColor = EkoColorSet.base.blend(.shade3)
        label.font = EkoFontSet.body
        headerView.addSubview(label)
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var postType: EkoPostTarget
        if indexPath.section == 0 {
            postType = .myFeed
        } else {
            guard let community = screenViewModel.community(at: indexPath) else { return }
            postType = .community(object: community)
        }

        let vc = EkoPostTextEditorViewController.make(postTarget: postType)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EkoPostTargetSelectionViewController: EkoPostToScreenViewModelDelegate {
    
    func screenViewModelDidUpdateItems(_ viewModel: EkoPostToScreenViewModel) {
        tableView.reloadData()
    }
    
}

extension EkoPostTargetSelectionViewController: EkoPostViewControllerDelegate {
    
    public func postViewController(_ viewController: UIViewController, didCreatePost post: EkoPostModel) {
        delegate?.postTargetSelectionViewController(self, didCreatePost: post)
    }
    
    public func postViewController(_ viewController: UIViewController, didUpdatePost post: EkoPostModel) {
        delegate?.postTargetSelectionViewController(self, didUpdatePost: post)
    }
    
}
