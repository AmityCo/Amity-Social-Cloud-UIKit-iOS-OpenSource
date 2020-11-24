//
//  EkoPageViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 6/11/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public class EkoPageViewController: EkoButtonPagerTabSViewController {
    
    public override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = EkoColorSet.backgroundColor
        settings.style.buttonBarItemBackgroundColor = EkoColorSet.backgroundColor
        settings.style.selectedBarBackgroundColor = EkoColorSet.primary
        settings.style.buttonBarItemTitleColor = EkoColorSet.base
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarLeftContentInset = 16
        settings.style.buttonBarRightContentInset = 16
        settings.style.bottomLineColor = EkoColorSet.base.blend(.shade4)
        super.viewDidLoad()
        delegate = self
        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = EkoColorSet.base
            oldCell?.label.font = EkoFontSet.title
            newCell?.label.textColor = EkoColorSet.primary
            newCell?.label.font = EkoFontSet.title
        }
        containerView.isScrollEnabled = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setBackgroundColor(with: .white)
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
