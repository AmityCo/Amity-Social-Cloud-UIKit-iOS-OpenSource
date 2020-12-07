//
//  EkoMessageAudioTableViewCell.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 2/12/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit
import EkoChat

final class EkoMessageAudioTableViewCell: EkoMessageTableViewCell {
    
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var actionImageView: UIImageView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        durationLabel.text = "0:00"
        actionImageView.image = EkoIconSet.Chat.iconPlay
    }
    
    func setupView() {
        durationLabel.text = "0:00"
        durationLabel.font = EkoFontSet.body
        durationLabel.textAlignment = .right
        actionImageView.image = EkoIconSet.Chat.iconPlay
        
        activityIndicatorView.hidesWhenStopped = true
        
    }
    
    override func display(message: EkoMessageModel) {
        if !message.isDeleted {
            if message.isOwner {
                durationLabel.textColor = EkoColorSet.baseInverse
                actionImageView.tintColor = EkoColorSet.baseInverse
                activityIndicatorView.style = .white
                switch message.syncState {
                case .syncing:
                    durationLabel.alpha = 0
                    activityIndicatorView.startAnimating()
                case .synced, .default, .error:
                    durationLabel.alpha = 1
                    activityIndicatorView.stopAnimating()
                @unknown default:
                    break
                }
            } else {
                durationLabel.textColor = EkoColorSet.base
                actionImageView.tintColor = EkoColorSet.base
                activityIndicatorView.style = .gray
            }
            
            if EkoAudioPlayer.shared.isPlaying(), EkoAudioPlayer.shared.fileName == message.messageId {
                actionImageView.image = EkoIconSet.Chat.iconPause
            } else {
                actionImageView.image = EkoIconSet.Chat.iconPlay
            }
        }
        super.display(message: message)
    }
    
}

extension EkoMessageAudioTableViewCell {
    @IBAction func playTap(_ sender: UIButton) {
        if !message.isDeleted {
            sender.isEnabled = false
            EkoMessageMediaService.shared.download(for: message.object) { [weak self] in
                self?.durationLabel.alpha = 0
                self?.activityIndicatorView.startAnimating()
            } completion: { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let url):
                    EkoAudioPlayer.shared.delegate = self
                    EkoAudioPlayer.shared.fileName = strongSelf.message.messageId
                    EkoAudioPlayer.shared.path = url
                    EkoAudioPlayer.shared.play()
                    sender.isEnabled = true
                    strongSelf.activityIndicatorView.stopAnimating()
                    strongSelf.durationLabel.alpha = 1
                case .failure(let error):
                    Log.add(error.localizedDescription)
                }
            }
        }
    }
}

extension EkoMessageAudioTableViewCell: EkoAudioPlayerDelegate {
    func playing() {
        actionImageView.image = EkoIconSet.Chat.iconPause
        delegate?.performEvent(self, events: .audioPlaying)
    }
    
    func stopPlaying() {
        actionImageView.image = EkoIconSet.Chat.iconPlay
        durationLabel.text = "0:00"
    }
    
    func finishPlaying() {
        actionImageView.image = EkoIconSet.Chat.iconPlay
        durationLabel.text = "0:00"
    }
    
    func displayDuration(_ duration: String) {
        durationLabel.text = duration
    }
}
