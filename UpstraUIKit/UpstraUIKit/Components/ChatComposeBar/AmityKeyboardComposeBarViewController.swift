//
//  AmityKeyboardComposeBar.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 26/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

struct AmityKeyboardComposeBarModel {
    let name: String
    let image: UIImage?
    let menuType: MenuType
     
    enum MenuType {
        case camera, album, file, location
    }
    
    static func menuList() -> [AmityKeyboardComposeBarModel] {
        return [
            AmityKeyboardComposeBarModel(name: AmityLocalizedStringSet.General.camera.localizedString, image: AmityIconSet.iconCameraFill, menuType: .camera),
            AmityKeyboardComposeBarModel(name: AmityLocalizedStringSet.General.album.localizedString, image: AmityIconSet.iconAlbumFill, menuType: .album),
//            AmityKeyboardComposeBarModel(name: AmityLocalizedStringSet.file.localizedString, image: AmityIconSet.iconFileFill, menuType: .file),
//            AmityKeyboardComposeBarModel(name: AmityLocalizedStringSet.location.localizedString, image: AmityIconSet.iconLocationFill, menuType: .location)
        ]
    }
}

final class AmityKeyboardComposeBarViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let menuList = AmityKeyboardComposeBarModel.menuList()
    
    // MARK: - Callback
    var selectedMenuHandler: ((AmityKeyboardComposeBarModel.MenuType) -> Void)?
    
    // MARK: View lifecycle
    private init() {
        super.init(nibName: AmityKeyboardComposeBarViewController.identifier, bundle: AmityUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
     
    static func make() -> AmityKeyboardComposeBarViewController {
        return AmityKeyboardComposeBarViewController()
    }
}

// MARK: - Setup View
private extension AmityKeyboardComposeBarViewController {
    func setupView() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let margin: CGFloat = 20
            let width = collectionView.bounds.width
            let numberOfItemsPerRow: CGFloat = 3
            let spacing: CGFloat = 40
            let availableWidth = width - spacing * (numberOfItemsPerRow + 1) - (margin * 2)
            let itemDimension = floor(availableWidth / numberOfItemsPerRow)
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: itemDimension, height: itemDimension)
            layout.minimumLineSpacing = margin
            layout.minimumInteritemSpacing = spacing
            layout.sectionInset = UIEdgeInsets(top: margin, left: spacing, bottom: margin, right: spacing)
        }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AmityKeyboardComposeBarCollectionViewCell.nib, forCellWithReuseIdentifier: AmityKeyboardComposeBarCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Delegate
extension AmityKeyboardComposeBarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemType = menuList[indexPath.item].menuType
        selectedMenuHandler?(itemType)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        configure(for: cell, at: indexPath)
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if let cell = cell as? AmityKeyboardComposeBarCollectionViewCell {
            cell.display(with: menuList[indexPath.item])
        }
    }
}

extension AmityKeyboardComposeBarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmityKeyboardComposeBarCollectionViewCell.identifier, for: indexPath)
        return cell
    }
}
