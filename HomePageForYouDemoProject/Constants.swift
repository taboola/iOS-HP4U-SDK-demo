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

    struct PublisherContent {
        static let contentFile = (name:"HomePageArticles", fileExtension: "json")
        enum HomePageSection: String {
            case health
            case sport
            case technology
            case topNews = "topnews"
        }
    }

    struct DefaultPublisher {
        static let name = "sdk-tester-hp4u-demo"
        static let apiKey = "05380b1d71ca985df52d641e1f0336ebbb8d67f7"
    }

    struct Layout {
        static let newsHeaderFont = UIFont(name: "Baskerville-Bold", size: 45.0) ?? .systemFont(ofSize: 45.0)
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
        static let eventType = 44
    }
}
