//
//  AmityProfileViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 14/9/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

protocol AmityRefreshable {
    func handleRefreshing()
}

public class AmityProfileViewController: AmityViewController, AmityProfileDataSource, AmityProfileProgressDelegate {
    
    private let refreshControl = UIRefreshControl()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configure(with: self, delegate: self)
    }
    
    func headerViewController() -> UIViewController {
        let header = AmityViewController()
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = .red
        header.view.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: header.view.topAnchor),
            customView.bottomAnchor.constraint(equalTo: header.view.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: header.view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: header.view.trailingAnchor),
            customView.heightAnchor.constraint(equalToConstant: 500)
        ])
        return header
    }
    
    func bottomViewController() -> UIViewController & AmityProfilePagerAwareProtocol {
        return AmityProfileBottomViewController()
    }
    
    func minHeaderHeight() -> CGFloat {
        return topInset
    }
    
    func scrollView(_ scrollView: UIScrollView, didUpdate progress: CGFloat) {
        
    }
    
    func scrollViewDidLoad(_ scrollView: UIScrollView) {
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
                 (navigationController?.navigationBar.frame.height ?? 0.0)
        
        let refreshView = UIView(frame: CGRect(x: 0, y: navBarHeight, width: 0, height: 0))
        scrollView.addSubview(refreshView)
        refreshView.addSubview(refreshControl)
    }
    
    // MARK: - Helper function
    
    @objc func handleRefreshControl() {
        (headerViewController() as? AmityRefreshable)?.handleRefreshing()
        (bottomViewController() as? AmityRefreshable)?.handleRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
}

public class AmityProfileBottomViewController: AmityButtonPagerTabSViewController, AmityProfilePagerAwareProtocol {
    private class MenuViewController: UIViewController, IndicatorInfoProvider {
        let tableView = UITableView()
        var pageIndex: Int = 0
        var pageTitle: String?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tableView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        func indicatorInfo(for pagerTabStripController: AmityPagerTabViewController) -> IndicatorInfo {
            return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
        }
    }
    
    // MARK: - Properties
    weak var pageDelegate: AmityProfileBottomPageDelegate?
    
    var currentViewController: UIViewController? {
        return viewControllers[currentIndex]
    }
    
    var pagerTabHeight: CGFloat? {
        return 44
    }
    
    // MARK: - View lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = AmityColorSet.backgroundColor
        settings.style.buttonBarItemBackgroundColor = AmityColorSet.backgroundColor
        settings.style.selectedBarBackgroundColor = AmityColorSet.primary
        settings.style.buttonBarItemTitleColor = AmityColorSet.base
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarLeftContentInset = 16
        settings.style.buttonBarRightContentInset = 16
        settings.style.bottomLineColor = AmityColorSet.secondary.blend(.shade4)
        super.viewDidLoad()
        delegate = self
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = AmityColorSet.base
            oldCell?.label.font = AmityFontSet.title
            newCell?.label.textColor = AmityColorSet.primary
            newCell?.label.font = AmityFontSet.title
        }
    }

    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        var _viewControllers: [UIViewController] = []
        for index in 1...5 {
            let vc = MenuViewController()
            vc.pageTitle = "Page \(index)"
            vc.pageIndex = index
            vc.view.backgroundColor = index % 2 == 0 ? .red:.green
            _viewControllers.append(vc)
        }
        return _viewControllers
    }
    
    override func reloadPagerTabStripView() {
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
    
    override func updateIndicator(for viewController: AmityPagerTabViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        guard indexWasChanged == true else { return }

        //IMPORTANT!!!: call the following to let the master scroll controller know which view to control in the bottom section
        self.pageDelegate?.pageViewController(self.currentViewController, didSelectPageAt: toIndex)
    }
}

extension AmityProfileBottomViewController: AmityRefreshable {
    
    func handleRefreshing() {
        // Trigger `handleRefresh` on every child view controllers.
        for viewController in viewControllers {
            (viewController as? AmityRefreshable)?.handleRefreshing()
        }
    }
    
}
