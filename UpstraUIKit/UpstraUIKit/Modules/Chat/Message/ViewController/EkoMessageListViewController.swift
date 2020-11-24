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
    private var navigationHeaderViewController: EkoMessageListHeaderViewController!
    private var messageViewController: EkoMessageListTableViewController!
    private var composeBarViewController: EkoMessageListComposeBarViewController!
    
    // MARK: - View lifecyle
    
    private init(viewModel: EkoMessageListScreenViewModelType) {
        screenViewModel = viewModel
        super.init(nibName: EkoMessageListViewController.identifier, bundle: UpstraUIKit.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
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
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.settings.selection.max = 20
        imagePicker.settings.selection.unselectOnReachingMax = false
        imagePicker.settings.theme.selectionStyle = .numbered
        presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { [weak self] assets in
            self?.screenViewModel.action.send(with: assets)
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
        view.backgroundColor = .white
        setupCustomNavigationBar()
        setupMessageContainer()
        setupComposeBarContainer()
    }
    
    func setupCustomNavigationBar() {
        navigationBarType = .custom
        navigationHeaderViewController = EkoMessageListHeaderViewController.make(viewModel: screenViewModel)
        addChild(viewController: navigationHeaderViewController)
        let item = UIBarButtonItem(customView: navigationHeaderViewController.view)
        navigationItem.leftBarButtonItem = item
        navigationHeaderViewController.didMove(toParent: self)
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
}

// MARK: - Binding ViewModel
private extension EkoMessageListViewController {
    func bindingViewModel() {
        screenViewModel.delegate = self   
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
                self?.screenViewModel.action.send(with: image)
            }
        }
    }
}

extension EkoMessageListViewController: EkoMessageListScreenViewModelDelegate {
    
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
            break
        case .didSendImage:
            break
        case .didUploadImage(indexPath: let indexPath):
            break
            messageViewController.tableView.reloadRows(at: [indexPath], with: .none)
        case .didDeeleteErrorMessage(let indexPath):
            EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.delete))
        }
    }
    
    func screenViewModelCellEvents(for events: EkoMessageListScreenViewModel.CellEvents) {
        
        switch events {
        case .edit(let indexPath):
            guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
            guard let text = message.data?["text"] as? String else { return }
            
            let editTextVC = EkoEditTextViewController.make(message: text, editMode: .edit)
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
            let alertViewController = UIAlertController(title: EkoLocalizedStringSet.messageListAlertDeleteTitle,
                                                        message: EkoLocalizedStringSet.messageListAlertDeleteDesc, preferredStyle: .alert)
            let cancel = UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .cancel, handler: nil)
            let delete = UIAlertAction(title: EkoLocalizedStringSet.delete, style: .destructive, handler: { [weak self] _ in
                self?.screenViewModel.action.delete(with: message.messageId, at: indexPath)
            })
            alertViewController.addAction(cancel)
            alertViewController.addAction(delete)
            present(alertViewController, animated: true)
        case .deleteErrorMessage(let indexPath):
            guard let message = screenViewModel.dataSource.message(at: indexPath) else { return }
            let alertViewController = UIAlertController(title: EkoLocalizedStringSet.messageListAlertDeleteErrorMessageTitle,
                                                        message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: EkoLocalizedStringSet.cancel, style: .cancel, handler: nil)
            let delete = UIAlertAction(title: EkoLocalizedStringSet.delete, style: .destructive, handler: { [weak self] _ in
                self?.screenViewModel.action.deleteErrorMessage(with: message.messageId, at: indexPath)
            })
            alertViewController.addAction(cancel)
            alertViewController.addAction(delete)
            present(alertViewController, animated: true)
            
        case .report:
            EkoHUD.show(.success(message: EkoLocalizedStringSet.HUD.reportSent))
        case .imageViewer(let imageView):
            let photoViewerVC = EkoPhotoViewerController(referencedView: imageView, image: imageView.image)
            present(photoViewerVC, animated: true, completion: nil)
        }
    }
    
}
