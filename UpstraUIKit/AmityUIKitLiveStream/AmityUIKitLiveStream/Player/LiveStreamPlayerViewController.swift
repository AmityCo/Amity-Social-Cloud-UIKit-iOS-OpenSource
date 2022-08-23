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
    private var streamRepository: AmityStreamRepository
    
    private let postId: String
    
    private var stream: AmityStream?
    private var getStreamToken: AmityNotificationToken?
    private var getReactionToken: AmityNotificationToken?
    private var liveCommentQueryToken: AmityNotificationToken?
    private var liveObjectQueryToken: AmityNotificationToken?
    private var liveCommentToken: AmityNotificationToken?
    
    private var postRepository: AmityPostRepository?
    private var reactionRepository: AmityReactionRepository?
    private var commentRepository: AmityCommentRepository?
    
    private var amityPost: AmityPost?
    private var liveStreamCommentArray:String?
        
    @IBOutlet private weak var renderView: UIView!
    
    @IBOutlet weak var statusContainer: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var streamingViewerContainer: UIView!
    @IBOutlet weak var streamingViewerCountLabel: UILabel!
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    //Live Comment
    @IBOutlet private weak var commentTableView: UITableView!
    @IBOutlet private weak var commentTextView: AmityTextView!
    @IBOutlet private weak var commentTextViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var postCommentButton: UIButton!
    @IBOutlet private weak var hideCommentButton: UIButton!
    @IBOutlet private weak var showCommentButton: UIButton!
    @IBOutlet private weak var likeCommentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var liveCommentView: UIView!
    @IBOutlet private weak var liveCommentViewHeightConstraint: NSLayoutConstraint!
    
    /// The view above renderView to intercept tap gestuere for show/hide control container.
    @IBOutlet private weak var renderGestureView: UIView!
    @IBOutlet private weak var renderGestureViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var loadingOverlay: UIView!
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Control Container
    @IBOutlet private weak var controlContainer: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var controlViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Stream End Container
    @IBOutlet private weak var streamEndContainer: UIView!
    @IBOutlet private weak var streamEndTitleLabel: UILabel!
    @IBOutlet private weak var streamEndDescriptionLabel: UILabel!
    
    var subscriptionManager: AmityTopicSubscription?
    var commentSet: Set<String> = []
    var storedComment: [AmityCommentModel] = []
        
    /// This sample app uses AmityVideoPlayer to play live videos.
    /// The player consumes the stream instance, and works automatically.
    /// At the this moment, the player only provide basic functionality, play and stop.
    ///
    /// For more rich features, it is recommend to use other video players that support RTMP streaming.
    /// You can get the RTMP url, by checking at `.watcherUrl` property.
    ///
    private var player: AmityVideoPlayer
    
    var timer = Timer()
    var isLike = false
    
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
    
    public init(streamIdToWatch: String, postId: String, post: AmityPost) {
        
        self.postRepository = AmityPostRepository(client: AmityUIKitManager.client)
        self.reactionRepository = AmityReactionRepository(client: AmityUIKitManager.client)
        self.streamRepository = AmityStreamRepository(client: AmityUIKitManager.client)
        self.commentRepository = AmityCommentRepository(client: AmityUIKitManager.client)
        self.subscriptionManager = AmityTopicSubscription(client: AmityUIKitManager.client)
        self.streamIdToWatch = streamIdToWatch
        self.player = AmityVideoPlayer(client: AmityUIKitManager.client)
        self.postId = postId
        self.amityPost = post
        
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: "LiveStreamPlayerViewController", bundle: bundle)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        liveObjectQueryToken = nil
        liveCommentQueryToken = nil
        subscriptionManager = nil
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
        getLiveStreamViwerCount()
        setupTableView()
        setupKeyboardListener()
        startRealTimeEventSubscribe()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
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
        
        streamingViewerContainer.clipsToBounds = true
        streamingViewerContainer.layer.cornerRadius = 4
        streamingViewerContainer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        streamingViewerCountLabel.textColor = .white
        streamingViewerCountLabel.font = AmityFontSet.captionBold
        
        streamEndTitleLabel.font = AmityFontSet.title
        streamEndDescriptionLabel.font = AmityFontSet.body
        
        loadingOverlay.isHidden = true
        
        // Show control at start by default
        controlContainer.isHidden = false
        
        controlContainer.alpha = 0
        
        loadingActivityIndicator.stopAnimating()
        
        controlContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(controlContainerDidTap)))
        
        renderGestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerContainerDidTap)))
        
    }
    
    func setupTableView(){
        
        guard let nibName = NSStringFromClass(LiveStreamBroadcastOverlayTableViewCell.self).components(separatedBy: ".").last else {
            fatalError("Class name not found")
        }
        let bundle = Bundle(for: LiveStreamBroadcastOverlayTableViewCell.self)
        let uiNib = UINib(nibName: nibName, bundle: bundle)
        commentTableView.register(uiNib, forCellReuseIdentifier: LiveStreamBroadcastOverlayTableViewCell.identifier)
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.separatorStyle = .none
        commentTableView.backgroundColor = .clear
        commentTableView.allowsSelection = false
        
        let textViewToolbar: UIToolbar = UIToolbar()
        textViewToolbar.barStyle = .default
        textViewToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: AmityLocalizedStringSet.General.done.localizedString, style: .done, target: self, action: #selector(cancelInput))
        ]
        textViewToolbar.sizeToFit()
//        commentTextView.inputAccessoryView = textViewToolbar
        commentTextView.backgroundColor = UIColor(hex: "#1C1C1C")
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = AmityColorSet.secondary.blend(.shade4).cgColor
        commentTextView.layer.cornerRadius = 4
        commentTextView.font = AmityFontSet.body.withSize(15)
        commentTextView.textColor = UIColor(hex: "#808080")
        commentTextView.layer.borderColor = UIColor(hex: "#808080").cgColor
        commentTextView.layer.cornerRadius = 10
        commentTextView.customTextViewDelegate = self
        commentTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        postCommentButton.titleLabel?.font = AmityFontSet.body.withSize(15)
        postCommentButton.addTarget(self, action: #selector(self.sendComment), for: .touchUpInside)
        
        liveCommentView.backgroundColor = UIColor(hex: "#404040", alpha: 1.0)
        
    }
    
    /// Call function get reaction count
    func getReactionData() {
        getReactionToken?.invalidate()
        getReactionToken = postRepository?.getPostForPostId(self.postId).observe { liveObject, error in
            guard liveObject.dataStatus == .fresh else { return }
            guard let post = liveObject.object else { return }
            var allReactions: [String] = []
            var myReactions: [AmityReactionType]
            allReactions = post.myReactions
            myReactions = allReactions.compactMap(AmityReactionType.init)
                        
            self.isLike = myReactions.contains(.like)
            
            print("---------------> \(liveObject.dataStatus)")
                        
            DispatchQueue.main.async {
                if self.isLike {
                    self.likeButton.isHidden = true
                    self.dislikeButton.isHidden = false
                } else {
                    self.likeButton.isHidden = false
                    self.dislikeButton.isHidden = true
                }
                self.likeCountLabel.text = String(post.reactionsCount)
            }
        }
    }
    
    func getLiveStreamViwerCount() {
        
        customAPIRequest.saveLiveStreamViewerData(postId: self.postId, liveStreamId: self.streamIdToWatch, userId: AmityUIKitManager.currentUserId, action: "join") { value in
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {_ in
            self.getReactionData()
            customAPIRequest.getLiveStreamViewerData(page_number: 1, liveStreamId: self.streamIdToWatch, type: "watching") { value in
                DispatchQueue.main.async {
                    self.streamingViewerCountLabel.text = String(value.count.formatUsingAbbrevation())
                }
            }
        })
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
            streamEndTitleLabel.text = AmityLocalizedStringSet.LiveStream.Show.ensesTitle.localizedString
            streamEndDescriptionLabel.text = AmityLocalizedStringSet.LiveStream.Show.playback.localizedString
            streamEndDescriptionLabel.isHidden = false
        case .idle:
            // Stream End Container will obseceure all views to show title and description.
            streamEndContainer.isHidden = false
            streamEndTitleLabel.text = AmityLocalizedStringSet.LiveStream.Show.unavailable.localizedString
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
    
    func setupKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @objc func cancelInput() {
        view.endEditing(true)
    }
    
    @IBAction private func stopButtonDidTouch() {
        stopStream()
    }
    
    @IBAction private func playButtonDidTouch() {
        playStream()
    }
    
    @IBAction func closeButtonDidTouch() {
        customAPIRequest.saveLiveStreamViewerData(postId: self.postId, liveStreamId: self.streamIdToWatch, userId: AmityUIKitManager.currentUserId, action: "leave") { value in
        }
        self.timer.invalidate()
        self.stopStream()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonDidTouch() {
        guard  let post = amityPost else { return }
        AmityEventHandler.shared.shareCommunityPostDidTap(from: self, title: nil, postId: self.postId, communityId: post.targetCommunity?.communityId ?? "")
    }
    
    @IBAction private func likeButtonDidTouch() {
        reactionRepository?.addReaction("like", referenceId: self.postId, referenceType: .post) { success, error in
            if success {
                print("-----------> Like")
                self.getReactionData()
            } else {
                AmityHUD.show(.error(message: AmityLocalizedStringSet.LiveStreamViewver.somethingWentWrong.localizedString))
            }
        }
    }
    
    @IBAction private func dislikeButtonDidTouch() {
        reactionRepository?.removeReaction("like", referenceId: self.postId, referenceType: .post) { success, error in
            if success {
                print("-----------> Unlike")
                self.getReactionData()
            }  else {
                AmityHUD.show(.error(message: AmityLocalizedStringSet.LiveStreamViewver.somethingWentWrong.localizedString))
            }
        }
    }
    
    @IBAction func hideCommentTable() {
        commentTableView.isHidden = true
        hideCommentButton.isHidden = true
        showCommentButton.isHidden = false
    }
    
    @IBAction func showCommentTable() {
        commentTableView.isHidden = false
        hideCommentButton.isHidden = false
        showCommentButton.isHidden = true
    }
    
}

extension LiveStreamPlayerViewController: AmityVideoPlayerDelegate {
    
    public func amityVideoPlayerMediaStateChanged(_ player: AmityVideoPlayer) {
        updateControlActionButton()
    }
    
}

//Move view when keyboard show and hide
extension LiveStreamPlayerViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if likeCommentViewBottomConstraint.constant == 0.0 {
//            if self.view.frame.origin.y == 0.0 {
                let safeAreaBottom = view.safeAreaInsets.bottom
//                self.view.frame.origin.y -= keyboardSize.height
                likeCommentViewBottomConstraint.constant += keyboardSize.height - safeAreaBottom
//
//                controlViewBottomConstraint.constant += 1000
//                renderGestureViewBottomConstraint.constant += 1000
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if likeCommentViewBottomConstraint.constant != 0.0 {
//        if self.view.frame.origin.y != 0.0 {
//            self.view.frame.origin.y = 0.0
//            let safeAreaBottom = view.safeAreaInsets.bottom
            likeCommentViewBottomConstraint.constant = 0.0
//            controlViewBottomConstraint.constant = safeAreaBottom
//            renderGestureViewBottomConstraint.constant = 0.0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension LiveStreamPlayerViewController: AmityTextViewDelegate {
    
    public func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == commentTextView {
            if text == "\n" {
                self.sendComment()
            }
        }
        return true
    }
    
    public func textViewDidChange(_ textView: AmityTextView) {
        if textView == commentTextView {
            let contentSize = textView.sizeThatFits(textView.bounds.size)
            commentTextViewHeight.constant = contentSize.height
            liveCommentViewHeightConstraint.constant = 70+contentSize.height-36
        }
    }
}

// MARK: - UITableViewDataSource
extension LiveStreamPlayerViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedComment.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LiveStreamBroadcastOverlayTableViewCell.identifier) as? LiveStreamBroadcastOverlayTableViewCell else { return UITableViewCell() }
        cell.display(comment: storedComment[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LiveStreamPlayerViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == commentTableView {
            if indexPath.row < storedComment.count {
                let currentComment = storedComment[indexPath.row]
                return LiveStreamBroadcastOverlayTableViewCell.height(for: currentComment, boundingWidth: commentTableView.bounds.width-40)
            }
        }
        return AmityMentionTableViewCell.height
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
}

// MARK: - Real time event
extension LiveStreamPlayerViewController {
    func startRealTimeEventSubscribe() {
        guard let currentPost = amityPost else { return }
        let eventTopic = AmityPostTopic(post: currentPost, andEvent: .comments)
        subscriptionManager?.subscribeTopic(eventTopic) { success, error in
            // Handle Result
            if success {
                print("[RTE]Successful to subscribe")
            } else {
                print("[RTE]Error: \(error?.localizedDescription)")
            }
        }
        
        liveCommentQueryToken = commentRepository?.getCommentsWithReferenceId(currentPost.postId, referenceType: .post, filterByParentId: false, parentId: nil, orderBy: .descending, includeDeleted: false).observe { collection, changes, error in
            if error != nil {
                print("[RTE]Error in get comment: \(error?.localizedDescription)")
            }
            let comments: [AmityCommentModel] = collection.allObjects().map(AmityCommentModel.init)
            print("[RTE]Comment : \(comments)")
            for comment in comments {
                if !self.commentSet.contains(comment.id){
                    self.commentSet.insert(comment.id)
                    self.storedComment.append(comment)
                } else {
                    continue
                }
            }
            DispatchQueue.main.async {
                self.commentTableView.reloadData()
                if !self.storedComment.isEmpty {
                    let lastIndex = IndexPath(row: self.storedComment.count-1, section: 0)
                    self.commentTableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @objc func sendComment() {
        //Reset all constant
        self.view.endEditing(true)
        commentTextViewHeight.constant = 36
        liveCommentViewHeightConstraint.constant = 70
        
        guard let currentPost = amityPost else { return }
        if commentTextView.text != "" || commentTextView.text == nil {
            guard let currentText = commentTextView.text else { return }
            self.commentTextView.text = ""
            liveCommentToken = commentRepository?.createComment(forReferenceId: currentPost.postId, referenceType: .post, parentId: currentPost.parentPostId, text: currentText).observeOnce { liveObject, error in
                if error != nil {
                    print("[LiveStream]Comment error: \(error?.localizedDescription)")
                }
            }
        } else {
            return
        }
    }
}
