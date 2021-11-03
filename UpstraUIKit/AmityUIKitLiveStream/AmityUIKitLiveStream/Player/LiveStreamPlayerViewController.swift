//
//  LiveStreamPlayerViewController.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 7/9/2564 BE.
//

import UIKit
import AmityUIKit
import AmitySDK
import AmityVideoPlayerKit

public class LiveStreamPlayerViewController: UIViewController {
    
    private let streamIdToWatch: String
    private let streamRepository: AmityStreamRepository
    
    private var stream: AmityStream?
    private var getStreamToken: AmityNotificationToken?
    
    @IBOutlet private weak var renderView: UIView!
    
    @IBOutlet weak var statusContainer: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    /// The view above renderView to intercept tap gestuere for show/hide control container.
    @IBOutlet private weak var renderGestureView: UIView!
    
    @IBOutlet private weak var loadingOverlay: UIView!
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Control Container
    @IBOutlet private weak var controlContainer: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    
    // MARK: - Stream End Container
    @IBOutlet private weak var streamEndContainer: UIView!
    @IBOutlet private weak var streamEndTitleLabel: UILabel!
    @IBOutlet private weak var streamEndDescriptionLabel: UILabel!
    
    /// This sample app uses AmityVideoPlayer to play live videos.
    /// The player consumes the stream instance, and works automatically.
    /// At the this moment, the player only provide basic functionality, play and stop.
    ///
    /// For more rich features, it is recommend to use other video players that support RTMP streaming.
    /// You can get the RTMP url, by checking at `.watcherUrl` property.
    ///
    private var player: AmityVideoPlayer
    
    /// Indicate that the user request to play the stream
    private var isStarting = true {
        didSet {
            updateContainer()
            updateControlActionButton()
        }
    }
    
    /// Indicate that the user request to play the stream, but the stream object is not yet ready.
    /// So we wait for stream object from the observe block.
    private var requestingStreamObject = true {
        didSet {
            updateContainer()
            updateControlActionButton()
        }
    }
    
    private var videoView: UIView!
    
    public init(streamIdToWatch: String) {
        
        self.streamRepository = AmityStreamRepository(client: AmityUIKitManager.client)
        self.streamIdToWatch = streamIdToWatch
        self.player = AmityVideoPlayer(client: AmityUIKitManager.client)
        
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: "LiveStreamPlayerViewController", bundle: bundle)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unobserveStreamObject()
        stopStream()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupStreamView()
        setupView()
        updateControlActionButton()
        //
        isStarting = true
        requestingStreamObject = true
        observeStreamObject()
    }
    
    private func setupStreamView() {
        // Create video view and embed in playerContainer
        videoView = UIView(frame: renderView.bounds)
        // We don't want to receive touch event for video view.
        // The touch event should pass through to the playerContainer.
        videoView.isUserInteractionEnabled = false
        videoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        renderView.addSubview(videoView)
        // Tell the player to render the video in this view.
        player.renderView = videoView
        player.delegate = self
    }
    
    private func setupView() {
        
        statusContainer.clipsToBounds = true
        statusContainer.layer.cornerRadius = 4
        statusContainer.backgroundColor = UIColor(red: 1, green: 0.188, blue: 0.353, alpha: 1)
        statusLabel.textColor = .white
        statusLabel.font = AmityFontSet.captionBold
        statusLabel.text = "LIVE"
        
        // We show "LIVE" static label while playing.
        statusContainer.isHidden = true
        
        streamEndTitleLabel.font = AmityFontSet.title
        streamEndDescriptionLabel.font = AmityFontSet.body
        
        loadingOverlay.isHidden = true
        
        // Show control at start by default
        controlContainer.isHidden = false
        
        loadingActivityIndicator.stopAnimating()
        
        controlContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(controlContainerDidTap)))
        
        renderGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerContainerDidTap)))
        
    }
    
    @objc private func playerContainerDidTap() {
        UIView.animate(withDuration: 0.15, animations: {
            self.controlContainer.alpha = 1
        }, completion: { finish in
            self.controlContainer.isUserInteractionEnabled = true
        })
    }
    
    @objc private func controlContainerDidTap() {
        controlContainer.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.15) {
            self.controlContainer.alpha = 0
        }
    }
    
    private func updateControlActionButton() {
        switch stream?.status {
        case .ended, .recorded, .idle:
            // Stream has already end, no need to show play and stop button.
            playButton.isHidden = true
            stopButton.isHidden = true
        default:
            // Stream end has not determine, play and stop button rely on player.mediaState.
            switch player.mediaState {
            case .playing:
                playButton.isHidden = true
                stopButton.isHidden = false
                statusContainer.isHidden = false
            case .stopped:
                playButton.isHidden = false
                stopButton.isHidden = true
                statusContainer.isHidden = true
            @unknown default:
                assertionFailure("Unexpected state")
            }
        }
    }
    
    private func updateContainer() {
        
        let status: AmityStreamStatus?
            
        if let isDeleted = stream?.isDeleted, isDeleted {
            // NOTE: If stream is deleted, we show the idle state UI.
            status = .idle
        } else {
            status = stream?.status
        }
        
        switch status {
        case .ended, .recorded:
            // Stream End Container will obseceure all views to show title and description.
            streamEndContainer.isHidden = false
            streamEndTitleLabel.text = "This livestream has ended."
            streamEndDescriptionLabel.text = "Playback will be available for you to watch shortly."
            streamEndDescriptionLabel.isHidden = false
        case .idle:
            // Stream End Container will obseceure all views to show title and description.
            streamEndContainer.isHidden = false
            streamEndTitleLabel.text = "The stream is currently unavailable."
            streamEndDescriptionLabel.text = nil
            streamEndDescriptionLabel.isHidden = true
        case .live, .none:
            // If stream end has not yet determined
            // - We hide streamEndContainer.
            streamEndContainer.isHidden = true
            // - We hide/show loadingOverlay based on loading states.
            if isStarting || requestingStreamObject {
                if !loadingActivityIndicator.isAnimating {
                    loadingActivityIndicator.startAnimating()
                }
                loadingOverlay.isHidden = false
            } else {
                loadingOverlay.isHidden = true
                loadingActivityIndicator.stopAnimating()
            }
        default:
            assertionFailure("Unexpected state")
        }
        
        
    }
    
    private func observeStreamObject() {
        
        getStreamToken = streamRepository.getStreamById(streamIdToWatch).observe { [weak self] data, error in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                self?.presentUnableToPlayLiveStreamError(reason: error.localizedDescription)
                return
            }
            
            guard let streamToWatch = data.object else {
                self?.presentUnableToPlayLiveStreamError(reason: nil)
                return
            }
            
            strongSelf.stream = streamToWatch
            
            let streamIsUnavailable: Bool
            
            if streamToWatch.isDeleted {
                streamIsUnavailable = true
            } else {
                switch streamToWatch.status {
                case .ended, .recorded:
                    streamIsUnavailable = true
                default:
                    streamIsUnavailable = false
                }
            }
            
            // stream is unavailable to watch.
            if streamIsUnavailable {
                // No longer need to observe stream update, it is already end.
                strongSelf.getStreamToken = nil
                // Stop the playing stream.
                strongSelf.stopStream()
                // Once we know that the stream has already end, we clean up requestToPlay / playing states.
                strongSelf.isStarting = false
                strongSelf.requestingStreamObject = false
                // Update container, this will trigger stream end container to obsecure all the views.
                strongSelf.updateContainer()
                //
                return
            }
            
            // stream is available to watch.
            switch streamToWatch.status {
            case .idle, .live:
                // Once we know that the stream is now .idle/.live
                // We check the requestingStreamObject that wait for stream object to be ready.
                // So we trigger `playStream` again, because the stream info is ready for the player to play.
                if strongSelf.requestingStreamObject {
                    // We turnoff the flag, so if the stream object is updated.
                    // It will not trigger playStream again.
                    strongSelf.requestingStreamObject = false
                    strongSelf.playStream()
                }
            default:
                break
            }
            
        }
        
    }
    
    private func unobserveStreamObject() {
        getStreamToken = nil
    }
    
    private func playStream() {
        
        isStarting = true
        
        guard let stream = stream else {
            // Stream object is not yet ready, so we set this flag, when the stream object is ready.
            // We will trigger this function again.
            requestingStreamObject = true
            return
        }
        
        switch stream.status {
        case .ended, .recorded:
            isStarting = false
            return
        default:
            break
        }
        
        player.play(stream, completion: { [weak self] result in
            self?.isStarting = false
            switch result {
            case .failure(let error):
                self?.presentUnableToPlayLiveStreamError(reason: error.localizedDescription)
            case .success:
                break
            }
        })
        
    }
    
    private func presentUnableToPlayLiveStreamError(reason: String?) {
        presentErrorDialogue(title: "Unable to play live stream.", message: reason, ok: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    private func stopStream() {
        player.stop()
    }
    
    @IBAction private func stopButtonDidTouch() {
        stopStream()
    }
    
    @IBAction private func playButtonDidTouch() {
        playStream()
    }
    
    @IBAction func closeButtonDidTouch() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LiveStreamPlayerViewController: AmityVideoPlayerDelegate {
    
    public func amityVideoPlayerMediaStateChanged(_ player: AmityVideoPlayer) {
        updateControlActionButton()
    }
    
}

