//
//  SamplePageViewController.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 23/11/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import AmityUIKit
import UIKit

class SamplePageViewController: UIViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let mySegmentedControl = UISegmentedControl(items: ["Global Feed", "My Feed", "Empty Page"])
    private var pages: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(mySegmentedControl)
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        mySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: mySegmentedControl.bottomAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupPageViewController()
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        pageViewController.setViewControllers([pages[mySegmentedControl.selectedSegmentIndex]], direction: .forward, animated: false, completion: nil)
    }
    
    private func setupPageViewController() {
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let initialPage = 0
        
        // add the individual viewControllers to the pageViewController
        let globalFeed = AmityGlobalFeedViewController.make()
        globalFeed.removeSwipeBackGesture()
        
        let myFeed = AmityMyFeedViewController.make()
        myFeed.removeSwipeBackGesture()
        
        pages.append(globalFeed)
        pages.append(myFeed)
        pages.append(RefreshableViewController())
        pageViewController.setViewControllers([pages[initialPage]], direction: .forward, animated: false, completion: nil)
        
        // segmentedControl
        mySegmentedControl.selectedSegmentIndex = initialPage
        mySegmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
    }
    
}

extension SamplePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return self.pages.last
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        return nil
    }
    
}

extension SamplePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewController = pageViewController.viewControllers?.first,
           let viewControllerIndex = pages.firstIndex(of: viewController) {
            mySegmentedControl.selectedSegmentIndex = viewControllerIndex
        }
    }
    
}


class RefreshableViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.backgroundColor = .systemTeal
        setupScrollView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refreshControl.endRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.frame
    }
    
    private func setupScrollView() {
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    @objc private func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
}
