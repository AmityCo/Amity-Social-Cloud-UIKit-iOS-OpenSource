//
//  AmityMessageListRecordingViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/11/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit

final class AmityMessageListRecordingViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet private var recordingImageView: UIImageView!
    @IBOutlet var recordingView: UIView!
    @IBOutlet private var descLabel: UILabel!
    @IBOutlet private var timerLabel: UILabel!
    
    // MARK: - Properties
    var finishRecordingHandler: ((AmityAudioRecorderState) -> Void)?
    
    // this vc doesn't support swipe back gesture
    // it requires setting a presenter to define who is using this vc
    // and then temporarily disable the gesture
    weak var presenter: AmityViewController?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        AmityAudioRecorder.shared.delegate = self
        setupView()
    }
    
    static func make() -> AmityMessageListRecordingViewController {
        let vc = AmityMessageListRecordingViewController(nibName: AmityMessageListRecordingViewController.identifier, bundle: AmityUIKitManager.bundle)
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.removeSwipeBackGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.setupFullWidthBackGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRecording()
    }
    
    func startRecording() {
        AmityAudioRecorder.shared.startRecording()
        recordingUI()
    }
    
    func stopRecording() {
        AmityAudioRecorder.shared.stopRecording()
        waitingForRecordUI()
    }
    
    func deleteRecording() {
        AmityAudioRecorder.shared.stopRecording(withDelete: true)
    }
    
    func deletingRecording() {
        deleteRecordingUI()
    }
    
    func cancelingDelete() {
        recordingUI()
    }
}

// MARK: - Setup View
private extension AmityMessageListRecordingViewController {
    
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
        recordingImageView.image = AmityIconSet.Chat.iconVoiceMessageWhite
        waitingForRecordUI()
    }
    
    func setupTimerLabel() {
        timerLabel.text = "0:00"
        timerLabel.textColor = UIColor.white
        timerLabel.font = AmityFontSet.title
    }
    
    func setupDescLabel() {
        descLabel.text = AmityLocalizedStringSet.MessageList.releaseToSend.localizedString
        descLabel.textColor = AmityColorSet.base.blend(.shade3)
        descLabel.font = AmityFontSet.caption
    }
    
    func setupDeleteButton() {
        deleteButton.setImage(AmityIconSet.Chat.iconDelete1, for: .normal)
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        waitingForDeleteUI()
    }
    
}

// MARK: - Update Views
private extension AmityMessageListRecordingViewController {
    
    func waitingForRecordUI() {
        recordingView.backgroundColor = AmityColorSet.primary.blend(.shade1).withAlphaComponent(0.5)
        recordingImageView.tintColor = UIColor.white
    }
    
    func recordingUI() {
        recordingView.backgroundColor = AmityColorSet.primary.blend(.shade1)
        recordingImageView.tintColor = UIColor.white
        
        waitingForDeleteUI()
    }
    
    func deleteRecordingUI() {
        recordingView.backgroundColor = AmityColorSet.secondary.blend(.shade1)
        recordingImageView.tintColor = AmityColorSet.base.blend(.shade3)
        
        deletingButtonUI()
    }
    
    func deletingButtonUI() {
        deleteButton.backgroundColor = AmityColorSet.alert
        deleteButton.tintColor = AmityColorSet.baseInverse
        deleteButton.setImage(AmityIconSet.Chat.iconDelete2, for: .normal)
    }
    
    func waitingForDeleteUI() {
        deleteButton.backgroundColor = AmityColorSet.secondary
        deleteButton.tintColor = AmityColorSet.base.blend(.shade3)
        deleteButton.setImage(AmityIconSet.Chat.iconDelete1, for: .normal)
    }
}

extension AmityMessageListRecordingViewController: AmityAudioRecorderDelegate {
    func finishRecording(state: AmityAudioRecorderState) {
        finishRecordingHandler?(state)
    }
    func requestRecordPermission(isAllowed: Bool) {
        
    }
    
    func displayDuration(_ duration: String) {
        timerLabel.text = duration
    }
    
    func voiceMonitoring(radius: CGFloat) {
        let pulse = AmityPulseAnimation(numberOfPulse: 1, radius: radius + (radius * 0.15), postion: recordingView.center)
        pulse.animationDuration = 3.0
        pulse.backgroundColor = UIColor.black.withAlphaComponent(0.8).cgColor
        view.layer.insertSublayer(pulse, below: recordingView.layer)
    }
    
}
