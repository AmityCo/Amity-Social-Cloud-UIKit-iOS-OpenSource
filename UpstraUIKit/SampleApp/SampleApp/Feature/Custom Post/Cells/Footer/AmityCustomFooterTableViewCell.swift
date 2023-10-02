//
//  AmityCustomFooterTableViewCell.swift
//  SampleApp
//
//  Created by sarawoot khunsri on 2/17/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit
import AmityUIKit

class AmityCustomFooterTableViewCell: UITableViewCell, AmityPostFooterProtocol {
    
    weak var delegate: AmityPostFooterDelegate?
    
    @IBOutlet private var likeButton: UIButton!
    var post: AmityPostModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func display(post: AmityPostModel) {
        self.post = post
    }
    
    @IBAction func likeTap() {
        
//        delegate?.didPerformAction(self, action: .tapLike)
    }
    
}
