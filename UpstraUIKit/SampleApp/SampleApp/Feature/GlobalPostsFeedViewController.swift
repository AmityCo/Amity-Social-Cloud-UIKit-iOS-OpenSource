//
//  GlobalPostsFeedViewController.swift
//  SampleApp
//
//  Created by Hamlet on 01.03.21.
//  Copyright © 2021 Amity. All rights reserved.
//
import UIKit
import AmityUIKit

class GlobalPostsFeedViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var dataSource: GlobalPostsDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = GlobalPostsDataSource(client: AmityUIKitManager.client)
        
        activityIndicator.startAnimating()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "PostPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "PostPreviewTableViewCell")

        dataSource.observePostsFeedChanges { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }

    // Support Pagination
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let frameHeight = scrollView.frame.size.height
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        let distanceFromBottom = contentHeight - contentOffset
        if distanceFromBottom < frameHeight {
            dataSource.loadMorePosts()
        }
    }
}

extension GlobalPostsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.getNumberOfFeedItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostPreviewTableViewCell") as! PostPreviewTableViewCell
        if let post = dataSource.getPostAtIndex(index: indexPath.section) {
            cell.display(post: post)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
