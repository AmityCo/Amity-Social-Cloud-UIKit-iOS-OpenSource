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

public class AmityPostEditorSettings {
    public init() { }
    public var shouldCameraButtonHide: Bool = false
    public var shouldAlbumButtonHide: Bool = false
    public var shouldFileButtonHide: Bool = true
    public var shouldVideoButtonHide: Bool = true
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
    private let postMode: AmityPostMode
    
    private let comunityPanelView = AmityComunityPanelView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let textView = AmityTextView(frame: .zero)
    private let separaterLine = UIView(frame: .zero)
    private let galleryView = AmityGalleryCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let fileView = AmityFileTableView(frame: .zero, style: .plain)
    private let postMenuView: AmityPostTextEditorMenuView
    private var postButton: UIBarButtonItem!
    private var galleryViewHeightConstraint: NSLayoutConstraint!
    private var fileViewHeightConstraint: NSLayoutConstraint!
    private var postMenuViewBottomConstraints: NSLayoutConstraint!
    private var filePicker: AmityFilePicker!
    
    private var isValueChanged: Bool {
        return !textView.text.isEmpty || !galleryView.medias.isEmpty || !fileView.files.isEmpty
    }
    
    private var attachmentType: AmityPostAttachmentType = .none {
        didSet {
            postMenuView.attachmentType = attachmentType
        }
    }
    
    weak var delegate: AmityPostViewControllerDelegate?
    
    init(postTarget: AmityPostTarget, postMode: AmityPostMode, settings: AmityPostEditorSettings) {
        self.postTarget = postTarget
        self.postMode = postMode
        self.settings = settings
        self.postMenuView = AmityPostTextEditorMenuView(settings: settings)
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
        
        galleryViewHeightConstraint = NSLayoutConstraint(item: galleryView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        fileViewHeightConstraint = NSLayoutConstraint(item: fileView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        postMenuViewBottomConstraints = NSLayoutConstraint(item: postMenuView, attribute: .bottom, relatedBy: .equal, toItem: view.layoutMarginsGuide, attribute: .bottom, multiplier: 1, constant: 0)
        postMenuView.isHidden = (postMode != .create)
        
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
            fileViewHeightConstraint
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
    }
    
    public override func didTapLeftBarButton() {
        if isValueChanged {
            let alertController = UIAlertController(title: AmityLocalizedStringSet.postCreationDiscardPostTitle.localizedString, message: AmityLocalizedStringSet.postCreationDiscardPostMessage.localizedString, preferredStyle: .alert)
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
        galleryViewHeightConstraint.constant = AmityGalleryCollectionView.height(for: galleryView.contentSize.width, numberOfItems: galleryView.medias.count)
    }
    
    private func presentAskMediaTypeDialogue(completion: @escaping (AmityMediaType?) -> Void) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: AmityLocalizedStringSet.General.generalPhoto.localizedString, style: .default) { _ in
            completion(.image)
        }
        let video = UIAlertAction(title: AmityLocalizedStringSet.General.generalVideo.localizedString, style: .default) { _ in
            completion(.video)
        }
        let cancel = UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .cancel) { _ in
            completion(nil)
        }
        controller.addAction(photo)
        controller.addAction(video)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
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
        
        if let post = currentPost {
            // update post
            screenViewModel.updatePost(oldPost: post, text: text, medias: medias, files: files)
        } else {
            // create post
            var communityId: String?
            if case .community(let community) = postTarget {
                communityId = community.communityId
            }
            screenViewModel.createPost(text: text, medias: medias, files: files, communityId: communityId)
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
        
        if !fileView.files.isEmpty {
            attachmentType = .file
        } else if galleryView.medias.contains(where: { $0.type == .image }) {
            attachmentType = .image
        } else if galleryView.medias.contains(where: { $0.type == .video }) {
            attachmentType = .video
        } else {
            attachmentType = .none
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
                        }, completion:  { [weak self] result in
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
                            fileUploadFailedDispatchGroup.leave()
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
                    }, completion: { result in
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
                        dispatchGroup.leave()
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
        
        // Currently users can only select one media type when create a post.
        // After users choose the media, we will not `presentAskMediaTypeDialogue` after that.
        // We automatically choose media type based on last media pick.
        switch attachmentType {
        case .none:
            cameraPicker.mediaTypes = [kUTTypeImage, kUTTypeMovie] as [String]
        case .image:
            cameraPicker.mediaTypes = [kUTTypeImage as String]
        case .video:
            cameraPicker.mediaTypes = [kUTTypeMovie as String]
        case .file:
            Log.add("Type mismatch")
            break
        }
        cameraPicker.delegate = self
        present(cameraPicker, animated: true, completion: nil)
    }
    
    private func presentMediaPickerAlbum(type: AmityMediaType) {
        
        let supportedMediaTypes: Set<Settings.Fetch.Assets.MediaTypes>
        
        // The closue to execute when picker finish picking the media.
        let finish: ([PHAsset]) -> Void
        
        switch type {
        case .image:
            supportedMediaTypes = [.image]
            finish = { [weak self] assets in
                guard let strongSelf = self else { return }
                let medias: [AmityMedia] = assets.map { asset in
                    AmityMedia(state: .localAsset(asset), type: .image)
                }
                strongSelf.addMedias(medias, type: .image)
            }
        case .video:
            supportedMediaTypes = [.video]
            finish = { [weak self] assets in
                guard let strongSelf = self else { return }
                let medias: [AmityMedia] = assets.map { asset in
                    let media = AmityMedia(state: .localAsset(asset), type: .video)
                    media.localAsset = asset
                    return media
                }
                strongSelf.addMedias(medias, type: .video)
            }
        }
        
        let maxNumberOfSelection: Int
        switch postMode {
        case .create:
            maxNumberOfSelection = Constant.maximumNumberOfImages
        case .edit:
            maxNumberOfSelection = Constant.maximumNumberOfImages - galleryView.medias.count
        }
        
        let imagePicker = AmityImagePickerController(selectedAssets: [])
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = supportedMediaTypes
        imagePicker.settings.selection.max = maxNumberOfSelection
        imagePicker.settings.selection.unselectOnReachingMax = false
        presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: finish, completion: nil)
        
    }
    
}

extension AmityPostTextEditorViewController: AmityGalleryCollectionViewDelegate {
    
    func galleryView(_ view: AmityGalleryCollectionView, didRemoveImageAt index: Int) {
        var medias = galleryView.medias
        medias.remove(at: index)
        galleryView.configure(medias: medias)
        updateViewState()
    }
    
    func galleryView(_ view: AmityGalleryCollectionView, didTapMedia media: AmityMedia, reference: UIImageView) {
        
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
            break
        }
        
    }
    
}

extension AmityPostTextEditorViewController: AmityTextViewDelegate {
    
    func textViewDidChange(_ textView: AmityTextView) {
        updateViewState()
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
        fileView.configure(files: currentPost!.files)
        galleryView.configure(medias: currentPost!.medias)
        textView.text = currentPost!.text
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
            presentMediaPickerCamera()
        case .album:
            presentMediaPickerAlbum(type: .image)
        case .video:
            presentMediaPickerAlbum(type: .video)
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
        
        switch attachmentType {
        case .none:
            break
        case .image:
            videoOption.image = AmityIconSet.iconPlayVideo?.setTintColor(disabledColor)
            videoOption.textColor = disabledColor
            videoOption.completion = nil
            fileOption.image = AmityIconSet.iconAttach?.setTintColor(disabledColor)
            fileOption.textColor = disabledColor
            fileOption.completion = nil
        case .video:
            galleryOption.image = AmityIconSet.iconPhoto?.setTintColor(disabledColor)
            galleryOption.textColor = disabledColor
            galleryOption.completion = nil
            fileOption.image = AmityIconSet.iconAttach?.setTintColor(disabledColor)
            fileOption.textColor = disabledColor
            fileOption.completion = nil
        case .file:
            cameraOption.image = AmityIconSet.iconCameraSmall?.setTintColor(disabledColor)
            cameraOption.textColor = disabledColor
            cameraOption.completion = nil
            galleryOption.image = AmityIconSet.iconPhoto?.setTintColor(disabledColor)
            galleryOption.textColor = disabledColor
            galleryOption.completion = nil
            videoOption.image = AmityIconSet.iconPlayVideo?.setTintColor(disabledColor)
            videoOption.textColor = disabledColor
            videoOption.completion = nil
        }
        
        contentView.configure(items: [cameraOption, galleryOption, videoOption, fileOption], selectedItem: nil)
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
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard isValueChanged else {
                return super.gestureRecognizerShouldBegin(gestureRecognizer)
            }
            
            if let view = gestureRecognizer.view,
               let directions = (gestureRecognizer as? UIPanGestureRecognizer)?.direction(in: view),
               directions.contains(.right) {
                let alertController = UIAlertController(title: AmityLocalizedStringSet.postCreationDiscardPostTitle.localizedString, message: AmityLocalizedStringSet.postCreationDiscardPostMessage.localizedString, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .cancel, handler: nil)
                let discardAction = UIAlertAction(title: AmityLocalizedStringSet.General.discard.localizedString, style: .destructive) { [weak self] _ in
                    self?.generalDismiss()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(discardAction)
                present(alertController, animated: true, completion: nil)

                // prevents swiping back and present confirmation message
                return false
            }
            
            // falls back to normal behaviour, swipe back to previous page
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        
    }
