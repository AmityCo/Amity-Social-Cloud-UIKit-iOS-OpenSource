//
//  LiveStreamBroadcastViewController.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 30/8/2564 BE.
//

import UIKit
import AmitySDK
import AmityLiveVideoBroadcastKit
import AmityUIKit

final public class LiveStreamBroadcastViewController: UIViewController {
    
    /// When the user finish live streaming, it will present post detail page.
    /// When the user exit post detail page, the it will dismiss back to this destination.
    public weak var destinationToUnwindBackAfterFinish: UIViewController?
    
    // MARK: - Dependencies
    
    let client: AmityClient
    let targetId: String?
    let targetType: AmityPostTargetType
    let communityRepository: AmityCommunityRepository
    let commentRepository: AmityCommentRepository
    let userRepository: AmityUserRepository
    let fileRepository: AmityFileRepository
    let streamRepository: AmityStreamRepository
    let postRepository: AmityPostRepository
    let reactionReposity: AmityReactionRepository
    var broadcaster: AmityStreamBroadcaster?
    
    // MARK: - Internal Const Properties
    
    /// The queue to execute go live operations.
    let goLiveOperationQueue = OperationQueue()
    
    /// Formatter to render live duration in streamingStatusLabel
    let liveDurationFormatter = DateComponentsFormatter()
    
    // MARK: - Private Const Properties
    private let mentionManager: AmityMentionManager
    // MARK: - States
    
    private var hasSetupBroadcaster = false
    
    /// Store cover image url, after the user choose cover image from the image picker.
    /// This will be used when the user press "go live" button.
    ///
    /// LiveStreamBroadcastVC+CoverImagePicker.swift
    var coverImageUrl: URL?
    
    /// Indicate current container state.
    ///
    /// LiveStreamBroadcast+UIContainerState.swift
    var containerState = ContainerState.create
    
    /// After successfully perform go live operationes, we will set the post.
    /// We use this post to start publish live stream, and navigate to post detail page, after the user finish streaming.
    var createdPost: AmityPost?
    
    /// This is set when this page start live publishing live stream.
    /// We use this state to display live stream timer.
    var startedAt: Date?
    
    /// We start this timer when we begin to publish stream.
    var liveDurationTimer: Timer?
    
    /// Live streaming token for get like count and live comment
    var liveObjectQueryToken: AmityNotificationToken?
    var liveCommentQueryToken: AmityNotificationToken?
    var liveCommentToken: AmityNotificationToken?
    var liveStreamCommentArray:String?
    
    
    /// Show and Hide comment button state
    var isShowCommentTable: Bool = true
    
    // MARK: - UI General
    @IBOutlet weak var renderingContainer: UIView!
    @IBOutlet private weak var overlayView: UIView!
    
    
    // MARK: - UI Container Create Components
    @IBOutlet weak var uiContainerCreate: UIView!
    
    // - uiContainerCreate.topRightStackView
    @IBOutlet private weak var selectCoverButton: UIButton! {
        didSet {
            selectCoverButton.layer.cornerRadius = 5
            selectCoverButton.setTitle(AmityLocalizedStringSet.LiveStream.Create.selectCover.localizedString, for: .normal)
        }
    }
    @IBOutlet private weak var coverImageContainer: UIView!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    // - uiContainerCreate.detailStackView
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var targetNameLabel: UILabel!
    @IBOutlet weak var titleTextField: AmityTextField!
    @IBOutlet weak var descriptionTextView: AmityTextView!
    
    @IBOutlet weak var goLiveButton: UIButton!
    
    // MARK: - UI Container Streaming Components
    @IBOutlet weak var uiContainerStreaming: UIView!
    @IBOutlet weak var streamingContainer: UIView!
    @IBOutlet weak var streamingStatusLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var streamingViewerContainer: UIView!
    @IBOutlet weak var streamingViewerCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet private weak var commentTableView: UITableView!
    @IBOutlet private weak var commentTextView: AmityTextView!
    @IBOutlet private weak var commentTextViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var postCommentButton: UIButton!
    @IBOutlet private weak var hideCommentButton: UIButton!
    @IBOutlet private weak var showCommentButton: UIButton!
    @IBOutlet private weak var streamingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var liveCommentView: UIView!
    @IBOutlet private weak var liveCommentViewHeightConstraint: NSLayoutConstraint!

    // MARK: - UI Container End Components
    @IBOutlet weak var uiContainerEnd: UIView!
    @IBOutlet weak var streamEndActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var streamEndLabel: UILabel!
    
    // MARK: - UI Mention tableView
    @IBOutlet private var mentionTableView: AmityMentionTableView!
    @IBOutlet private var mentionTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var mentionTableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Keyboard Observations
    // LiveStreamBroadcastVC+Keyboard.swift
    var keyboardIsHidden = true
    var keyboardHeight: CGFloat = 0
    var keyboardObservationTokens: [NSObjectProtocol] = []
    
    var isClose: Bool = false
        
    var streamId: String?
    var timer = Timer()
    var subscriptionManager: AmityTopicSubscription?
    var commentSet: Set<String> = []
    var storedComment: [AmityCommentModel] = []
    
    // MARK: - Init / Deinit
    
    public init(client: AmityClient, targetId: String?, targetType: AmityPostTargetType) {
        
        self.client = client
        self.targetId = targetId
        self.targetType = targetType
         
        communityRepository = AmityCommunityRepository(client: client)
        commentRepository = AmityCommentRepository(client: client)
        userRepository = AmityUserRepository(client: client)
        fileRepository = AmityFileRepository(client: client)
        streamRepository = AmityStreamRepository(client: client)
        postRepository = AmityPostRepository(client: client)
        reactionReposity = AmityReactionRepository(client: client)
        broadcaster = AmityStreamBroadcaster(client: client)
        subscriptionManager = AmityTopicSubscription(client: client)
        mentionManager = AmityMentionManager(withType: .post(communityId: targetId))
        
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: "LiveStreamBroadcastViewController", bundle: bundle)
        
        goLiveOperationQueue.maxConcurrentOperationCount = 1
        // It's fine to set the underlyingQueue to main thread.
        // The work items will be schedule and pickup on the main thread.
        // While the actual work will be run in the background thread.
        // See the detail of main() functions of GoLive operations.
        goLiveOperationQueue.underlyingQueue = .main
        
        liveDurationFormatter.allowedUnits = [.minute, .second]
        liveDurationFormatter.unitsStyle = .positional
        liveDurationFormatter.zeroFormattingBehavior = .pad
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        liveObjectQueryToken = nil
        liveCommentQueryToken = nil
        subscriptionManager = nil
        unobserveKeyboardFrame()
        stopLiveDurationTimer()
    }
    
    // MARK: - View Controller Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        queryTargetDetail()
        observeKeyboardFrame()
        updateCoverImageSelection()
        switchToUIState(.create)
        mentionManager.delegate = self
        mentionManager.setFont(AmityFontSet.body, highlightFont: AmityFontSet.bodyBold)
        mentionManager.setColor(.white, highlightColor: .white)
        getLiveStreamViwerCount()
        setupKeyboardListener()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
        updateUIBaseOnKeyboardFrame()
        //
        // If the permission is authorized, we can try setup broadcaster now.
        if permissionsGranted() {
            trySetupBroadcaster()
        } else if permissionsNotDetermined() {
            requestPermissions { [weak self] granted in
                if granted {
                    self?.trySetupBroadcaster()
                } else {
                    self?.presentPermissionRequiredDialogue()
                }
            }
        } else {
            presentPermissionRequiredDialogue()
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUIBaseOnKeyboardFrame()
    }
    
    // MARK: - Internal Functions
    
    /// Call function get reaction count
    func getLikeCount() {
        guard let postId = createdPost?.postId else { return }
        liveObjectQueryToken = postRepository.getPostForPostId(postId).observe { liveObject, error in
            guard let post = liveObject.object else { return }
            self.likeCountLabel.text = String(post.reactionsCount)
        }
    }
    
    /// Call function Timer With Interval
    func getLiveStreamViwerCount() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {_ in
            customAPIRequest.getLiveStreamViewerData(page_number: 1, liveStreamId: self.streamId ?? "", type: "watching") { value in
                DispatchQueue.main.async {
                    self.streamingViewerCountLabel.text = String(value.count.formatUsingAbbrevation())
                }
            }
        })
    }
    
    /// goLiveButtomSpace will change base on keyboard frame.
    func updateUIBaseOnKeyboardFrame() {
        
        // Currently we don't do update UI base on keyboard.
        
        guard isViewLoaded, view.window != nil else {
            // only perform this logic, when view controller is visible.
            return
        }
        if keyboardIsHidden {
            mentionTableViewBottomConstraint.constant = 0
        } else {
            mentionTableViewBottomConstraint.constant = keyboardHeight
        }
        view.setNeedsLayout()
        
    }
    
    /// Call this function to update UI state, when the user select / unselect cover image
    func updateCoverImageSelection() {
        if let coverImageUrl = coverImageUrl {
            coverImageView.image = UIImage(contentsOfFile: coverImageUrl.path)
            selectCoverButton.isHidden = true
            coverImageContainer.isHidden = false
        } else {
            selectCoverButton.isHidden = false
            coverImageContainer.isHidden = true
        }
    }
    
    // MARK: - Private Functions
    
    private func setupViews() {
        
        targetNameLabel.textColor = .white
        targetNameLabel.font = AmityFontSet.bodyBold
        
        targetImageView.contentMode = .scaleAspectFill
        targetImageView.layer.cornerRadius = targetImageView.bounds.height * 0.5
        targetImageView.backgroundColor = UIColor.lightGray
        
        titleTextField.maxLength = 30
        titleTextField.font = AmityFontSet.headerLine
        titleTextField.textColor = .white
        titleTextField.attributedPlaceholder =
        NSAttributedString(string: AmityLocalizedStringSet.LiveStream.Create.title.localizedString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        titleTextField.returnKeyType = .done
        titleTextField.delegate = self
        
        descriptionTextView.text = nil
        descriptionTextView.padding = .zero
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.font = AmityFontSet.body
        descriptionTextView.placeholder = AmityLocalizedStringSet.LiveStream.Create.description.localizedString
        descriptionTextView.textColor = .white
        descriptionTextView.returnKeyType = .default
        descriptionTextView.customTextViewDelegate = self
        descriptionTextView.typingAttributes = [.font: AmityFontSet.body, .foregroundColor: UIColor.white]
        
        let textViewToolbar: UIToolbar = UIToolbar()
        textViewToolbar.barStyle = .default
        textViewToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: AmityLocalizedStringSet.General.done.localizedString, style: .done, target: self, action: #selector(cancelInput))
        ]
        textViewToolbar.sizeToFit()
        descriptionTextView.inputAccessoryView = textViewToolbar
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 4
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCoverButtonDidTouch)))
        
        goLiveButton.backgroundColor = .white
        goLiveButton.clipsToBounds = true
        goLiveButton.layer.cornerRadius = 4
        goLiveButton.layer.borderWidth = 1
        goLiveButton.layer.borderColor = UIColor(red: 0.647, green: 0.663, blue: 0.71, alpha: 1).cgColor
        goLiveButton.setAttributedTitle(NSAttributedString(string: AmityLocalizedStringSet.LiveStream.Create.goLive.localizedString, attributes: [
            .foregroundColor: UIColor.black,
            .font: AmityFontSet.bodyBold
        ]), for: .normal)
        
//        finishButton.backgroundColor = .black
//        finishButton.setAttributedTitle(NSAttributedString(string: AmityLocalizedStringSet.LiveStream.Live.finish.localizedString, attributes: [
//            .foregroundColor: UIColor.white,
//            .font: AmityFontSet.bodyBold
//        ]), for: .normal)
//        finishButton.setTitleColor(.white, for: .normal)
//        finishButton.clipsToBounds = true
//        finishButton.layer.cornerRadius = 4
//        finishButton.layer.borderColor = UIColor.white.cgColor
//        finishButton.layer.borderWidth = 1
        
        streamingContainer.clipsToBounds = true
        streamingContainer.layer.cornerRadius = 4
        streamingContainer.backgroundColor = UIColor(red: 1, green: 0.188, blue: 0.353, alpha: 1)
        streamingStatusLabel.textColor = .white
        streamingStatusLabel.font = AmityFontSet.captionBold
        
        streamingViewerContainer.clipsToBounds = true
        streamingViewerContainer.layer.cornerRadius = 4
        streamingViewerContainer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        streamingViewerCountLabel.textColor = .white
        streamingViewerCountLabel.font = AmityFontSet.captionBold
        setupMentionTableView()
        
        streamEndLabel.text = AmityLocalizedStringSet.LiveStream.Live.endingLiveStream.localizedString
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
        commentTextView.backgroundColor = UIColor(hex: "#474747")
        commentTextView.layer.cornerRadius = 4
        commentTextView.font = AmityFontSet.body
        commentTextView.textColor = UIColor(hex: "#8c8c8c")
        commentTextView.layer.cornerRadius = 10
        commentTextView.customTextViewDelegate = self
        commentTextView.textContainer.lineBreakMode = .byTruncatingTail
        commentTextView.placeholder = AmityLocalizedStringSet.LiveStream.Live.streamningCommentPlaceholder.localizedString
        
        postCommentButton.titleLabel?.font = AmityFontSet.body
        postCommentButton.addTarget(self, action: #selector(self.sendComment), for: .touchUpInside)
        
        liveCommentView.backgroundColor = UIColor(hex: "#000000", alpha: 1.0)
    }
    
    private func trySetupBroadcaster() {
        if !hasSetupBroadcaster && permissionsGranted() {
            hasSetupBroadcaster = true
            setupBroadcaster()
        }
    }
    
    private func setupBroadcaster() {
        
        guard let broadcaster = broadcaster else {
            assertionFailure("broadcaster must exist at this point.")
            return
        }
        
        let config = AmityStreamBroadcasterConfiguration()
        config.canvasFitting = .fill
        config.bitrate = 3_000_000 // 3mbps
        config.frameRate = .fps30
        
        broadcaster.delegate = self
        broadcaster.videoResolution = renderingContainer.bounds.size
        broadcaster.setup(with: config)
        
        // Embed broadcaster.previewView
        broadcaster.previewView.translatesAutoresizingMaskIntoConstraints = false
        renderingContainer.addSubview(broadcaster.previewView)
        
        NSLayoutConstraint.activate([
            broadcaster.previewView.centerYAnchor.constraint(equalTo: renderingContainer.centerYAnchor),
            broadcaster.previewView.centerXAnchor.constraint(equalTo: renderingContainer.centerXAnchor),
            broadcaster.previewView.widthAnchor.constraint(equalToConstant: renderingContainer.bounds.width),
            broadcaster.previewView.heightAnchor.constraint(equalToConstant: renderingContainer.bounds.height)
        ])
        
    }
    
    private func switchCamera() {
        
        guard let broadcaster = broadcaster else {
            assertionFailure("broadcaster must exist at this point.")
            return
        }
        
        switch broadcaster.cameraPosition {
        case .front:
            broadcaster.cameraPosition = .back
        case .back:
            broadcaster.cameraPosition = .front
        @unknown default:
            assertionFailure("Unhandled case")
        }
        
    }
    
    private func presentEndLiveStreamConfirmationDialogue() {
        let title = AmityLocalizedStringSet.LiveStream.Live.titleStopLive.localizedString
        let alertController = UIAlertController(title: title, message: AmityLocalizedStringSet.LiveStream.Live.descriptionStopLive.localizedString, preferredStyle: .alert)
        let end = UIAlertAction(title: AmityLocalizedStringSet.LiveStream.Live.stopLive.localizedString, style: .default) { [weak self] action in
            self?.finishLive()
            self?.timer.invalidate()
        }
        let cancel = UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .cancel, handler: nil)
        alertController.addAction(end)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func cancelInput() {
        view.endEditing(true)
    }
    
    private func setupMentionTableView() {
        mentionTableView.isHidden = true
        mentionTableView.delegate = self
        mentionTableView.dataSource = self
        mentionTableView.register(AmityMentionTableViewCell.nib, forCellReuseIdentifier: AmityMentionTableViewCell.identifier)
    }
    
    private func showAlertForMaximumCharacters() {
        let title = "Unable to post"
        let message = "Unable message"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupKeyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        //Looks for single or multiple taps.
//         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//
//        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
//        tap.cancelsTouchesInView = false
//
//        view.addGestureRecognizer(tap)
    }
    
    // MARK: - IBActions
    
    @IBAction private func switchCameraButtonDidTouch() {
        switchCamera()
    }
    
    @IBAction private func selectCoverButtonDidTouch() {
        checkPhotoLibraryPermission {
            DispatchQueue.main.async { [weak self] in
                self?.presentCoverImagePicker()
            }
        } fail: {
            self.alertPhotoPermision()
        }
    }
    
    @IBAction private func closeButtonDidTouch() {
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func goLiveButtonDidTouch() {
        let titleCount = "\(titleTextField.text ?? "")\n\n".count
        let metadata = mentionManager.getMetadata(shift: titleCount)
        let mentionees = mentionManager.getMentionees()
        
        if !permissionsGoliveNotDetermined() {
            requestPermissions { [weak self] granted in
                if granted {
                    self?.trySetupBroadcaster()
                    self?.mentionManager.resetState()
                    self?.goLive(metadata: metadata, mentionees: mentionees)
                } else {
                    self?.presentPermissionRequiredDialogue()
                }
            }
        } else {
            trySetupBroadcaster()
            mentionManager.resetState()
            goLive(metadata: metadata, mentionees: mentionees)
        }
    }
    
    @IBAction func finishButtonDidTouch() {
        presentEndLiveStreamConfirmationDialogue()
    }
    
    @IBAction func shareButtonDidTouch() {
        guard  let post = createdPost else { return }
        AmityEventHandler.shared.shareCommunityPostDidTap(from: self, title: nil, postId: post.postId, communityId: post.targetCommunity?.communityId ?? "")
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

extension LiveStreamBroadcastViewController: AmityTextViewDelegate {
    public func textViewDidChangeSelection(_ textView: AmityTextView) {
        mentionManager.changeSelection(textView)
    }
    
    public func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if textView.text?.count ?? 0 > AmityMentionManager.maximumCharacterCountForPost {
//            showAlertForMaximumCharacters()
//            return false
//        }
//        return mentionManager.shouldChangeTextIn(textView, inRange: range, replacementText: text, currentText: textView.text ?? "")
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

extension LiveStreamBroadcastViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case titleTextField:
            return titleTextField.verifyFields(shouldChangeCharactersIn: range, replacementString: string)
            
        default:
            return true
        }
    }
    
}

extension LiveStreamBroadcastViewController: AmityStreamBroadcasterDelegate {
    
    public func amityStreamBroadcasterDidUpdateState(_ broadcaster: AmityStreamBroadcaster) {
        updateStreamingStatusText()
    }
    
}

// MARK: - AmityMentionManagerDelegate
extension LiveStreamBroadcastViewController: AmityMentionManagerDelegate {
    public func didGetUsers(users: [AmityMentionUserModel]) {
        if users.isEmpty {
            mentionTableViewHeightConstraint.constant = 0
            mentionTableView.isHidden = true
        } else {
            var heightConstant:CGFloat = 240.0
            if users.count < 5 {
                heightConstant = CGFloat(users.count) * 52.0
            }
            mentionTableViewHeightConstraint.constant = heightConstant
            mentionTableView.isHidden = false
            mentionTableView.reloadData()
        }
//        mentionTableView.isHidden = true
    }
    
    public func didCreateAttributedString(attributedString: NSAttributedString) {
        descriptionTextView.attributedText = attributedString
        descriptionTextView.typingAttributes = [.font: AmityFontSet.body, .foregroundColor: UIColor.white]
    }
    
    public func didMentionsReachToMaximumLimit() {
        let alertController = UIAlertController(title: AmityLocalizedStringSet.Mention.unableToMentionTitle.localizedString, message: AmityLocalizedStringSet.Mention.unableToMentionReplyDescription.localizedString, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.done.localizedString, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func didCharactersReachToMaximumLimit() {
        showAlertForMaximumCharacters()
    }
}

// MARK: - UITableViewDataSource
extension LiveStreamBroadcastViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == commentTableView {
            return storedComment.count
        }
        return mentionManager.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == commentTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LiveStreamBroadcastOverlayTableViewCell.identifier) as? LiveStreamBroadcastOverlayTableViewCell else { return UITableViewCell() }
            cell.display(comment: storedComment[indexPath.row])
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AmityMentionTableViewCell.identifier) as? AmityMentionTableViewCell else { return UITableViewCell() }
        if let model = mentionManager.item(at: indexPath) {
            cell.display(with: model)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LiveStreamBroadcastViewController: UITableViewDelegate {
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textInput: UITextInput = titleTextField
        var text = titleTextField.text
        if !titleTextField.isFirstResponder {
            textInput = descriptionTextView
            text = descriptionTextView.text
        }
        
        mentionManager.addMention(from: textInput, in: text ?? "", at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == commentTableView {

        } else {
            if tableView.isBottomReached {
                mentionManager.loadMore()
            }
        }
    }

    
}

// MARK: - Real time event
extension LiveStreamBroadcastViewController {
    func startRealTimeEventSubscribe() {
        guard let currentPost = createdPost else { return }
        let eventTopic = AmityPostTopic(post: currentPost, andEvent: .comments)
        subscriptionManager?.subscribeTopic(eventTopic) { success, error in
            // Handle Result
            if success {
                print("[RTE]Successful to subscribe")
            } else {
                print("[RTE]Error: \(error?.localizedDescription)")
            }
        }
        
        liveCommentQueryToken = commentRepository.getCommentsWithReferenceId(currentPost.postId, referenceType: .post, filterByParentId: false, parentId: nil, orderBy: .descending, includeDeleted: false).observe { collection, changes, error in
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
        
        guard let currentPost = createdPost else { return }
        if commentTextView.text != "" || commentTextView.text == nil {
            guard let currentText = commentTextView.text else { return }
            self.commentTextView.text = ""
            liveCommentToken = commentRepository.createComment(forReferenceId: currentPost.postId, referenceType: .post, parentId: currentPost.parentPostId, text: currentText).observeOnce { liveObject, error in
                if error != nil {
                    print("[LiveStream]Comment error: \(error?.localizedDescription)")
                }
            }
        } else {
            return
        }
    }
}

//Move view when keyboard show and hide
extension LiveStreamBroadcastViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if streamingViewBottomConstraint.constant == 0.0 {
                streamingViewBottomConstraint.constant += keyboardSize.height
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
        if streamingViewBottomConstraint.constant != 0.0 {
            streamingViewBottomConstraint.constant = 0.0
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

extension Int {
    
    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()
        
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        return numFormatter.string(from: NSNumber (value:value))!
    }
}
