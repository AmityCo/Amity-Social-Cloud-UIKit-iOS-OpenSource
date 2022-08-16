//
//  LiveStreamBroadcastOverlayTableViewCell.swift
//  AmityUIKitLiveStream
//
//  Created by Mono TheForestcat on 10/8/2565 BE.
//

import UIKit
import AmityUIKit

class LiveStreamBroadcastOverlayTableViewCell: UITableViewCell,Nibbable {
    
    @IBOutlet var avatarView: AmityAvatarView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    static let height: CGFloat = 60
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func display(comment: AmityCommentModel){
        
        self.backgroundColor = .clear
        
        avatarView.backgroundColor = .clear
        
        if !comment.avatarCustomURL.isEmpty {
            avatarView.setImage(withCustomURL: comment.avatarCustomURL)
        } else {
            avatarView.setImage(withImageURL: comment.fileURL)
        }
        
        displayNameLabel.text = comment.displayName
        displayNameLabel.font = AmityFontSet.headerLine.withSize(16)
        displayNameLabel.backgroundColor = .clear
        
        commentLabel.text = comment.text
        commentLabel.font = AmityFontSet.caption.withSize(14)
        commentLabel.backgroundColor = .clear
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.sizeToFit()
    }
    
    class func height(for comment: AmityCommentModel, boundingWidth: CGFloat) -> CGFloat {

        var height: CGFloat = 30
        var actualWidth: CGFloat = 0

        // for cell layout and calculation, please go check this pull request https://github.com/EkoCommunications/EkoMessagingSDKUIKitIOS/pull/713
        let horizontalPadding: CGFloat = 0
        actualWidth = boundingWidth - horizontalPadding

        let messageHeight = AmityExpandableLabel.height(for: comment.text, font: AmityFontSet.body, boundingWidth: actualWidth, maximumLines: 0)
        height += messageHeight
        return height

    }
    
}
