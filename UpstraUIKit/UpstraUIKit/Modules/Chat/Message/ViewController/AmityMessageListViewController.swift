//
//  AmityMessageListViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmitySDK
import AVFoundation
import PhotosUI

public protocol AmityMessageListDataSource: AnyObject {
    func cellForMessageTypes() -> [AmityMessageTypes: AmityMessageCellProtocol.Type]
}

public extension AmityMessageListViewController {
    
    /// The settings of `AmityMessageListViewController`, you can specify this in `.make(...).
    struct Settings {
        /// Set compose bar style. The default value is `ComposeBarStyle.default`.
        public var composeBarStyle = ComposeBarStyle.default
        public var shouldHideAudioButton: Bool = false
        public var shouldShowChatSettingBarButton: Bool = false
        public var enableConnectionBar: Bool = true
        public init() {
            // Intentionally left empty
        }
        
    }
    
    /// This enum represent compose bar style.
    enum ComposeBarStyle {
        /// The default compose bar that support text / media / audio record input.
        case `default`
        /// The compose bar that support only text input.
        case textOnly
    }
    
}

/// Amity Message List
public final class AmityMessageListViewController: AmityViewController, AmityMessageListHeaderViewDelegate {
    
    public weak var dataSource: AmityMessageListDataSource?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var messageContainerView: UIView!
    @IBOutlet private var composeBarContainerView: UIView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var connectionStatusBar: UIView!
    @IBOutlet weak var connectionStatusBarTopSpace: NSLayoutConstraint!
    @IBOutlet weak var connectionStatusBarHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    private var screenViewModel: AmityMessageListScreenViewModelType!
    private var connectionStatatusObservation: NSKeyValueObservation?
    
    // MARK: - Container View
    private var navigationHeaderViewController: AmityMessageListHeaderView!
    private var messageViewController: AmityMessageListTableViewController!
    private var composeBar: AmityComposeBar!
    
    // MARK: - Refresh Overlay
    @IBOutlet weak var refreshOverlay: UIView!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    private var audioRecordingViewController: AmityMessageListRecordingViewController?
    
    private let circular = AmityCircularTransition()
    
    private var settings = Settings()
    
    private var didEnterBackgroundObservation: NSObjectProtocol?
    private var willEnterForegroundObservation: NSObjectProtocol?
    
    // MARK: - View lifecyle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConnectionStatusBar()
        buildViewModel()
        shouldCellOverride()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AmityKeyboardService.shared.delegate = self
        screenViewModel.startReading()
        
        bottomConstraint.constant = .zero
        view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.navigationController?.setNavigationBarHidden(false, animated: false)
            self?.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AmityKeyboardService.shared.delegate = nil
        
        screenViewModel.action.toggleKeyboardVisible(visible: false)
        screenViewModel.action.inputSource(for: .default)
        screenViewModel.action.stopReading()
        
        AmityAudioPlayer.shared.stop()
        bottomConstraint.constant = .zero
        view.endEditing(true)
    }
    
    /// Create `AmityMessageListViewController` instance.
    /// - Parameters:
    ///   - channelId: The channel id.
    ///   - settings: Specify the custom settings, or leave to use the default settings.
    /// - Returns: An instance of `AmityMessageListViewController`.
    public static func make(
        channelId: String,
        settings: AmityMessageListViewController.Settings = .init()
    ) -> AmityMessageListViewController {
        let viewModel = AmityMessageListScreenViewModel(channelId: channelId)
        let vc = AmityMessageListViewController(nibName: AmityMessageListViewController.identifier, bundle: AmityUIKitManager.bundle)
        vc.screenViewModel = viewModel
        vc.settings = settings
        return vc
    }
    
    private func shouldCellOverride() {
        screenViewModel.action.registerCellNibs()
        
        if let dataSource = dataSource {
            screenViewModel.action.register(items: dataSource.cellForMessageTypes())
        }
        messageViewController.setupView()
    }
    
    func avatarDidTapGesture(userId: String) {
        AmityEventHandler.shared.userDidTap(from: self, userId: userId)
    }
}

// MARK: - Action
private extension AmityMessageListViewController {
    
    func cameraTap() {
        checkCameraPermission { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                #warning("Redundancy: camera picker should be replaced with a singleton class")
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = .camera
                cameraPicker.delegate = self
                strongSelf.present(cameraPicker, animated: true, completion: nil)
            }
        } fail: { [weak self] in
            let alert = UIAlertController(title: "Camera" , message: "Please allow access camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                //
            }))
            alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func albumTap() {
        checkAlbumPermission { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let imagePicker = AmityImagePickerController(selectedAssets: [])
                imagePicker.settings.theme.selectionStyle = .checked
                imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
                imagePicker.settings.selection.max = 20
                imagePicker.settings.selection.unselectOnReachingMax = false
                imagePicker.settings.theme.selectionStyle = .numbered
                strongSelf.presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { [weak self] assets in
                    let medias = assets.map { AmityMedia(state: .localAsset($0), type: .image) }
                    self?.screenViewModel.action.send(withMedias: medias)
                })
            }
        } fail: { [weak self]  in
            let alert = UIAlertController(title: "Photo" , message: "Please allow access photo library", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                //
            }))
            alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func fileTap() {
        
    }
    
    func locationTap() {
        
    }
}

// MARK: - Setup View
private extension AmityMessageListViewController {
    
    func setupView() {
        setupCustomNavigationBar()
        view.backgroundColor = AmityColorSet.backgroundColor
        setRefreshOverlay(visible: false)
        setupMessageContainer()
        setupComposeBarContainer()
        setupAudioRecordingView()
    }
    
    func setupCustomNavigationBar() {
        navigationBarType = .custom
        navigationHeaderViewController = AmityMessageListHeaderView(viewModel: screenViewModel)
        navigationHeaderViewController.delegate = self
        let headerType: AmityNavigationBarType
        if navigationController?.viewControllers.count ?? 0 <= 1 {
            if presentingViewController != nil {
                headerType = .present
            } else {
                headerType = .push
            }
        } else {
            headerType = .push
        }
        navigationHeaderViewController.amityNavigationBarType = headerType
        let item = UIBarButtonItem(customView: navigationHeaderViewController)
        navigationItem.leftBarButtonItem = item
    }
    
    
    func setupConnectionStatusBar() {
        
        if !settings.enableConnectionBar {
            connectionStatusBar.isHidden = true
            return
        }
        
        updateConnectionStatusBar(animated: false)
        
        // Start observing connection status to update the UI.
        observeConnectionStatus()
        
        // When we go background, the connection status update might notify, but we don't care.
        // Since we can't update the UI.
        didEnterBackgroundObservation = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.unobserveConnectionStatus()
        }
        
        // When the app enter foreground, we now re-observe connection status, to update the UI.
        willEnterForegroundObservation = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.updateConnectionStatusBar(animated: false)
            self?.observeConnectionStatus()
        }
        
    }
    
    private func observeConnectionStatus() {
        connectionStatatusObservation = Reachability.shared.observe(\.isConnectedToNetwork, options: [.initial]) { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.updateConnectionStatusBar(animated: true)
            }
        }
    }
    
    private func unobserveConnectionStatus() {
        connectionStatatusObservation = nil
    }
    
    private func updateConnectionStatusBar(animated: Bool) {
        var barVisibilityIsUpdate = false
        let barIsShowing = (connectionStatusBarTopSpace.constant == -connectionStatusBarHeight.constant)
        if Reachability.shared.isConnectedToNetwork {
            // online
            if !barIsShowing {
                connectionStatusBarTopSpace.constant = -connectionStatusBarHeight.constant
                view.setNeedsLayout()
                barVisibilityIsUpdate = true
            }
        } else {
            // not online
            if barIsShowing {
                connectionStatusBarTopSpace.constant = 0
                view.setNeedsLayout()
                barVisibilityIsUpdate = true
            }
        }
        if barVisibilityIsUpdate, animated {
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    private func setRefreshOverlay(visible: Bool) {
        refreshOverlay.isHidden = !visible
        if visible {
            refreshActivityIndicator.startAnimating()
        } else {
            refreshActivityIndicator.stopAnimating()
        }
    }
    
    @objc func didTapSetting() {
        let vc = AmityChatSettingsViewController.make(channelId: screenViewModel.dataSource.getChannelId())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupMessageContainer() {
        messageViewController = AmityMessageListTableViewController.make(viewModel: screenViewModel)
        addContainerView(messageViewController, to: messageContainerView)
    }
    
    func setupComposeBarContainer() {
        // Switch compose bar view controller based on styling.
        let composeBarViewController: UIViewController & AmityComposeBar
        switch settings.composeBarStyle {
        case .default:
            composeBarViewController = AmityMessageListComposeBarViewController.make(viewModel: screenViewModel, setting: settings)
        case .textOnly:
            composeBarViewController = AmityComposeBarOnlyTextViewController.make(viewModel: screenViewModel)
        }
        
        // Manage view controller
        addContainerView(composeBarViewController, to: composeBarContainerView)
        
        // Keep reference to the AmityComposeBar
        composeBar = composeBarViewController
        
        composeBar.selectedMenuHandler = { [weak self] menu in
            self?.view.endEditing(true)
            switch menu {
            case .camera:
                self?.cameraTap()
            case .album:
                self?.albumTap()
            case .file:
                self?.fileTap()
            case .location:
                self?.locationTap()
            }
        }
        
    }
    
    func setupAudioRecordingView() {
        
        let screenSize = UIScreen.main.bounds
        audioRecordingViewController = AmityMessageListRecordingViewController.make()
        audioRecordingViewController?.presenter = self
        circular.duration = 0.3
        circular.startingPoint = CGPoint(x: screenSize.width / 2, y: screenSize.height)
        circular.circleColor = UIColor.black.withAlphaComponent(0.70)
        circular.presentedView = audioRecordingViewController?.view
        
        audioRecordingViewController?.finishRecordingHandler = { [weak self] state in
            switch state {
            case .finish:
                self?.screenViewModel.action.sendAudio()
                Log.add("Finish")
            case .finishWithMaximumTime:
                self?.screenViewModel.action.sendAudio()
                Log.add("finishWithMaximumTime")
            case .notFinish:
                Log.add("notFinish")
            case .timeTooShort:
                Log.add("timeTooShort")
                self?.composeBar.showPopoverMessage()
            }
        }
        
        composeBar.deletingTarget = audioRecordingViewController?.deleteButton
        
    }
    
    // MARK: - Permission Check
    func checkCameraPermission(success: @escaping() -> (), fail: @escaping() -> ()){
        
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorization {
        case .authorized:
            success()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    success()
                }
            }
        case .restricted:
            break
        case .denied:
            fail()
            break
        @unknown default:
            fail()
            break
        }
    }
    
    func checkAlbumPermission(success: @escaping() -> (), fail: @escaping() -> ()){
        
        let photoAuthorization = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorization {
        case .authorized:
            success()
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
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
}

// MARK: - Binding ViewModel
private extension AmityMessageListViewController {
    func buildViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.getChannel()
    }
    
}

extension AmityMessageListViewController: AmityKeyboardServiceDelegate {
    func keyboardWillChange(service: AmityKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        bottomConstraint.constant = -height + offset
        
        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()
        
        if height == 0 {
            screenViewModel.action.toggleKeyboardVisible(visible: false)
            screenViewModel.action.inputSource(for: .default)
        } else {
            screenViewModel.action.toggleKeyboardVisible(visible: true)
            screenViewModel.shouldScrollToBottom(force: true)
        }
    }
}

extension AmityMessageListViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) { [weak self] in
            do {
                let resizedImage = image
                    .scalePreservingAspectRatio()
                let media = AmityMedia(state: .image(resizedImage), type: .image)
                self?.screenViewModel.action.send(withMedias: [media])
            } catch {
                Log.add(error.localizedDescription)
            }
        }
        
    }
    
}

extension AmityMessageListViewController: AmityMessageListScreenViewModelDelegate {
    
    func screenViewModelAudioRecordingEvents(for events: AmityMessageListScreenViewModel.AudioRecordingEvents) {
        switch events {
        case .show:
            composeBar.isTimeout = false
            guard let window = UIApplication.shared.keyWindow else { return }
            circular.show(for: window)
        case .hide:
            circular.hide()
            audioRecordingViewController?.stopRecording()
        case .deleting:
            audioRecordingViewController?.deletingRecording()
        case .cancelingDelete:
            audioRecordingViewController?.cancelingDelete()
        case .delete:
            circular.hide()
            audioRecordingViewController?.deleteRecording()
        case .record:
            circular.hide()
            audioRecordingViewController?.stopRecording()
        case .timeoutRecord:
            circular.hide()
            screenViewModel.action.sendAudio()
            composeBar.isTimeout = true
        }
    }
    
    func screenViewModelRoute(route: AmityMessageListScreenViewModel.Route) {
        switch route {
        case .pop:
            navigationController?.popViewController(animated: true)
        case .dissmiss:
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func screenViewModelShouldUpdateScrollPosition(to indexPath: IndexPath) {
        messageViewController.updateScrollPosition(to: indexPath)
    }
    
    func screenViewModelDidGetChannel(channel: AmityChannelModel) {
        navigationHeaderViewController?.updateViews(channel: channel)
        screenViewModel.action.shouldScrollToBottom(force: false)
    }
    
    func screenViewModelScrollToBottom(for indexPath: IndexPath) {
        messageViewController.scrollToBottom(indexPath: indexPath)
    }
    
    func screenViewModelDidTextChange(text: String) {
        composeBar.updateViewDidTextChanged(text)
    }
    
    func screenViewModelKeyboardInputEvents(for events: AmityMessageListScreenViewModel.KeyboardInputEvents) {
        switch events {
        case .default:
            composeBar.rotateMoreButton(canRotate: false)
        case .composeBarMenu:
            composeBar.rotateMoreButton(canRotate: true)
        default:
            break
        }
    }
    
    func screenViewModelLoadingState(for state: AmityLoadingState) {
        switch state {
        case .loading:
            messageViewController.showBottomIndicator()
        case .loaded, .initial:
            messageViewController.hideBottomIndicator()
        }
    }
    
    func screenViewModelEvents(for events: AmityMessageListScreenViewModel.Events) {
        switch events {
        case .updateMessages:
            
            let offset = messageViewController.tableView.contentOffset.y
            let contentHeight = messageViewController.tableView.contentSize.height

            messageViewController.tableView.reloadData()
            messageViewController.tableView.layoutIfNeeded()
            
            let newcontentHeight = self.messageViewController.tableView.contentSize.height
            let newOffset = (newcontentHeight - contentHeight) + offset
            self.messageViewController.tableView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: false)
            
        case .didSendText:
            composeBar.clearText()
            screenViewModelScrollTableviewToLastIndex()
        case .didEditText:
            break
        case .didDelete(let indexPath):
            AmityHUD.hide()
            messageViewController.tableView.reloadRows(at: [indexPath], with: .none)
        case .didSendImage:
            screenViewModelScrollTableviewToLastIndex()
            break
        case .didUploadImage:
            screenViewModelScrollTableviewToLastIndex()
            break
        case .didDeeleteErrorMessage:
            AmityHUD.show(.success(message: AmityLocalizedStringSet.HUD.delete.localizedString))
        case .didSendAudio:
            circular.hide()
            audioRecordingViewController?.stopRecording()
            screenViewModelScrollTableviewToLastIndex()
        }
    }
    
    func screenViewModelScrollTableviewToLastIndex() {
        if let lastIndexPath = messageViewController.tableView.lastIndexPath {
            messageViewController.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
        }
    }
    
    func screenViewModelCellEvents(for events: AmityMessageListScreenViewModel.CellEvents) {
        
        switch events {
        case .edit(let indexPath):
            guard let message = screenViewModel.dataSource.message(at: indexPath),
                  let text = message.text else { return }
            
            let editTextVC = AmityEditTextViewController.make(text: text, editMode: .editMessage)
            editTextVC.title = AmityLocalizedStringSet.editMessageTitle.localizedString
            editTextVC.dismissHandler = {
                editTextVC.dismiss(animated: true, completion: nil)
            }
            editTextVC.editHandler = { [weak self] newMessage, _, _ in
                self?.screenViewModel.action.editText(with: newMessage, messageId: message.messageId)
            }
            let nav = UINavigationController(rootViewController: editTextVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .delete(let indexPath):
            guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
            let alertViewController = UIAlertController(title: AmityLocalizedStringSet.MessageList.alertDeleteTitle.localizedString,
                                                        message: AmityLocalizedStringSet.MessageList.alertDeleteDesc.localizedString, preferredStyle: .alert)
            alertViewController.setTitle(font: AmityFontSet.title)
            alertViewController.setMessage(font: AmityFontSet.body)
            let cancel = UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .cancel, handler: nil)
            let delete = UIAlertAction(title: AmityLocalizedStringSet.General.delete.localizedString, style: .destructive, handler: { [weak self] _ in
                self?.screenViewModel.action.delete(withMessage: message, at: indexPath)
            })
            alertViewController.addAction(cancel)
            alertViewController.addAction(delete)
            present(alertViewController, animated: true)
        case .deleteErrorMessage(let indexPath):
            self.view.endEditing(true)
            guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
            let alertViewController = UIAlertController(title: AmityLocalizedStringSet.MessageList.alertErrorMessageTitle.localizedString,
                                                        message: nil, preferredStyle: .actionSheet)
            alertViewController.setTitle(font: AmityFontSet.title)
            alertViewController.setMessage(font: AmityFontSet.body)
            let cancel = UIAlertAction(title: AmityLocalizedStringSet.General.cancel.localizedString, style: .cancel, handler: nil)
            let delete = UIAlertAction(title: AmityLocalizedStringSet.General.delete.localizedString, style: .destructive, handler: { [weak self] _ in
                self?.screenViewModel.action.deleteErrorMessage(with: message.messageId, at: indexPath)
            })
            alertViewController.addAction(cancel)
            alertViewController.addAction(delete)
            present(alertViewController, animated: true)
            
        case .report(let indexPath):
            screenViewModel.action.reportMessage(at: indexPath)
        case .imageViewer(let indexPath, let imageView):
            guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
            AmityUIKitManagerInternal.shared.messageMediaService.downloadImageForMessage(message: message.object, size: .full, progress: nil) { [weak self] (result) in
                switch result {
                case .success(let image):
                    let photoViewerVC = AmityPhotoViewerController(referencedView: imageView, image: image)
                    self?.present(photoViewerVC, animated: true, completion: nil)
                case .failure:
                    break
                }
            }
            
        }
    }
    
    func screenViewModelToggleDefaultKeyboardAndAudioKeyboard(for events: AmityMessageListScreenViewModel.KeyboardInputEvents) {
        switch events {
        case .default:
            composeBar.showRecordButton(show: false)
        case .audio:
            composeBar.showRecordButton(show: true)
        default:
            break
        }
        screenViewModel.action.toggleKeyboardVisible(visible: false)
        view.endEditing(true)
    }
    
    func screenViewModelDidReportMessage(at indexPath: IndexPath) {
        AmityHUD.show(.success(message: AmityLocalizedStringSet.HUD.reportSent.localizedString))
    }
    
    func screenViewModelDidFailToReportMessage(at indexPath: IndexPath, with error: Error?) {
        // Intentionally left empty
    }
    
    func screenViewModelIsRefreshing(_ isRefreshing: Bool) {
        setRefreshOverlay(visible: isRefreshing)
    }
    
}
