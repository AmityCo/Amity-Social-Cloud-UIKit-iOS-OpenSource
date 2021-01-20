//
//  EkoTextMessageView.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 14/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import EkoChat

class EkoTextMessageView: EkoView {
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var label: UILabel!
    @IBOutlet private var readmoreButton: UIButton!
    @IBOutlet private var overlayView: UIView!
    @IBOutlet private var readmoreLabel: UILabel!
    
    // MARK: - Properties
    var message: EkoMessageModel? {
        didSet {
            setText()
        }
    }
    
    var messageReadmore: EkoMessageReadmoreModel?
    var readmoreHandler: (() -> Void)?
    var text: String?
    
    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }
    
    var readmoreTextColor: UIColor? {
        didSet {
            readmoreLabel.textColor = readmoreTextColor
        }
    }
    
    var textFont: UIFont? {
        didSet {
            label.font = textFont
        }
    }
    
    var numberOfLines: Int = 0 {
        didSet {
            label.numberOfLines = numberOfLines
        }
    }
    
    var textAlignment: NSTextAlignment = .center {
        didSet {
            label.textAlignment = textAlignment
        }
    }
    
    override func initial() {
        loadNibContent()
        setupView()

    }
    
    private func setupView() {
        label.lineBreakMode = .byWordWrapping
        readmoreLabel.text = EkoLocalizedStringSet.messageReadmore.localizedString
        readmoreLabel.font = EkoFontSet.body
    }
    
    private func setText() {
        label.text = message?.data?["text"] as? String
        let actualLine = label.maxNumberOfLines()
        setReadmore(with: actualLine)
    }
    
    private func setReadmore(with actualLine: Int) {
        guard let messageReadmore = messageReadmore else { return }
        if messageReadmore.shouldShowReadmore == nil && messageReadmore.isExpanded == nil {
            if actualLine > 12 {
                messageReadmore.shouldShowReadmore = true
                messageReadmore.isExpanded = false
            } else {
                messageReadmore.shouldShowReadmore = false
                messageReadmore.isExpanded = false
            }
        }
        updateReadmoreStatus()
    }
    
    private func updateReadmoreStatus() {
        guard let shouldShowReadmore = messageReadmore?.shouldShowReadmore, let isExpanded = messageReadmore?.isExpanded  else { return }
        
        if !shouldShowReadmore && isExpanded {
            readmoreLabel.text = ""
            readmoreLabel.isHidden = true
            readmoreButton.isHidden = true
            label.numberOfLines = 0
        } else if label.maxNumberOfLines() <= 12 && !shouldShowReadmore {
            label.numberOfLines = numberOfLines
            readmoreLabel.isHidden = true
            readmoreButton.isHidden = true
            readmoreLabel.text = ""
        } else {
            readmoreLabel.isHidden = false
            readmoreButton.isHidden = false
            label.numberOfLines = numberOfLines
            readmoreLabel.text = EkoLocalizedStringSet.messageReadmore.localizedString
        }
    }
}

private extension EkoTextMessageView {
    @IBAction func readmoreTap() {
        messageReadmore?.shouldShowReadmore = false
        messageReadmore?.isExpanded = true
        messageReadmore?.messageId = message?.messageId ?? ""
        updateReadmoreStatus()
        readmoreHandler?()
    }
}

private extension UILabel {
    func maxNumberOfLines() -> Int {
        let width: CGFloat = ((UIScreen.main.bounds.width * 0.7) - 12)
        let maxSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
    
}


