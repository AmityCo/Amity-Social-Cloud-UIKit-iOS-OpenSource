//
//  PostGallerySegmentedControlCell.swift
//  AmityUIKit
//
//  Created by Nutchaphon Rewik on 4/8/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import UIKit

protocol PostGallerySegmentedControlCellDelegate: AnyObject {
    
    func postGallerySegmentedControlCell(
        _ cell: PostGallerySegmentedControlCell,
        didTouchSection section: PostGallerySegmentedControlCell.Section
    )
    
}

class PostGallerySegmentedControlCell: UICollectionViewCell, Nibbable {

    enum Section {
        case image
        case video
        case livestream
    }
    
    weak var delegate: PostGallerySegmentedControlCellDelegate?
    
    private var currentSection: PostGallerySegmentedControlCell.Section?
    
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var videoButton: UIButton!
    @IBOutlet private weak var livestreamButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButton(photoButton, isHighlighted: false)
        configureButton(videoButton, isHighlighted: false)
        configureButton(livestreamButton, isHighlighted: false)
        // TODO: Uncomment this in the next release.
        livestreamButton.isHidden = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        for button in [photoButton, videoButton, livestreamButton] {
            button!.layer.cornerRadius = button!.bounds.height * 0.5
            button!.clipsToBounds = true
        }
    }
    
    private func configureButton(_ button: UIButton, isHighlighted: Bool) {
        let attributes: [NSAttributedString.Key: Any]
        if isHighlighted {
            attributes = [
                .foregroundColor: AmityThemeManager.currentTheme.primary.blend(.shade4),
                .font: AmityFontSet.bodyBold
            ]
        } else {
            attributes = [
                .foregroundColor: AmityThemeManager.currentTheme.secondary.blend(.shade3),
                .font: AmityFontSet.body
            ]
        }
        let title = button.title(for: .normal) ?? ""
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        // Regardless of animated = true/false, we don't animate this, since it's not good looking.
        UIView.performWithoutAnimation {
            button.setAttributedTitle(attributedString, for: .normal)
            button.layoutIfNeeded()
        }
        button.backgroundColor = isHighlighted
            ? AmityThemeManager.currentTheme.primary
            : AmityThemeManager.currentTheme.secondary.blend(.shade4)
    }
    
    func setSelectedSection(_ section: Section?, animated: Bool) {
        if let currentSection = currentSection, currentSection == section {
            return
        }
        let updateButtons: () -> Void = { [weak self] in
            // isHighlighted = false, for previous section
            guard let strongSelf = self else { return }
            if let previousSection = strongSelf.currentSection {
                let button = strongSelf.buttonForSection(previousSection)
                strongSelf.configureButton(button, isHighlighted: false)
            }
            // isHighlighted = true, for new section
            if let newSection = section {
                let button = strongSelf.buttonForSection(newSection)
                strongSelf.configureButton(button, isHighlighted: true)
            }
            //
            strongSelf.currentSection = section
        }
        if animated {
            UIView.animate(withDuration: 0.15) {
                updateButtons()
            }
        } else {
            updateButtons()
        }
    }
    
    private func buttonForSection(_ section: PostGallerySegmentedControlCell.Section) -> UIButton {
        switch section {
        case .image:
            return photoButton
        case .video:
            return videoButton
        case .livestream:
            return livestreamButton
        }
    }
    
    @IBAction private func photoDidTouch() {
        delegate?.postGallerySegmentedControlCell(self, didTouchSection: .image)
    }
    
    @IBAction private func videoDidTouch() {
        delegate?.postGallerySegmentedControlCell(self, didTouchSection: .video)
    }
    
    @IBAction func livestreamDidTouch() {
        delegate?.postGallerySegmentedControlCell(self, didTouchSection: .livestream)
    }
    
    static var height: CGFloat {
        return 64
    }
    
}
