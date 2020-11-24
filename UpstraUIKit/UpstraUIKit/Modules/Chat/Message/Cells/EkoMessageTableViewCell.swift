//
//  EkoMessageTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import EkoChat

class EkoMessageTableViewCell: UITableViewCell, EkoMessageCellProtocol {
    
    // MARK: - IBOutlet Properties
    @IBOutlet var avatarView: EkoAvatarView!
    @IBOutlet var containerView: EkoResponsiveView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var metadataLabel: UILabel!
    @IBOutlet var messageImageView: UIImageView!
    @IBOutlet var statusMetadataImageView: UIImageView!
    @IBOutlet var errorStateButton: UIButton!
    
    // MARK: Container
    @IBOutlet var containerMessageView: UIView!
    @IBOutlet var containerMetadataView: UIView!
    
    // MARK: - Properties
    var screenViewModel: EkoMessageListScreenViewModelType!
    var message: EkoMessageModel!
    
    var errorStateHandler: (() -> Void)?
    var errorStateActionHandler: ((EkoMessageModel) -> Void)?
    
    var indexPath: IndexPath!
    let editMenuItem = UIMenuItem(title: EkoLocalizedStringSet.edit, action: #selector(editTap))
    let deleteMenuItem = UIMenuItem(title: EkoLocalizedStringSet.delete, action: #selector(deleteTap))
    let reportMenuItem = UIMenuItem(title: EkoLocalizedStringSet.report, action: #selector(reportTap))
    
    // MARK: - Delegate
    weak var delegate: EkoMessageCellDelegate?
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if message.isOwner {
            if message.messageType == .image || message.messageType == .file {
                return action == #selector(deleteTap)
            } else {
                return action == #selector(editTap) || action == #selector(deleteTap)
            }
        } else {
            return action == #selector(reportTap)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusMetadataImageView.isHidden = true
        containerMessageView.isHidden = false
        metadataLabel.isHidden = false
    }
    
    func setViewModel(with viewModel: EkoMessageListScreenViewModelType) {
        screenViewModel = viewModel
    }
    
    func setIndexPath(with _indexPath: IndexPath) {
        indexPath = _indexPath
    }
    
    func display(message: EkoMessageModel) {
        self.message = message
        
        if message.isOwner {
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            switch message.messageType {
            case .text:
                containerView.backgroundColor = EkoColorSet.messageBubble
            default:
                containerView.backgroundColor = .white
            }
        } else {
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            
            if case .text = message.messageType {
                containerView.backgroundColor = EkoColorSet.messageBubbleInverse
            } else {
                containerView.backgroundColor = .white
            }
            
            displayNameLabel.font = EkoFontSet.body
            displayNameLabel.textColor = EkoColorSet.base.blend(.shade1)
            
            setDisplayName(for: message)
        }
        setMetadata(message: message)
    }
    
    func setMetadata(message: EkoMessageModel) {
        let fullString = NSMutableAttributedString()
        let style: [NSAttributedString.Key : Any]? = [.foregroundColor: EkoColorSet.base.blend(.shade2),
                                                      .font: EkoFontSet.caption]
        if message.isDeleted {
            containerMessageView.isHidden = true
            statusMetadataImageView.isHidden = false
            let deleteMessage = String.localizedStringWithFormat(EkoLocalizable.localizedString(forKey: "message_delete"), message.time)
            fullString.append(NSAttributedString(string: deleteMessage, attributes: style))
            statusMetadataImageView.image = EkoIconSet.iconDeleteMessage
        } else if message.isEdited {
            let editMessage = String.localizedStringWithFormat(EkoLocalizable.localizedString(forKey: "message_edit"), message.time)
            fullString.append(NSAttributedString(string: editMessage, attributes: style))
        } else {
            if message.isOwner {
                errorStateButton.isHidden = true
                switch message.syncState {
                case .error:
                    errorStateButton.isHidden = false
                    errorStateHandler?()
                    fullString.append(NSAttributedString(string: message.time, attributes: style))
                case .syncing:
                    fullString.append(NSAttributedString(string: EkoLocalizedStringSet.messageListSending, attributes: style))
                case .synced:
                    fullString.append(NSAttributedString(string: message.time, attributes: style))
                default:
                    break
                }
            } else {
                fullString.append(NSAttributedString(string: message.time, attributes: style))
            }
        }
        metadataLabel.attributedText = fullString
    }
    
    private func setDisplayName(for message: EkoMessageModel) {
        setDisplayName(message.displayName)
    }
    
    private func setDisplayName(_ name: String?) {
        displayNameLabel.text = name
    }
}

// MARK: - Action
private extension EkoMessageTableViewCell {
    @objc
    func editTap() {
        screenViewModel.action.performCellEvent(for: .edit(indexPath: indexPath))
    }
    
    @objc
    func deleteTap() {
        switch message.syncState {
        case .error:
            screenViewModel.action.performCellEvent(for: .deleteErrorMessage(indexPath: indexPath))
        default:
            screenViewModel.action.performCellEvent(for: .delete(indexPath: indexPath))
        }
        
    }
    
    @objc
    func reportTap() {
        screenViewModel.action.performCellEvent(for: .report(indexPath: indexPath))
    }
    
    @IBAction func errorStateTap() {
        errorStateActionHandler?(message)
    }
}

// MARK: - Setup View
private extension EkoMessageTableViewCell {
    private func setupView() {
        selectionStyle = .none
        
        statusMetadataImageView.isHidden = true
        containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        containerView.layer.cornerRadius = 4
        containerView.menuItems = [editMenuItem, deleteMenuItem, reportMenuItem]
        
        contentView.backgroundColor = .white
    }
}
