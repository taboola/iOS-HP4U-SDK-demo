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
        contentView.backgroundColor = .white
    }

    var isSwapped: Bool = false {
        didSet {
            isSwappedLabel.isHidden = !isSwapped
            // animations
            if isSwapped {
                isSwappedLabel.fadeInOut(finished: true)
            } else {
                isSwappedLabel.layer.removeAllAnimations()
            }
        }
    }
}
