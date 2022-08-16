//
//  LiveStreamBroadcastOverlayCommentTableViewCell.swift
//  AmityUIKitLiveStream
//
//  Created by Mono TheForestcat on 9/8/2565 BE.
//

import UIKit
import AmityUIKit

class LiveStreamBroadcastOverlayCommentTableViewCell: UITableViewCell, Nibbable {
    
    @IBOutlet weak var avatarImage: AmityAvatarView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    public static let height: CGFloat = 40.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        displayName.text = ""
        commentText.text = ""
    }
    
    func display(comment: AmityCommentModel) {
        displayName.text = comment.displayName
        displayName.font = AmityFontSet.caption.withSize(16)
        
        commentText.text = comment.text
        commentText.font = AmityFontSet.caption.withSize(14)
        commentText.backgroundColor = .gray
        
        avatarImage.setImage(withCustomURL: comment.avatarCustomURL)
    }
}
