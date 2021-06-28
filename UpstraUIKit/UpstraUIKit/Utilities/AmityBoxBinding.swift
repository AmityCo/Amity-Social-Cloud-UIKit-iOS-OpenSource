//
//  AmityBoxBinding.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 24/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

#warning("FIXME: This class should be removed and all callers will be replaced with delegae or completion blocks.")
final class AmityBoxBinding<T> {
    typealias Listener = (T) -> ()
   
   // MARK: - variables for the binder
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    var listener: Listener?
    
    // MARK: - intializers for the binder
    init(_ value: T) {
        self.value = value
    }
    
    // MARK: -  function for the binder
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
