//
//  EkoSettingsTableView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 6/3/2564 BE.
//  Copyright © 2564 BE Upstra. All rights reserved.
//


import UIKit

protocol EkoSettingsItemTableViewDelegate: class {
    func didPerformAction(item: EkoSettingsItem)
}

final class EkoSettingsItemTableView: UITableView {
    
    // MARK: - Property
    private let emptyView = EkoEmptyView()
    
    // MARK: - Callback
    var actionHandler: ((EkoSettingsItem) -> Void)?
    var settingsItems: [EkoSettingsItem] = [] {
        didSet {
            reloadData()
        }
    }
    var isEmptyViewHidden: Bool = false {
        didSet {
            backgroundView = isEmptyViewHidden ? nil : emptyView
        }
    }
    
    // MARK: - Initial
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        register(cell: EkoSettingsItemHeaderContentTableViewCell.self)
        register(cell: EkoSettingsItemSeparatorContentTableViewCell.self)
        register(cell: EkoSettingsItemTextContentTableViewCell.self)
        register(cell: EkoSettingsItemNavigationContentTableViewCell.self)
        register(cell: EkoSettingsItemToggleContentTableViewCell.self)
        register(cell: EkoSettingsItemRadioButtonContentTableViewCell.self)
        tableFooterView = UIView()
        separatorColor = .clear
        delegate = self
        dataSource = self
    }
    
    func updateEmptyView(title: String, subtitle: String? = nil, image: UIImage?) {
        emptyView.update(title: title, subtitle: subtitle, image: image)
    }

}
// MARK: - UITableViewDelegate
extension EkoSettingsItemTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !settingsItems.isEmpty else { return }
        let settingItem = settingsItems[indexPath.row]
        switch settingItem {
        case .textContent, .navigationContent, .radioButtonContent:
            actionHandler?(settingItem)
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension EkoSettingsItemTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingItems = settingsItems[indexPath.row]
        switch settingItems {
        case .header(let content):
            let cell: EkoSettingsItemHeaderContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            return cell
        case .separator:
            let cell: EkoSettingsItemSeparatorContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .textContent(let content):
            let cell: EkoSettingsItemTextContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            return cell
        case .navigationContent(let content):
            let cell: EkoSettingsItemNavigationContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            return cell
        case .toggleContent(let content):
            let cell: EkoSettingsItemToggleContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            cell.delegate = self
            return cell
        case .radioButtonContent(let content):
            let cell: EkoSettingsItemRadioButtonContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            return cell
        }
    }
    
}

extension EkoSettingsItemTableView: EkoSettingsItemToggleContentCellDelegate {
    func didPerformActionToggleContent(withContent content: EkoSettingsItem.ToggleContent) {
        actionHandler?(EkoSettingsItem.toggleContent(content: content))
    }
}
