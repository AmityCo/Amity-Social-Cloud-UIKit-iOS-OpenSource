//
//  EkoMessageListScreenViewModelProtocol.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 5/8/2563 BE.
//  Copyright © 2563 Eko Communication. All rights reserved.
//

import UIKit
import Photos
import EkoChat

protocol EkoMessageListScreenViewModelDelegate: class {
    func screenViewModelRoute(route: EkoMessageListScreenViewModel.Route)
    func screenViewModelDidGetChannel(channel: EkoChannel)
    func screenViewMdoelScrollToBottom(for indexPath: IndexPath)
    func screenViewModelDidTextChange(text: String)
    func screenViewModelLoadingState(for state: EkoLoadingState)
    func screenViewModelEvents(for events: EkoMessageListScreenViewModel.Events)
    func screenViewModelCellEvents(for events: EkoMessageListScreenViewModel.CellEvents)
    func screenViewModelKeyboardInputEvents(for events: EkoMessageListScreenViewModel.KeyboardInputEvents)
    func screenViewModelToggleDefaultKeyboardAndAudioKeyboard(for events: EkoMessageListScreenViewModel.KeyboardInputEvents)
    func screenViewModelAudioRecordingEvents(for events: EkoMessageListScreenViewModel.AudioRecordingEvents)
}

protocol EkoMessageListScreenViewModelDataSource {
    var allCells: [String: UINib] { get }
    var cache: ImageCache { get }
    
    func message(at indexPath: IndexPath) -> EkoMessageModel?
    func numberOfSection() -> Int
    func numberOfMessage(in section: Int) -> Int
    func getKeyboardVisible() -> Bool
}

protocol EkoMessageListScreenViewModelAction {
    func route(for route: EkoMessageListScreenViewModel.Route)
    func setText(withText text: String?)
    func getChannel()
    func getMessage()
    
    func send(withText text: String?)
    func send(withImages images: [EkoImage])
    func sendAudio()
    
    func editText(with text: String, messageId: String)
    func delete(withMessage message: EkoMessageModel, at indexPath: IndexPath)
    func deleteErrorMessage(with messageId: String, at indexPath: IndexPath)
    func startReading()
    func stopReading()
    
    func scrollToBottom()
    
    func registerCell()
    func register(items: [EkoMessageTypes:EkoMessageCellProtocol.Type])
    
    func inputSource(for event: EkoMessageListScreenViewModel.KeyboardInputEvents)
    func toggleInputSource()
    func toggleKeyboardVisible(visible: Bool)
    
    func performCellEvent(for event: EkoMessageListScreenViewModel.CellEvents)
    
    func loadMoreScrollUp(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    func toggleShowDefaultKeyboardAndAudioKeyboard(_ sender: UIButton)
    
    func performAudioRecordingEvents(for event: EkoMessageListScreenViewModel.AudioRecordingEvents)
    
}

protocol EkoMessageListScreenViewModelType: EkoMessageListScreenViewModelAction, EkoMessageListScreenViewModelDataSource {
    var action: EkoMessageListScreenViewModelAction { get }
    var dataSource: EkoMessageListScreenViewModelDataSource { get }
    var delegate: EkoMessageListScreenViewModelDelegate? { get set }
}

extension EkoMessageListScreenViewModelType {
    var action: EkoMessageListScreenViewModelAction { return self }
    var dataSource: EkoMessageListScreenViewModelDataSource { return self }
}
