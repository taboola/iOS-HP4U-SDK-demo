//
//  TopicHeaderHeaderView.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 10.06.2022.
//

import UIKit

class TopicHeaderHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
}
