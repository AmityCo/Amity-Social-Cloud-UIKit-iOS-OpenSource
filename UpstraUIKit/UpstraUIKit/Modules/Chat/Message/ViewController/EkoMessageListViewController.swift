//
//  EkoMessageListViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 7/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import EkoChat

public protocol EkoMessageListDataSource {
    func cellForMessageTypes() -> [EkoMessageTypes: EkoMessageCellProtocol.Type]
}

/// Eko Message List
public final class EkoMessageListViewController: EkoViewController {
    
    public var dataSource: EkoMessageListDataSource?
    
    // MARK: - IBOutlet Properties
    @IBOutlet private var messageContainerView: UIView!
    @IBOutlet private var composeBarContainerView: UIView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var screenViewModel: EkoMessageListScreenViewModelType
    
    // MARK: - Container View
    private var navigationHeaderViewController: EkoMessageListHeaderView!
    private var messageViewController: EkoMessageListTableViewController!
    private var composeBarViewController: EkoMessageListComposeBarViewController!

    private var audioRecordingViewController = EkoMessageListRecordingViewController.make()
    
    private let circular = EkoCircularTransition()
    
    // MARK: - View lifecyle
    
    private init(viewModel: EkoMessageListScreenViewModelType) {
        screenViewModel = viewModel
        super.init(nibName: EkoMessageListViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        buildViewModel()
        shouldCellOverride()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EkoKeyboardService.shared.delegate = self
        screenViewModel.startReading()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EkoKeyboardService.shared.delegate = nil
        screenViewModel.action.stopReading()
        EkoAudioPlayer.shared.stop()
    }
    
    public static func make(channelId: String) -> EkoMessageListViewController {
        let viewModel = EkoMessageListScreenViewModel(channelId: channelId)
        let vc = EkoMessageListViewController(viewModel: viewModel)
        return vc
    }
    
    private func shouldCellOverride() {
        screenViewModel.action.registerCell()
        if let dataSource = dataSource {
            screenViewModel.action.register(items: dataSource.cellForMessageTypes())
        }
        messageViewController.setupView()
    }
}

// MARK: - Action
private extension EkoMessageListViewController {
    
    func cameraTap() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = self
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func albumTap() {
        let imagePicker = EkoImagePickerController(selectedAssets: [])
        imagePicker.settings.theme.selectionStyle = .checked
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.max = 20
        imagePicker.settings.selection.unselectOnReachingMax = false
        imagePicker.settings.theme.selectionStyle = .numbered
        presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { [weak self] assets in
            let images = assets.map { EkoImage(state: .localAsset($0)) }
            self?.screenViewModel.action.send(withImages: images)
        })
    }
    
    func fileTap() {
        
    }
    
    func locationTap() {
        
    }
}

// MARK: - Setup View
private extension EkoMessageListViewController {
    func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
        setupCustomNavigationBar()
        setupMessageContainer()
        setupComposeBarContainer()
        setupAudioRecordingView()
    }
    
    func setupCustomNavigationBar() {
        navigationBarType = .custom
        navigationHeaderViewController = EkoMessageListHeaderView(viewModel: screenViewModel)
        
        // Just using the view form this
        let item = UIBarButtonItem(customView: navigationHeaderViewController)
        navigationItem.leftBarButtonItem = item
    }
    
    func setupMessageContainer() {
        messageViewController = EkoMessageListTableViewController.make(viewModel: screenViewModel)
        addContainerView(messageViewController, to: messageContainerView)
    }
    
    func setupComposeBarContainer() {
        composeBarViewController = EkoMessageListComposeBarViewController.make(viewModel: screenViewModel)
        addContainerView(composeBarViewController, to: composeBarContainerView)
        
        composeBarViewController.composeBarView.selectedMenuHandler = { [weak self] menu in
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
        circular.duration = 0.3
        circular.startingPoint = CGPoint(x: screenSize.width / 2, y: screenSize.height)
        circular.circleColor = UIColor.black.withAlphaComponent(0.70)
        circular.presentedView = audioRecordingViewController.view
        
        audioRecordingViewController.finishRecordingHandler = { [weak self] state in
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
                self?.composeBarViewController.showPopoverMessage()
            }
        }
        
        composeBarViewController.recordButton.deletingTarget = audioRecordingViewController.deleteButton
    }
}

// MARK: - Binding ViewModel
private extension EkoMessageListViewController {
    func buildViewModel() {
        screenViewModel.delegate = self
        screenViewModel.action.getChannel()
    }
}

extension EkoMessageListViewController: EkoKeyboardServiceDelegate {
    func keyboardWillChange(service: EkoKeyboardService, height: CGFloat, animationDuration: TimeInterval) {
        let offset = height > 0 ? view.safeAreaInsets.bottom : 0
        bottomConstraint.constant = -height + offset
        messageViewController.tableView.setBottomInset(to: height > 0 ? 0:1)
        view.setNeedsUpdateConstraints()
        view.layoutIfNeeded()

        if height == 0 {
            screenViewModel.action.toggleKeyboardVisible(visible: false)
            screenViewModel.action.inputSource(for: .default)
        } else {
            screenViewModel.action.toggleKeyboardVisible(visible: true)
        }
    }
}

extension EkoMessageListViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[.originalImage] as? UIImage {
                let ekoImage = EkoImage(state: .image(image))
                self?.screenViewModel.action.send(withImages: [ekoImage])
            }
        }
    }
}

extension EkoMessageListViewController: EkoMessageListScreenViewModelDelegate {
    func screenViewModelAudioRecordingEvents(for events: EkoMessageListScreenViewModel.AudioRecordingEvents) {
        switch events {
        case .show:
            composeBarViewController.recordButton.isTimeout = false
            guard let window = UIApplication.shared.keyWindow else { return }
            circular.show(for: window)
        case .hide:
            circular.hide()
            audioRecordingViewController.stopRecording()
        case .deleting:
            audioRecordingViewController.deletingRecording()
        case .cancelingDelete:
            audioRecordingViewController.cancelingDelete()
        case .delete:
            circular.hide()
            audioRecordingViewController.deleteRecording()
        case .record:
            circular.hide()
            audioRecordingViewController.stopRecording()
        case .timeoutRecord:
            circular.hide()
            screenViewModel.action.sendAudio()
            composeBarViewController.recordButton.isTimeout = true
        }
    }
    
    func screenViewModelRoute(route: EkoMessageListScreenViewModel.Route) {
        switch route {
        case .pop:
            navigationController?.popViewController(animated: true)
        }
    }
    
    func screenViewModelDidGetChannel(channel: EkoChannel) {
        navigationHeaderViewController.updateViews(channel: channel)
    }
    
    func screenViewMdoelScrollToBottom(for indexPath: IndexPath) {
        messageViewController.scrollToBottom(indexPath: indexPath)
    }
    
    func screenViewModelDidTextChange(text: String) {
        composeBarViewController.updateViewDidTextChanged(text)
    }
    
    func screenViewModelKeyboardInputEvents(for events: EkoMessageListScreenViewModel.KeyboardInputEvents) {
        switch events {
        case .default:
            composeBarViewController.rotateMoreButton(canRotate: false)
        case .composeBarMenu:
            composeBarViewController.rotateMoreButton(canRotate: true)
        default:
            break
        }
    }
    
    func screenViewModelLoadingState(for state: EkoLoadingState) {
        switch state {
        case .loadmore:
            messageViewController.showBottomIndicator()
        case .loaded, .initial:
            messageViewController.hideBottomIndicator()
        case .loading:
            break
        }
    }
    
    func screenViewModelEvents(for events: EkoMessageListScreenViewModel.Events) {
        switch events {
        case .updateMessages:
            messageViewController.tableView.reloadData()
        case .didSendText:
            composeBarViewController.textComposeBarView.clearText()
        case .didEditText:
            break
        case .didDelete(let indexPath):
            messageViewController.tableView.reloadRows(at: [indexPath], with: .none)
        case .didSendImage:
            break
        case .didUploadImage(indexPath: let indexPath):
            break
            messageViewController.tableView.reloadRows(at: [indexPath], with: .none)
        case .didDeeleteErrorMessage(let indexPath):
            EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.delete.localizedString))
        case .didSendAudio:
            circular.hide()
            audioRecordingViewController.stopRecording()
        }
    }
    
    func screenViewModelCellEvents(for events: EkoMessageListScreenViewModel.CellEvents) {
        
        switch events {
        case .edit(let indexPath):
            guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
            guard let text = message.data?["text"] as? String else { return }
            
            let editTextVC = EkoEditTextViewController.make(message: text, editMode: .edit)
            editTextVC.title = EkoLocalizedStringSet.editMessageTitle.localizedString
            editTextVC.dismissHandler = {
                editTextVC.dismiss(animated: true, completion: nil)
            }
            editTextVC.editHandler = { [weak self] newMessage in
                self?.screenViewModel.action.editText(with: newMessage, messageId: message.messageId)
            }
            let nav = UINavigationController(rootViewController: editTextVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .delete(let indexPath):
            guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
            let alertViewController = UIAlertController(title: EkoLocalizedStringSet.MessageList.alertDeleteTitle.localizedString,
                                                        message: EkoLocalizedStringSet.MessageList.alertDeleteDesc.localizedString, preferredStyle: .alert)
            let cancel = UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil)
            let delete = UIAlertAction(title: EkoLocalizedStringSet.delete.localizedString, style: .destructive, handler: { [weak self] _ in
                self?.screenViewModel.action.delete(withMessage: message, at: indexPath)
            })
            alertViewController.addAction(cancel)
            alertViewController.addAction(delete)
            present(alertViewController, animated: true)
        case .deleteErrorMessage(let indexPath):
            guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
            let alertViewController = UIAlertController(title: EkoLocalizedStringSet.MessageList.alertErrorMessageTitle.localizedString,
                                                        message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: EkoLocalizedStringSet.cancel.localizedString, style: .cancel, handler: nil)
            let delete = UIAlertAction(title: EkoLocalizedStringSet.delete.localizedString, style: .destructive, handler: { [weak self] _ in
                self?.screenViewModel.action.deleteErrorMessage(with: message.messageId, at: indexPath)
            })
            alertViewController.addAction(cancel)
            alertViewController.addAction(delete)
            present(alertViewController, animated: true)
            
        case .report:
            EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.reportSent.localizedString))
        case .imageViewer(let imageView):
            let photoViewerVC = EkoPhotoViewerController(referencedView: imageView, image: imageView.image)
            present(photoViewerVC, animated: true, completion: nil)
        }
    }
    
    func screenViewModelToggleDefaultKeyboardAndAudioKeyboard(for events: EkoMessageListScreenViewModel.KeyboardInputEvents) {
        switch events {
        case .default:
            composeBarViewController.showRecordButton(show: false)
        case .audio:
            composeBarViewController.showRecordButton(show: true)
            view.endEditing(true)
            view.endEditing(true)
        default:
            break
        }
    }
}
