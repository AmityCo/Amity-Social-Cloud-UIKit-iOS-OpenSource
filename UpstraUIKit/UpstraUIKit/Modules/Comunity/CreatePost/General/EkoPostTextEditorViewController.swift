//
//  EkoPostTextEditorViewController.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 1/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import Photos
import EkoChat

public class EkoPostEditorSettings {
    public init() { }
    public var shouldCameraButtonHide: Bool = false
    public var shouldPhotoButtonHide: Bool = false
    public var shouldFileButtonHide: Bool = false
}

protocol EkoPostViewControllerDelegate: class {
    func postViewController(_ viewController: UIViewController, didCreatePost post: EkoPostModel)
    func postViewController(_ viewController: UIViewController, didUpdatePost post: EkoPostModel)
}

public class EkoPostTextEditorViewController: EkoViewController {
    
    enum Constant {
        static let maximumNumberOfImages: Int = 10
        static let toolBarHeight: CGFloat = 44.0
    }
    
    // MARK: - Properties
    
    // Use specifically for edit mode
    private var currentPost: EkoPostModel?
    
    private let settings: EkoPostEditorSettings
    private var screenViewModel: EkoPostTextEditorScreenViewModelType = EkoPostTextEditorScreenViewModel()
    private let postTarget: EkoPostTarget
    private let postMode: EkoPostMode
    
    private let comunityPanelView = EkoComunityPanelView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let textView = EkoTextView(frame: .zero)
    private let separaterLine = UIView(frame: .zero)
    private let galleryView = EkoGalleryCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let fileView = EkoFileTableView(frame: .zero, style: .plain)
    private let postMenuView: EkoPostTextEditorMenuView
    private var postButton: UIBarButtonItem!
    private var galleryViewHeightConstraint: NSLayoutConstraint!
    private var fileViewHeightConstraint: NSLayoutConstraint!
    private var postMenuViewBottomConstraints: NSLayoutConstraint!
    private var filePicker: EkoFilePicker!
    
    private var isValueChanged: Bool {
        return !textView.text.isEmpty || !galleryView.images.isEmpty || !fileView.files.isEmpty
    }
    
    weak var delegate: EkoPostViewControllerDelegate?
    
    init(postTarget: EkoPostTarget, postMode: EkoPostMode, settings: EkoPostEditorSettings) {
        self.postTarget = postTarget
        self.postMode = postMode
        self.settings = settings
        self.postMenuView = EkoPostTextEditorMenuView(settings: settings)
        super.init(nibName: nil, bundle: nil)
        
        screenViewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(postTarget: EkoPostTarget, postMode: EkoPostMode = .create, settings: EkoPostEditorSettings = EkoPostEditorSettings()) -> EkoPostTextEditorViewController {
        let vc = EkoPostTextEditorViewController(postTarget: postTarget, postMode: postMode, settings: settings)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        filePicker = EkoFilePicker(presentationController: self, delegate: self)
        
        let isCreateMode = (postMode == .create)
        postButton = UIBarButtonItem(title: isCreateMode ? EkoLocalizedStringSet.post.localizedString : EkoLocalizedStringSet.save.localizedString, style: .plain, target: self, action: #selector(onPostButtonTap))
        postButton.tintColor = EkoColorSet.primary
        navigationItem.rightBarButtonItem = postButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        #warning("ViewController must be implemented with storyboard")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.backgroundColor = EkoColorSet.backgroundColor
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constant.toolBarHeight, right: 0)
        view.addSubview(scrollView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.padding = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        textView.customTextViewDelegate = self
        textView.isScrollEnabled = false
        textView.font = EkoFontSet.body
        textView.minCharacters = 1
        textView.placeholder = EkoLocalizedStringSet.postCreationTextPlaceholder.localizedString
        scrollView.addSubview(textView)
        
        separaterLine.translatesAutoresizingMaskIntoConstraints = false
        separaterLine.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        separaterLine.isHidden = true
        scrollView.addSubview(separaterLine)
        
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        galleryView.actionDelegate = self
        galleryView.isEditable = true
        galleryView.isScrollEnabled = false
        galleryView.backgroundColor = EkoColorSet.backgroundColor
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
            postMenuView.heightAnchor.constraint(equalToConstant: postMode == .create ? Constant.toolBarHeight : 0),
            postMenuViewBottomConstraints,
            comunityPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comunityPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comunityPanelView.bottomAnchor.constraint(equalTo: postMenuView.topAnchor),
            comunityPanelView.heightAnchor.constraint(equalToConstant: EkoComunityPanelView.defaultHeight),
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
            title = EkoLocalizedStringSet.postCreationEditPostTitle.localizedString
            comunityPanelView.isHidden = true
        case .create:
            switch postTarget {
            case .community(let comunity):
                title = comunity.displayName
                comunityPanelView.isHidden = !comunity.isOfficial
            case .myFeed:
                title = EkoLocalizedStringSet.postCreationMyTimelineTitle.localizedString
                comunityPanelView.isHidden = true
            }
        }
        
        if case .edit(let postId) = postMode {
            screenViewModel.dataSource.loadPost(for: postId)
        }
    }
    
    override func didTapLeftBarButton() {
        if isValueChanged {
            let alertController = UIAlertController(title: EkoLocalizedStringSet.postCreationDiscardPostTitle.localizedString, message: EkoLocalizedStringSet.postCreationDiscardPostMessage.localizedString, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil)
            let discardAction = UIAlertAction(title: EkoLocalizedStringSet.discard.localizedString, style: .destructive) { [weak self] _ in
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
        fileViewHeightConstraint.constant = EkoFileTableView.height(for: fileView.files.count, isEdtingMode: true, isExpanded: false)
        galleryViewHeightConstraint.constant = EkoGalleryCollectionView.height(for: galleryView.contentSize.width, numberOfItems: galleryView.images.count)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardScreenEndFrame = keyboardValue.size
        let comunityPanelHeight = comunityPanelView.isHidden ? 0.0 : EkoComunityPanelView.defaultHeight
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constant.toolBarHeight + comunityPanelHeight, right: 0)
            postMenuViewBottomConstraints.constant = view.layoutMargins.bottom
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardScreenEndFrame.height - view.safeAreaInsets.bottom + Constant.toolBarHeight + comunityPanelHeight, right: 0)
            postMenuViewBottomConstraints.constant = view.layoutMargins.bottom - keyboardScreenEndFrame.height
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    // MARK: - Action
    
    @objc private func onPostButtonTap() {
        guard let text = textView.text else { return }
        let images = galleryView.images
        let files = fileView.files
        
        view.endEditing(true)
        postButton.isEnabled = false
        
        if let post = currentPost {
            // update post
            screenViewModel.updatePost(oldPost: post, text: text, images: images, files: files)
        } else {
            // create post
            var communityId: String?
            if case .community(let community) = postTarget {
                communityId = community.communityId
            }
            screenViewModel.createPost(text: text, images: images, files: files, communityId: communityId)
        }
        
    }
    
    private func updateViewState() {
        
        // Update separater state
        separaterLine.isHidden = galleryView.images.isEmpty && fileView.files.isEmpty
        
        var isPostValid = textView.isValid
        
        // Update post button state
        var isImageValid = true
        if !galleryView.images.isEmpty {
            isImageValid = galleryView.images.filter({
                switch $0.state {
                case .uploaded, .downloadable:
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
            let isImageChanged = galleryView.images != post.images
            let isDocumentChanged = fileView.files.map({ $0.id }) != post.files.map({ $0.id })
            let isPostChanged = isTextChanged || isImageChanged || isDocumentChanged
            postButton.isEnabled = isPostChanged && isPostValid
        } else {
            postButton.isEnabled = isPostValid
        }
        postMenuView.isCameraButtonEnabled = fileView.files.isEmpty
        postMenuView.isPhotoButtonEnabled = fileView.files.isEmpty
        postMenuView.isFileButtonEnabled = galleryView.images.isEmpty
    }
    
    // MARK: Helper functions
    
    private func uploadImages() {
        let fileUploadFailedDispatchGroup = DispatchGroup()
        var isUploadFailed = false
        for index in 0..<galleryView.images.count {
            let image = galleryView.images[index]
            // if file is uploading, skip checking task
            guard case .idle = galleryView.viewState(for: image.id) else { continue }
            
            switch galleryView.imageState(for: image.id) {
            case .localAsset, .image:
                
                fileUploadFailedDispatchGroup.enter()
                
                // get local image for uploading
                image.getImageForUploading { [weak self] result in
                    switch result {
                    case .success(let img):
                        EkoFileService.shared.uploadImage(image: img, progressHandler: { progress in
                            self?.galleryView.updateViewState(for: image.id, state: .uploading(progress: progress))
                            Log.add("[UIKit]: Upload Progress \(progress)")
                        }, completion:  { [weak self] result in
                            switch result {
                            case .success(let imageData):
                                Log.add("[UIKit]: Uploaded image data \(imageData.fileId)")
                                image.state = .uploaded(data: imageData)
                                self?.galleryView.updateViewState(for: image.id, state: .uploaded)
                            case .failure:
                                Log.add("[UIKit]: Image upload failed")
                                image.state = .error
                                self?.galleryView.updateViewState(for: image.id, state: .error)
                                isUploadFailed = true
                            }
                            fileUploadFailedDispatchGroup.leave()
                            self?.updateViewState()
                        })
                    case .failure:
                        image.state = .error
                        self?.galleryView.updateViewState(for: image.id, state: .error)
                        isUploadFailed = true
                    }
                }
            case .uploading, .uploaded, .downloadable, .error, .none:
                break
            }
        }
        
        fileUploadFailedDispatchGroup.notify(queue: .main) { [weak self] in
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
            // if file is uploading, skip checking task
            guard case .idle = fileView.viewState(for: file.id),
                case .local = fileView.fileState(for: file.id) else { continue }
            
            guard let fileUrl = file.fileURL, let fileData = try? Data(contentsOf: fileUrl) else { continue }
            
            let fileToUpload = UploadableFile(fileData: fileData, fileName: file.fileName)
            fileUploadFailedDispatchGroup.enter()
            EkoFileService.shared.uploadFile(file: fileToUpload, progressHandler: { [weak self] progress in
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
        }
        
        fileUploadFailedDispatchGroup.notify(queue: .main) { [weak self] in
            if isUploadFailed && self?.presentedViewController == nil {
                self?.showUploadFailureAlert()
            }
        }
    }

    private func showUploadFailureAlert() {
        let alertController = UIAlertController(title: EkoLocalizedStringSet.postCreationUploadIncompletTitle.localizedString, message: EkoLocalizedStringSet.postCreationUploadIncompletDescription.localizedString, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: EkoLocalizedStringSet.ok.localizedString, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension EkoPostTextEditorViewController: EkoGalleryCollectionViewDelegate {
    
    func galleryView(_ view: EkoGalleryCollectionView, didRemoveImageAt index: Int) {
        var _images = galleryView.images
        _images.remove(at: index)
        galleryView.configure(images: _images)
        updateViewState()
    }
    
    func galleryView(_ view: EkoGalleryCollectionView, didTapImage image: EkoImage, reference: UIImageView) {
        //
    }
}

extension EkoPostTextEditorViewController: EkoTextViewDelegate {
    
    func textViewDidChange(_ textView: EkoTextView) {
        updateViewState()
    }
    
}

extension EkoPostTextEditorViewController: EkoFilePickerDelegate {
    
    func didPickFiles(files: [EkoFile]) {
        fileView.configure(files: files)
        
        // file and images are not supported posting together
        galleryView.configure(images: [])
        updateViewState()
        uploadFiles()
        updateConstraints()
    }
}

extension EkoPostTextEditorViewController: EkoFileTableViewDelegate {
    
    func fileTableView(_ view: EkoFileTableView, didTapAt index: Int) {
        //
    }
    
    func fileTableViewDidDeleteData(_ view: EkoFileTableView, at index: Int) {
        var _files = fileView.files
        _files.remove(at: index)
        fileView.configure(files: _files)
        updateViewState()
    }
    
    func fileTableViewDidUpdateData(_ view: EkoFileTableView) {
        updateViewState()
    }
    
    func fileTableViewDidTapViewAll(_ view: EkoFileTableView) {
        //
    }
}

extension EkoPostTextEditorViewController: EkoPostTextEditorScreenViewModelDelegate {
    
    func screenViewModelDidLoadPost(_ viewModel: EkoPostTextEditorScreenViewModel, post: EkoPost) {
        // This will get call once when open with edit mode
        currentPost = EkoPostModel(post: post)
        fileView.configure(files: currentPost!.files)
        galleryView.configure(images: currentPost!.images)
        textView.text = currentPost!.text
        updateConstraints()
    }
    
    func screenViewModelDidCreatePost(_ viewModel: EkoPostTextEditorScreenViewModel, error: Error?) {
        postButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func screenViewModelDidUpdatePost(_ viewModel: EkoPostTextEditorScreenViewModel, error: Error?) {
        postButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}

extension EkoPostTextEditorViewController: EkoPostTextEditorMenuViewDelegate {
    
    func postMenuView(_ view: EkoPostTextEditorMenuView, didTap action: EkoPostMenuActionType) {
        switch action {
        case .camera:
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            present(cameraPicker, animated: true, completion: nil)
        case .photo:
            let imagePicker = EkoImagePickerController(selectedAssets: [])
            imagePicker.settings.theme.selectionStyle = .numbered
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.max = (postMode == .create) ? Constant.maximumNumberOfImages : Constant.maximumNumberOfImages - galleryView.images.count
            imagePicker.settings.selection.unselectOnReachingMax = false
            presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { [weak self] assets in
                guard let strongSelf = self else { return }
                
                let images: [EkoImage] = assets.map { EkoImage(state: .localAsset($0)) }
                strongSelf.addImages(images)
                }, completion: nil)
            break
        case .file:
            filePicker.present(from: view, files: fileView.files)
            break
        }
    }
    
    private func addImages(_ images: [EkoImage]) {
        let sumNumberOfImages = galleryView.images.count + images.count
        guard sumNumberOfImages <= Constant.maximumNumberOfImages else {
            #warning("Localized")
            let alertController = UIAlertController(title: "Maximum number of images exceeded", message: "Maximum number of images that can be uploaded is \(Constant.maximumNumberOfImages). The rest images will be discarded.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: EkoLocalizedStringSet.ok.localizedString, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        galleryView.addImage(images)
        fileView.configure(files: [])
        
        // start uploading
        updateViewState()
        uploadImages()
        updateConstraints()
    }
    
}

extension EkoPostTextEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let _image = EkoImage(state: .image(image))
            addImages([_image])
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
