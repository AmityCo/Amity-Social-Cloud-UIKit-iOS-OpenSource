//
//  AmityPageViewController.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 6/11/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public class AmityPageViewController: AmityButtonPagerTabSViewController {
    
    public override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = AmityColorSet.backgroundColor
        settings.style.buttonBarItemBackgroundColor = AmityColorSet.backgroundColor
        settings.style.selectedBarBackgroundColor = AmityColorSet.primary
        settings.style.buttonBarItemTitleColor = AmityColorSet.base
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarLeftContentInset = 16
        settings.style.buttonBarRightContentInset = 16
        settings.style.bottomLineColor = AmityColorSet.base.blend(.shade4)
        super.viewDidLoad()
        delegate = self
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = AmityColorSet.base
            oldCell?.label.font = AmityFontSet.title
            newCell?.label.textColor = AmityColorSet.primary
            newCell?.label.font = AmityFontSet.title
        }
        containerView.isScrollEnabled = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setBackgroundColor(with: AmityColorSet.backgroundColor)
    }
    
    override func reloadPagerTabStripView() {
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
}
