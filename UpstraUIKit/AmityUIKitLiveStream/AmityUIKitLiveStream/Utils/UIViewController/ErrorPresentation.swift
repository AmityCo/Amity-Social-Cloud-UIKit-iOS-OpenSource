//
//  ViewControllerUtils.swift
//  AmityUIKitLiveStream
//
//  Created by Nutchaphon Rewik on 31/8/2564 BE.
//

import UIKit

extension UIViewController {
    
    func presentErrorDialogue(title: String?, message: String?, ok: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            ok?()
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
}

