//
//  AmitySettingsTableView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 6/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//


import UIKit

protocol AmitySettingsItemTableViewDelegate: AnyObject {
    func didPerformAction(item: AmitySettingsItem)
}

final class AmitySettingsItemTableView: UITableView {
    
    // MARK: - Property
    private let emptyView = AmityEmptyView()
    
    // MARK: - Callback
    var actionHandler: ((AmitySettingsItem) -> Void)?
    var settingsItems: [AmitySettingsItem] = [] {
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
        register(cell: AmitySettingsItemHeaderContentTableViewCell.self)
        register(cell: AmitySettingsItemSeparatorContentTableViewCell.self)
        register(cell: AmitySettingsItemTextContentTableViewCell.self)
        register(cell: AmitySettingsItemNavigationContentTableViewCell.self)
        register(cell: AmitySettingsItemToggleContentTableViewCell.self)
        register(cell: AmitySettingsItemRadioButtonContentTableViewCell.self)
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
extension AmitySettingsItemTableView: UITableViewDelegate {
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
extension AmitySettingsItemTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingItems = settingsItems[indexPath.row]
        switch settingItems {
        case .header(let content):
            let cell: AmitySettingsItemHeaderContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            return cell
        case .separator:
            let cell: AmitySettingsItemSeparatorContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .textContent(let content):
            let cell: AmitySettingsItemTextContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            return cell
        case .navigationContent(let content):
            let cell: AmitySettingsItemNavigationContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            return cell
        case .toggleContent(let content):
            let cell: AmitySettingsItemToggleContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            cell.delegate = self
            return cell
        case .radioButtonContent(let content):
            let cell: AmitySettingsItemRadioButtonContentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.display(content: content)
            return cell
        }
    }
    
}

extension AmitySettingsItemTableView: AmitySettingsItemToggleContentCellDelegate {
    func didPerformActionToggleContent(withContent content: AmitySettingsItem.ToggleContent) {
        actionHandler?(AmitySettingsItem.toggleContent(content: content))
    }
}
