//
//  AmityAudioPlayer.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 3/12/2563 BE.
//  Copyright © 2563 BE Amity. All rights reserved.
//

import UIKit
import AVFoundation

protocol AmityAudioPlayerDelegate: AnyObject {
    func playing()
    func stopPlaying()
    func finishPlaying()
    func displayDuration(_ duration: String)
}

final class AmityAudioPlayer: NSObject {
    
    static let shared = AmityAudioPlayer()
    weak var delegate: AmityAudioPlayerDelegate?
    
    var fileName: String?
    var path: URL?
    private var _fileName: String?
    private var player: AVAudioPlayer!
    private var timer: Timer?
    private var duration: TimeInterval = 0.0 {
        didSet {
            displayDuration()
        }
    }
    func isPlaying() -> Bool {
        if player == nil {
            return false
        }
        return player.isPlaying
    }
    
    func play() {
        resetTimer()
        if player == nil {
            playAudio()
        } else {
            if _fileName != fileName {
                stop()
                playAudio()
            } else {
                if player.isPlaying {
                    stop()
                } else {
                    playAudio()
                }
            }
        }
    }
    
    func stop() {
        if player != nil {
            player.stop()
            player = nil
            resetTimer()
            delegate?.stopPlaying()
        }
    }
    
    // MARK: - Helper functions
    
    private func playAudio() {
        _fileName = fileName
        prepare()
    }
    
    private func prepare() {
        guard let url = path else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
                self?.duration += timer.timeInterval
            })
            timer?.tolerance = 0.2
            guard let timer = timer else { return }
            RunLoop.main.add(timer, forMode: .common)
            delegate?.playing()
        } catch {
            Log.add("Error while playing audio \(error.localizedDescription)")
            player = nil
        }
    }
    
    private func displayDuration() {
        let time = Int(duration)
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let display = String(format:"%01i:%02i", minutes, seconds)
        delegate?.displayDuration(display)
    }
    
    private func resetTimer() {
        duration = 0
        timer?.invalidate()
    }
}

extension AmityAudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
        fileName = nil
        resetTimer()
        delegate?.finishPlaying()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            Log.add("Error while decoding \(error.localizedDescription)")
        }
    }
}
