//
//  EkoView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit

public class EkoView: UIView, NibFileOwnerLoadable {
    
    public var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initial()
    }
    
    func initial() { }
    
}
