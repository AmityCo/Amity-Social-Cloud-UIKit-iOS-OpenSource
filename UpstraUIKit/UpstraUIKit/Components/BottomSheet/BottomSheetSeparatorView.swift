//
//  BottomSheetSeparatorView.swift
//  AmityUIKit
//
//  Created by Nishan Niraula on 1/23/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import UIKit

public class BottomSheetSeparatorView: UIView, BottomSheetComponent {

    public var componentHeight: CGFloat { return 1 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = AmityColorSet.backgroundColor
    }
}
