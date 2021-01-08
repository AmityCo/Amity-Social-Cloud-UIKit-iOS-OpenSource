//
//  EkoPopoverMessageViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/11/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit

final class EkoPopoverMessageViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: - Properties
    var text: String?
    
    // MARK: - View Lifecycle
    static func make() -> EkoPopoverMessageViewController {
        return EkoPopoverMessageViewController(nibName: EkoPopoverMessageViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.dismiss(animated: true, completion: nil )
        }
    }
}

private extension EkoPopoverMessageViewController {
    
    func setupText() {
        view.backgroundColor = EkoColorSet.secondary
        titleLabel.text = text
        titleLabel.font = EkoFontSet.body
        titleLabel.textColor = EkoColorSet.baseInverse
        titleLabel.textAlignment = .center
        
        let textSize = (text as NSString?)?.size(withAttributes: [.font: EkoFontSet.body]) ?? .zero
        preferredContentSize  = CGSize(width: textSize.width + 32, height: textSize.height + 20)
        print("Size")
    }
    
}
