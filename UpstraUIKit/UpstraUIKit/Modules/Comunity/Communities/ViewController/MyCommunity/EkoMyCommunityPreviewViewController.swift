//
//  EkoMyCommunityViewController.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 21/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

public protocol EkoMyCommunityPreviewViewControllerDelegate: class {
    func viewController(_ viewController: EkoMyCommunityPreviewViewController, didPerformAction action: EkoMyCommunityPreviewViewController.ActionType)
}

final public class EkoMyCommunityPreviewViewController: UIViewController {
    
    public enum ActionType {
        case seeAll
        case communityItem(indexPath: IndexPath)
    }
    
    private enum Constant {
        static let maximumItems: Int = 8
    }

    // MARK: -  IBOutlet Properties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var actionButton: UIButton!
    @IBOutlet private var separatorView: UIView!
    
    // MARK: - Properties
    private var communities: [EkoCommunityModel] = []
    public weak var delegate: EkoMyCommunityPreviewViewControllerDelegate?
    
    // MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func configure(with communities: [EkoCommunityModel]) {
        self.communities = communities
        collectionView?.reloadData()
    }
    
    public static func make() -> EkoMyCommunityPreviewViewController {
        return EkoMyCommunityPreviewViewController(nibName: EkoMyCommunityPreviewViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    private func setupView() {
        view.backgroundColor = EkoColorSet.backgroundColor
        
        titleLabel.text = EkoLocalizedStringSet.myCommunityTitle.localizedString
        titleLabel.font = EkoFontSet.title
        titleLabel.textColor = EkoColorSet.base
        
        actionButton.setImage(EkoIconSet.iconNext, for: .normal)
        actionButton.tintColor = EkoColorSet.base
        separatorView.backgroundColor = EkoColorSet.secondary.blend(.shade4)
        
        let layout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)
        layout?.scrollDirection = .horizontal
        layout?.itemSize = CGSize(width: 68, height: 64)
        layout?.minimumLineSpacing = 8
        layout?.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView.backgroundColor = EkoColorSet.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EkoUtilities.UINibs(nibName: EkoMyCommunityCollectionViewCell.identifier), forCellWithReuseIdentifier: EkoMyCommunityCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func myCommunityTap() {
        delegate?.viewController(self, didPerformAction: .seeAll)
    }
    
}

extension EkoMyCommunityPreviewViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == Constant.maximumItems {
            delegate?.viewController(self, didPerformAction: .seeAll)
        } else {
            delegate?.viewController(self, didPerformAction: .communityItem(indexPath: indexPath))
        }
    }
}

extension EkoMyCommunityPreviewViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = communities.count
        return count <= Constant.maximumItems ? count : Constant.maximumItems + 1 // seemore button
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EkoMyCommunityCollectionViewCell.identifier, for: indexPath)
        configure(for: cell, at: indexPath)
        return cell
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoMyCommunityCollectionViewCell {
            if indexPath.row == Constant.maximumItems {
                cell.seeAll()
            } else {
                let community = communities[indexPath.row]
                cell.display(with: community)
            }
            
        }
    }
}
