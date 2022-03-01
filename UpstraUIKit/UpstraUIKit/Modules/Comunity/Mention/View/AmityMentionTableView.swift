//
//  AmityMentionTableView.swift
//  AmityUIKit
//
//  Created by Hamlet on 08.11.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

public final class AmityMentionTableView: UITableView {
    // MARK: - Initial
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        register(AmityMentionTableViewCell.nib, forCellReuseIdentifier: AmityMentionTableViewCell.identifier)
        backgroundColor = AmityColorSet.backgroundColor
        tableFooterView = UIView()
        separatorColor = .clear
        separatorStyle = .none
        showsVerticalScrollIndicator = true
        showsHorizontalScrollIndicator = false
    }
}
