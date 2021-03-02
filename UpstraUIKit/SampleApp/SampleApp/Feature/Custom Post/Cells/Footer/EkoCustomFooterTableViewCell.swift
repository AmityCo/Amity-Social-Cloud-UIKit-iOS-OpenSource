//
//  EkoCustomFooterTableViewCell.swift
//  SampleApp
//
//  Created by sarawoot khunsri on 2/17/21.
//  Copyright © 2021 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

class EkoCustomFooterTableViewCell: UITableViewCell, EkoPostFooterProtocol {
    
    weak var delegate: EkoPostFooterDelegate?
    
    @IBOutlet private var likeButton: UIButton!
    var post: EkoPostModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func display(post: EkoPostModel) {
        self.post = post
    }
    
    @IBAction func likeTap() {
        
//        delegate?.didPerformAction(self, action: .tapLike)
    }
    
}
