//
//  EkoPostCreateViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 9/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

/// A view controller for providing post creator.
public class EkoPostCreateViewController {

    // This is a wrapper class to help fill in parameters.
    public static func make(postTarget: EkoPostTarget) -> EkoViewController {
        return EkoPostTextEditorViewController.make(postTarget: postTarget, postMode: .create)
    }
    
}
