//
//  EkoMessageListComposeBarViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 30/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

final class EkoMessageListComposeBarViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet var textComposeBarView: EkoTextComposeBarView!
    @IBOutlet var sendMessageButton: UIButton!
    @IBOutlet private var showKeyboardComposeBarButton: UIButton!
    
    // MARK: - Properties
    private let screenViewModel: EkoMessageListScreenViewModelType
    let composeBarView = EkoKeyboardComposeBarViewController.make()
    
    // MARK: - View lifecycle
    private init(viewModel: EkoMessageListScreenViewModelType) {
        screenViewModel = viewModel
        super.init(nibName: EkoMessageListComposeBarViewController.identifier, bundle: UpstraUIKit.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    static func make(viewModel: EkoMessageListScreenViewModelType) -> EkoMessageListComposeBarViewController {
        return EkoMessageListComposeBarViewController(viewModel: viewModel)
    }
}

// MARK: - Action
private extension EkoMessageListComposeBarViewController {
    @IBAction func sendMessageTap() {
        screenViewModel.action.send(with: textComposeBarView.text)
    }
    
    @IBAction func showKeyboardComposeBarTap() {
        screenViewModel.action.toggleInputSource()
    }
}

// MARK: - Setup View
private extension EkoMessageListComposeBarViewController {
    func setupView() {
        setupTextComposeBarView()
        setupSendMessageButton()
        setupShowKeyboardComposeBarButton()
    }
    
    func setupTextComposeBarView() {
        textComposeBarView.placeholder = EkoLocalizedStringSet.textMessagePlaceholder
        textComposeBarView.textViewDidChanged = { [weak self] text in
            self?.screenViewModel.action.setText(withText: text)
        }
        
        textComposeBarView.textViewShouldBeginEditing = { [weak self] textView in
            self?.screenViewModel.action.toggleKeyboardVisible(visible: true)
            self?.screenViewModel.action.inputSource(for: .default)
        }
    }
    
    func setupSendMessageButton() {
        
        sendMessageButton.setTitle(nil, for: .normal)
        sendMessageButton.setImage(EkoIconSet.iconSendMessage, for: .normal)
        sendMessageButton.isEnabled = false
        sendMessageButton.isHidden = true
    }
    
    func setupShowKeyboardComposeBarButton() {
        showKeyboardComposeBarButton.setTitle(nil, for: .normal)
        showKeyboardComposeBarButton.setImage(EkoIconSet.iconAdd, for: .normal)
        showKeyboardComposeBarButton.tintColor = EkoColorSet.base.blend(.shade1)
        showKeyboardComposeBarButton.isHidden = false
    }
}

// MARK: - Update views
extension EkoMessageListComposeBarViewController {
    func updateViewDidTextChanged(_ text: String) {
        sendMessageButton.isEnabled = !text.isEmpty
        showKeyboardComposeBarButton.isHidden = !text.isEmpty
        sendMessageButton.isHidden = text.isEmpty
    }
}


extension EkoMessageListComposeBarViewController {
    
    func rotateMoreButton(canRotate rotate: Bool) {
        if rotate {
            // for show keyboard compose bar menu
            animationForRotation(with: CGFloat.pi * 0.25, animation: { [weak self] in
                self?.textComposeBarView.inputView = self?.composeBarView.view
                self?.textComposeBarView.reloadInputViews()
                self?.textComposeBarView.becomeFirstResponder()
            })
        } else {
            // for show keyboard default
            animationForRotation(with: 0, animation: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.screenViewModel.dataSource.getKeyboardVisible() {
                    strongSelf.textComposeBarView.inputView = nil
                    strongSelf.textComposeBarView.resignFirstResponder()
                    if !strongSelf.textComposeBarView.becomeFirstResponder() {
                        strongSelf.textComposeBarView.textView.becomeFirstResponder()
                    }
                } else {
                    strongSelf.textComposeBarView.textView.resignFirstResponder()
                }
            })
        }
    }
    
    func animationForRotation(with angle: CGFloat, animation: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.showKeyboardComposeBarButton.transform = CGAffineTransform(rotationAngle: angle)
            animation()
        })
    }
}
