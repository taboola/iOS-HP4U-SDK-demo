//
//  HomePageCollectionHostingCellView.swift
//  HomePageForYouDemoProject
//
//  Created by Roman Slyepko on 18.08.2025.
//  Copyright © 2025 Taboola. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

final class HomePageCollectionHostingCellView: UICollectionViewCell {
    var item: PublisherItem? {
        didSet { setNeedsUpdateConfiguration() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let item else {
            contentConfiguration = nil
            return
        }

        if #available(iOS 16.0, *) {
            contentConfiguration = UIHostingConfiguration {
                HomePageSwiftUiCellView(item: item)
            }
            .margins(.all, 0)
        } else {
            print("UIHostingConfiguration is not supported in iOS<16.0")
        }
    }
}
