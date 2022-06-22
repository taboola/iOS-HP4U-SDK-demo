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

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
}
