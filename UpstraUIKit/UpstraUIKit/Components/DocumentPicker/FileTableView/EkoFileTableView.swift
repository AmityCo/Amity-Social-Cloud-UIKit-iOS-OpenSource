//
//  EkoFileTableView.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 28/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

protocol EkoFileTableViewDelegate: class {
    func fileTableView(_ view: EkoFileTableView, didTapAt index: Int)
    func fileTableViewDidDeleteData(_ view: EkoFileTableView, at index: Int)
    func fileTableViewDidUpdateData(_ view: EkoFileTableView)
    func fileTableViewDidTapViewAll(_ view: EkoFileTableView)
}

class EkoFileTableView: UITableView {
    
    private enum Constant {
        static let itemSapcing: CGFloat = 12.0
        static let footerHeight: CGFloat = 36.0
        static let footerLabelHight: CGFloat = 20
        static let limitItem: Int = 5
        static let topInset: CGFloat = 12
    }
    
    private(set) var files: [EkoFile] = []
    
    var isEditingMode: Bool = false {
        didSet {
            reloadData()
        }
    }
    
    weak var actionDelegate: EkoFileTableViewDelegate?
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
        register(EkoFileTableViewCell.nib, forCellReuseIdentifier: EkoFileTableViewCell.identifier)
        isScrollEnabled = false
        separatorStyle = .none
        dataSource = self
        delegate = self
    }
    
    func configure(files: [EkoFile]) {
        self.files = files
        reloadData()
    }
    
    func updateViewState(for fileId: String, state: EkoFileTableViewCell.ViewState) {
        guard let index = files.firstIndex(where: { $0.id == fileId }),
            let cell = cellForRow(at: IndexPath(row: index, section: 0)) as? EkoFileTableViewCell else {
                return
        }
        cell.updateViewState(state)
    }
    
    func viewState(for fileId: String) -> EkoFileTableViewCell.ViewState {
        guard let index = files.firstIndex(where: { $0.id == fileId }),
            let cell = cellForRow(at: IndexPath(row: index, section: 0)) as? EkoFileTableViewCell else {
                return .idle
        }
        return cell.viewState
    }
    
    func fileState(for fileId: String) -> EkoFileState {
        guard let file = files.first(where: { $0.id == fileId }) else {
            return .error(errorMessage: "")
        }
        return file.state
    }
    
    static func height(for numberOfItems: Int, isEdtingMode: Bool, isExpanded: Bool) -> CGFloat {
        if isEdtingMode {
            return CGFloat(numberOfItems) * EkoFileTableViewCell.defaultHeight + Constant.topInset
        }
        if isExpanded {
            return CGFloat(numberOfItems) * EkoFileTableViewCell.defaultHeight + Constant.topInset
        } else {
            let footerHeight = numberOfItems > Constant.limitItem ? Constant.footerHeight : 0
            let visisbleItems = min(numberOfItems, Constant.limitItem)
            return CGFloat(visisbleItems) * EkoFileTableViewCell.defaultHeight + footerHeight + Constant.topInset
        }
    }
    
    @objc private func didTapViewAll() {
        actionDelegate?.fileTableViewDidTapViewAll(self)
    }
    
}

extension EkoFileTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEditingMode {
            return files.count
        }
        return isExpanded ? files.count : min(files.count, Constant.limitItem)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkoFileTableViewCell.identifier, for: indexPath) as! EkoFileTableViewCell
        let item = files[indexPath.row]
        cell.delegate = self
        cell.configure(with: item, isEditingMode: isEditingMode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: contentSize.width, height: Constant.footerHeight))
        let label = UILabel(frame: CGRect(x: 16.0, y: 0.0, width: contentSize.width - 32.0, height: Constant.footerLabelHight))
        label.text = "View all files"
        label.textColor = .systemBlue
        label.font = EkoFontSet.body
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

extension EkoFileTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EkoFileTableViewCell.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionDelegate?.fileTableView(self, didTapAt: indexPath.row)
    }
    
}

extension EkoFileTableView: EkoFileTableViewCellDelegate {
    
    func didTapClose(_ cell: EkoFileTableViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        actionDelegate?.fileTableViewDidDeleteData(self, at: indexPath.row)
        actionDelegate?.fileTableViewDidUpdateData(self)
        reloadData()
    }
    
}
