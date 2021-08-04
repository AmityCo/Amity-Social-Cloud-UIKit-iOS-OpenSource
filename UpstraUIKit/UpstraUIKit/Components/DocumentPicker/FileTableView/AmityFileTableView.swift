//
//  AmityFileTableView.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 28/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

protocol AmityFileTableViewDelegate: AnyObject {
    func fileTableView(_ view: AmityFileTableView, didTapAt index: Int)
    func fileTableViewDidDeleteData(_ view: AmityFileTableView, at index: Int)
    func fileTableViewDidUpdateData(_ view: AmityFileTableView)
    func fileTableViewDidTapViewAll(_ view: AmityFileTableView)
}

class AmityFileTableView: UITableView {
    
    private enum Constant {
        static let itemSapcing: CGFloat = 12.0
        static let footerHeight: CGFloat = 36.0
        static let footerLabelHight: CGFloat = 20
        static let limitItem: Int = 5
        static let topInset: CGFloat = 12
    }
    
    private(set) var files: [AmityFile] = []
    
    var isEditingMode: Bool = false {
        didSet {
            reloadData()
        }
    }
    
    weak var actionDelegate: AmityFileTableViewDelegate?
    var isExpanded: Bool = false {
        didSet {
            reloadData()
        }
    }
    
    private var shouldShowFooter: Bool {
        if isEditingMode {
            return false
        }
        return isExpanded ? false : files.count > Constant.limitItem
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        register(AmityFileTableViewCell.nib, forCellReuseIdentifier: AmityFileTableViewCell.identifier)
        isScrollEnabled = false
        separatorStyle = .none
        dataSource = self
        delegate = self
    }
    
    func configure(files: [AmityFile]) {
        if isEditingMode {
            handleFileChanges(newFiles: files)
        } else {
            self.files = files
            reloadData()
        }
    }
    
    func updateViewState(for fileId: String, state: AmityFileTableViewCell.ViewState) {
        guard let index = files.firstIndex(where: { $0.id == fileId }),
            let cell = cellForRow(at: IndexPath(row: index, section: 0)) as? AmityFileTableViewCell else {
                return
        }
        cell.updateViewState(state)
    }
    
    func viewState(for fileId: String) -> AmityFileTableViewCell.ViewState {
        guard let index = files.firstIndex(where: { $0.id == fileId }),
            let cell = cellForRow(at: IndexPath(row: index, section: 0)) as? AmityFileTableViewCell else {
                return .idle
        }
        return cell.viewState
    }
    
    func fileState(for fileId: String) -> AmityFileState {
        guard let file = files.first(where: { $0.id == fileId }) else {
            return .error(errorMessage: "")
        }
        return file.state
    }
    
    static func height(for numberOfItems: Int, isEdtingMode: Bool, isExpanded: Bool) -> CGFloat {
        if isEdtingMode {
            return CGFloat(numberOfItems) * AmityFileTableViewCell.defaultHeight + Constant.topInset
        }
        if isExpanded {
            return CGFloat(numberOfItems) * AmityFileTableViewCell.defaultHeight + Constant.topInset
        } else {
            let footerHeight = numberOfItems > Constant.limitItem ? Constant.footerHeight : 0
            let visisbleItems = min(numberOfItems, Constant.limitItem)
            return CGFloat(visisbleItems) * AmityFileTableViewCell.defaultHeight + footerHeight + Constant.topInset
        }
    }
    
    @objc private func didTapViewAll() {
        actionDelegate?.fileTableViewDidTapViewAll(self)
    }
    
}

extension AmityFileTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEditingMode {
            return files.count
        }
        return isExpanded ? files.count : min(files.count, Constant.limitItem)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AmityFileTableViewCell.identifier, for: indexPath) as! AmityFileTableViewCell
        let item = files[indexPath.row]
        cell.delegate = self
        cell.configure(with: item, isEditingMode: isEditingMode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: contentSize.width, height: Constant.footerHeight))
        let label = UILabel(frame: CGRect(x: 16.0, y: 0.0, width: contentSize.width - 32.0, height: Constant.footerLabelHight))
        label.text = AmityLocalizedStringSet.viewAllFilesTitle.localizedString
        label.textColor = .systemBlue
        label.font = AmityFontSet.body
        let button = UIButton(frame: label.frame)
        button.addTarget(self, action: #selector(didTapViewAll), for: .touchUpInside)
        footerView.addSubview(button)
        footerView.addSubview(label)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return shouldShowFooter ? Constant.footerHeight : 0.0
    }
    
}

extension AmityFileTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AmityFileTableViewCell.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionDelegate?.fileTableView(self, didTapAt: indexPath.row)
    }
    
}

extension AmityFileTableView: AmityFileTableViewCellDelegate {
    
    func didTapClose(_ cell: AmityFileTableViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        
        // Remove the row instead of reloading the data
        files.remove(at: indexPath.row)
        deleteRows(at: [indexPath], with: .none)
        
        actionDelegate?.fileTableViewDidDeleteData(self, at: indexPath.row)
        actionDelegate?.fileTableViewDidUpdateData(self)
        reloadData()
    }
    
}

private extension AmityFileTableView {
    func handleFileChanges(newFiles: [AmityFile]) {
        // newFiles array contains currentFiles plus new attachments
        // Append only non existing files to the files array
        let currentFilesId = files.map { $0.id }
        let newFilesId = newFiles.map { $0.id }

        // Create a set to find the difference between current files and new files
        let currentFilesSet = Set(currentFilesId)
        let newFilesSet = Set(newFilesId)
        let difference = Array(newFilesSet.symmetricDifference(currentFilesSet))

        for item in newFiles {
            if difference.contains(item.id) {
                files.append(item)
                insertRows(at: [IndexPath(row: files.count - 1, section: 0)], with: .none)
            }
        }
    }
}
