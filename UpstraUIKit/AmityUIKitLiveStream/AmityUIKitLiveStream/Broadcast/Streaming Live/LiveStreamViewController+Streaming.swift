//
//  LiveStreamViewController+Streaming.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 2/9/2564 BE.
//

import UIKit
import AmityUIKit

extension LiveStreamBroadcastViewController {
    
    func startLiveDurationTimer() {
        startedAt = Date()
        updateStreamingStatusText()
        liveDurationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            #if DEBUG
            dispatchPrecondition(condition: .onQueue(.main))
            #endif
            self?.updateStreamingStatusText()
        }
    }
    
    func stopLiveDurationTimer() {
        liveDurationTimer?.invalidate()
        liveDurationTimer = nil
    }
    
    func updateStreamingStatusText() {
        guard let startedAt = startedAt,
              let durationText = liveDurationFormatter.string(from: startedAt, to: Date()),
              let broadcaster = broadcaster else {
                  streamingStatusLabel.text = AmityLocalizedStringSet.LiveStream.Live.live.localizedString
            return
        }
        switch broadcaster.state {
        case .connected:
            streamingStatusLabel.text = "\(AmityLocalizedStringSet.LiveStream.Live.live.localizedString) \(durationText)"
        case .connecting, .disconnected, .idle:
            streamingStatusLabel.text = "\(AmityLocalizedStringSet.LiveStream.Live.connecting.localizedString) \(durationText)"
        @unknown default:
            streamingStatusLabel.text = "\(AmityLocalizedStringSet.LiveStream.Live.live.localizedString) \(durationText)"
        }
    }
    
}
