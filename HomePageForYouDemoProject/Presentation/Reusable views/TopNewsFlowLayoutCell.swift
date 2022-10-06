//
//  TopNewsFlowLayoutCell.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 07.06.2022.
//

import Foundation
import UIKit

class TopNewsFlowLayoutCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var isSwappedLabel: UILabel!

    @IBOutlet var widthConstraint: NSLayoutConstraint!
    
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

    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        isSwapped = false
        titleLabel.text = nil
        subtitleLabel.text = nil
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
