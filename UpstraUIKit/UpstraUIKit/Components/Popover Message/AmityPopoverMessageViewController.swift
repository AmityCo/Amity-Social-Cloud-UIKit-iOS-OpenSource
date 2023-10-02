//
//  AmityPopoverMessageViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 30/11/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit

final class AmityPopoverMessageViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: - Properties
    var text: String?
    
    // MARK: - View Lifecycle
    static func make() -> AmityPopoverMessageViewController {
        return AmityPopoverMessageViewController(nibName: AmityPopoverMessageViewController.identifier, bundle: AmityUIKitManager.bundle)
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

private extension AmityPopoverMessageViewController {
    
    func setupText() {
        view.backgroundColor = AmityColorSet.secondary
        titleLabel.text = text
        titleLabel.font = AmityFontSet.body
        titleLabel.textColor = AmityColorSet.baseInverse
        titleLabel.textAlignment = .center
        
        let textSize = (text as NSString?)?.size(withAttributes: [.font: AmityFontSet.body]) ?? .zero
        preferredContentSize  = CGSize(width: textSize.width + 32, height: textSize.height + 20)
    }
    
}
