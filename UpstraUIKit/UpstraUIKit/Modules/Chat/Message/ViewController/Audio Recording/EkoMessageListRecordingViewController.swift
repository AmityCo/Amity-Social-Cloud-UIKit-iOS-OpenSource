//
//  EkoMessageListRecordingViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 26/11/2563 BE.
//  Copyright © 2563 BE Upstra. All rights reserved.
//

import UIKit

final class EkoMessageListRecordingViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet private var recordingImageView: UIImageView!
    @IBOutlet var recordingView: UIView!
    @IBOutlet private var descLabel: UILabel!
    @IBOutlet private var timerLabel: UILabel!
    
    // MARK: - Properties
    var finishRecordingHandler: ((EkoAudioRecorderState) -> Void)?
    // MARK: - View lifecycle
    static func make() -> EkoMessageListRecordingViewController {
        return EkoMessageListRecordingViewController(nibName: EkoMessageListRecordingViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EkoAudioRecorder.shared.delegate = self
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRecording()
    }
    
    func startRecording() {
        EkoAudioRecorder.shared.startRecording()
        recordingUI()
    }
    
    func stopRecording() {
        EkoAudioRecorder.shared.stopRecording()
        waitingForRecordUI()
    }
    
    func deleteRecording() {
        EkoAudioRecorder.shared.stopRecording(withDelete: true)
    }
    
    func deletingRecording() {
        deleteRecordingUI()
    }
    
    func cancelingDelete() {
        recordingUI()
    }
}

// MARK: - Setup View
private extension EkoMessageListRecordingViewController {
    
    func setupView() {
        view.isOpaque = false
        view.backgroundColor = UIColor.clear
        setupRecordingButton()
        setupTimerLabel()
        setupDescLabel()
        setupDeleteButton()
    }
    
    func setupRecordingButton() {
        recordingView.layer.cornerRadius = recordingView.frame.height / 2
        recordingImageView.image = EkoIconSet.Chat.iconVoiceMessageWhite
        waitingForRecordUI()
    }
    
    func setupTimerLabel() {
        timerLabel.text = "0:00"
        timerLabel.textColor = UIColor.white
        timerLabel.font = EkoFontSet.title
    }
    
    func setupDescLabel() {
        descLabel.text = EkoLocalizedStringSet.MessageList.releaseToSend.localizedString
        descLabel.textColor = EkoColorSet.base.blend(.shade3)
        descLabel.font = EkoFontSet.caption
    }
    
    func setupDeleteButton() {
        deleteButton.setImage(EkoIconSet.Chat.iconDelete1, for: .normal)
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        waitingForDeleteUI()
    }
    
}

// MARK: - Update Views
private extension EkoMessageListRecordingViewController {
    
    func waitingForRecordUI() {
        recordingView.backgroundColor = EkoColorSet.primary.blend(.shade1).withAlphaComponent(0.5)
        recordingImageView.tintColor = UIColor.white
    }
    
    func recordingUI() {
        recordingView.backgroundColor = EkoColorSet.primary.blend(.shade1)
        recordingImageView.tintColor = UIColor.white
        
        waitingForDeleteUI()
    }
    
    func deleteRecordingUI() {
        recordingView.backgroundColor = EkoColorSet.secondary.blend(.shade1)
        recordingImageView.tintColor = EkoColorSet.base.blend(.shade3)
        
        deletingButtonUI()
    }
    
    func deletingButtonUI() {
        deleteButton.backgroundColor = EkoColorSet.alert
        deleteButton.tintColor = EkoColorSet.baseInverse
        deleteButton.setImage(EkoIconSet.Chat.iconDelete2, for: .normal)
    }
    
    func waitingForDeleteUI() {
        deleteButton.backgroundColor = EkoColorSet.secondary
        deleteButton.tintColor = EkoColorSet.base.blend(.shade3)
        deleteButton.setImage(EkoIconSet.Chat.iconDelete1, for: .normal)
    }
}

extension EkoMessageListRecordingViewController: EkoAudioRecorderDelegate {
    func finishRecording(state: EkoAudioRecorderState) {
        finishRecordingHandler?(state)
    }
    func requestRecordPermission(isAllowed: Bool) {
        
    }
    
    func displayDuration(_ duration: String) {
        timerLabel.text = duration
    }
    
    func voiceMonitoring(radius: CGFloat) {
        let pulse = EkoPulseAnimation(numberOfPulse: 1, radius: radius + (radius * 0.15), postion: recordingView.center)
        pulse.animationDuration = 3.0
        pulse.backgroundColor = UIColor.black.withAlphaComponent(0.8).cgColor
        view.layer.insertSublayer(pulse, below: recordingView.layer)
    }
    
}
