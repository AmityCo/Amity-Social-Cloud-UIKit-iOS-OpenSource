//
//  EkoKeyboardComposeBar.swift
//  UpstraUIKit
//
//  Created by Sarawoot Khunsri on 26/10/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import UIKit

struct EkoKeyboardComposeBarModel {
    let name: String
    let image: UIImage?
    let menuType: MenuType
     
    enum MenuType {
        case camera, album, file, location
    }
    
    static func menuList() -> [EkoKeyboardComposeBarModel] {
        return [
            EkoKeyboardComposeBarModel(name: EkoLocalizedStringSet.camera, image: EkoIconSet.iconCameraFill, menuType: .camera),
            EkoKeyboardComposeBarModel(name: EkoLocalizedStringSet.album, image: EkoIconSet.iconAlbumFill, menuType: .album),
//            EkoKeyboardComposeBarModel(name: EkoLocalizedStringSet.file, image: EkoIconSet.iconFileFill, menuType: .file),
//            EkoKeyboardComposeBarModel(name: EkoLocalizedStringSet.location, image: EkoIconSet.iconLocationFill, menuType: .location)
        ]
    }
}

final class EkoKeyboardComposeBarViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let menuList = EkoKeyboardComposeBarModel.menuList()
    
    // MARK: - Callback
    var selectedMenuHandler: ((EkoKeyboardComposeBarModel.MenuType) -> Void)?
    
    // MARK: View lifecycle
    private init() {
        super.init(nibName: EkoKeyboardComposeBarViewController.identifier, bundle: UpstraUIKitManager.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
     
    static func make() -> EkoKeyboardComposeBarViewController {
        return EkoKeyboardComposeBarViewController()
    }
}

// MARK: - Setup View
private extension EkoKeyboardComposeBarViewController {
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
        collectionView.register(EkoKeyboardComposeBarCollectionViewCell.nib, forCellWithReuseIdentifier: EkoKeyboardComposeBarCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Delegate
extension EkoKeyboardComposeBarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemType = menuList[indexPath.item].menuType
        selectedMenuHandler?(itemType)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        configure(for: cell, at: indexPath)
    }
    
    private func configure(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if let cell = cell as? EkoKeyboardComposeBarCollectionViewCell {
            cell.display(with: menuList[indexPath.item])
        }
    }
}

extension EkoKeyboardComposeBarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EkoKeyboardComposeBarCollectionViewCell.identifier, for: indexPath)
        return cell
    }
}
