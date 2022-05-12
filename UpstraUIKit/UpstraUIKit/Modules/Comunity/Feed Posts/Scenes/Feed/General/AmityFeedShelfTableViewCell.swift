//
//  AmityFeedShelfTableViewCell.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 11/5/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit

class AmityFeedShelfTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = AmityColorSet.backgroundColor
    }
    
    func set(shelfView: UIView?) {
        guard let shelfView = shelfView else { return }
        
        shelfView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shelfView)
        NSLayoutConstraint.activate([
            shelfView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shelfView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shelfView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            shelfView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
}
