//
//  TopNewsCollectionViewCell.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.06.2022.
//

import Foundation
import UIKit

class TopNewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var isSwappedLabel: UILabel!

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    override func prepareForReuse() {
        imageView.image = UIImage.placeholder
        isSwapped = false
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    var isSwapped: Bool = false {
        didSet {
            isSwappedLabel.isHidden = !isSwapped
            // animations
            if isSwapped {
                isSwappedLabel.fadeInOut()
            } else {
                isSwappedLabel.layer.removeAllAnimations()
            }
        }
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)

        let size = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame
         return layoutAttributes
    }
}
