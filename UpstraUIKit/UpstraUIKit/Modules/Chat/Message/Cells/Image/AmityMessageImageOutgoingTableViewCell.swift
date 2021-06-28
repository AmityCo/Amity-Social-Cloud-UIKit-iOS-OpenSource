//
//  AmityMessageImageOutgoingTableViewCell.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 4/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit

final class AmityMessageImageOutgoingTableViewCell: AmityMessageImageTableViewCell {
    
    @IBOutlet private var drimView: UIView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        drimView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func display(message: AmityMessageModel) {
        if !message.isDeleted {
            switch message.syncState {
            case .syncing:
                activityIndicatorView.startAnimating()
                drimView.isHidden = false
            case .synced, .default, .error:
                activityIndicatorView.stopAnimating()
                drimView.isHidden = true
            @unknown default:
                break
            }
        }
        
        super.display(message: message)
    }
}
