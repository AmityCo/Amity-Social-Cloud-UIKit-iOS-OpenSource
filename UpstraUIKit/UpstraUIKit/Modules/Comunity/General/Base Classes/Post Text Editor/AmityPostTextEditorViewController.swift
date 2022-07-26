//
//  AmityPostTextEditorViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 1/7/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit
import Photos
import AmitySDK
import AVKit
import MobileCoreServices
import AVFoundation

public class AmityPostEditorSettings {
    
    public init() { }
    
    /// To set what are the attachment types to allow, the default value is `AmityPostAttachmentType.allCases`.
    public var allowPostAttachments: Set<AmityPostAttachmentType> = Set<AmityPostAttachmentType>(AmityPostAttachmentType.allCases)
    
    public var shouldCameraButtonHide: Bool = false
    public var shouldAlbumButtonHide: Bool = false
    public var shouldFileButtonHide: Bool = true
    public var shouldVideoButtonHide: Bool = false
    public var shouldExpandButtonHide: Bool = true
}

protocol AmityPostViewControllerDelegate: AnyObject {
    func postViewController(_ viewController: UIViewController, didCreatePost post: AmityPostModel)
    func postViewController(_ viewController: UIViewController, didUpdatePost post: AmityPostModel)
}

public class AmityPostTextEditorViewController: AmityViewController {
    
    enum Constant {
        static let maximumNumberOfImages: Int = 10
    }
    
    // MARK: - Properties
    
    // Use specifically for edit mode
    private var currentPost: AmityPostModel?
    
    private let settings: AmityPostEditorSettings
    private var screenViewModel: AmityPostTextEditorScreenViewModelType = AmityPostTextEditorScreenViewModel()
    private let postTarget: AmityPostTarget
    private let postType: PostFromTodayType?
    private let postMode: AmityPostMode
    
    private var galleryAsset: [PHAsset] = []
    private var fromGallery: Bool = false
    
    private let comunityPanelView = AmityComunityPanelView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let textView = AmityTextView(frame: .zero)
    private let separaterLine = UIView(frame: .zero)
//    private let galleryView = AmityGalleryCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let galleryView = TrueIDGalleryCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let fileView = AmityFileTableView(frame: .zero, style: .plain)
    private let postMenuView: AmityPostTextEditorMenuView
    private var postButton: UIBarButtonItem!
    private var galleryViewHeightConstraint: NSLayoutConstraint!
    private var fileViewHeightConstraint: NSLayoutConstraint!
    private var postMenuViewBottomConstraints: NSLayoutConstraint!
    private var filePicker: AmityFilePicker!
    private var mentionTableView: AmityMentionTableView
    private var mentionTableViewHeightConstraint: NSLayoutConstraint!
    private var mentionManager: AmityMentionManager?
    
    private var isValueChanged: Bool {
        return !textView.text.isEmpty || !galleryView.medias.isEmpty || !fileView.files.isEmpty
    }
    
    private var currentAttachmentState: AmityPostAttachmentType? {
        didSet {
            postMenuView.currentAttachmentState = currentAttachmentState
        }
    }
    
    weak var delegate: AmityPostViewControllerDelegate?
    
    init(postTarget: AmityPostTarget, postMode: AmityPostMode, settings: AmityPostEditorSettings) {
        
        self.postTarget = postTarget
        self.postType = nil
        self.postMode = postMode
        self.settings = settings
        self.postMenuView = AmityPostTextEditorMenuView(allowPostAttachments: settings.allowPostAttachments)
        self.mentionTableView = AmityMentionTableView(frame: .zero)
        
        if postMode == .create {
            var communityId: String? = nil
            switch postTarget {
            case .community(let community):
                communityId = community.isPublic ? nil : community.communityId
            default: break
            }
            mentionManager = AmityMentionManager(withType: .post(communityId: communityId))
        }
        
        super.init(nibName: nil, bundle: nil)
        
        screenViewModel.delegate = self
    }
    
    //init from today page
    init(postTarget: AmityPostTarget, postType: PostFromTodayType, postMode: AmityPostMode, settings: AmityPostEditorSettings) {
        
        self.postTarget = postTarget
        self.postType = postType
        self.postMode = postMode
        self.settings = settings
        self.postMenuView = AmityPostTextEditorMenuView(allowPostAttachments: settings.allowPostAttachments)
        self.mentionTableView = AmityMentionTableView(frame: .zero)
        
        if postMode == .create {
            var communityId: String? = nil
            switch postTarget {
            case .community(let community):
                communityId = community.isPublic ? nil : community.communityId
            default: break
            }
            mentionManager = AmityMentionManager(withType: .post(communityId: communityId))
        }
        
        super.init(nibName: nil, bundle: nil)
        
        screenViewModel.delegate = self
    }
    
    //init when select media from gallery
    init(postTarget: AmityPostTarget, postMode: AmityPostMode, settings: AmityPostEditorSettings, asset: [PHAsset]) {
        
        self.postTarget = postTarget
        self.postType = nil
        self.postMode = postMode
        self.settings = settings
        self.galleryAsset = asset
        self.fromGallery = true
        self.postMenuView = AmityPostTextEditorMenuView(allowPostAttachments: settings.allowPostAttachments)
        self.mentionTableView = AmityMentionTableView(frame: .zero)
        
        if postMode == .create {
            var communityId: String? = nil
            switch postTarget {
            case .community(let community):
                communityId = community.isPublic ? nil : community.communityId
            default: break
            }
            mentionManager = AmityMentionManager(withType: .post(communityId: communityId))
        }
        
        super.init(nibName: nil, bundle: nil)
        
        screenViewModel.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        filePicker = AmityFilePicker(presentationController: self, delegate: self)
        
        let isCreateMode = (postMode == .create)
        postButton = UIBarButtonItem(title: isCreateMode ? AmityLocalizedStringSet.General.post.localizedString : AmityLocalizedStringSet.General.save.localizedString, style: .plain, target: self, action: #selector(onPostButtonTap))
        postButton.tintColor = AmityColorSet.primary
        navigationItem.rightBarButtonItem = postButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        #warning("ViewController must be implemented with storyboard")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.backgroundColor = AmityColorSet.backgroundColor
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: AmityPostTextEditorMenuView.defaultHeight, right: 0)
        view.addSubview(scrollView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.padding = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        textView.customTextViewDelegate = self
        textView.isScrollEnabled = false
        textView.font = AmityFontSet.body
        textView.minCharacters = 1
        textView.placeholder = AmityLocalizedStringSet.postCreationTextPlaceholder.localizedString
        scrollView.addSubview(textView)
        
        separaterLine.translatesAutoresizingMaskIntoConstraints = false
        separaterLine.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        separaterLine.isHidden = true
        scrollView.addSubview(separaterLine)
        
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        galleryView.actionDelegate = self
        galleryView.isEditable = true
        galleryView.isScrollEnabled = false
        galleryView.backgroundColor = AmityColorSet.backgroundColor
        scrollView.addSubview(galleryView)
        
        fileView.translatesAutoresizingMaskIntoConstraints = false
        fileView.actionDelegate = self
        fileView.isEditingMode = true
        scrollView.addSubview(fileView)
        
        postMenuView.translatesAutoresizingMaskIntoConstraints = false
        postMenuView.delegate = self
        view.addSubview(postMenuView)
        
        comunityPanelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(comunityPanelView)
        
        mentionTableView.isHidden = true
        mentionTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mentionTableView)
        mentionTableViewHeightConstraint = mentionTableView.heightAnchor.constraint(equalToConstant: 240.0)
        
        galleryViewHeightConstraint = NSLayoutConstraint(item: galleryView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        fileViewHeightConstraint = NSLayoutConstraint(item: fileView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        postMenuViewBottomConstraints = NSLayoutConstraint(item: postMenuView, attribute: .bottom, relatedBy: .equal, toItem: view.layoutMarginsGuide, attribute: .bottom, multiplier: 1, constant: 0)
        
        switch postMode {
        case .create:
            // If there is no menu to show, so we don't show postMenuView.
            postMenuView.isHidden = settings.allowPostAttachments.isEmpty
        case .edit:
            postMenuView.isHidden = true
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            postMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postMenuView.heightAnchor.constraint(equalToConstant: postMode == .create ? AmityPostTextEditorMenuView.defaultHeight : 0),
            postMenuViewBottomConstraints,
            comunityPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comunityPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comunityPanelView.bottomAnchor.constraint(equalTo: postMenuView.topAnchor),
            comunityPanelView.heightAnchor.constraint(equalToConstant: AmityComunityPanelView.defaultHeight),
            textView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            textView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            separaterLine.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            separaterLine.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            separaterLine.centerYAnchor.constraint(equalTo: galleryView.topAnchor),
            separaterLine.heightAnchor.constraint(equalToConstant: 1),
            galleryView.topAnchor.constraint(equalTo: textView.bottomAnchor),
            galleryView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            galleryView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            galleryView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            galleryViewHeightConstraint,
            fileView.topAnchor.constraint(equalTo: galleryView.bottomAnchor),
            fileView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            fileView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            fileView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            fileViewHeightConstraint,
            mentionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mentionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mentionTableView.bottomAnchor.constraint(equalTo: postMenuView.topAnchor),
            mentionTableViewHeightConstraint
        ])
        updateConstraints()
        // keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        switch postMode {
        case .edit(let postId):
            screenViewModel.dataSource.loadPost(for: postId)
            title = AmityLocalizedStringSet.postCreationEditPostTitle.localizedString
            comunityPanelView.isHidden = true
        case .create:
            switch postTarget {
            case .community(let comunity):
                title = comunity.displayName
                comunityPanelView.isHidden = true
            case .myFeed:
                AmityEventHandler.shared.communityCreatePostButtonTracking(screenName: ScreenName.userProfile.rawValue)
                title = AmityLocalizedStringSet.postCreationMyTimelineTitle.localizedString
                comunityPanelView.isHidden = true
            }
        }
        
        if case .edit(let postId) = postMode {
            screenViewModel.dataSource.loadPost(for: postId)
        }
        mentionTableView.delegate = self
        mentionTableView.dataSource = self
        mentionManager?.delegate = self
        
        if postType != nil {
            switch postType {
            case .video:
                postMenuView(postMenuView, didTap: .video)
            case .photo:
                postMenuView(postMenuView, didTap: .album)
            case .camera:
                postMenuView(postMenuView, didTap: .camera)
            default:
                break
            }
        }
        
        if !galleryAsset.isEmpty {
            addMediasFromGallery()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationController?.setNavigationBarHidden(false, animated: false)
            self?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    public override func didTapLeftBarButton() {
        if isValueChanged {
            let alertController = UIAlertController(title: AmityLocalizedStringSet.postCreationDiscardPostTitle.localizedString, message: AmityLocalizedStringSet.postCreationDiscardPostMessage.localizedString, preferredStyle: .alert)
            alertController.setTitle(font: AmityFontSet.title)
            alertController.setMessage(font: AmityFontSet.body)
            let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .cancel, handler: nil)
            let discardAction = UIAlertAction(title: AmityLocalizedStringSet.General.discard.localizedString, style: .destructive) { [weak self] _ in
                self?.generalDismiss()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(discardAction)
            present(alertController, animated: true, completion: nil)
        } else {
            generalDismiss()
        }
    }
    
    private func updateConstraints() {
        fileViewHeightConstraint.constant = AmityFileTableView.height(for: fileView.files.count, isEdtingMode: true, isExpanded: false)
        galleryViewHeightConstraint.constant = TrueIDGalleryCollectionView.height(for: galleryView.contentSize.width, numberOfItems: galleryView.medias.count)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardScreenEndFrame = keyboardValue.size
        let comunityPanelHeight = comunityPanelView.isHidden ? 0.0 : AmityComunityPanelView.defaultHeight
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: AmityPostTextEditorMenuView.defaultHeight + comunityPanelHeight, right: 0)
            postMenuViewBottomConstraints.constant = view.layoutMargins.bottom
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardScreenEndFrame.height - view.safeAreaInsets.bottom + AmityPostTextEditorMenuView.defaultHeight + comunityPanelHeight, right: 0)
            postMenuViewBottomConstraints.constant = view.layoutMargins.bottom - keyboardScreenEndFrame.height
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    // MARK: - Action
    
    @objc private func onPostButtonTap() {
        guard let text = textView.text else { return }
        let medias = galleryView.medias
        let files = fileView.files
        
        view.endEditing(true)
        postButton.isEnabled = false
        let metadata = mentionManager?.getMetadata()
        let mentionees = mentionManager?.getMentionees()
        if let post = currentPost {
            // update post
            screenViewModel.updatePost(oldPost: post, text: text, medias: medias, files: files, metadata: metadata, mentionees: mentionees)
        } else {
            // create post
            var communityId: String?
            if case .community(let community) = postTarget {
                communityId = community.communityId
            }
            screenViewModel.createPost(text: text, medias: medias, files: files, communityId: communityId, metadata: metadata, mentionees: mentionees)
        }
        
    }
    
    private func updateViewState() {
        
        // Update separater state
        separaterLine.isHidden = galleryView.medias.isEmpty && fileView.files.isEmpty
        
        var isPostValid = textView.isValid
        
        // Update post button state
        var isImageValid = true
        if !galleryView.medias.isEmpty {
            isImageValid = galleryView.medias.filter({
                switch $0.state {
                case .uploadedImage, .uploadedVideo , .downloadableImage, .downloadableVideo:
                    return false
                default:
                    return true
                }
            }).isEmpty
            isPostValid = isImageValid
        }
        var isFileValid = true
        if !fileView.files.isEmpty {
            isFileValid = fileView.files.filter({
                switch $0.state {
                case .uploaded, .downloadable:
                    return false
                default:
                    return true
                }
            }).isEmpty
            isPostValid = isFileValid
        }
        
        if let post = currentPost {
            let isTextChanged = textView.text != post.text
            let isImageChanged = galleryView.medias != post.medias
            let isDocumentChanged = fileView.files.map({ $0.id }) != post.files.map({ $0.id })
            let isPostChanged = isTextChanged || isImageChanged || isDocumentChanged
            postButton.isEnabled = isPostChanged && isPostValid
        } else {
            postButton.isEnabled = isPostValid
        }
        
        if galleryView.medias.count == Constant.maximumNumberOfImages {
            postMenuView.isMaximum = true
        } else {
            postMenuView.isMaximum = false
        }
        
        // Update postMenuView.currentAttachmentState to disable buttons based on the chosen attachment.
        if !fileView.files.isEmpty {
            currentAttachmentState = .file
        } else if galleryView.medias.contains(where: { $0.type == .image }) {
            currentAttachmentState = .image
        } else if galleryView.medias.contains(where: { $0.type == .video }) {
            currentAttachmentState = .video
        } else {
            currentAttachmentState = .none
        }
        
        if textView.text.isEmpty {
            textView.textColor = AmityColorSet.base
        }
    }
    
    // MARK: Helper functions
    
    private func uploadImages() {
        let fileUploadFailedDispatchGroup = DispatchGroup()
        var isUploadFailed = false
        for index in 0..<galleryView.medias.count {
            let media = galleryView.medias[index]
            guard case .idle = galleryView.viewState(for: media.id) else {
                // If file is uploading, skip checking task
                continue
            }
            switch galleryView.mediaState(for: media.id) {
            case .localAsset, .image:
                fileUploadFailedDispatchGroup.enter()
                // Start with 0% immediately.
                galleryView.updateViewState(for: media.id, state: .uploading(progress: 0))
                // get local image for uploading
                media.getImageForUploading { [weak self] result in
                    switch result {
                    case .success(let img):
                        AmityUIKitManagerInternal.shared.fileService.uploadImage(image: img, progressHandler: { progress in
                            self?.galleryView.updateViewState(for: media.id, state: .uploading(progress: progress))
                            Log.add("[UIKit]: Upload Progress \(progress)")
                        }, completion:  { [weak self, weak fileUploadFailedDispatchGroup] result in
                            switch result {
                            case .success(let imageData):
                                Log.add("[UIKit]: Uploaded image data \(imageData.fileId)")
                                media.state = .uploadedImage(data: imageData)
                                self?.galleryView.updateViewState(for: media.id, state: .uploaded)
                            case .failure:
                                Log.add("[UIKit]: Image upload failed")
                                media.state = .error
                                self?.galleryView.updateViewState(for: media.id, state: .error)
                                isUploadFailed = true
                            }
                            fileUploadFailedDispatchGroup?.leave()
                            self?.updateViewState()
                        })
                    case .failure:
                        media.state = .error
                        self?.galleryView.updateViewState(for: media.id, state: .error)
                        isUploadFailed = true
                    }
                }
            default:
                Log.add("[UIKit]: Unsupported media state for uploading.")
                break
            }
        }
        
        fileUploadFailedDispatchGroup.notify(queue: .main) { [weak self] in
            if isUploadFailed && self?.presentedViewController == nil {
                self?.showUploadFailureAlert()
            }
        }
        
    }
    
    private func uploadVideos() {
        let dispatchGroup = DispatchGroup()
        var isUploadFailed = false
        for index in 0..<galleryView.medias.count {
            let media = galleryView.medias[index]
            guard case .idle = galleryView.viewState(for: media.id) else {
                // If file is uploading, skip checking task
                continue
            }
            switch galleryView.mediaState(for: media.id) {
            case .localAsset, .localURL:
                // Note:
                // - .localUrl via camera
                // - .localAsset via photo album picker
                dispatchGroup.enter()
                // Start with 0% immediately.
                galleryView.updateViewState(for: media.id, state: .uploading(progress: 0))
                // get local video url for uploading
                media.getLocalURLForUploading { [weak self] url in
                    guard let url = url else {
                        media.state = .error
                        self?.galleryView.updateViewState(for: media.id, state: .error)
                        isUploadFailed = true
                        return
                    }
                    AmityUIKitManagerInternal.shared.fileService.uploadVideo(url: url, progressHandler: { progress in
                        self?.galleryView.updateViewState(for: media.id, state: .uploading(progress: progress))
                        Log.add("[UIKit]: Upload Progress \(progress)")
                    }, completion: { [weak dispatchGroup] result in
                        switch result {
                        case .success(let videoData):
                            Log.add("[UIKit]: Uploaded video \(videoData.fileId)")
                            media.state = .uploadedVideo(data: videoData)
                            self?.galleryView.updateViewState(for: media.id, state: .uploaded)
                        case .failure:
                            Log.add("[UIKit]: Video upload failed")
                            media.state = .error
                            self?.galleryView.updateViewState(for: media.id, state: .error)
                            isUploadFailed = true
                        }
                        dispatchGroup?.leave()
                        self?.updateViewState()
                    })
                }
            default:
                break
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            if isUploadFailed && self?.presentedViewController == nil {
                self?.showUploadFailureAlert()
            }
        }
        
    }
    
    private func uploadFiles() {
        let fileUploadFailedDispatchGroup = DispatchGroup()
        var isUploadFailed = false
        for index in 0..<fileView.files.count {
            let file = fileView.files[index]
            
            switch fileView.viewState(for: file.id) {
            case .idle:
                if case .local = fileView.fileState(for: file.id), let fileUrl = file.fileURL, let fileData = try? Data(contentsOf: fileUrl) {
                    let fileToUpload = AmityUploadableFile(fileData: fileData, fileName: file.fileName)
                    fileUploadFailedDispatchGroup.enter()
                    // Start with 0% immediately.
                    fileView.updateViewState(for: file.id, state: .uploading(progress: 0))
                    AmityUIKitManagerInternal.shared.fileService.uploadFile(file: fileToUpload, progressHandler: { [weak self] progress in
                        self?.fileView.updateViewState(for: file.id, state: .uploading(progress: progress))
                        Log.add("[UIKit]: File upload progress: \(progress)")
                    }) { [weak self] result in
                        switch result {
                        case .success(let fileData):
                            Log.add("[UIKit]: File upload success")
                            file.state = .uploaded(data: fileData)
                            self?.fileView.updateViewState(for: file.id, state: .uploaded)
                        case .failure(let error):
                            Log.add("[UIKit]: File upload failed")
                            file.state = .error(errorMessage: error.localizedDescription)
                            self?.fileView.updateViewState(for: file.id, state: .error)
                            isUploadFailed = true
                        }
                        fileUploadFailedDispatchGroup.leave()
                        self?.updateViewState()
                    }
                } else {
                    fileView.updateViewState(for: file.id, state: .error)
                }
            case .error:
                fileView.updateViewState(for: file.id, state: .error)
            case .downloadable, .uploaded, .uploading(_):
                break
            }
        }
        
        fileUploadFailedDispatchGroup.notify(queue: .main) { [weak self] in
            if isUploadFailed && self?.presentedViewController == nil {
                self?.showUploadFailureAlert()
            }
        }
        
    }
    
    private func showUploadFailureAlert() {
        let alertController = UIAlertController(title: AmityLocalizedStringSet.postCreationUploadIncompletTitle.localizedString, message: AmityLocalizedStringSet.postCreationUploadIncompletDescription.localizedString, preferredStyle: .alert)
        alertController.setTitle(font: AmityFontSet.title)
        alertController.setMessage(font: AmityFontSet.body)
        let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.ok.localizedString, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func handleCreatePostError(_ error: AmityError) {
        switch error {
        case .bannedWord:
            let message = AmityLocalizedStringSet.ErrorHandling.errorMessageCommentBanword.localizedString
            let title = AmityLocalizedStringSet.ErrorHandling.errorMessageTitle.localizedString
            showError(title: title, message: message)
        case .linkNotAllowed:
            let message = AmityLocalizedStringSet.ErrorHandling.errorMessageLinkNotAllowedDetail.localizedString
            let title = AmityLocalizedStringSet.ErrorHandling.errorMessageLinkNotAllowed.localizedString
            showError(title: title, message: message)
        case .userIsBanned, .userIsGlobalBanned:
            let message = AmityLocalizedStringSet.ErrorHandling.errorMessageUserIsBanned.localizedString
            showError(title: "", message: message)
        default:
            let message = AmityLocalizedStringSet.ErrorHandling.errorMessageDefault.localizedString + " (\(error.rawValue))"
            showError(title: "", message: message)
        }
    }
    
    private func showError(title: String, message: String) {
        AmityUtilities.showAlert(title: title, message: message, viewController: self) { _ in
            self.postButton.isEnabled = true
        }
    }
    
    private func playVideo(for asset: PHAsset) {
        guard asset.mediaType == .video else {
            assertionFailure("Not a valid video media type")
            return
        }
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { [weak self] asset, max, info in
            guard let asset = asset as? AVURLAsset else {
                assertionFailure("Unable to convert asset to AVURLAsset")
                return
            }
            DispatchQueue.main.async {
                self?.presentVideoPlayer(at: asset.url)
            }
        }
    }
    
    private func presentMaxNumberReachDialogue() {
        let alertController = UIAlertController(
            title: "Maximum number of images exceeded",
            message: "Maximum number of images that can be uploaded is \(Constant.maximumNumberOfImages). The rest images will be discarded.",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: AmityLocalizedStringSet.General.ok.localizedString,
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentMediaPickerCamera() {
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = self
        
        // We automatically choose media type based on last media pick.
        switch currentAttachmentState {
        case .none:
            // If the user have not chosen any media yet, we allow both type to be picked.
            // After it is selected, we force the same type for the later actions.
            var mediaTypesWhenNothingSelected: [String] = []
            if settings.allowPostAttachments.contains(.image) {
                mediaTypesWhenNothingSelected.append(kUTTypeImage as String)
            }
            if settings.allowPostAttachments.contains(.video) {
                mediaTypesWhenNothingSelected.append(kUTTypeMovie as String)
            }
            cameraPicker.mediaTypes = mediaTypesWhenNothingSelected
        case .image:
            // The user already select image, so we force the media type to allow only image.
            cameraPicker.mediaTypes = [kUTTypeImage as String]
        case .video:
            // The user already select video, so we force the media type to allow only video.
            cameraPicker.mediaTypes = [kUTTypeMovie as String]
        case .file:
            Log.add("Type mismatch")
        }
        
        present(cameraPicker, animated: true, completion: nil)
        
    }
    
    private func presentMediaPickerAlbum(type: AmityMediaType) {
            
        let supportedMediaTypes: Set<Settings.Fetch.Assets.MediaTypes>
        
        // The closue to execute when picker finish picking the media.
        let finish: ([PHAsset]) -> Void
        
        var selectedAssets: [PHAsset] = []
        for media in galleryView.medias {
            if let local = media.localAsset {
                selectedAssets.append(local)
            }
        }
        let selectedAssetIds: [String] = selectedAssets.map { $0.localIdentifier }
        
        switch type {
        case .image:
            supportedMediaTypes = [.image]
            finish = { [weak self] assets in
                guard let strongSelf = self else { return }
                
                var newMedias: [AmityMedia] = []
                for asset in assets {
                    guard !selectedAssetIds.contains(asset.localIdentifier) else {
                        continue
                    }
                    let media = AmityMedia(state: .localAsset(asset), type: .image)
                    media.localAsset = asset
                    newMedias.append(media)
                }
                strongSelf.addMedias(newMedias, type: .image)
            }
        case .video:
            supportedMediaTypes = [.video]
            finish = { [weak self] assets in
                guard let strongSelf = self else { return }
                
                var newMedias: [AmityMedia] = []
                for asset in assets {
                    guard !selectedAssetIds.contains(asset.localIdentifier) else {
                        continue
                    }
                    let media = AmityMedia(state: .localAsset(asset), type: .video)
                    media.localAsset = asset
                    newMedias.append(media)
                }
                strongSelf.addMedias(newMedias, type: .video)
            }
        }
        
        let maxNumberOfSelection: Int
        switch postMode {
        case .create:
            maxNumberOfSelection = Constant.maximumNumberOfImages
        case .edit:
            maxNumberOfSelection = Constant.maximumNumberOfImages - galleryView.medias.count
        }
        let imagePicker = AmityImagePickerController(selectedAssets: selectedAssets)
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = supportedMediaTypes
        imagePicker.settings.selection.max = maxNumberOfSelection
        imagePicker.settings.selection.unselectOnReachingMax = false
        presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: finish, completion: nil)
        
    }
    
    func addMediasFromGallery(){
        //Use asset from parameter to show on screen
        var selectedAssets: [PHAsset] = []
        for media in galleryView.medias {
            if let local = media.localAsset {
                selectedAssets.append(local)
            }
        }
        let selectedAssetIds: [String] = selectedAssets.map { $0.localIdentifier }
        
        var newMedias: [AmityMedia] = []
        for asset in self.galleryAsset {
            guard !selectedAssetIds.contains(asset.localIdentifier) else {
                continue
            }
            let media = AmityMedia(state: .localAsset(asset), type: .image)
            media.localAsset = asset
            newMedias.append(media)
        }
        addMedias(newMedias, type: .image)
    }
    
}

extension AmityPostTextEditorViewController: TrueIDGalleryCollectionViewDelegate {
    
    func galleryView(_ view: TrueIDGalleryCollectionView, didRemoveImageAt index: Int) {
        var medias = galleryView.medias
        medias.remove(at: index)
        galleryView.configure(medias: medias)
        updateViewState()
        updateConstraints()
    }
    
    private func presentPhotoViewer(media: AmityMedia, from cell: AmityPostGalleryTableViewCell) {
        let photoViewerVC = AmityPhotoViewerController(referencedView: cell.imageView, media: media)
        photoViewerVC.dataSource = cell
        photoViewerVC.delegate = cell
        present(photoViewerVC, animated: true, completion: nil)
    }
    
    func galleryView(_ view: TrueIDGalleryCollectionView, didTapMedia media: AmityMedia, reference: UIImageView) {
        
        switch media.type {
        case .video:
            if let asset = media.localAsset {
                // The video is picked from album.
                playVideo(for: asset)
            } else if let videoUrl = media.localUrl {
                // The video is taken from camera.
                presentVideoPlayer(at: videoUrl)
            } else {
                assertionFailure("Unsupported media when tapping at the video.")
            }
        case .image:
            // Do nothing when tap at the image.
            switch media.state {
            case .uploading(progress: _):
                break
            case .uploadedImage(data: _):
                let photoViewerVC = AmityPhotoViewerController(referencedView: reference, image: reference.image)
                present(photoViewerVC, animated: true, completion: nil)
            case .uploadedVideo(data: _):
                break
            case .localAsset(_):
                break
            case .image(_):
                break
            case .localURL(url: _):
                break
            case .downloadableImage(imageData: _, placeholder: _):
                break
            case .downloadableVideo(videoData: _, thumbnailUrl: _):
                break
            case .none:
                break
            case .error:
                break
            }
        }
        
    }
    
}

extension AmityPostTextEditorViewController: AmityTextViewDelegate {
    
    public func textViewDidChange(_ textView: AmityTextView) {
        updateViewState()
    }
    
    public func textView(_ textView: AmityTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count > AmityMentionManager.maximumCharacterCountForPost {
            showAlertForMaximumCharacters()
            return false
        }
        return mentionManager?.shouldChangeTextIn(textView, inRange: range, replacementText: text, currentText: textView.text) ?? true
    }
    
    public func textViewDidChangeSelection(_ textView: AmityTextView) {
        mentionManager?.changeSelection(textView)
    }
}

extension AmityPostTextEditorViewController: AmityFilePickerDelegate {
    
    func didPickFiles(files: [AmityFile]) {
        fileView.configure(files: files)
        
        // file and images are not supported posting together
        galleryView.configure(medias: [])
        updateViewState()
        uploadFiles()
        updateConstraints()
    }
    
}

extension AmityPostTextEditorViewController: AmityFileTableViewDelegate {
    
    func fileTableView(_ view: AmityFileTableView, didTapAt index: Int) {
        //
    }
    
    func fileTableViewDidDeleteData(_ view: AmityFileTableView, at index: Int) {
        updateViewState()
    }
    
    func fileTableViewDidUpdateData(_ view: AmityFileTableView) {
        updateViewState()
    }
    
    func fileTableViewDidTapViewAll(_ view: AmityFileTableView) {
        //
    }
    
}

extension AmityPostTextEditorViewController: AmityPostTextEditorScreenViewModelDelegate {
    
    func screenViewModelDidLoadPost(_ viewModel: AmityPostTextEditorScreenViewModel, post: AmityPost) {
        // This will get call once when open with edit mode
        currentPost = AmityPostModel(post: post)
        
        guard let postModel = currentPost else { return }
        
        fileView.configure(files: postModel.files)
        galleryView.configure(medias: postModel.medias)
        textView.text = postModel.text
        
        setupMentionManager(withPost: postModel)
        updateConstraints()
    }
    
    func screenViewModelDidCreatePost(_ viewModel: AmityPostTextEditorScreenViewModel, post: AmityPost?, error: Error?) {
        
        if let post = post {
            switch post.getFeedType() {
            case .reviewing:
                AmityAlertController.present(title: AmityLocalizedStringSet.postCreationSubmitTitle.localizedString,
                                             message: AmityLocalizedStringSet.postCreationSubmitDesc.localizedString, actions: [.ok(style: .default, handler: { [weak self] in
                    self?.postButton.isEnabled = true
                    self?.dismiss(animated: true, completion: nil)
                })], from: self)
            case .published, .declined:
                postButton.isEnabled = true
                dismiss(animated: true, completion: nil)
            @unknown default:
                break
            }
        } else {
            postButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
        
        //If post from 'Today' page. Tell client to redirect
        if postType != nil || fromGallery{
            let userId = AmityUIKitManagerInternal.shared.currentUserId
            if error == nil {
                AmityEventHandler.shared.finishPostEvent(true, userId: userId)
            } else {
                AmityEventHandler.shared.finishPostEvent(false, userId: userId)
            }
        }
    }
    
    func screenViewModelDidUpdatePost(_ viewModel: AmityPostTextEditorScreenViewModel, error: Error?) {
        postButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func screenViewModelDidCreatePostFailure(error: AmityError?) {
        if let error = error {
            handleCreatePostError(error)
        }
    }
    
}

extension AmityPostTextEditorViewController: AmityPostTextEditorMenuViewDelegate {
    
    func postMenuView(_ view: AmityPostTextEditorMenuView, didTap action: AmityPostMenuActionType) {
        
        switch action {
        case .camera:
            checkCameraPermission {
                DispatchQueue.main.async { [weak self] in
                    self?.presentMediaPickerCamera()
                }
            } fail: { [weak self] in
                self?.alrtPermisionAccessphoto(title: "Camera", message: "Please allow access camera library")
            }
        case .album:
            checkPhotoLibraryPermission {
                DispatchQueue.main.async { [weak self] in
                    self?.presentMediaPickerAlbum(type: .image)
                }
            } fail: { [weak self] in
                self?.alrtPermisionAccessphoto(title: "Photo", message: "Please allow access photo library")
            }
        case .video:
            checkPhotoLibraryPermission {
                DispatchQueue.main.async { [weak self] in
                    self?.presentMediaPickerAlbum(type: .video)
                }
            } fail: { [weak self] in
                self?.alrtPermisionAccessphoto(title: "Video", message: "Please allow access photo library")
            }
        case .file:
            filePicker.present(from: view, files: fileView.files)
        case .expand:
            presentBottomSheetMenus()
        }
        
    }
    
    private func presentBottomSheetMenus() {
        
        let bottomSheet = BottomSheetViewController()
        let contentView = ItemOptionView<ImageItemOption>()
        let imageBackgroundColor = AmityColorSet.base.blend(.shade4)
        let disabledColor = AmityColorSet.base.blend(.shade3)
        
        var cameraOption = ImageItemOption(title: AmityLocalizedStringSet.General.camera.localizedString,
                                           image: AmityIconSet.iconCameraSmall,
                                           imageBackgroundColor: imageBackgroundColor) { [weak self] in
            self?.presentMediaPickerCamera()
        }
        
        var galleryOption = ImageItemOption(title: AmityLocalizedStringSet.General.generalPhoto.localizedString,
                                            image: AmityIconSet.iconPhoto,
                                            imageBackgroundColor: imageBackgroundColor) { [weak self] in
            self?.presentMediaPickerAlbum(type: .image)
        }
        
        var videoOption = ImageItemOption(title: AmityLocalizedStringSet.General.generalVideo.localizedString,
                                          image: AmityIconSet.iconPlayVideo,
                                          imageBackgroundColor: imageBackgroundColor) { [weak self] in
            self?.presentMediaPickerAlbum(type: .video)
        }
        
        var fileOption = ImageItemOption(title: AmityLocalizedStringSet.General.generalAttachment.localizedString,
                                         image: AmityIconSet.iconAttach,
                                         imageBackgroundColor: imageBackgroundColor)
        fileOption.completion = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.filePicker.present(from: strongSelf.postMenuView, files: strongSelf.fileView.files)
        }
        
        // Each option will be added, based on allowPostAttachments.
        var items: [ImageItemOption] = []
        if settings.allowPostAttachments.contains(.image) || settings.allowPostAttachments.contains(.video) {
            items.append(cameraOption)
            items.append(galleryOption)
        }
        if settings.allowPostAttachments.contains(.file) {
            items.append(fileOption)
        }
        if settings.allowPostAttachments.contains(.video) {
            items.append(videoOption)
        }
        
        // NOTE: Once the currentAttachmentState has changed from `none` to something else.
        // We still show the buttons, but we disable them based on the currentAttachmentState.
        if currentAttachmentState != .none {
            if currentAttachmentState != .image || currentAttachmentState != .video {
                // Disable gallery option
                galleryOption.image = AmityIconSet.iconPhoto?.setTintColor(disabledColor)
                galleryOption.textColor = disabledColor
                galleryOption.completion = nil
                // Disable camera option
                cameraOption.image = AmityIconSet.iconCameraSmall?.setTintColor(disabledColor)
                cameraOption.textColor = disabledColor
                cameraOption.completion = nil
            }
            if currentAttachmentState != .video {
                // Disable video option
                videoOption.image = AmityIconSet.iconPlayVideo?.setTintColor(disabledColor)
                videoOption.textColor = disabledColor
                videoOption.completion = nil
            }
            if currentAttachmentState != .file {
                // Disable file option
                fileOption.image = AmityIconSet.iconAttach?.setTintColor(disabledColor)
                fileOption.textColor = disabledColor
                fileOption.completion = nil
            }
        }
        
        contentView.configure(items: items, selectedItem: nil)
        contentView.didSelectItem = { _ in
            bottomSheet.dismissBottomSheet()
        }
        
        bottomSheet.sheetContentView = contentView
        bottomSheet.isTitleHidden = true
        bottomSheet.modalPresentationStyle = .overFullScreen
        
        present(bottomSheet, animated: false, completion: nil)
        
    }
    
    private func addMedias(_ medias: [AmityMedia], type: AmityMediaType) {
        let totalNumberOfMedias = galleryView.medias.count + medias.count
        guard totalNumberOfMedias <= Constant.maximumNumberOfImages else {
            presentMaxNumberReachDialogue()
            return
        }
        galleryView.addMedias(medias)
        fileView.configure(files: [])
        // start uploading
        updateViewState()
        switch type {
        case .image:
            uploadImages()
        case .video:
            uploadVideos()
        }
        updateConstraints()
    }
    
    private func showAlertForMaximumCharacters() {
        let alertController = UIAlertController(title: AmityLocalizedStringSet.postUnableToPostTitle.localizedString, message: AmityLocalizedStringSet.postUnableToPostDescription.localizedString, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.done.localizedString, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension AmityPostTextEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let mediaType = info[.mediaType] as? String else {
            return
        }
        
        var selectedMedia: AmityMedia?
        
        switch mediaType {
        case String(kUTTypeImage):
            if let image = info[.originalImage] as? UIImage {
                selectedMedia = AmityMedia(state: .image(image), type: .image)
            }
        case String(kUTTypeMovie):
            if let fileUrl = info[.mediaURL] as? URL {
                let media = AmityMedia(state: .localURL(url: fileUrl), type: .video)
                media.localUrl = fileUrl
                // Generate thumbnail
                let asset = AVAsset(url: fileUrl)
                let assetImageGenerator = AVAssetImageGenerator(asset: asset)
                assetImageGenerator.appliesPreferredTrackTransform = true
                let time = CMTime(seconds: 1.0, preferredTimescale: 1)
                var actualTime: CMTime = CMTime.zero
                do {
                    let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: &actualTime)
                    media.generatedThumbnailImage = UIImage(cgImage: imageRef)
                } catch {
                    print("Unable to generate thumbnail image for kUTTypeMovie.")
                }
                selectedMedia = media
            }
        default:
            assertionFailure("Unsupported media type")
            break
        }
        
        // We want to process selected media only after the default ui for selecting media
        // dismisses completely. Otherwise we see `Attempt to present ....` error
        picker.dismiss(animated: true) { [weak self] in
            guard let media = selectedMedia else { return }
            self?.addMedias([media], type: media.type)
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension AmityPostTextEditorViewController {
    
//    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        guard isValueChanged, !(mentionManager?.isSearchingStarted ?? false) else {
//            return super.gestureRecognizerShouldBegin(gestureRecognizer)
//        }
//
//        if let view = gestureRecognizer.view,
//            let directions = (gestureRecognizer as? UIPanGestureRecognizer)?.direction(in: view),
//            directions.contains(.right) {
//            let alertController = UIAlertController(title: AmityLocalizedStringSet.postCreationDiscardPostTitle.localizedString, message: AmityLocalizedStringSet.postCreationDiscardPostMessage.localizedString, preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .cancel, handler: nil)
//            let discardAction = UIAlertAction(title: AmityLocalizedStringSet.General.discard.localizedString, style: .destructive) { [weak self] _ in
//                self?.generalDismiss()
//            }
//            alertController.addAction(cancelAction)
//            alertController.addAction(discardAction)
//            present(alertController, animated: true, completion: nil)
//
//            // prevents swiping back and present confirmation message
//            return false
//        }
//
//        // falls back to normal behaviour, swipe back to previous page
//        return super.gestureRecognizerShouldBegin(gestureRecognizer)
//    }
}

// MARK: - UITableViewDelegate
extension AmityPostTextEditorViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AmityMentionTableViewCell.height
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mentionManager?.addMention(from: textView, in: textView.text, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (mentionManager?.users.count ?? 0) - 4 {
            mentionManager?.loadMore()
        }
    }
}

// MARK: - UITableViewDataSource
extension AmityPostTextEditorViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionManager?.users.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AmityMentionTableViewCell.identifier) as? AmityMentionTableViewCell, let model = mentionManager?.item(at: indexPath) else { return UITableViewCell() }
        cell.display(with: model)
        return cell
    }
}

// MARK: - AmityMentionManagerDelegate
extension AmityPostTextEditorViewController: AmityMentionManagerDelegate {
    public func didCreateAttributedString(attributedString: NSAttributedString) {
        textView.attributedText = attributedString
        textView.typingAttributes = [.font: AmityFontSet.body, .foregroundColor: AmityColorSet.base]
    }
    
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
    
    public func didMentionsReachToMaximumLimit() {
        let alertController = UIAlertController(title: AmityLocalizedStringSet.Mention.unableToMentionTitle.localizedString, message: AmityLocalizedStringSet.Mention.unableToMentionPostDescription.localizedString, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.done.localizedString, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func didCharactersReachToMaximumLimit() {
        showAlertForMaximumCharacters()
    }
}

// MARK: - Private methods
private extension AmityPostTextEditorViewController {
    func setupMentionManager(withPost post: AmityPostModel) {
        guard mentionManager == nil else { return }
        let communityId: String? = (currentPost?.targetCommunity?.isPublic ?? true) ? nil : currentPost?.targetCommunity?.communityId
        mentionManager = AmityMentionManager(withType: .post(communityId: communityId))
        mentionManager?.delegate = self
        mentionManager?.setColor(AmityColorSet.base, highlightColor: AmityColorSet.primary)
        mentionManager?.setFont(AmityFontSet.body, highlightFont: AmityFontSet.bodyBold)
        
        if let metadata = post.metadata {
            mentionManager?.setMentions(metadata: metadata, inText: post.text)
        }
    }
}

//MARK: - Check photo and camera permision
extension AmityPostTextEditorViewController {
    
    func checkPhotoLibraryPermission(success: @escaping() -> (), fail: @escaping() -> ()) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
           switch photoAuthorizationStatus {
           case .authorized:
               success()
               break
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization({
                   (newStatus) in
                   if newStatus ==  PHAuthorizationStatus.authorized {
                       success()
                   }
               })
           case .restricted:
               break
           case .denied:
               fail()
               break
           case .limited:
               fail()
               break
           @unknown default:
               fail()
               break
           }
    }
    
    func checkCameraPermission(success: @escaping() -> (), fail: @escaping() -> ()) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
            success()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    success()
                } else {
                    fail()
                }
            }
        }
    }
    
    func alrtPermisionAccessphoto(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            }))
            alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self.present(alert, animated: true)
        }
    }
}
