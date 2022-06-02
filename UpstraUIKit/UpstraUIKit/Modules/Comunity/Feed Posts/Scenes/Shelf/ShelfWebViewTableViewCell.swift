//
//  AmityFeedShelfTableViewCell.swift
//  AmityUIKit
//
//  Created by Jiratin Teean on 11/5/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import WebKit

class ShelfWebViewTableViewCell: UITableViewCell, WKUIDelegate, WKNavigationDelegate {
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Setup
        contentView.backgroundColor = AmityColorSet.backgroundColor
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: contentView.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.layoutIfNeeded()
        webView.setNeedsLayout()
        webView.scrollView.isScrollEnabled = false
        contentView.addSubview(webView)

        // Load url
        if let url = URL(string: AmityUIKitManagerInternal.shared.urlAdvertisement) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func set(shelfView: UIView?) {
        guard let shelfView = shelfView else { return }
        
        shelfView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shelfView)
        NSLayoutConstraint.activate([
            shelfView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shelfView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shelfView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            shelfView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
}
