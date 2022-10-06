//
//  TopNewsCompositionalLayoutCell.swift
//  HomePageForYouDemoProject
//
//  Created by Alexander Zhuchinskiy on 06.10.2022.
//

import UIKit

class TopNewsCompositionalLayoutCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var isSwappedLabel: UILabel!
    
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
}
