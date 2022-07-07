//
//  Constants.swift
//  HomePageForYouDemoProject (iOS)
//
//  Created by Karen Shaham Palman on 25/05/2022.
//

import Foundation
import UIKit

struct Constants {
    struct Color {
        static let accent = UIColor(named: "accent-red") ?? .red
    }
    struct DefaultPublisher {
        static let name = "newsplace-israel-feed-ios"
        static let apiKey = "f44d224ed117102b74bed53b82e6079af28600d5"
    }

    struct Layout {
        static let newsHeaderFont = UIFont(name: "Baskerville-Bold", size: 45.0)
    }

    struct NavigationSegue {
        static let demo = "openDemo"
        static let info = "openInfo"
        static let article = "openArticle"
    }

    struct LaunchScreen {
        static let onScreenTime = 2.0
    }


    struct UsageReporting {
        static let usageEventType = 3
    }
}
