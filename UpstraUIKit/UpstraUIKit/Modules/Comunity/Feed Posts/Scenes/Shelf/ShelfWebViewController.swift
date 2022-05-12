//
//  ShelfWebViewController.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 11/5/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import WebKit

public final class ShelfWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
        
    @IBOutlet var contentView: UIView!
        
    var webView = WKWebView()

    public override func loadView() {
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
        self.view.backgroundColor = AmityColorSet.backgroundColor
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://home.trueid.net/campaign/nRNzQawWNm0R") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    public static func make() -> ShelfWebViewController {
        let vc = ShelfWebViewController(nibName: ShelfWebViewController.identifier, bundle: AmityUIKitManager.bundle)
        return vc
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
            return
        }
    }
}

extension ShelfWebViewController: FeedHeaderPresentable {
    
    public var headerView: UIView {
        return view
    }
    
    public var height: CGFloat {
        return 150
    }
    
}
