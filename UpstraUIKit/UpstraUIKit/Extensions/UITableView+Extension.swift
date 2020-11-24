//
//  UITableView+Extension.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 1/6/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit

extension UITableView {
    
    var isBottomReached: Bool {
        return contentOffset.y >= (contentSize.height - frame.size.height)
    }
    
    /// Variables-height UITableView tableHeaderView with autolayout
    func layoutTableHeaderView() {
        
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = [NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: headerWidth)]
        headerView.addConstraints(temporaryWidthConstraints)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
    
    func setEmptyView(with emptyView: UIView, with numberOfData: Int) {
        backgroundView = numberOfData == 0 ? emptyView : nil
    }
    
    // MARK: - Dequeue
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func showLoadingIndicator() {
        let loading = UIActivityIndicatorView(style: .gray)
        loading.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 40)
        loading.startAnimating()
        tableFooterView = loading
    }
    
    func showHeaderLoadingIndicator() {
        let loading = UIActivityIndicatorView(style: .gray)
        loading.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 40)
        loading.startAnimating()
        tableHeaderView = loading
    }
    
}
