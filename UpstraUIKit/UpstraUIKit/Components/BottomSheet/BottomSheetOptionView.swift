//
//  BottomSheetOptionView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 7/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

protocol ItemOption: Equatable {
    var tintColor: UIColor { get }
    var title: String { get }
    var textColor: UIColor { get }
    var completion: (() -> Void)? { get set }
}

struct TextItemOption: ItemOption {
    static func == (lhs: TextItemOption, rhs: TextItemOption) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    var tintColor: UIColor = EkoColorSet.base
    var textColor: UIColor = EkoColorSet.base
    var completion: (() -> Void)? = nil
}

final class ItemOptionView<T: ItemOption>: UIView, BottomSheetComponent, UITableViewDataSource, UITableViewDelegate {
    
    private var items: [T] = []
    private var selectedItem: T? = nil
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    var componentHeight: CGFloat { return contentHeight + bottomPadding }
    private let defaultCellHeight: CGFloat = 44
    private let bottomPadding: CGFloat = 16
    private var contentHeight: CGFloat = 0
    
    var didSelectItem: ((T) -> Void)?
    
    convenience init() {
        self.init(frame: .zero)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = EkoColorSet.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding)
        ])
    }
    
    func configure(items: [T], selectedItem: T?) {
        self.items = items
        self.selectedItem = selectedItem
        contentHeight = defaultCellHeight * CGFloat(items.count)
        tableView.reloadData()
    }
    
    // Table View DataSource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        cell.accessibilityIdentifier = item.title.lowercased().replacingOccurrences(of: " ", with: "_")
        cell.selectionStyle = .none
        cell.textLabel?.text = item.title
        cell.tintColor = item.tintColor
        cell.textLabel?.textColor = item.textColor
        cell.backgroundColor = EkoColorSet.backgroundColor
    }
    
    // Table View Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return defaultCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if let bottomSheet = parentViewController as? BottomSheetViewController {
            bottomSheet.dismissBottomSheet { [weak self] in
                item.completion?()
                self?.didSelectItem?(item)
            }
        } else {
            item.completion?()
            didSelectItem?(item)
        }
    }
    
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
