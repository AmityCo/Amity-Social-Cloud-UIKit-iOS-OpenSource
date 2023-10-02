//
//  LiveStreamBroadcast+UIContainerState.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 1/9/2564 BE.
//

import UIKit

extension LiveStreamBroadcastViewController {
    
    enum ContainerState {
        case create
        case streaming
        case end
    }
    
    func switchToUIState(_ state: ContainerState) {
        containerState = state
        updateContainerStateUI()
    }
    
    func updateContainerStateUI() {
        
        uiContainerCreate.isHidden = (containerState != .create)
        uiContainerStreaming.isHidden = (containerState != .streaming)
        uiContainerEnd.isHidden = (containerState != .end)
        
        if containerState == .end {
            streamEndActivityIndicator.startAnimating()
        } else {
            streamEndActivityIndicator.stopAnimating()
        }
        
    }
    
}
