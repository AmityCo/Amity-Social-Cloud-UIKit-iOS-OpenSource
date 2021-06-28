//
//  AmityCreatePostViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 1/7/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import Photos
import AmitySDK

public protocol AmityPostViewControllerDelegate: class {
    func postViewController(_ viewController: UIViewController, didCreatePost post: AmityPostModel)
    func postViewController(_ viewController: UIViewController, didUpdatePost post: AmityPostModel)
}

enum AmityPostMode: Equatable {
    case create
    case edit(AmityPostModel)
    
    static func == (lhs: AmityPostMode, rhs: AmityPostMode) -> Bool {
        if case .create = lhs, case .create = rhs {
            return true
        }
        return false
    }
}

enum AmityPostType {
    case user
    case comunity(AmityCommunity)
}

public class EkoCreatePostViewController: AmityViewController {
    
    enum Constant {
        static let maximumNumberOfItems: Int = 10
        static let toolBarHeight: CGFloat = 44.0
    }
    
    // MARK: - Properties
    private let screenViewModel = EkoCreatePostScreenViewModel()
    
    var role: AmityPostType = .user {
        didSet {
            updateVewLayout()
        }
    }
    
    var postMode: AmityPostMode = .create {
        didSet {
            postModeDidSet()
        }
    }
    
    private let comunityPanelView = EkoComunityPanelView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let textView = EkoTextView(frame: .zero)
    private let separaterLine = UIView(frame: .zero)
    private let galleryView = EkoGalleryCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let fileView = EkoFileTableView(frame: .zero, style: .plain)
    private let postMenuView = EkoCreatePostMenuView(frame: .zero)
    private var postButton: UIBarButtonItem!
    private var galleryViewHeightConstraint: NSLayoutConstraint!
    private var fileViewHeightConstraint: NSLayoutConstraint!
    private var toolBarBottomConstraints: NSLayoutConstraint!
    private var documentPicker: EkoDocumentPicker!
    
    private var isValueChanged: Bool {
        return !textView.text.isEmpty || !galleryView.images.isEmpty || !screenViewModel.selectedDocuments.isEmpty
    }
    
    weak var delegate: AmityPostViewControllerDelegate?
    
    private func updateVewLayout() {
        if case .comunity(let comunity) = role {
            title = comunity.displayName
            comunityPanelView.isHidden = !comunity.isOfficial
        } else {
            #warning("Localization")
            title = "My Timeline"
            comunityPanelView.isHidden = true
        }
    }
    
    private func postModeDidSet() {
        if case .edit(let post) = postMode {
            post.documents = post.documents.map { doc -> EkoFile in
                doc.syncState = .network
                return doc
            }
            fileView.configure(documents: post.documents)
            galleryView.setImage(post.images)
            textView.text = post.text
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        documentPicker = EkoDocumentPicker(presentationController: self, delegate: self)
        
        let isCreateMode = (postMode == .create)
        #warning("Localization")
        postButton = UIBarButtonItem(title: isCreateMode ? "Post" : "Save", style: .plain, target: self, action: #selector(onPostButtonTap))
        navigationItem.rightBarButtonItem = postButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        #warning("ViewController must be implemented with storyboard")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constant.toolBarHeight, right: 0)
        view.addSubview(scrollView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        textView.customTextViewDelegate = self
        textView.isScrollEnabled = false
        textView.minCharacters = 1
        #warning("Localization")
        textView.placeholder = "What’s going on..."
        scrollView.addSubview(textView)
        
        separaterLine.translatesAutoresizingMaskIntoConstraints = false
        #warning("Avoid setting the hex string directly")
        separaterLine.backgroundColor = UIColor(hex: "#E3E4E8")
        separaterLine.isHidden = true
        scrollView.addSubview(separaterLine)
        
        galleryView.translatesAutoresizingMaskIntoConstraints = false
        galleryView.actionDelegate = self
        galleryView.isEditable = true
        galleryView.isScrollEnabled = false
        galleryView.backgroundColor = .white
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
        toolBarBottomConstraints = NSLayoutConstraint(item: postMenuView, attribute: .bottom, relatedBy: .equal, toItem: view.layoutMarginsGuide, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postMenuView.heightAnchor.constraint(equalToConstant: Constant.toolBarHeight),
            toolBarBottomConstraints,
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
        
        screenViewModel.delegate = self
    }
    
    override func didTapLeftBarButton() {
        if isValueChanged {
            let alertController = UIAlertController(title: "Discard Post?", message: "Do you want to discard your post?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let discardAction = UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(discardAction)
            present(alertController, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateConstraints() {
        fileViewHeightConstraint.constant = EkoFileTableView.height(for: fileView.documents.count, isEdtingMode: true, isExpanded: false)
        galleryViewHeightConstraint.constant = EkoGalleryCollectionView.height(for: galleryView.contentSize.width, numberOfItems: galleryView.images.count)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardScreenEndFrame = keyboardValue.size
        //        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let comunityPanelHeight = comunityPanelView.isHidden ? 0.0 : EkoComunityPanelView.defaultHeight
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constant.toolBarHeight + comunityPanelHeight, right: 0)
            toolBarBottomConstraints.constant = view.layoutMargins.bottom
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardScreenEndFrame.height - view.safeAreaInsets.bottom + Constant.toolBarHeight + comunityPanelHeight, right: 0)
            toolBarBottomConstraints.constant = view.layoutMargins.bottom - keyboardScreenEndFrame.height
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc private func onPostButtonTap() {
        self.postButton.isEnabled = false
        
        guard let text = self.textView.text else { return }
        let images = self.galleryView.images
        let documents = self.fileView.documents
        
        if case .edit(let post) = self.postMode {
            self.screenViewModel.updatePost(oldPost: post, text: text, images: images, files: documents)
        } else {
            var communityId: String?
            if case .comunity(let comunity) = self.role {
                communityId = comunity.communityId
            }
            self.screenViewModel.createPost(text: text, images: images, files: documents, communityId: communityId)
        }
    }
    
    private func updateSeparater() {
        separaterLine.isHidden = galleryView.images.isEmpty && fileView.documents.isEmpty
    }
    
    private func updatePostButtonState() {
        let isImageValid = galleryView.images.isEmpty ? false : galleryView.images.filter({ $0.syncState != .uploaded }).isEmpty
        let isFileValid = fileView.documents.isEmpty ? false : fileView.documents.filter({ $0.syncState != .uploaded }).isEmpty
        let isPostValid = textView.isValid || isImageValid || isFileValid
        if case .edit(let post) = postMode {
            let isTextChanged = textView.text != post.text
            let isImageChanged = galleryView.images != post.images
            let isDocumentChanged = fileView.documents.map({ $0.id }) != post.documents.map({ $0.id })
            let isPostChanged = isTextChanged || isImageChanged || isDocumentChanged
            postButton.isEnabled = isPostChanged && isPostValid
        } else {
            postButton.isEnabled = isPostValid
        }
        postMenuView.isCameraButtonEnabled = fileView.documents.isEmpty
        postMenuView.isPhotoButtonEnabled = fileView.documents.isEmpty
        postMenuView.isFileButtonEnabled = galleryView.images.isEmpty
    }
    
}

extension EkoCreatePostViewController: UINavigationControllerDelegate {
    
}

extension EkoCreatePostViewController: EkoGalleryCollectionViewDelegate {
    
    func galleryView(_ view: EkoGalleryCollectionView, didRemoveImageAt index: Int) {
        
        var _images = galleryView.images
        _images.remove(at: index)
        galleryView.setImage(_images)
        updateSeparater()
        updatePostButtonState()
    }
    
    func galleryView(_ view: EkoGalleryCollectionView, didTapImage image: EkoImage, reference: UIImageView) {
        let viewController = EkoPhotoViewerController(referencedView: reference, image: image.image())
        viewController.dataSource = self
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func galleryView(_ view: EkoGalleryCollectionView, didUpload image: EkoImage) {
        
        // TODO:
        // Upload it
        // Get Image Data Here
        // Then change post button state
        
        
        updatePostButtonState()
    }
    
}

extension EkoCreatePostViewController: EkoTextViewDelegate {
    
    func textViewDidChange(_ textView: EkoTextView) {
        updatePostButtonState()
    }
    
}

extension EkoCreatePostViewController: EkoPhotoViewerControllerDataSource {
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, configureCell cell: EkoPhotoCollectionViewCell, forPhotoAt index: Int) {
        
    }
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = galleryView.cellForItem(at: indexPath) as? EkoGalleryCollectionViewCell {
            return cell.imageView
        }
        
        return nil
    }
    
    public func numberOfItems(in photoViewerController: EkoPhotoViewerController) -> Int {
        return galleryView.images.count
    }
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        imageView.image = galleryView.images[index].image()
    }
    
}

// MARK: AmityPhotoViewerControllerDelegate
extension EkoCreatePostViewController: EkoPhotoViewerControllerDelegate {
    
    public func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: EkoPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: galleryView.selectedImageIndex, animated: false)
    }
    
    public func photoViewerController(_ photoViewerController: EkoPhotoViewerController, didScrollToPhotoAt index: Int) {
        galleryView.selectedImageIndex = index
        photoViewerController.titleLabel.text = "\(index + 1)/\(galleryView.images.count)"
        let indexPath = IndexPath(item: index, section: 0)
        // If cell for selected index path is not visible
        if !galleryView.indexPathsForVisibleItems.contains(indexPath) {
            // Scroll to make cell visible
            galleryView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
        }
    }
    
    func simplePhotoViewerController(_ viewController: EkoPhotoViewerController, savePhotoAt index: Int) {
        // UIImageWriteToSavedPhotosAlbum(images[index], nil, nil, nil)
    }
}

extension EkoCreatePostViewController: EkoDocumentDelegate {
    
    func didPickDocuments(documents: [EkoDocument]) {
        self.screenViewModel.selectedDocuments = documents
        
        // Convert these documents to files
        let files = documents.map { EkoFile(document: $0) }
        fileView.configure(documents: files)
        
        // file and images are not supported posting together
        galleryView.setImage([])
        updateSeparater()
        updatePostButtonState()
        updateConstraints()
    }
}

extension EkoCreatePostViewController: EkoFileTableViewDelegate {
    
    func fileTableViewDidDeleteData(_ view: EkoFileTableView, at index: Int) {
        screenViewModel.selectedDocuments.remove(at: index)
        updatePostButtonState()
    }
    
    func fileTableViewDidUpdateData(_ view: EkoFileTableView) {
        updatePostButtonState()
    }
    
    func fileTableViewDidTapViewAll(_ view: EkoFileTableView) {
        //
    }
}

extension EkoCreatePostViewController: EkoCreatePostScreenViewModelDelegate {
    
    func screenViewModelDidCreatePost(_ viewModel: EkoCreatePostScreenViewModel, error: Error?) {
        self.postButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func screenViewModelDidUpdatePost(_ viewModel: EkoCreatePostScreenViewModel, error: Error?) {
        self.postButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
}

extension EkoCreatePostViewController: EkoCreatePostMenuViewDelegate {
    
    func postMenuView(_ view: EkoCreatePostMenuView, didTap action: AmityPostMenuActionType) {
        switch action {
        case .camera:
            break
        case .photo:
            var selectedAssets: [PHAsset] = []
            for case .local(let asset) in galleryView.images.map({ $0.value }) {
                selectedAssets.append(asset)
            }
            let imagePicker = EkoImagePickerController(selectedAssets: selectedAssets)
            imagePicker.settings.theme.selectionStyle = .numbered
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.unselectOnReachingMax = true
            imagePicker.settings.selection.max = (postMode == .create) ? Constant.maximumNumberOfItems : Constant.maximumNumberOfItems - galleryView.images.count
            imagePicker.settings.selection.unselectOnReachingMax = false
            
            presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { [weak self] assets in
                guard let strongSelf = self else { return }
                if strongSelf.postMode == .create {
                    let newImages: [EkoImage] = assets.map { EkoImage(value: .local($0)) }
                    strongSelf.galleryView.setImage(newImages)
                } else {
                    let localIdentifiers = strongSelf.galleryView.images.compactMap { image -> String? in
                        if case .local(let asset) = image.value {
                            return asset.localIdentifier
                        }
                        return nil
                    }
                    // ImagePicker will keep image localidentifier.
                    // Every time we finish picking images, all images will be sent to this block.
                    // We need to filter images which already added to `galleryView`.
                    let newImages: [EkoImage] = assets.filter({ !localIdentifiers.contains($0.localIdentifier) }).map { EkoImage(value: .local($0)) }
                    strongSelf.galleryView.addImage(newImages)
                }
                strongSelf.fileView.configure(documents: [])
                strongSelf.updateSeparater()
                strongSelf.updatePostButtonState()
                strongSelf.updateConstraints()
                }, completion: nil)
            break
        case .file:
            documentPicker.present(from: view, documents: screenViewModel.selectedDocuments)
            break
        }
    }
    
}
