//
//  AmityView.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public class AmityView: UIView, NibFileOwnerLoadable {
    
    public var contentView: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initial()
    }
    
    func initial() { }
    
}
