//
//  BottomSheetOptionView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 7/8/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

protocol ItemOption: Equatable {
    var tintColor: UIColor { get }
    var title: String { get }
    var textColor: UIColor { get }
    var completion: (() -> Void)? { get set }
    var height: CGFloat { get set }
}

protocol ImageRepresentableOption {
    var image: UIImage? { get set }
    var imageBackgroundColor: UIColor? { get set }
}

struct TextItemOption: ItemOption {
    static func == (lhs: TextItemOption, rhs: TextItemOption) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    var tintColor: UIColor = AmityColorSet.base
    var textColor: UIColor = AmityColorSet.base
    var completion: (() -> Void)? = nil
    var height: CGFloat = 44.0
}

struct ImageItemOption: ItemOption, ImageRepresentableOption {
    
    static func == (lhs: ImageItemOption, rhs: ImageItemOption) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    var tintColor: UIColor = AmityColorSet.base
    var textColor: UIColor = AmityColorSet.base
    var image: UIImage?
    var imageBackgroundColor: UIColor?
    var completion: (() -> Void)?
    var height: CGFloat = 56.0
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
        backgroundColor = AmityColorSet.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ItemOptionTableViewCell.nib, forCellReuseIdentifier: ItemOptionTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = AmityColorSet.backgroundColor
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
        contentHeight = items.map({ $0.height }).reduce(0, +)
        tableView.reloadData()
    }
    
    // Table View DataSource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: ItemOptionTableViewCell.identifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ItemOptionTableViewCell else { return }
        let item = items[indexPath.row]
        cell.accessibilityIdentifier = item.title.lowercased().replacingOccurrences(of: " ", with: "_")
        cell.selectionStyle = .none
        cell.backgroundColor = AmityColorSet.backgroundColor
        cell.titleLabel.text = item.title
        cell.titleLabel.tintColor = item.tintColor
        cell.titleLabel.textColor = item.textColor
        cell.titleLabel.font = AmityFontSet.bodyBold
        
        if let imageItem = item as? ImageRepresentableOption {
            cell.iconImageView.image = imageItem.image
            cell.imageBackgroundView.isHidden = imageItem.image == nil
            cell.imageBackgroundView.backgroundColor = imageItem.imageBackgroundColor
        }
    }
    
    // Table View Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return items[indexPath.row].height
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
