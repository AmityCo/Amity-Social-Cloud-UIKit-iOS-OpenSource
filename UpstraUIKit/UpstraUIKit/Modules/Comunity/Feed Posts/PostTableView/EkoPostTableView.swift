//
//  EkoPostTableView.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/15/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

protocol EkoPostTableViewDelegate: class {
    func tableView(_ tableView: EkoPostTableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: EkoPostTableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: EkoPostTableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: EkoPostTableView, heightForHeaderInSection section: Int) -> CGFloat
    func tableView(_ tableView: EkoPostTableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(_ tableView: EkoPostTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: EkoPostTableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: EkoPostTableView, viewForFooterInSection section: Int) -> UIView?
}
extension EkoPostTableViewDelegate {
    func tableView(_ tableView: EkoPostTableView, didSelectRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: EkoPostTableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: EkoPostTableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: EkoPostTableView, heightForHeaderInSection section: Int) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: EkoPostTableView, heightForFooterInSection section: Int) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: EkoPostTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: EkoPostTableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: EkoPostTableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

protocol EkoPostTableViewDataSource: class {
    func numberOfSections(in tableView: EkoPostTableView) -> Int
    func tableView(_ tableView: EkoPostTableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: EkoPostTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

final class EkoPostTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Internal Delegate
    weak var eko_delegate: EkoPostTableViewDelegate?
    // Internal DataSource
    weak var eko_dataSource: EkoPostTableViewDataSource?
    
    // Post Delegate
    weak var postDelegate: EkoFeedDelegate?
    // Post DataSource
    weak var postDataSource: EkoFeedDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDelegateAndDataSource()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupDelegateAndDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDelegateAndDataSource()
    }
    
    private func setupDelegateAndDataSource() {
        postDelegate = EkoFeedUISettings.shared.delegate
        postDataSource = EkoFeedUISettings.shared.dataSource
        delegate = self
        dataSource = self
    }
    
    // Register custom cell
    func registerCustomCell() {
        EkoFeedUISettings.shared.customNib.forEach { register($0.nib, forCellReuseIdentifier: $0.identifier) }
        EkoFeedUISettings.shared.customCellClass.forEach { register($0.cellClass.self, forCellReuseIdentifier: $0.identifier) }
    }
    
    // These cell are default post cell
    func registerPostCell() {
        register(cell: EkoPostHeaderTableViewCell.self)
        register(cell: EkoPostFooterTableViewCell.self)
        register(cell: EkoPostPreviewCommentTableViewCell.self)
        register(cell: EkoPostTextTableViewCell.self)
        register(cell: EkoPostGalleryTableViewCell.self)
        register(cell: EkoPostFileTableViewCell.self)
        register(cell: EkoPostPlaceHolderTableViewCell.self)
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eko_delegate?.tableView(self, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return eko_delegate?.tableView(self, heightForRowAt: indexPath) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return eko_delegate?.tableView(self, estimatedHeightForRowAt: indexPath) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return eko_delegate?.tableView(self, heightForHeaderInSection: section) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return eko_delegate?.tableView(self, heightForFooterInSection: section) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        eko_delegate?.tableView(self, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        eko_delegate?.tableView(self, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return eko_delegate?.tableView(self, viewForFooterInSection: section)
    }
    
    // MARK: - DatSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return eko_dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eko_dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return eko_dataSource?.tableView(self, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}
