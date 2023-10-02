//
//  GeneralError.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 31/8/2564 BE.
//

import Foundation

struct GeneralError: LocalizedError {
    
    let message: String

    init(message: String) {
        self.message = message
    }
    
    var errorDescription: String? {
        return message
        
    }
    
}

